//
//  TTT_lib.h
//  TTT.lib
//
//  Created by hackeru on 26/04/2017.
//  Copyright © 2017 Alon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTT_lib : NSObject

@property (nonatomic, setter=setNothing:) NSString* A_login;
@property (nonatomic, setter=setNothing:) NSString* A_register;
@property (nonatomic, setter=setNothing:) NSString* A_joinHost;
@property (nonatomic, setter=setNothing:) NSString* A_acceptRequest;
@property (nonatomic, setter=setNothing:) NSString* A_declineRequest;
@property (nonatomic, setter=setNothing:) NSString* A_pollRequests;
@property (nonatomic, setter=setNothing:) NSString* A_pollHosts;
@property (nonatomic, setter=setNothing:) NSString* A_requestToJoin;
@property (nonatomic, setter=setNothing:) NSString* A_pollStatus;
@property (nonatomic, setter=setNothing:) NSString* A_conqure;
@property (nonatomic, setter=setNothing:) NSString* A_pollWhatAmI;
@property (nonatomic, setter=setNothing:) NSString* A_pollGameStatus;
@property (nonatomic, setter=setNothing:) NSString* A_pollTurn;
@property (nonatomic, setter=setNothing:) NSString* A_pollBoard;
@property (nonatomic, setter=setNothing:) NSString* A_pollGame;
@property (nonatomic, setter=setNothing:) NSString* A_surrender;
@property (nonatomic, setter=setNothing:) NSString* A_logout;

@property (nonatomic, setter=setNothing:) NSString* K_action;
@property (nonatomic, setter=setNothing:) NSString* K_username;
@property (nonatomic, setter=setNothing:) NSString* K_password;
@property (nonatomic, setter=setNothing:) NSString* K_gameToken;
@property (nonatomic, setter=setNothing:) NSString* K_userToken;
@property (nonatomic, setter=setNothing:) NSString* K_hostToken;
@property (nonatomic, setter=setNothing:) NSString* K_conqureSquare;

@property (nonatomic, setter=setNothing:) NSString* M_resOk;
@property (nonatomic, setter=setNothing:) NSString* M_resStatusIdle;
@property (nonatomic, setter=setNothing:) NSString* M_resStatusHasRequests;
@property (nonatomic, setter=setNothing:) NSString* M_resStatusWaitingForAnswer;
@property (nonatomic, setter=setNothing:) NSString* M_resStatusNoRequests;
@property (nonatomic, setter=setNothing:) NSString* M_resStatusInGame;
@property (nonatomic, setter=setNothing:) NSString* M_resGameXWon;
@property (nonatomic, setter=setNothing:) NSString* M_resGameOWon;
@property (nonatomic, setter=setNothing:) NSString* M_resGameDraw;
@property (nonatomic, setter=setNothing:) NSString* M_resGameSlotNotEmpty;
@property (nonatomic, setter=setNothing:) NSString* M_resGameNotYourTurn;
@property (nonatomic, setter=setNothing:) NSString* M_resGameIAmX;
@property (nonatomic, setter=setNothing:) NSString* M_resGameIAmO;
@property (nonatomic, setter=setNothing:) NSString* M_resGameXTurn;
@property (nonatomic, setter=setNothing:) NSString* M_resGameOTurn;
@property (nonatomic, setter=setNothing:) NSString* M_resGameNoPositionGiven;
@property (nonatomic, setter=setNothing:) NSString* M_resGameStatusLive;
@property (nonatomic, setter=setNothing:) NSString* M_resGameStatusEndedX;
@property (nonatomic, setter=setNothing:) NSString* M_resGameStatusEndedO;
@property (nonatomic, setter=setNothing:) NSString* M_resGameStatusEndedD;
@property (nonatomic, setter=setNothing:) NSString* M_resGameStatusStopped;
@property (nonatomic, setter=setNothing:) NSString* M_resErrRegUsernameTaken;
@property (nonatomic, setter=setNothing:) NSString* M_resErrRegPasswordWeak;
@property (nonatomic, setter=setNothing:) NSString* M_resErrLoginBadPassOrUser;
@property (nonatomic, setter=setNothing:) NSString* M_resErrUserNotOnline;
@property (nonatomic, setter=setNothing:) NSString* M_resErrHostWasntLocated;
@property (nonatomic, setter=setNothing:) NSString* M_resErrNoGameFound;
@property (nonatomic, setter=setNothing:) NSString* M_resErrInvalidMove;
@property (nonatomic, setter=setNothing:) NSString* M_resErrIllegalToken;
@property (nonatomic, setter=setNothing:) NSString* M_resErrTokenNoLongerInUser;
@property (nonatomic, setter=setNothing:) NSString* M_resErrNoUserFound;
@property (nonatomic, setter=setNothing:) NSString* M_resErrAlreadyWaiting;
@property (nonatomic, setter=setNothing:) NSString* M_resErrHostNotOnline;
@property (nonatomic, setter=setNothing:) NSString* M_resErrAlreadyRequestToJoin;
@property (nonatomic, setter=setNothing:) NSString* M_resErrGameNotLive;
@property (nonatomic, setter=setNothing:) NSString* M_resErrNotYourGame;

@property (nonatomic, setter=setNothing:) NSString* M_repX;
@property (nonatomic, setter=setNothing:) NSString* M_repO;

@property (nonatomic, setter=setNothing:) NSString* M_DEFAULT_ESCAPE_CHAR;
@property (nonatomic, setter=setNothing:) NSString* M_DEFAULT_URL;
@property (nonatomic, setter=setNothing:) NSString* M_ASKED_FLAG;
@property (nonatomic, setter=setNothingI:) NSInteger M_DEFAULT_CHUNK_SIZE;

@property (nonatomic, setter=setNothing:) NSString* DK_token;
@property (nonatomic, setter=setNothing:) NSString* DK_gameToken;
@property (nonatomic, setter=setNothing:) NSString* DK_symbol;
@property (nonatomic, setter=setNothing:) NSString* DK_turnX;
+ (id) pullInstance;

- (NSURL *) generateURLFor: (NSString *) url withPairs:(NSArray *) pairs;

@end
