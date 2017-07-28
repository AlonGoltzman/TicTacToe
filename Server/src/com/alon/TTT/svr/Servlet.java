package com.alon.TTT.svr;

import com.alon.TTT.lib.C;
import com.sun.istack.internal.NotNull;
import org.json.JSONException;
import org.json.JSONObject;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.security.PrivateKey;
import java.util.ArrayList;
import java.util.Base64;
import java.util.HashMap;

import static java.util.Objects.isNull;

/**
 * Created by Mgr on 3/8/2017.
 */
public class Servlet extends javax.servlet.http.HttpServlet {

    private static PrivateKey pKey = null;
    private static Cipher cipher = null;

    private final ArrayList<User> registeredUsers = new ArrayList<>();
    private final ArrayList<User> hostsWaitingForPlayers = new ArrayList<>();

    @Override
    public void init() throws ServletException {
        super.init();
        loadKey();
        initCipher();
    }

    protected void doPost(javax.servlet.http.HttpServletRequest request, javax.servlet.http.HttpServletResponse response) throws javax.servlet.ServletException, IOException {
        InputStream stream = request.getInputStream();
        int aRead;
        byte[] buffer = new byte[1024];
        StringBuilder builder = new StringBuilder();
        while ((aRead = stream.read(buffer)) != -1)
            builder.append(new String(buffer, 0, aRead));
        stream.close();
        try {
            String encryptedParcel = builder.toString();
            if (encryptedParcel.isEmpty()) {
                response.sendError(500, "Decryption failed.");
                return;
            }
            //Decrypt Parcel.
            builder.setLength(0);
            for (String subPart : encryptedParcel.split(C.M.DEFAULT_ESCAPE_CHAR))
                builder.append(decrypt(subPart));
            JSONObject parcel = new JSONObject(builder.toString());
            String uN;
            String pW;
            switch (parcel.getString(C.K.action)) {
                case C.A.login:
                    uN = decrypt(parcel.getString(C.K.username));
                    pW = decrypt(parcel.getString(C.K.password));
                    System.out.println(String.format("doPost -> Parcel Decryption -> Username = %s & Password = %s", uN, pW));
                    for (User user : registeredUsers)
                        if (user.getUsername().equals(uN))
                            if (user.getPassword().equals(pW)) {
                                user.setLoggedIn(true);
                                response.getWriter().write(user.refreshToken());
                                return;
                            } else {
                                response.getWriter().write(C.M.resErrLoginBadPassOrUser);
                                return;
                            }
                    response.getWriter().write(C.M.resErrNoUserFound);
                    return;
                case C.A.register:
                    uN = decrypt(parcel.getString(C.K.username));
                    pW = decrypt(parcel.getString(C.K.password));
                    System.out.println(String.format("doPost -> Parcel Decryption -> Username = %s & Password = %s", uN, pW));
                    synchronized (registeredUsers) {
                        for (User user : registeredUsers)
                            if (user.getUsername().equals(uN)) {
                                response.getWriter().write(C.M.resErrRegUsernameTaken);
                                return;
                            }
                    }
                    //TODO: password strength test.
                    User newUser = new User(uN, pW, true);
                    registeredUsers.add(newUser);
                    response.getWriter().write(newUser.refreshToken());
                    break;
            }

        } catch (JSONException e) {
            e.printStackTrace();
            response.sendError(400, "Parcel corrupted.");

        }
    }

