package com.tictactoe.contstants;

/**
 * Created by Alon on 1/2/2017.
 */
public interface TTTConstants {

    String ACTION_KEY = "action";
    String USERNAME_KEY = "username";
    String PASSWORD_KEY = "password";
    String TOKEN_KEY = "token";
    String SEC_TOKEN_KEY = "secToken";
    String GAME_KEY = "gameID";
    String POS_KEY = "pos";

    String ACTION_LOGIN = "login";
    String ACTION_REGISTER = "signup";
    String ACTION_ADD_HOST = "addToWait";
    String ACTION_POLL_HOSTS = "pollWait";
    String ACTION_POLL_STATUS = "pollStatus";
    String ACTION_POLL_WAITERS = "pollQueue";
    String ACTION_TRY_JOIN = "join";
    String ACTION_TRY_JOIN_DECLINE = "joinDecline";
    String ACTION_TRY_JOIN_ACCEPT = "joinAccept";
    String ACTION_DISCONNECT = "disconnect";
    String ACTION_REMOVE_HOST = "removeHost";
    String ACTION_LEAVE_GAME = "leaveGame";
    String ACTION_GET_PLACEMENTS = "gamePlacements";
    String ACTION_GET_GAME_ID = "getGameID";

    String ACTION_MAKE_MOVE = "move";

    String ERR_USER_NOT_ONLINE = "-100";
    String ERR_HOST_NOT_ONLINE = "-99";

    String ERR_NO_USER_FOUND = "-15";
    String ERR_PASSWORD_OR_USERNAME = "-14";
    String ERR_USER_ALREADY_EXISTS = "-13";
    String ERR_ALREADY_WAITING = "-12";
    String ERR_HOST_ISNT_ON_WAIT = "-11";
    String ERR_ALREADY_ACCEPTED = "-10";
    String ERR_NO_HOST_FOUND = "-9";
    String ERR_HOST_REGISTERED = "-8";
    String ERR_NO_REQUESTS_FOR_HOST = "-7";
    String ERR_REQUEST_DOESNT_EXIST = "-6";
    String ERR_CLIENT_ALREADY_IN_GAME = "-5";
    String ERR_USER_NOT_IN_GAME = "-4";
    String ERR_CONNECTION_REFUSED = "-3";
    String ERR_GAME_DOESNT_EXISTS = "-2";
    String ERR_SECOND_PLAYER_NOT_ONLINE = "-1";
    String ERR_UNKNOWN_ERROR = "0";

    String STATUS_IDLE = "10";
    String STATUS_WAITING_FOR_SOMEONE = "11";
    String STATUS_WAITING_FOR_RESPONSE = "12";
    String STATUS_DECLINED_REQUEST = "13";
    String STATUS_ACCEPTED_REQUEST = "14";
    String STATUS_IN_GAME = "15";
    String STATUS_IN_GAME_X = "16";
    String STATUS_IN_GAME_O = "17";

    String ESCAPE_STRING = "&";

    Byte GAME_NO_RESULT_YET = 0;
    Byte GAME_X_WON = 1;
    Byte GAME_O_WON = 2;
    Byte GAME_NO_VICTORY = 3;

    String GAME_VALID_MOVE = "ok";
    String GAME_X_VICTORY = "XV";
    String GAME_O_VICTORY = "OV";
    String GAME_DRAW = "D";
    String GAME_OCCUPIED_CELL = "OC";
    String GAME_INVALID_MOVE = "IM";

    String ANDROID_BUNDLE_TOKEN_ID = "token_id";
    String ANDROID_BUNDLE_USERNAME_ID = "user_id";
    String ANDROID_BUNDLE_LIST_ID = "host_list";
    String ANDROID_BUNDLE_HOST_FLAG = "ishost";
    String ANDROID_BUNDLE_GAME_ID = "game_id";

    String RESULT_OK = "-10492";
}
