//
//  BackgroundRobot.m
//  ShootEmUp
//
//  Created by Justin Fletcher on 9/12/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import "BackgroundRobot.h"


#define kBRActionLaserLeftToRight 1
#define kBRActionLaserRightToLeft 2
#define kBRActionLaserLTR_RTL 3
#define kBRActionLaserRTL_LTR 4
#define kBRActionWalkLeft 5
#define kBRActionWalkRight 6

@implementation BackgroundRobot

+(id)robot {
    return [BackgroundRobot spriteWithSpriteFrameName:@"backgroundrobot1.png"];
}

-(id)initWithTexture:(CCTexture2D *)texture rect:(CGRect)rect {
    if ((self = [super initWithTexture:texture rect:rect])) {
        
        gs = [GameState sharedGameState];
        
        actionTime = [gs randomNumberFrom:3 To:8];
        actionTimer = 0.0f;
        
        [self scheduleUpdate];
        
    }
    return self;
}

-(int)getAction {
    [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"backgroundrobot1.png"]];
    actionTimer = 0.0;
    actionTime = [gs randomNumberFrom:3 To:8];
    return [gs randomNumberFrom:1 To:6]; //////// 1 to 6 bc there are 6 actions.
}


-(void)update:(ccTime)delta {
    
    if (actionTimer >= actionTime) {
        int action = [self getAction];
        
        NSArray *f = NULL;
        CCAnimation *a = NULL;
        id walk = NULL;
        
        switch (action) {
            case kBRActionLaserLeftToRight:
                f = [gs framesWithFrameName:@"backgroundrobotLaser" fromFrame:5 toFrame:1];
                a = [CCAnimation animationWithSpriteFrames:f delay:0.1];
                break;
            case kBRActionLaserRightToLeft:
                f = [gs framesWithFrameName:@"backgroundrobotLaser" fromFrame:1 toFrame:5];
                a = [CCAnimation animationWithSpriteFrames:f delay:0.1];
                break;
            case kBRActionLaserLTR_RTL:
                f = [gs framesWithFrameName:@"backgroundrobotLaser" fromFrame:5 toFrame:1 andReverse:YES andAntiAlias:NO];
                a = [CCAnimation animationWithSpriteFrames:f delay:0.1];
                break;
            case kBRActionLaserRTL_LTR:
                f = [gs framesWithFrameName:@"backgroundrobotLaser" fromFrame:1 toFrame:5 andReverse:YES andAntiAlias:NO];
                a = [CCAnimation animationWithSpriteFrames:f delay:0.1];
                break;
            case kBRActionWalkLeft:
                if (self.position.x <= self.contentSize.width/2) { ////too far left, walk right instead.
                    walk = [CCJumpBy actionWithDuration:1.5f position:ccp(20, 0) height:5 jumps:2];
                }
                else {
                    walk = [CCJumpBy actionWithDuration:1.5f position:ccp(-20, 0) height:5 jumps:2];
                }
                break;
            case kBRActionWalkRight:
                if (self.position.x >= gs.winSize.width - self.contentSize.width/2) { ////too far right, walk left instead.
                    walk = [CCJumpBy actionWithDuration:1.5f position:ccp(-20, 0) height:5 jumps:2];
                }
                else {
                    walk = [CCJumpBy actionWithDuration:1.5f position:ccp(20, 0) height:5 jumps:2];
                }
                break;
                
            default:
                break;
        }
        
        if (f != NULL && a != NULL) {
            id animate = [CCAnimate actionWithAnimation:a];
            id callfunc = [CCCallFunc actionWithTarget:self selector:@selector(getAction)];
            [self runAction:[CCSequence actionOne:animate two:callfunc]];
        }
        else if (walk != NULL) {
            id callfunc = [CCCallFunc actionWithTarget:self selector:@selector(getAction)];
            [self runAction:[CCSequence actionOne:walk two:callfunc]];
        }
        else {
            [self getAction];
        }
        
        
    }
    else {
        actionTimer += gs.gameDelta;
    }
    
    
}


-(void)dealloc {
    [super dealloc];
}

@end
