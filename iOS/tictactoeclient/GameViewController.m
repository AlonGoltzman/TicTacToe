//
//  GameViewController.m
//  tictactoeclient
//
//  Created by Admin on 09/05/2017.
//  Copyright © 2017 Alon. All rights reserved.
//

#import "GameViewController.h"
#import "UIGameBoard.h"

@implementation GameViewController
{
    UILabel *turnInfo;
    UIGameBoard *gameBoard;
    UIButton *refresh;
    UIButton *quit;
    
    int boardArr[9];
    NSMutableArray<Pair *>* pairs;
    NSMutableArray<NSString *>* gameCells;
    
    BOOL firstRun;
    BOOL attemptedLogout;
    BOOL gameOver;
    
    TTT_lib *lib;
}


-(void) viewDidLoad{
    [super viewDidLoad];
    [self initViews];
    for(int i = 0 ; i < 9 ;i++)
        boardArr[i] = -1;
}

-(void) viewDidAppear:(BOOL)animated{
    [Util invoke:POLL_WHAT_AM_I withArgs:pairs andDelegate:self];
}

-(void) initViews{
    lib = [TTT_lib pullInstance];
    
    attemptedLogout = NO;
    gameOver = NO;
    firstRun = YES;
   
    gameCells = [NSMutableArray<NSString *> arrayWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"",nil];
    pairs  = [[NSMutableArray alloc]initWithObjects:
              [[Pair alloc]initWithKey:lib.K_userToken andValue:
               (NSString *)[Util getValueForKey:lib.DK_token]],
              [[Pair alloc]initWithKey:lib.K_gameToken andValue:
               (NSString *)[Util getValueForKey:lib.DK_gameToken]],
              nil];
    self.view.backgroundColor = [UIColor whiteColor];
    //Label:
    turnInfo = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, 30)];
    turnInfo.textAlignment = NSTextAlignmentCenter;
    turnInfo.text = @"Loading...";
    
    //Buttons:
    refresh = [UIButton buttonWithType:UIButtonTypeSystem];
    refresh.titleLabel.textAlignment = NSTextAlignmentCenter;
    refresh.frame = CGRectMake(self.view.frame.size.width - 100, self.view.frame.size.height - 30, 100, 30);
    [refresh setTitle:@"Refresh" forState:UIControlStateNormal];
    [refresh addTarget:self action:NSSelectorFromString(@"click:") forControlEvents:UIControlEventTouchUpInside];
    
    quit = [UIButton buttonWithType:UIButtonTypeSystem];
    quit.titleLabel.textAlignment = NSTextAlignmentCenter;
    quit.frame = CGRectMake(0, self.view.frame.size.height - 30, 100, 30);
    [quit setTitle:@"Quit" forState:UIControlStateNormal];
    [quit addTarget:self action:NSSelectorFromString(@"click:") forControlEvents:UIControlEventTouchUpInside];
    
    gameBoard = [[UIGameBoard alloc]initWithFrame:
                 CGRectMake(40, 150, self.view.frame.size.width-60, self.view.frame.size.width-60)
                                andGameController:self
                                         andBoard:gameCells];
    
    [self.view addSubview:turnInfo];
    [self.view addSubview:refresh];
    [self.view addSubview:quit];

}

//#######################
//Event Callbacks
//#######################
-(void) click:(UIButton *)sender{
    ServerCall call;
    if([sender isEqual:quit]){
        if(gameOver){
            [_mainView setSwitchToLobby:YES];
            [Util saveValue:nil forKey:lib.DK_gameToken];
            [self dismissViewControllerAnimated:YES completion:nil];
            return;
        }
        call = QUIT_GAME;
        attemptedLogout = YES;
    }else if ([sender isEqual:refresh])
        call = POLL_BOARD;
    if(call != POLL_BOARD && call != QUIT_GAME){
        NSLog(@"Unknown element called 'click'.");
        return;
    }
    refresh.enabled = NO;
    [Util invoke:call withArgs:pairs andDelegate:self];
}

