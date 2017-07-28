//
//  GameViewController.h
//  tictactoeclient
//
//  Created by Admin on 09/05/2017.
//  Copyright © 2017 Alon. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "ServerAssistantResponseDelegate.h"
#import "Util.h"
#import "TTT_lib.h"
#import "Pair.h"

#import "LoginViewController.h"

@interface GameViewController : UIViewController < ServerAssistantResponseDelegate>

@property LoginViewController *mainView;

@end
