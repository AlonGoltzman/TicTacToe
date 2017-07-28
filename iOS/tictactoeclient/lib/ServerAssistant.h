//
//  ServerAssistant.h
//  TTT.lib
//
//  Created by hackeru on 26/04/2017.
//  Copyright © 2017 Alon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerResponse.h"
#import "ServerAssistantResponseDelegate.h"

typedef enum{
    LOGIN,LOGOUT, REGISTER, POLL_STATUS, POLL_HOSTS, POLL_REQUESTS,
    JOIN_HOSTS, JOIN_REQUEST,
    ACCEPT_USER, DECLINE_USER,
    POLL_GAME_TOKEN, POLL_WHAT_AM_I,
    POLL_GAME_STATUS, POLL_TURN, POLL_BOARD, CONQURE, QUIT_GAME
}ServerCall;

@interface ServerAssistant : NSObject

@property(nonatomic,readwrite,copy)NSString *ip;

+(id)instantiateWithVerbose:(BOOL) verbose andFromEmulator: (BOOL) emulator;

-(void) invokeServerCall:(ServerCall)call withValues:(NSArray *)values invokeDelegateOnComplete:(id<ServerAssistantResponseDelegate>) delegate;

@end
