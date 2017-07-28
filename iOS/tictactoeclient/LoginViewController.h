//
//  ViewController.h
//  tictactoeclient
//
//  Created by Admin on 27/04/2017.
//  Copyright © 2017 Alon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTT_lib.h"
#import "ServerAssistant.h"
#import "ServerResponse.h"
#import "Pair.h"
#import "Util.h"

@interface LoginViewController : UIViewController <ServerAssistantResponseDelegate>

/*!
 @brief Should the view controller switch to the game view controller once it reappears on the screen.
 */
@property BOOL switchToGame;

/*!
 @brief Should the view controller switch to the lobby view controller once it reappears on the screen.
 */
@property BOOL switchToLobby;

@end

