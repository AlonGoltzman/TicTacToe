//
//  ServerResponse.m
//  TTT.lib
//
//  Created by hackeru on 26/04/2017.
//  Copyright © 2017 Alon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTT_lib.h"
#import "ServerResponse.h"

@implementation ServerResponse

+(ServerResponse *)findResponseFor:(NSString *)input{
    TTT_lib * lib = [TTT_lib pullInstance];
    ServerResponse * response = [[ServerResponse alloc]init];
    response.responseLiteral = input;
    if([input isEqualToString:lib.M_resErrUserNotOnline]){
        response.responseType = ERROR;
        response.responseInfo = @"User Not Online.";
    } else if ([input isEqualToString:lib.M_resErrIllegalToken]){
        response.responseType = ERROR;
        response.responseInfo = @"Token not valid.";
    } else if ([input isEqualToString:lib.M_resErrRegUsernameTaken]){
        response.responseType = EXCEPTION;
        response.responseInfo = @"Username taken.";
    } else if ([input isEqualToString:lib.M_resErrRegPasswordWeak]){
        response.responseType = EXCEPTION;
        response.responseInfo = @"Password too weak.";
    } else if ([input isEqualToString:lib.M_resErrLoginBadPassOrUser]){
        response.responseType = EXCEPTION;
        response.responseInfo = @"Bad Login.";
    } else if ([input isEqualToString:lib.M_resErrAlreadyWaiting]){
        response.responseType = EXCEPTION;
        response.responseInfo = @"Already waiting in the host queue.";
    } else if ([input isEqualToString:lib.M_resErrAlreadyRequestToJoin]){
        response.responseType = EXCEPTION;
        response.responseInfo = @"Already asked to join.";
    } else if ([input isEqualToString:lib.M_resErrHostNotOnline]){
        response.responseType = EXCEPTION;
        response.responseInfo = @"Host not online.";
    } else if ([input isEqualToString:lib.M_resErrHostWasntLocated]){
        response.responseType = EXCEPTION;
        response.responseInfo = @"Host wasn't located.";
    } else if ([input isEqualToString:lib.M_resErrNoUserFound]){
        response.responseType = EXCEPTION;
        response.responseInfo = @"No user found.";
    } else if ([input isEqualToString:lib.M_resGameNotYourTurn]){
        response.responseType = EXCEPTION;
        response.responseInfo = @"Not your turn.";
    } else if ([input isEqualToString:lib.M_resGameSlotNotEmpty]){
        response.responseType = EXCEPTION;
        response.responseInfo = @"Not empty.";
    } else if ([input isEqualToString:lib.M_resOk]){
        response.responseType = OK;
    } else if ([input isEqualToString:lib.M_resStatusHasRequests]){
        response.responseType = STATUS;
        response.responseInfo = @"New game requests.";
    } else if ([input isEqualToString:lib.M_resStatusIdle]){
        response.responseType = STATUS;
        response.responseInfo = @"You are currently idle.";
    } else if ([input isEqualToString:lib.M_resStatusNoRequests]){
        response.responseType = STATUS;
        response.responseInfo = @"No new game requests.";
    } else if ([input isEqualToString:lib.M_resStatusInGame]){
        response.responseType = STATUS;
        response.responseInfo = @"You are in a game.";
    } else if ([input isEqualToString:lib.M_resGameIAmX]){
        response.responseType = GAME_INFO;
        response.responseInfo = @"You are X.";
    } else if ([input isEqualToString:lib.M_resGameIAmO]){
        response.responseType = GAME_INFO;
        response.responseInfo = @"You are O";
    } else if ([input isEqualToString:lib.M_resGameXTurn]){
        response.responseType = GAME_INFO;
        response.responseInfo = @"It's X's turn.";
    } else if ([input isEqualToString:lib.M_resGameOTurn]){
        response.responseType = GAME_INFO;
        response.responseInfo = @"It's O's turn.";
    } else if ([input isEqualToString:lib.M_resGameXWon]){
        response.responseType = GAME_INFO;
        response.responseInfo = @"X Won!";
    } else if ([input isEqualToString:lib.M_resGameOWon]){
        response.responseType = GAME_INFO;
        response.responseInfo = @"O Won!";
    } else if ([input isEqualToString:lib.M_resGameDraw]){
        response.responseType = GAME_INFO;
        response.responseInfo = @"It's a Draw!";
    } else if ([input isEqualToString:lib.M_resGameStatusStopped]){
        response.responseType = GAME_STATUS;
        response.responseInfo = @"The opponent quit.";
    } else if ([input isEqualToString:lib.M_resErrGameNotLive]){
        response.responseType = GAME_STATUS;
        response.responseInfo = @"Game live.";
    } else if ([input isEqualToString:lib.M_resGameStatusEndedX]){
        response.responseType = GAME_STATUS;
        response.responseInfo = @"X Won!";
    } else if ([input isEqualToString:lib.M_resGameStatusEndedO]){
        response.responseType = GAME_STATUS;
        response.responseInfo = @"O Won!";
    } else if ([input isEqualToString:lib.M_resGameStatusLive]){
        response.responseType = GAME_STATUS;
    } else {
        NSError *err = NULL;
        NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:@"\\w{20,30}+" options:0 error:&err];
        if(err != NULL){
            NSLog(@"something.");
            return nil;
        }
        NSUInteger matches = [expression numberOfMatchesInString:input options:0 range:NSMakeRange(0, [input length])];
        if(matches == 1 && !([input containsString:@"&"]) && !([input containsString:@"~"])){
            response.responseType = TOKEN;
        }else{
            expression = [NSRegularExpression regularExpressionWithPattern:@"\\w{45,60}+" options:0 error:&err];
            if(err != NULL){
                NSLog(@"something.");
                return nil;
            }
            matches = [expression numberOfMatchesInString:input options:0 range:NSMakeRange(0, [input length])];
            if(matches == 1 && !([input containsString:@"&"]) && !([input containsString:@"~"])){
                response.responseType = GAME_TOKEN;
            }else{
                if([input containsString:@"~"] || [input containsString:@"&"])
                    response.responseType = LIST;
                else
                    response.responseType = UNKNOWN;
            }
        }
    }
    return response;
}

@end
