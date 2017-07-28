//
//  UIGameBoard.h
//  tictactoeclient
//
//  Created by hackeru on 10/05/2017.
//  Copyright © 2017 Alon. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "GameViewController.h"

@interface UIGameBoard : NSObject

@property GameViewController *controller;
@property NSArray<NSString *>* gameBoard;

-(instancetype) initWithFrame:(CGRect) frame
            andGameController:(GameViewController *)gvController
                     andBoard:(NSArray<NSString *>*) board;
-(void) enabled:(BOOL) f;
-(void) clearScreen;
-(void) reloadInfo;

-(int)what:(UIButton *)buttonWasClicked;

@end
