//
//  TTT_lib.m
//  TTT.lib
//
//  Created by hackeru on 26/04/2017.
//  Copyright © 2017 Alon. All rights reserved.
//

#import "TTT_lib.h"
#import "Pair.h"

@implementation TTT_lib
{
    const TTT_lib *instance;
}

+(id) pullInstance{
    static TTT_lib *instance;
    static dispatch_once_t dispatcher;
    dispatch_once(&dispatcher, ^{
        instance = [[self alloc]init];
    });
    return instance;
}


-(id) init{
    if(self = [super init]){
        //C.A equivelant in iOS.
        self->_A_login=@"lo";
        self->_A_register=@"r";
        self->_A_joinHost=@"jH";
        self->_A_acceptRequest=@"aR";
        self->_A_declineRequest=@"dR";
        self->_A_pollRequests=@"pR";
        self->_A_pollHosts=@"pH";
        self->_A_requestToJoin=@"rJG";
        self->_A_pollStatus=@"pS";
        self->_A_conqure=@"c";
        self->_A_pollWhatAmI =@"pXORO";
        self->_A_pollGameStatus=@"pGS";
        self->_A_pollTurn=@"pT";
        self->_A_pollBoard = @"pB";
        self->_A_pollGame = @"pG";
        self->_A_surrender = @"s";
        self->_A_logout = @"e";
        //C.K equivelant in iOS.
        self->_K_action=@"a";
        self->_K_username=@"uN";
        self->_K_password=@"pW";
        self->_K_gameToken=@"gT";
        self->_K_userToken=@"uT";
        self->_K_hostToken=@"hT";
        self->_K_conqureSquare=@"cS";
        //C.M equivelant in iOS.
        self->_M_resOk=@"0";
        self->_M_resStatusIdle=@"1";
        self->_M_resStatusHasRequests=@"2";
        self->_M_resStatusWaitingForAnswer=@"3";
        self->_M_resStatusNoRequests=@"4";
        self->_M_resStatusInGame=@"5";
        self->_M_resGameXWon=@"10";
        self->_M_resGameOWon=@"20";
        self->_M_resGameDraw=@"30";
        self->_M_resGameSlotNotEmpty=@"40";
        self->_M_resGameNotYourTurn=@"50";
        self->_M_resGameIAmX=@"60";
        self->_M_resGameIAmO=@"70";
        self->_M_resGameXTurn=@"80";
        self->_M_resGameOTurn=@"90";
        self->_M_resGameNoPositionGiven=@"100";
        self->_M_resGameStatusLive=@"21";
        self->_M_resGameStatusEndedX=@"22";
        self->_M_resGameStatusEndedO=@"23";
        self->_M_resGameStatusEndedD=@"24";
        self->_M_resGameStatusStopped=@"25";
       
        self->_M_resErrRegUsernameTaken=@"-1";
        self->_M_resErrRegPasswordWeak=@"-2";
        self->_M_resErrLoginBadPassOrUser=@"-3";
        self->_M_resErrUserNotOnline=@"-4";
        self->_M_resErrHostWasntLocated=@"-5";
        self->_M_resErrNoGameFound=@"-6";
        self->_M_resErrInvalidMove=@"-7";
        self->_M_resErrIllegalToken=@"-8";
        self->_M_resErrTokenNoLongerInUser=@"-9";
        self->_M_resErrNoUserFound=@"-10";
        self->_M_resErrAlreadyWaiting=@"-11";
        self->_M_resErrHostNotOnline=@"-12";
        self->_M_resErrAlreadyRequestToJoin=@"-13";
        self->_M_resErrGameNotLive=@"-14";
        self->_M_resErrNotYourGame=@"-15";
        
        self->_M_repX=@"11";
        self->_M_repO=@"12";
        
        self->_M_DEFAULT_ESCAPE_CHAR=@"~";
        self->_M_DEFAULT_URL=@"http://10.0.0.2:75/ttt?";
        self->_M_ASKED_FLAG=@"###";
        self->_M_DEFAULT_CHUNK_SIZE=64;
        
        self->_DK_token = @"a";
        self->_DK_gameToken = @"b";
        self->_DK_symbol = @"c";
        self->_DK_turnX = @"d";
    }
    return self;
}

-(NSURL *) generateURLFor:(NSString *)url withPairs:(NSArray *)pairs{
    NSMutableString *response = [[NSMutableString alloc] initWithString:url];
    for(id item in pairs){
        if([item isKindOfClass:NSClassFromString(@"Pair")]){
            if([item respondsToSelector:NSSelectorFromString(@"value")] && [item respondsToSelector:NSSelectorFromString(@"key")])
                [response appendString:[NSString stringWithFormat:@"%@=%@&", ((Pair *)item).key, ((Pair *)item).value]];
        }		
    }
    [response deleteCharactersInRange:NSMakeRange(response.length - 1, 1)];
    return [[NSURL alloc]initWithString:response];
}

-(void) setNothing:(NSString *)val{
    return;
}
-(void) setNothingI:(NSInteger)val{
    return;
}

@end
