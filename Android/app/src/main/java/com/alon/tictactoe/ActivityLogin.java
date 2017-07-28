package com.alon.tictactoe;

import android.app.Activity;
import android.os.Build;
import android.os.Bundle;
import android.view.KeyEvent;
import android.view.View;
import android.view.inputmethod.EditorInfo;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.tictactoe.contstants.Constants;

import static com.alon.tictactoe.Util.IS_EMULATOR;

public class ActivityLogin extends Activity implements View.OnClickListener, OnPostExecute, Constants {

    private EditText mUser, mPass;
    private Util util;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);

        util = Util.getInstance();
        util.addVar(IS_EMULATOR, isEmulator());
        Button login = (Button) findViewById(R.id.LOGIN_login);
        Button register = (Button) findViewById(R.id.LOGIN_register);

        mUser = (EditText) findViewById(R.id.LOGIN_usr);
        mUser.setOnEditorActionListener(new TextView.OnEditorActionListener() {
            @Override
            public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
                if (actionId == EditorInfo.IME_ACTION_NEXT) {
                    mPass.requestFocus();
                    return true;
                }
                return false;
            }
        });

        mPass = (EditText) findViewById(R.id.LOGIN_wrd);
        mPass.setOnEditorActionListener(new TextView.OnEditorActionListener() {
            @Override
            public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
                if (actionId == EditorInfo.IME_ACTION_DONE) {
                    findViewById(R.id.LOGIN_login).callOnClick();
                    return true;
                }
                return false;
            }
        });

        login.setOnClickListener(this);
        register.setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        String usr = mUser.getText().toString();
        String pass = mPass.getText().toString();
        if (usr.isEmpty() || pass.isEmpty()) {
            Toast.makeText(this, "Missing info", Toast.LENGTH_SHORT).show();
            return;
        }
        String action = null;
        switch (v.getId()) {
            case R.id.LOGIN_login:
                action = ACTION_LOGIN;
                break;
            case R.id.LOGIN_register:
                action = ACTION_REGISTER;
                break;
        }
        String strURL = String.format("?%1$s=%2$s%3$s%4$s=%5$s%3$s%6$s=%7$s", ACTION_KEY, action,
                ESCAPE_STRING,
                USERNAME_KEY, usr,
                PASSWORD_KEY, pass);
        util.getTask(this, strURL);
    }

    @Override
    public void onPostExecute(String result) {

    }

    public boolean isEmulator() {
        return Build.FINGERPRINT.startsWith("generic")
                || Build.FINGERPRINT.startsWith("unknown")
                || Build.MODEL.contains("google_sdk")
                || Build.MODEL.contains("Emulator")
                || Build.MODEL.contains("Android SDK built for x86")
                || Build.MANUFACTURER.contains("Genymotion")
                || (Build.BRAND.startsWith("generic") && Build.DEVICE.startsWith("generic"))
                || "google_sdk".equals(Build.PRODUCT);
    }
}
