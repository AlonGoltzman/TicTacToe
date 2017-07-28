//
//  LobbyViewController.h
//  tictactoeclient
//
//  Created by Admin on 01/05/2017.
//  Copyright © 2017 Alon. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "ServerAssistantResponseDelegate.h"
#import "LoginViewController.h"
#import "Util.h"
#import "Pair.h"
#import "TTT_lib.h"
#import "TTTUser.h"
#import "UIAssosiativeButton.h"

@interface LobbyViewController : UIViewController <ServerAssistantResponseDelegate, UITableViewDelegate, UITableViewDataSource>

@property LoginViewController *mainView;

@end