-(void) gameCellPressed:(UIButton *)sender{
    int num = [gameBoard what:sender];
    [pairs addObject:[[Pair alloc]initWithKey:(NSString *)lib.K_conqureSquare andValue:[NSString stringWithFormat:@"%i", num]]];
    [Util invoke:CONQURE withArgs:pairs andDelegate:self];
    [gameCells setObject:[Util mySymbol] atIndexedSubscript:num];
    boardArr[num] = [([[Util mySymbol] isEqualToString:@"O"] ? lib.M_repO : lib.M_repX) intValue];
    [gameBoard setGameBoard:gameCells];
    [Util toggleTurn];
    [gameBoard reloadInfo];
}


//#######################
//Protocol methods
//#######################

//ServerAssistantResponseDelegate
-(void)requestCompletedFor:(ServerResponse *)response{
    if([response responseType] == GAME_INFO){
        if([[response responseLiteral] isEqualToString:lib.M_resGameIAmX]){
            [Util saveValue:lib.M_repX forKey:lib.DK_symbol];
            [Util invoke:POLL_TURN withArgs:pairs andDelegate:self];
        } else if([[response responseLiteral]isEqualToString:lib.M_resGameIAmO]) {
            [Util saveValue:lib.M_repO forKey:lib.DK_symbol];
            [Util invoke:POLL_TURN withArgs:pairs andDelegate:self];
        } else if([[response responseLiteral]isEqualToString:lib.M_resGameXTurn]){
            [Util saveValue:@"YES" forKey:lib.DK_turnX];
            [gameBoard enabled:[Util isMyTurn]];
            [Util invoke:POLL_BOARD withArgs:pairs andDelegate:self];
        } else if([[response responseLiteral]isEqualToString:lib.M_resGameOTurn]){
            [Util saveValue:@"NO" forKey:lib.DK_turnX];
            [gameBoard enabled:[Util isMyTurn]];
            [Util invoke:POLL_BOARD withArgs:pairs andDelegate:self];
        }
    } else if ([response responseType] == LIST){
        BOOL updateInfo = NO;
        NSArray *info = [[response responseLiteral]componentsSeparatedByString:@"~"];
        NSMutableArray<NSString *>* tmpArr = [[NSMutableArray alloc]init];
        for(int i = 0; i < 9 ;i++){
            int valueAtCS = [((NSString *)[info objectAtIndex:i])intValue];
            [tmpArr addObject:[NSString stringWithFormat:@"%@", valueAtCS == [lib.M_repO intValue] ? @"O" : (valueAtCS == [lib.M_repX intValue] ? @"X" : @"")]];
            if(valueAtCS != boardArr[i] && boardArr[i] != -1){
                [Util invoke:QUIT_GAME withArgs:pairs andDelegate:self];
                [_mainView setSwitchToLobby:YES];
                [self dismissViewControllerAnimated:YES completion:nil];
                return;
            }else if (boardArr[i] == -1 && valueAtCS != boardArr[i]	){
                boardArr[i] = [((NSString *)[info objectAtIndex:i]) intValue];
                updateInfo = YES;
            }
        }
        gameCells = tmpArr;
        if(updateInfo){
            if(!firstRun)
                [Util toggleTurn];
            else
                firstRun = NO;
            [gameBoard setGameBoard:gameCells];
            [gameBoard reloadInfo];
            turnInfo.text = [Util turnInfo];
        }
        [Util invoke:POLL_GAME_STATUS withArgs:pairs andDelegate:self];
    } else if ([response responseType] == GAME_STATUS){
        if(![[response responseLiteral] isEqualToString:lib.M_resGameStatusLive]){
            [turnInfo setText:[response responseInfo]];
            [gameBoard enabled:NO];
            refresh.enabled = NO;
            gameOver = YES;
            return;
        }
    } else if([response responseType] == OK){
        [pairs removeLastObject];
        if(attemptedLogout){
            [_mainView setSwitchToLobby:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
            return;
        }
    } else {
        NSLog(@"%@ -> L, %@ -> I", [response responseLiteral], [response responseInfo]);
        [Util saveValue:nil forKey:lib.DK_gameToken];
        [_mainView setSwitchToLobby:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    if(firstRun)
        firstRun = NO;
    turnInfo.text = [Util turnInfo];
    refresh.enabled = YES;
}

-(void)timedout{
    
}

@end
