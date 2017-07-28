//
//  ServerAssistantResponseDelegate.h
//  TTT.lib
//
//  Created by Admin on 27/04/2017.
//  Copyright © 2017 Alon. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "ServerResponse.h"

/*!
    @brief This Protocol is used to pass an argument to the ServerAssistant, so that once the communication with the server ends,
    we can send a response to the current view controller.
 */
@protocol ServerAssistantResponseDelegate <NSObject>

@required
/*!
 @brief The method that will be called upon receiving and parsing a response from the server.
    
 @param response - The ServerResponse object parsed from the server.
 
 @see ServerResponse.h
 */
-(void) requestCompletedFor: (ServerResponse *) response;


/*!
 @brief Once a server call has taken too long, or the parsed response determined that there is no connection this method will be called, 
 it needs to be used to log the user out and delete his token.
 */
-(void) timedout;
@end
