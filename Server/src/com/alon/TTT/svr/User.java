package com.alon.TTT.svr;

import com.alon.TTT.lib.C;

import javax.servlet.http.HttpServlet;
import java.math.BigInteger;
import java.security.SecureRandom;
import java.util.ArrayList;

/**
 * Created by Alon on 3/9/2017.
 */
public class User {

    private static final User nullDef = new User();

    private final String uName;
    private final String pWord;

    private String token;

    private boolean loggedIn;

    private TimeoutThread thread;

    private String status = C.M.resStatusIdle;
    private final ArrayList<User> requests = new ArrayList<>(1);

    private User() {
        uName = null;
        pWord = null;
    }

    public User(String username, String password, boolean online) {
        uName = username;
        pWord = password;
        setLoggedIn(online);
        generateToken();
        System.out.println("User init -> New user: " + username + " online status: " + online + " token designation: " + token);
        thread = new TimeoutThread();
        thread.start();
    }

    String refreshToken() {
        generateToken();
        return token;
    }

    private void generateToken() {
        token = new BigInteger(128, new SecureRandom()).toString(32);
    }


    boolean addRequest(User user) {
        synchronized (requests) {
            if (!requests.contains(user)) {
                requests.add(user);
                status = C.M.resStatusHasRequests;
            } else
                return false;
        }
        return true;
    }

    boolean containsRequest(User user) {
        synchronized (requests) {
            return requests.contains(user);
        }
    }

    //Setters and getters =============================
    boolean isLoggedIn() {
        return loggedIn;
    }

    void setLoggedIn(boolean flag) {
        if (!flag) {
            thread.interrupt();
        }
        loggedIn = flag;
    }

    String getUsername() {
        return uName;
    }

    String getPassword() {
        return pWord;
    }

    String getToken() {
        return token;
    }

    String getStatus() {
        return status;
    }

    static User getNullDefinition() {
        return nullDef;
    }

    @Override
    public String toString() {
        return getUsername() + "~" + getToken();
    }

    @Override
    public boolean equals(Object other) {
        return other instanceof User && getToken().equals(((User) other).getToken()) && getUsername().equals(((User) other).getUsername()) && getPassword().equals(((User) other).getPassword());
    }


    private final class TimeoutThread extends Thread {


        private long startTime;

        TimeoutThread() {
            refreshTimeout();
        }

        @Override
        public void run() {
            if (System.currentTimeMillis() - startTime > 1000 * 60 * 60) {
                setLoggedIn(false);
            } else {
                try {
                    Thread.sleep(1000 * 60 * 10);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        }

        void refreshTimeout() {
            startTime = System.currentTimeMillis();
        }
    }
}
