//
//  UIGameBoard.m
//  tictactoeclient
//
//  Created by hackeru on 10/05/2017.
//  Copyright © 2017 Alon. All rights reserved.
//
#import "UIGameBoard.h"

@implementation UIGameBoard
{
    UIView *container;
    UIButton *buttons[9];
    UIColor *enabledColor;
    UIColor *disabledColor;
}

@synthesize controller;
@synthesize gameBoard;

NSString *const __method_name = @"gameCellPressed:";

-(instancetype) initWithFrame:(CGRect) frame andGameController:(GameViewController *)gvController andBoard:(NSArray<NSString *>*) board{
    self = [super init];
    
    enabledColor = [UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1];
    disabledColor = [UIColor colorWithRed:0.75f green:0.75f blue:0.75f alpha:1];
    
    container = [[UIView alloc]initWithFrame:frame];
    [self setController:gvController];
    [self setGameBoard:board];
    int size = frame.size.width / 3;
    for(int i = 0; i < 3 ;i++)
        for(int j = 0; j < 3; j++){
            int index = i * 3 + j;
            buttons[index] = [UIButton buttonWithType:UIButtonTypeSystem];
            buttons[index].frame = CGRectMake(j * size,i * size, size - 20, size - 20);
            buttons[index].backgroundColor = disabledColor;
            [buttons[index] setTitle:[gameBoard objectAtIndex:index]  forState:UIControlStateNormal];
            if(![[gameBoard objectAtIndex:index] isEqualToString:@""]){
                [buttons[index] removeTarget:controller action:NSSelectorFromString(__method_name) forControlEvents:UIControlEventTouchUpInside];
                [buttons[index] setTitle:@"Not Empty" forState:UIControlStateHighlighted];
            } else {
                [buttons[index] addTarget:controller action:NSSelectorFromString(__method_name) forControlEvents:UIControlEventTouchUpInside];
            }
            [container addSubview:buttons[index]];
        }
    [controller.view addSubview:container];
    return self;
}

-(void)clearScreen{
    NSString *defaultCellValue = @"";
    NSArray<NSString *>* arr = [NSArray arrayWithObjects:
                                defaultCellValue,
                                defaultCellValue,
                                defaultCellValue,
                                defaultCellValue,
                                defaultCellValue,
                                defaultCellValue,
                                defaultCellValue,
                                defaultCellValue,
                                defaultCellValue,
                                nil];
    [self setGameBoard:arr];
    [self reloadInfo];
}

-(void)reloadInfo{
    BOOL enabled = [Util isMyTurn];
    for(int i = 0; i < 3;i++){
        for(int j = 0; j < 3;j++){
            int index = i * 3 + j;
            [buttons[index] setTitle:[gameBoard objectAtIndex:index]  forState:UIControlStateNormal];
            buttons[index].enabled = enabled;
            buttons[index].backgroundColor = enabled ? enabledColor : disabledColor;
            if(![[gameBoard objectAtIndex:index] isEqualToString:@""]){
                [buttons[index] removeTarget:controller action:NSSelectorFromString(__method_name) forControlEvents:UIControlEventTouchUpInside];
                [buttons[index] setTitle:@"Not Empty" forState:UIControlStateHighlighted];
            } else {
                [buttons[index] addTarget:controller action:NSSelectorFromString(__method_name) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
}

-(void)enabled:(BOOL)f{
    for(int i = 0;i < 9;i++)
        buttons[i].enabled = f;
}

-(int) what:(UIButton *)buttonWasClicked{
    for(int i = 0; i < 9;i++)
        if([buttons[i] isEqual:buttonWasClicked])
            return i;
    return -1;
}

@end
