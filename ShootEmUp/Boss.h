//
//  Boss.h
//  ShootEmUp
//
//  Created by Justin Fletcher on 5/21/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Boss : JSprite {
    BOOL didEnter;
    int stopEnterX;
    
    int collideStrength;
    CCArray *_bossNodes;
    BOOL bossDone;
}
@property(nonatomic)BOOL didEnter;
@property(nonatomic, retain)CCArray *_bossNodes;
@property(nonatomic)BOOL bossDone;

+(id)boss;
-(id)initWithSpriteFrameName:(NSString *)framename Health:(float)h;
-(id)initWithFileName:(NSString*)filename Health:(float)h;

-(void)addBossNodes;

-(void)updateBoss:(ccTime)dt;
@end
