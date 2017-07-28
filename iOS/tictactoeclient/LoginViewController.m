//
//  ViewController.m
//  tictactoeclient
//
//  Created by Admin on 27/04/2017.
//  Copyright © 2017 Alon. All rights reserved.
//

#import "LoginViewController.h"
#import "LobbyViewController.h"
#import "GameViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
{
    TTT_lib *lib;
    UIView *container;
    UILabel *title;
    UIButton *login;
    UIButton *reg;
    UITextField *username;
    UITextField *password;
    
    UIActivityIndicatorView *working;
}

@synthesize switchToGame;
@synthesize switchToLobby;

-(void) viewDidLoad {
    [super viewDidLoad];
    switchToLobby = NO;
    switchToGame = NO;
    [self initViews];
    [Util loadDictionary];
}

-(void) viewDidAppear:(BOOL)animated{
    if(switchToGame){
        GameViewController *controller = [[GameViewController alloc] init];
        [controller setMainView:self];
        container.hidden = YES;
        [self presentViewController:controller animated:YES completion:nil];
        return;
    } else if(switchToLobby){
        LobbyViewController *controller = [[LobbyViewController alloc]init];
        [controller setMainView:self];
        container.hidden = YES;
        [self presentViewController:controller animated:YES completion:nil];
        return;
    } else {
        [Util invoke:LOGOUT withArgs:[NSArray arrayWithObject:[[Pair alloc]initWithKey:lib.K_userToken andValue:(NSString *)[Util getValueForKey:lib.DK_token]]] andDelegate:self];
        [Util saveValue:nil forKey:lib.DK_token];
        container.hidden = NO;
    }
    switchToGame = NO;
    switchToLobby = NO;
}

-(void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) initViews{
    //Container:
    container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300)];
    CGPoint center = self.view.center;
    center.y += 50;
    container.center = center;
    container.backgroundColor = [UIColor whiteColor];
    
    //Label:
    title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, container.frame.size.width, 30)];
    title.textAlignment = NSTextAlignmentCenter;\
    title.text = @"Tic-Tac-Toe";
    title.font = [UIFont boldSystemFontOfSize: 24];
    
    //Buttons:
    login = [UIButton buttonWithType:UIButtonTypeSystem];
    reg = [UIButton buttonWithType:UIButtonTypeSystem];
    
    login.frame = CGRectMake(0, 105, container.frame.size.width, 30);
    reg.frame = CGRectMake(0, 135, container.frame.size.width, 30);
    
    [login setTitle:@"Login" forState:UIControlStateNormal];
    [reg setTitle:@"Register" forState:UIControlStateNormal];
    
    //Fields:
    username = [[UITextField alloc]initWithFrame:CGRectMake(50, 35 , container.frame.size.width - 95, 30)];
    password = [[UITextField alloc]initWithFrame:CGRectMake(50, 70 , container.frame.size.width - 95, 30)];
    
    username.borderStyle = UITextBorderStyleRoundedRect;
    password.borderStyle = UITextBorderStyleRoundedRect;
    
    [username setPlaceholder:@"Username"];
    [password setPlaceholder:@"Password"];
    
    //Progress:
    working = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 165, container.frame.size.width, 50)];
    working.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    
    
    //Adding all to container:
    [container addSubview:title];
    [container addSubview:reg];
    [container addSubview:login];
    [container addSubview:password];
    [container addSubview:username];
    [container addSubview:working];
    
    //Adding container:
    [self.view addSubview:container];
    [container sizeToFit];
    
    //Setting controllers:
    [login addTarget:self action:NSSelectorFromString(@"click:") forControlEvents:UIControlEventTouchUpInside];
    [reg addTarget:self action:NSSelectorFromString(@"click:") forControlEvents:UIControlEventTouchUpInside];
    
    lib = [TTT_lib pullInstance];
}

-(void) click:(UIButton *) sender{
    ServerCall call;
    if([sender isEqual:login]){
        call = LOGIN;
    }else if([sender isEqual:reg]){
        call = REGISTER;
    }
    if(call != LOGIN && call != REGISTER){
        NSLog(@"Unknown element called 'Click:' function.");
        return;
    }
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^a-zA-Z0-9]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *uname = username.text;
    NSString *pword = password.text;
    if(uname.length <= 0 || [[regex matchesInString:uname options:0 range:NSMakeRange(0, uname.length)] count] > 0){
        [Util displayToastWithMessage:@"Illegal Username, only letters & numbers" on:self];
        return;
    }
    regex = [NSRegularExpression regularExpressionWithPattern:@"[^a-zA-Z0-9_!@#$&*]" options:NSRegularExpressionCaseInsensitive error:nil];
    if(pword.length < 9 || [[regex matchesInString:pword options:0 range:NSMakeRange(0, pword.length)] count] > 0){
        [Util displayToastWithMessage:@"Password: only letters numbers & _!@#$&*" on:self];
        return;
    }
    [working startAnimating];
    username.enabled = NO;
    password.enabled = NO;
    login.enabled = NO;
    reg.enabled = NO;
    
    Pair *userPair = [[Pair alloc]initWithKey:lib.K_username andValue:uname];
    Pair *passPair = [[Pair alloc]initWithKey:lib.K_password andValue:pword];
    NSArray<Pair *> *pairs = [NSArray arrayWithObjects:userPair, passPair,nil];
    [Util invoke:call withArgs:pairs andDelegate:self];
}

//##############################
-(void) requestCompletedFor:(ServerResponse *)response{
    if([response responseType]	== TOKEN){
        [Util saveValue: [response responseLiteral] forKey: lib.DK_token];
        LobbyViewController *controller = [[LobbyViewController alloc]init];
        [controller setMainView:self];
        container.hidden = YES;
        [self presentViewController:controller animated:YES completion:nil];
    } else {
        if([response responseType] == NO_CONN_ESTABLISHED){
            [Util displayToastWithMessage:@"No Connection to server" on:self];
            [self timedout];
        } else{
            [Util displayToastWithMessage:[response responseInfo] on:self];
        }
    }
    [working stopAnimating];
    username.enabled = YES;
    password.enabled = YES;
    login.enabled = YES;
    reg.enabled = YES;
}

-(void) timedout{
    dispatch_sync(dispatch_get_main_queue(), ^{
        [Util displayToastWithMessage:@"No Connection to server" on:self];
        [working stopAnimating];
        username.enabled = YES;
        password.enabled = YES;
        login.enabled = YES;
        reg.enabled = YES;
    });
}

@end
