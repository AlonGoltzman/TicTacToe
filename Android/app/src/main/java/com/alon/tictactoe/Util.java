package com.alon.tictactoe;

import android.os.AsyncTask;

import com.tictactoe.contstants.Constants;

import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;

/**
 * Created by Alon on 1/6/2017.
 */

public class Util implements Constants {

    public static final String IS_EMULATOR = "1";

    private static Util instance;

    private HashMap<String, Object> mVars;

    public static Util getInstance() {
        return instance == null ? new Util() : instance;
    }

    private Util() {
        instance = this;
        mVars = new HashMap<>();
    }

    public AsyncTask getTask(OnPostExecute execute, String strUrl) {
        return new AsynWrapper(execute, strUrl) {
            @Override
            protected String doInBackground(String... params) {
                try {
                    URL siteURL = new URL(url);
                    HttpURLConnection conn = (HttpURLConnection) siteURL.openConnection();
                    conn.setRequestMethod("GET");
                    conn.setUseCaches(false);
                    conn.connect();

                    InputStream in = conn.getInputStream();
                    byte[] buffer = new byte[512];
                    int aRead;

                    StringBuilder builder = new StringBuilder();

                    while ((aRead = in.read(buffer)) != -1)
                        builder.append(new String(buffer, 0, aRead));

                    return builder.toString();

                } catch (IOException ex) {
                    return ERR_CONNECTION_REFUSED;
                }
            }

            @Override
            protected void onPostExecute(String s) {
                postExecute.onPostExecute(s);
            }
        };
    }

    public void addVar(String key, Object var) {
        mVars.put(key, var);
    }

    public Object getVar(String key) {
        return mVars.get(key);
    }


    private abstract class AsynWrapper extends AsyncTask<String, Void, String> {

        OnPostExecute postExecute;
        String url;

        AsynWrapper(OnPostExecute execute, String URL) {
            postExecute = execute;
            url = URL;
        }

    }

}
