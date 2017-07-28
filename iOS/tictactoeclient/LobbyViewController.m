//
//  LobbyViewController.m
//  tictactoeclient
//
//  Created by Admin on 01/05/2017.
//  Copyright © 2017 Alon. All rights reserved.
//

#import "LobbyViewController.h"

@implementation LobbyViewController
{
    UIButton *join;
    UIButton *poll;
    UIButton *back;
    UIButton *refresh;
    UITableView *listContainer;
    
    BOOL ranOnce;
    BOOL isHost;
    BOOL attemptedLogout;
    BOOL declinedUser;
    BOOL firstJoin;
    
    TTT_lib* lib;
    
    NSMutableArray<NSString *>* responseUsers;
}

@synthesize mainView;

//#######################
//View methods
//#######################

-(void) viewDidLoad{
    [super viewDidLoad];
    
    ranOnce = NO;
    isHost = NO;
    attemptedLogout = NO;
    declinedUser = NO;
    firstJoin = NO;
    
    responseUsers = [[NSMutableArray alloc]init];
    
    [self initViews];
}

-(void)viewDidAppear:(BOOL)animated{
    if(!ranOnce)
        [Util displayToastWithMessage:@"Logged in" on:self];
    ranOnce = YES;
    if([Util hasUserBeenLoggedOut]){
        [Util saveValue:nil forKey:lib.DK_token];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
-(void) initViews{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //Buttons:
    join = [UIButton buttonWithType:UIButtonTypeSystem];
    join.frame = CGRectMake(20, 20, 100, 30);
    join.titleLabel.textAlignment = NSTextAlignmentCenter;
    [join setTitle:@"Join Hosts" forState:UIControlStateNormal];
    
    poll = [UIButton buttonWithType:UIButtonTypeSystem];
    poll.frame = CGRectMake(self.view.frame.size.width - 120, 20, 100, 30);
    poll.titleLabel.textAlignment = NSTextAlignmentCenter;
    [poll setTitle:@"Poll Hosts" forState:UIControlStateNormal];
    
    back = [UIButton buttonWithType:UIButtonTypeSystem];
    back.frame = CGRectMake(20, self.view.frame.size.height - 40, 100, 30);
    back.titleLabel.textAlignment = NSTextAlignmentCenter;
    [back setTitle:@"Logout" forState:UIControlStateNormal];
    
    refresh = [UIButton buttonWithType:UIButtonTypeSystem];
    refresh.enabled = NO;
    refresh.frame = CGRectMake(self.view.frame.size.width - 120,self.view.frame.size.height-40, 100, 30);
    refresh.titleLabel.textAlignment = NSTextAlignmentCenter;
    [refresh setTitle:@"Refresh" forState:UIControlStateNormal];
    
    //Stack and scroll view:
    listContainer = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height - 150) style:UITableViewStylePlain];
    listContainer.allowsSelection = NO;
    listContainer.delegate = self;
    listContainer.dataSource = self;
    listContainer.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [listContainer registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell_id_reuse"];
    
    [self.view addSubview:join];
    [self.view addSubview:poll];
    [self.view addSubview:back];
    [self.view addSubview:refresh];
    [self.view addSubview:listContainer];
    
    //Targets:
    [join addTarget:self action:NSSelectorFromString(@"click:") forControlEvents:UIControlEventTouchUpInside];
    [poll addTarget:self action:NSSelectorFromString(@"click:") forControlEvents:UIControlEventTouchUpInside];
    [back addTarget:self action:NSSelectorFromString(@"click:") forControlEvents:UIControlEventTouchUpInside];
    [refresh addTarget:self action:NSSelectorFromString(@"click:") forControlEvents:UIControlEventTouchUpInside];
    
    lib = [TTT_lib pullInstance];
}


//#######################
//Utility method
//#######################

-(UIView *)genNewViewForUser:(TTTUser *)user {
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width / 3, 30)];
    UIAssosiativeButton *accept;
    UIAssosiativeButton *decline;
    UIAssosiativeButton *joinBtn;
    if(!isHost){
        joinBtn = [UIAssosiativeButton buttonWithType:UIButtonTypeSystem];
        joinBtn.frame = CGRectMake(self.view.frame.size.width / 3 + 30, 0, self.view.frame.size.width / 3 * 2, 30);
        joinBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [joinBtn setTitle:@"Join" forState:UIControlStateNormal];
        [joinBtn addTarget:self action:NSSelectorFromString(@"userClick:") forControlEvents:UIControlEventTouchUpInside];
        if([user asked])
            joinBtn.enabled = NO;
        [joinBtn setUser:user];
        [joinBtn setBtnType:(int *)UIAssosiativeButtonTypeJoin];
        [container addSubview:joinBtn];
    } else {
        accept = [UIAssosiativeButton buttonWithType: UIButtonTypeSystem];
        accept.frame = CGRectMake(self.view.frame.size.width-150, 0, 75, 30);
        accept.titleLabel.textAlignment = NSTextAlignmentCenter;
        [accept setTitle:@"Accept" forState:UIControlStateNormal];
        [accept addTarget:self action:NSSelectorFromString(@"userClick:") forControlEvents:UIControlEventTouchUpInside];
        [accept setUser:user];
        [accept setBtnType:(int *)UIAssosiativeButtonTypeAccept];
        
        decline = [UIAssosiativeButton buttonWithType:UIButtonTypeSystem];
        decline.frame = CGRectMake(self.view.frame.size.width-75, 0, 75, 30);
        decline.titleLabel.textAlignment = NSTextAlignmentCenter;
        [decline setTitle:@"Decline" forState:UIControlStateNormal];
        [decline addTarget:self action:NSSelectorFromString(@"userClick:") forControlEvents:UIControlEventTouchUpInside];
        [decline setUser:user];
        [decline setBtnType:(int *)UIAssosiativeButtonTypeDecline];
        
        [container addSubview:accept];
        [container addSubview:decline];
    }
    name.textAlignment = NSTextAlignmentCenter;
    [name setText:[user name]];
    
    [container addSubview:name];
    
    container.frame = CGRectInset(container.frame, -20.0f, -1.0f);
    container.layer.borderColor = [[UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1.0f]CGColor];
    container.layer.borderWidth = 1.0f;
    container.layer.masksToBounds = YES;
    
    
    return container;
}