    protected void doGet(javax.servlet.http.HttpServletRequest request, javax.servlet.http.HttpServletResponse response) throws javax.servlet.ServletException, IOException {
        HashMap<String, String> queryMap = mappifyQuery(request.getQueryString());
        String action = queryMap.getOrDefault(C.K.action, null);
        if (isNull(action)) {
            response.sendError(400, "Insufficient Params.");
            System.out.println("doGet -> Action is null.");
            return;
        }
        Object result;
        User user = null;
        User hostUser = null;
        User playerUser = null;
        switch (action) {

            // >> Any User
            case C.A.login:
                response.sendError(406, "Login isn't allowed in GET request type.");
                break;
            case C.A.register:
                response.sendError(406, "Register isn't allowed in GET request type.");
                break;
            case C.A.joinHost:
                result = safetyCheck(queryMap.getOrDefault(C.K.userToken, null), false, response);
                if (result instanceof User)
                    user = (User) result;
                else {
                    return;
                }
                synchronized (hostsWaitingForPlayers) {
                    if (hostsWaitingForPlayers.contains(user)) {
                        response.getWriter().write(C.M.resErrAlreadyWaiting);
                        return;
                    } else {
                        hostsWaitingForPlayers.add(user);
                    }
                }
                response.getWriter().write(C.M.resOk);
                break;
            case C.A.pollStatus:
                result = safetyCheck(queryMap.getOrDefault(C.K.userToken, null), false, response);
                if (result instanceof User)
                    user = (User) result;
                else {
                    return;
                }
                response.getWriter().write(user.getStatus());
                break;
            // >> Client
            case C.A.pollHosts:
                result = safetyCheck(queryMap.getOrDefault(C.K.userToken, null), false, response);
                if (result instanceof User)
                    user = (User) result;
                else {
                    return;
                }
                StringBuilder builder = new StringBuilder();
                for (User host : hostsWaitingForPlayers) {
                    if (host.isLoggedIn()) {
                        if (host.containsRequest(user)) {
                            continue;
                        }
                        builder.append(host.toString()).append("&");
                    } else {
                        System.out.println("doGet -> Host: " + host.getToken() + " was found to not be logged in.");
                        hostsWaitingForPlayers.remove(host);
                    }
                }
                builder.deleteCharAt(builder.lastIndexOf("&"));
                response.getWriter().write(builder.toString());
                break;
            case C.A.requestToJoin:
                result = safetyCheck(queryMap.getOrDefault(C.K.userToken, null), false, response);
                if (result instanceof User)
                    user = (User) result;
                else
                    return;
                result = safetyCheck(queryMap.getOrDefault(C.K.hostToken, null), true, response);
                if (result instanceof User)
                    hostUser = (User) result;
                else
                    return;
                if (hostUser.addRequest(user))
                    response.getWriter().write(C.M.resOk);
                else
                    response.getWriter().write(C.M.resErrAlreadyRequestedToJoin);
                break;
                // >> Hosts
            case C.A.pollRequests:

                break;
        }
    }

    private Object safetyCheck(String token, boolean isHost, HttpServletResponse response) {
        try {
            String givenToken = decrypt(token);
            if (isNull(token)) {
                response.sendError(400);
                System.out.println("doGet -> No token.");
                return false;
            }
            User user = findUser(givenToken);
            if (user == null) {
                if (isHost)
                    response.getWriter().write(C.M.resErrHostNotOnline);
                else
                    response.getWriter().write(C.M.resErrNoUserFound);
                return false;
            } else if (user.equals(User.getNullDefinition())) {
                response.getWriter().write(C.M.resErrUserNotOnline);
                return false;
            }
            return user;
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }

    private HashMap<String, String> mappifyQuery(String query) {
        HashMap<String, String> map = new HashMap<>();
        String[] qParts = query.split("&");
        for (String part : qParts) {
            String[] subQPart = part.split("=");
            map.put(subQPart[0], subQPart[1]);
        }
        return map;
    }

    private User findUser(@NotNull String token) {
        for (User user : registeredUsers) {
            if (user.getToken().equals(token))
                if (user.isLoggedIn()) {
                    return user;
                } else {
                    return User.getNullDefinition();
                }
        }
        return null;
    }

    private <T extends String> String decrypt(T t) {
        if (isNull(pKey))
            return null;
        try {
            byte[] bytes = Base64.getDecoder().decode(t.getBytes());
            Cipher cipher = Cipher.getInstance("RSA/ECB/PKCS1Padding");
            cipher.init(Cipher.DECRYPT_MODE, pKey);
            byte[] decrypted = cipher.doFinal(bytes);
            return new String(decrypted);
        } catch (NoSuchAlgorithmException | NoSuchPaddingException | InvalidKeyException | IllegalBlockSizeException | BadPaddingException e) {
            e.printStackTrace();
            return null;
        }
    }

    private synchronized void loadKey() {
        if (isNull(pKey)) {
            try {
                System.out.println("loadKey -> MAKE SURE YOU CHANGE KEY DIRECTORY ON DIFFERENT MACHINE!!!");
                ObjectInputStream stream = new ObjectInputStream(new FileInputStream(new File("F:\\Development\\Android\\Projects\\TicTacToe\\PrivateKey.key")));
                pKey = (PrivateKey) stream.readObject();
            } catch (IOException | ClassNotFoundException e) {
                e.printStackTrace();
            }
        }
    }

    private synchronized void initCipher() {
        if (isNull(cipher)) {
            try {
                cipher = Cipher.getInstance("RSA/ECB/PKCS1Padding");
                cipher.init(Cipher.DECRYPT_MODE, pKey);
            } catch (NoSuchAlgorithmException | NoSuchPaddingException | InvalidKeyException e) {
                e.printStackTrace();
            }
        }
    }

}
