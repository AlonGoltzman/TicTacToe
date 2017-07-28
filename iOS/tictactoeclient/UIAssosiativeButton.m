//
//  UIAssosiativeButton.m
//  tictactoeclient
//
//  Created by hackeru on 07/05/2017.
//  Copyright © 2017 Alon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIAssosiativeButton.h"

@implementation UIAssosiativeButton

@synthesize btnType;

-(instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    user = [[TTTUser alloc]init];
    return self;
}

-(void) setUser:(TTTUser *)usr{
    [self.user copyUser:usr];
}

-(TTTUser *)user{
    return user;
}

@end