//#######################
//Event Callbacks
//#######################
-(void) userClick:(UIAssosiativeButton *) sender{
    NSArray<Pair *> * pairs = [NSArray arrayWithObjects:
                               [[Pair alloc] initWithKey:lib.K_userToken andValue:(NSString *)[Util getValueForKey:lib.DK_token]],
                               [[Pair alloc] initWithKey:lib.K_hostToken andValue:[sender.user token]]
                               , nil];
    ServerCall call;
    switch((int)[sender btnType]){
        case UIAssosiativeButtonTypeJoin:{
            call = JOIN_REQUEST;
            for(int i = 0; i < responseUsers.count;i++){
                NSString *user = [responseUsers objectAtIndex:i];
                if([[[user componentsSeparatedByString:@"~"]objectAtIndex:0]isEqualToString:[sender user].name]){
                    [responseUsers setObject:[NSString stringWithFormat:@"###%@", user] atIndexedSubscript:i];
                    break;
                }
            }
            [listContainer reloadData];
            break;
        }
        case UIAssosiativeButtonTypeAccept:{
            call = ACCEPT_USER;
            break;
        }
        case UIAssosiativeButtonTypeDecline:{
            call = DECLINE_USER;
            declinedUser = YES;
            [[sender superview]removeFromSuperview];
            break;
        }
        default:{
            call = LOGOUT;
            break;
        }
    }
    if(call == LOGOUT){
        NSLog(@"Unknown element called 'userClick'");
        return;
    }
    [Util invoke:call withArgs:pairs andDelegate:self];
}

-(void) click:(UIButton *)sender{
    ServerCall call;
    if([sender isEqual:join]){
        call = JOIN_HOSTS;
        isHost = YES;
        firstJoin = YES;
    } else if([sender isEqual:poll]){
        call = POLL_HOSTS;
        firstJoin = YES;
    } else if([sender isEqual:back]){
        call = LOGOUT;
        attemptedLogout = YES;
    } else if ([sender isEqual:refresh]){
        call = isHost ? POLL_REQUESTS : POLL_HOSTS;
    }
    if(call != JOIN_HOSTS && call != POLL_HOSTS && call != LOGOUT && call != POLL_REQUESTS){
        NSLog(@"Unknown element called 'Click:' function.");
        return;
    }
    poll.enabled = NO;
    join.enabled = NO;
    refresh.enabled = NO;
    NSArray<Pair *>* pairs = [NSArray arrayWithObject:[[Pair alloc]initWithKey:lib.K_userToken andValue:(NSString *)[Util getValueForKey:lib.DK_token]]];
    [Util invoke:call withArgs:pairs andDelegate:self];
}

