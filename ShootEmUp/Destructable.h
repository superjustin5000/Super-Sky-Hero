//
//  Destructable.h
//  ShootEmUp
//
//  Created by Justin Fletcher on 7/18/12.
//  Copyright 2012 Happy Fox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Destructable : JSprite {
    CCAnimation *baseAnimation;
    CCAnimation *explodeAnimation;
    int strength;
    BOOL invincible;
}
+(id)destructable;
-(id)initWithSpriteFrameName:(NSString*)framename Strength:(int)str StartingHealth:(float)startHP Velocity:(CGPoint)vel;
-(id)initWithFileName:(NSString*)filename Strength:(int)str StartingHealth:(float)startHP Velocity:(CGPoint)vel;

-(void)updateDestructable:(ccTime)dt;

-(void)hitByBullet:(float)strength;
-(void)kill2;

@end
