//
//  Pair.m
//  TTT.lib
//
//  Created by hackeru on 26/04/2017.
//  Copyright © 2017 Alon. All rights reserved.
//

#import "Pair.h"

@implementation Pair

@synthesize key;
@synthesize value;

-(id) initWithKey: (NSString *) k andValue:(NSString *) v{
    if(self = [super init]){
        [self setKey:k];
        [self setValue:v];
    }
    return self;
}

@end
