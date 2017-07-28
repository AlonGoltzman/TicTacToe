//
//  ServerAssistant.m
//  TTT.lib
//
//  Created by hackeru on 26/04/2017.
//  Copyright © 2017 Alon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerAssistant.h"
#import "ServerAssistantResponseDelegate.h"
#import "TTT_lib.h"
#import "Pair.h"

@implementation ServerAssistant{
    BOOL _verbose;
    BOOL _emulator;
    TTT_lib * lib;
}

@synthesize ip;

+(id) instantiateWithVerbose:(BOOL)verbose andFromEmulator:(BOOL)emulator{
    static ServerAssistant * assistant = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        assistant = [[ServerAssistant alloc]initWithVerbose:verbose andFromEmulator:emulator];
    });
    return assistant;
}

-(id)initWithVerbose:(BOOL)verbose andFromEmulator:(BOOL) emualtor{
    if(self = [super init]){
        _verbose = verbose;
        _emulator = emualtor;
        lib = [TTT_lib pullInstance];
    }
    return self;
}

-(void)invokeServerCall:(ServerCall)call withValues:(NSArray *)values invokeDelegateOnComplete:(id<ServerAssistantResponseDelegate>) delegate{
    if(delegate == nil || ![delegate respondsToSelector:NSSelectorFromString(@"requestCompletedFor:")]){
        NSLog(@"Passed 'nil' as delegate or doesn't implement method.");
        @throw NSGenericException;
    }
    ServerResponse * result = [[ServerResponse alloc] init];
    result.responseType = INVALID_SERVER_CALL;
    Pair * action = [[Pair alloc]initWithKey:lib.K_action andValue:@""];
    NSString * actionLiteral;
    NSMutableArray<Pair *> * pairs = [[NSMutableArray alloc]init];
    switch(call){
        case POLL_STATUS:
        case POLL_REQUESTS:
        case POLL_HOSTS:
        case POLL_GAME_TOKEN:
        case JOIN_HOSTS:
        {
            actionLiteral = (call == POLL_STATUS ? lib.A_pollStatus : (call == POLL_REQUESTS ? lib.A_pollRequests : (call == JOIN_HOSTS ? lib.A_joinHost : (call == POLL_HOSTS ? lib.A_pollHosts : lib.A_pollGame))));
            id pair = [values objectAtIndex:0];
            if([pair isKindOfClass:NSClassFromString(@"Pair")]){
                [pairs addObject:pair];
            } else {
                result.responseType = INVALID_PARAMETERS;
                [delegate requestCompletedFor:result];
            }
            break;
        }
        case JOIN_REQUEST:
        case ACCEPT_USER:
        case DECLINE_USER:
        case POLL_BOARD:
        case POLL_WHAT_AM_I:
        case POLL_TURN:
        case POLL_GAME_STATUS:
        case LOGIN:
        case LOGOUT:
        case REGISTER:
        case QUIT_GAME:
        case CONQURE:
        {
            actionLiteral = (call == JOIN_REQUEST ? lib.A_requestToJoin :
                             (call == DECLINE_USER ? lib.A_declineRequest :
                              (call == ACCEPT_USER ? lib.A_acceptRequest :
                               (call == POLL_WHAT_AM_I ? lib.A_pollWhatAmI :
                                (call == POLL_BOARD ? lib.A_pollBoard :
                                 (call == POLL_TURN ? lib.A_pollTurn :
                                  (call == POLL_GAME_STATUS ? lib.A_pollGameStatus :
                                   (call == REGISTER ? lib.A_register :
                                    (call == LOGIN ? lib.A_login :
                                     (call == CONQURE ? lib.A_conqure :
                                      (call == QUIT_GAME? lib.A_surrender :
                                       lib.A_logout)))))))))));
            for(id pair in values){
                if([pair isKindOfClass:NSClassFromString(@"Pair")]){
                    [pairs addObject:pair];
                } else {
                    result.responseType = INVALID_PARAMETERS;
                    [delegate requestCompletedFor:result];
                }
            }
            break;
        }
    }
    [action setValue:actionLiteral];
    [pairs addObject:action];
    NSURL *genURL = [lib generateURLFor:lib.M_DEFAULT_URL withPairs:pairs];
    [self processConnectionFor:genURL withDelegate:delegate];
}

-(void)processConnectionFor:(NSURL *)url withDelegate:(id<ServerAssistantResponseDelegate>) delegate{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    request.HTTPMethod = @"GET";
    request.cachePolicy = NSURLCacheStorageNotAllowed;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error != nil && error != NULL){
            NSLog(@"%@", error.localizedDescription);
            return;
        }
        NSString *responseInput = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [delegate requestCompletedFor:[ServerResponse findResponseFor:responseInput]];
        });
    }];
    [task resume];
}


@end
