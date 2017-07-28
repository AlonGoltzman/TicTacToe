//
//  TTTUser.h
//  tictactoeclient
//
//  Created by hackeru on 07/05/2017.
//  Copyright © 2017 Alon. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface TTTUser : NSObject

/*! The user's name. */
@property (nonatomic, copy) NSString *name;

/*! The user's token. */
@property (nonatomic, copy) NSString *token;

/*! If the user was asked to allow the player to join him.*/
@property (nonatomic, assign) BOOL asked;

-(id)init;

-(id)initWithName:(NSString *)n Token:(NSString *)t andWasAsked:(BOOL) f;

-(void) copyUser:(TTTUser *) user;



@end
