//
//  UIAssosiativeButton.h
//  tictactoeclient
//
//  Created by hackeru on 07/05/2017.
//  Copyright © 2017 Alon. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "TTTUser.h"

typedef enum{
    UIAssosiativeButtonTypeJoin,
    UIAssosiativeButtonTypeAccept,
    UIAssosiativeButtonTypeDecline
} UIAssosiativeButtonType;

@interface UIAssosiativeButton : UIButton
{
    TTTUser *user;
}

@property (nonatomic, assign) int *btnType;

-(void)setUser:(TTTUser *)usr;
-(TTTUser *)user;
@end
