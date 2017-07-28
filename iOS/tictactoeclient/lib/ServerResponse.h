//
//  ServerResponse.h
//  TTT.lib
//
//  Created by hackeru on 26/04/2017.
//  Copyright © 2017 Alon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerResponse : NSObject

typedef enum{
    OK,
    ERROR,
    EXCEPTION,
    GAME_STATUS,
    STATUS,
    TOKEN,
    GAME_TOKEN,
    LIST,
    GAME_INFO,
    NO_CONN_ESTABLISHED,
    INVALID_SERVER_CALL,
    INVALID_PARAMETERS,
    UNKNOWN
} ServerResponseType;

@property(nonnull, nonatomic, readwrite, copy) NSString *responseInfo;
@property(nonnull, nonatomic, readwrite, copy) NSString *responseLiteral;
@property(nonatomic, readwrite, assign) ServerResponseType responseType;
+(ServerResponse * _Nonnull) findResponseFor:(NSString * _Nonnull) input;
@end
