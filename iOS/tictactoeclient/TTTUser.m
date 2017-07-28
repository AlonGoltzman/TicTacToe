//
//  TTTUser.m
//  tictactoeclient
//
//  Created by hackeru on 07/05/2017.
//  Copyright © 2017 Alon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTTUser.h"

@implementation TTTUser

@synthesize name;
@synthesize token;
@synthesize asked;

-(id) init{
    return (self = [super init]);
}

-(id) initWithName:(NSString *)n Token:(NSString *)t andWasAsked:(BOOL)f{
    self = [super init];
    self->name = n;
    self->token = t;
    self->asked = f;
    return self;
}

-(void) copyUser:(TTTUser *)user{
    [self setName:[user name]];
    [self setToken:[user token]];
    [self setAsked:[user asked]];
}

@end
