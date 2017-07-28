//
//  Pair.h
//  TTT.lib
//
//  Created by hackeru on 26/04/2017.
//  Copyright © 2017 Alon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Pair : NSObject

@property(nonnull, nonatomic, readwrite, copy) NSString *key;
@property(nonnull, nonatomic, readwrite, copy) NSString *value;

-(id _Nonnull) initWithKey:(NSString * _Nonnull)k andValue:(NSString * _Nonnull) v;
@end
