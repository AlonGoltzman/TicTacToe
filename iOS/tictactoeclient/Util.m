//
//  Util.m
//  tictactoeclient
//
//  Created by Admin on 30/04/2017.
//  Copyright © 2017 Alon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Util.h"
#import "TTT_lib.h"

static ServerAssistant *assistant;
static NSMutableDictionary *objects;

@implementation Util

+(void) invoke:(ServerCall)call withArgs:(NSArray *)pairs andDelegate:(id<ServerAssistantResponseDelegate>)delegate{
    if(assistant == nil){
        [self initAssistant];
    }
    [self refreshLogoutTime];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [assistant invokeServerCall:call withValues:pairs invokeDelegateOnComplete:delegate];
    });
}

+(void)  displayToastWithMessage:(NSString *)msg on:(UIViewController *)controller{
    if(msg.length > 40){
        NSLog(@"%@", [NSThread callStackSymbols]);
        NSLog(@"###\ntoast supports max of 40 characters\n###");
        @throw NSGenericException;
        return;
    }
    UIView *container = [[UIView alloc]initWithFrame:CGRectMake(50, controller.view.frame.size.height - 100, controller.view.frame.size.width - 100, 30)];
    UILabel *txtMsg = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, container.frame.size.width - 40, 30)];
    
    txtMsg.adjustsFontSizeToFitWidth = YES;
    txtMsg.text = msg;
    txtMsg.textAlignment = NSTextAlignmentCenter;
    txtMsg.textColor = [UIColor whiteColor];
    txtMsg.backgroundColor = [UIColor clearColor];
    
    container.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
    container.layer.cornerRadius = 5;
    container.layer.masksToBounds = YES;
    container.alpha = 0.0f;

    [container addSubview:txtMsg];
    
    [controller.view addSubview:container];
    
    [UIView animateWithDuration:1.5 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        container.alpha = 1.0f;
    } completion:^(BOOL finished) {
        if(finished == YES){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2000 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:1.5 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
                    container.alpha = 0.0f;
                } completion:^(BOOL finished) {
                    if(finished == YES){
                        [container removeFromSuperview];
                    }
                }];
            });
        }
    }];
    
}

+(void)loadDictionary{
    objects = [NSMutableDictionary dictionaryWithContentsOfFile:@"prefs.ttt"];
}
+(void)saveValue:(NSObject *)value forKey:(NSString *)key{
    if(objects == nil)
        [self initDictionary];
    if(value == nil){
       [objects removeObjectForKey:key];
        return;
    }
    NSDictionary *dic = [NSDictionary dictionaryWithObject:value forKey:key];
    [objects addEntriesFromDictionary:dic];
    [objects writeToFile:@"prefs.ttt" atomically:YES];
}
+(NSObject *) getValueForKey:(NSString *) key{
    return [objects objectForKey:key];
}

+(void)refreshLogoutTime{
    NSDate *logout_time = [[NSDate date] dateByAddingTimeInterval: 5];
    [self saveValue:logout_time forKey:@"logoutTime"];
}

+(BOOL)hasUserBeenLoggedOut{
    NSDate *date = (NSDate *)[self getValueForKey:@"logoutTime"];
    NSDate *now = [NSDate date];
    return [[now earlierDate:date]isEqualToDate:date];
}

+(BOOL)isMyTurn{
    TTT_lib *lib = [TTT_lib pullInstance];
    NSString *symbol = (NSString *)[self getValueForKey:lib.DK_symbol];
    NSString *turn = [((NSString *)[self getValueForKey:lib.DK_turnX]) boolValue] ? lib.M_repX : lib.M_repO;
    return [symbol isEqualToString:turn];
}

+(void)toggleTurn{
    TTT_lib *lib = [TTT_lib pullInstance];
    [self saveValue:([((NSString *)[self getValueForKey:lib.DK_turnX]) boolValue] ? @"NO": @"YES") forKey:lib.DK_turnX];
}

+(NSString *) turnInfo{
    return [NSString stringWithFormat:@"You are: %@ It's %@'s turn.", [self mySymbol], [self isMyTurn] ? [self mySymbol] : [[self mySymbol] isEqualToString:@"X"] ? @"O" : @"X"];
}

+(NSString *) mySymbol{
    TTT_lib *lib = [TTT_lib pullInstance];
    return [((NSString *)[self getValueForKey:lib.DK_symbol]) isEqualToString:lib.M_repO] ? @"O" : @"X";
}

//##########################
+(void) initAssistant{
    assistant = [ServerAssistant instantiateWithVerbose:true andFromEmulator:false];
}
+(void) initDictionary{
    objects = [NSMutableDictionary dictionary];
}
@end
