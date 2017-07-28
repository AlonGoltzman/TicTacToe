//
//  Util.h
//  tictactoeclient
//
//  Created by Admin on 30/04/2017.
//  Copyright © 2017 Alon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerAssistantResponseDelegate.h"
#import "ServerResponse.h"
#import "ServerAssistant.h"
@interface Util : NSObject

/*!
 @brief Uses a static instance of ServerAssistant and invoked a server call, with the needed Pairs, provided by the user.
 
 @param call - The server call that needs to be invoked.
 
 @param pairs - An NSArray of type Pair, containing all the needed values, such as user's token, game token, and so on.
 
 @param delegate - A delegate that conforms to ServerAssistantResponseDelegate to be executed once communication is done with the server.
 */
+(void) invoke:(ServerCall) call withArgs:(NSArray *) pairs andDelegate: (id<ServerAssistantResponseDelegate>) delegate;	

/*!
 @brief Used to display a toast on a given view controller.
 
 @param msg - The message, must not be over 40 character.
 
 @param controller - The view controller to present the toast on.
 
 @throws NSGenericException - if msg is over 40 characters.
 */

+(void) displayToastWithMessage:(NSString *)msg on:(UIViewController *)controller;


/*!
 @brief Loads the preference dictionary, containing the user logout time, token, game token, and other vital information.
 */
+(void) loadDictionary;
/*!
 @brief Save a value for a key in the dictionary, if value is nil, removes the key from the dictionary.
 
 @param value - The value to be saved, nil will erase the key-value pair from the dictionary.
 
 @param key - The key to update.
 */
+(void) saveValue:(NSObject *) value forKey:(NSString *)key;
/*!
 @brief Gets the value for a certain key.
 
 @param key - The key to which the value pair should be returned.
 
 @returns The value associated with the given key.
 */
+(NSObject *) getValueForKey:(NSString *) key;

/*!
 @brief Refreshes the logout time of the user, default logout time is 5 minutes, updated when a user performs an action on the screen.
 */
+(void) refreshLogoutTime;

/*!
 @brief Returns whether or no the user has been logged out.
 
 @returns YES if the user has been logged out, NO otherwise. [Logged out means past the 5 minute inactivity threshold].
 */
+(BOOL) hasUserBeenLoggedOut;

/*!
 @brief Returns whether or no it's the user's turn.
 
 @returns YES if it is, NO otherwise.
 */
+(BOOL) isMyTurn;

/*!
 @brief Toggle the current turn.
 */
+(void) toggleTurn;

+(NSString *) turnInfo;

+(NSString *) mySymbol;
@end