//#######################
//Protocol methods
//#######################

//ServerAssistantResponseDelegate
-(void)requestCompletedFor:(ServerResponse *)response{
    NSArray<Pair *>* pairs = [NSArray arrayWithObject:[[Pair alloc]initWithKey:lib.K_userToken andValue:(NSString *)[Util getValueForKey:lib.DK_token]]];
    if([response responseType] == LIST){
        NSString *listValue = [response responseLiteral];
        NSArray<NSString *> *array = [listValue componentsSeparatedByString:@"&"];
        if(array.count > 0){
            [responseUsers removeAllObjects];
            [listContainer reloadData];
            [responseUsers addObjectsFromArray:array];
            [listContainer reloadData];
        } else {
            [responseUsers removeAllObjects];
            [listContainer reloadData];
            NSLog(@"Empty list.");
        }
    } else if([response responseType] == OK){
        if(attemptedLogout){
            [Util saveValue:nil forKey:lib.DK_token];
            [self dismissViewControllerAnimated:YES completion:nil];
            return;
        }else if(declinedUser){
            //Do nothing.
        }else{
            if(!firstJoin)
                [Util displayToastWithMessage:@"No new hosts" on:self];
            else
                firstJoin = NO;
        }
    } else if ([response responseType] == EXCEPTION){
        NSLog(@"%@", [response responseInfo]);
        [Util displayToastWithMessage:[response responseInfo] on:self];
        if(![[response responseLiteral]isEqualToString:@"Already asked to join."]){
            [self dismissViewControllerAnimated:YES completion:nil];
            [Util displayToastWithMessage:@"Something went wrong, try again" on:mainView];
        }
        return;
    } else if ([response responseType] == GAME_TOKEN){
        [mainView setSwitchToGame:YES];
        [Util saveValue:[response responseLiteral] forKey:lib.DK_gameToken];
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    } else if([response responseType] == STATUS){
        if([[response responseLiteral] isEqualToString:lib.M_resStatusInGame]){
            [Util invoke:POLL_GAME_TOKEN withArgs:pairs andDelegate:self];
        }
        return;
    }
    refresh.enabled = YES;
    if(!isHost){
        [Util invoke:POLL_STATUS withArgs:pairs andDelegate:self];
    }

}

-(void)timedout{
    [Util saveValue:nil forKey:lib.DK_token];
    [self dismissViewControllerAnimated:YES completion:nil];
}


//UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return responseUsers.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cell_id_reuse";
    UITableViewCell *cell = [listContainer dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    UIView *cUser = [cell.contentView viewWithTag:100];
    
    NSString *cString = [responseUsers objectAtIndex:indexPath.row];
    NSArray<NSString *>* parts = [cString componentsSeparatedByString:@"~"];
    NSMutableString *name = [NSMutableString stringWithString:[parts objectAtIndex:0]];
    NSString *token = [parts objectAtIndex:1];
    BOOL asked = NO;
    if([name hasPrefix:lib.M_ASKED_FLAG]){
        [name deleteCharactersInRange:NSMakeRange(0, 3)];
        asked = YES;
    }
    TTTUser *userToAppend = [[TTTUser alloc]initWithName:name Token:token andWasAsked:asked];
    
    if(cUser == nil){
        UIView *usr = [self genNewViewForUser:userToAppend];
        usr.frame = cell.contentView.frame;
        [usr setTag:100];
        [cell.contentView addSubview:usr];
    } else {
        NSArray<UIView *>* views = [cUser subviews];
        for(UIView *view in views){
            if([view isKindOfClass:[UILabel class]]){
                ((UILabel *)view).text = [userToAppend name];
            } else if ([view isKindOfClass:[UIAssosiativeButton class]]){
                [((UIAssosiativeButton *)view).user copyUser:userToAppend];
                ((UIAssosiativeButton *)view).enabled = !	userToAppend.asked;
            }
        }
    }
    return cell;
}


@end
