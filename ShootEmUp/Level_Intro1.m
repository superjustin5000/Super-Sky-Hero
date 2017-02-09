//
//  Level_Intro1.m
//  ShootEmUp
//
//  Created by Justin Fletcher on 11/18/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import "Level_Intro1.h"
#import "SimpleAudioEngine.h"

@implementation Level_Intro1

-(id)init {
    if ((self = [super initWithNumber:100 DelayStart:0])) {
        
        [BackgroundScroll setNegativeDirection];
        
        [gs._ships removeObject:playerShip];
        playerShip.opacity = 0;
        [playerShip noFlame];
        [hud disablePad];
        
        newShip = [PlayerShip ship];
        newShip.bulletTime = -1;
        newShip.scale = 1.25;
        newShip.scaleX = -newShip.scaleX;
        
        
        newShip.position = ccp(gs.winSize.width - 100, y_2);
        [self addChild:newShip];
        
        [newShip normalSound];
        
    }
    return self;
}

-(void)levelTime:(ccTime)time {
    
    if (time == 2) {
        [MessageBox mBoxWithMessage:@"SOS! Come in all Rescue! Under Attack! Heavy Fire! Sector 12!" Character:kHudFaceStatic Duration:5];
    }
    else if (time == 8) {
        [MessageBox mBoxWithMessage:@"I'm on route! Do you need medical?" Character:kHudFacePilot1 Duration:4];
    }
    else if (time == 10) {
        [newShip smallFlame];
        [bgStatic slowDownToStop];
        
        [newShip smallSound];
    }
    else if (time == 13) {
        [MessageBox mBoxWithMessage:@"No bandaids! Just bullets! Get Here Fas...." Character:kHudFaceStatic Duration:4];
    }
    else if (time == 18) {
        [MessageBox mBoxWithMessage:@"... Bringing both! Respond!" Character:kHudFacePilot1 Duration:3];
    }
    else if (time == 22) {
        [MessageBox mBoxWithMessage:@"..........." Character:kHudFaceStatic Duration:2];
    }
    else if (time == 25) {
        [MessageBox mBoxWithMessage:@"Damnit!" Character:kHudFacePilot1 Duration:2];
    }
    
    else if (time == 28) {
        
        void (^engineHigh) (void) = ^{
            [newShip bigFlame];
            [newShip bigSound];
        };
        
        void (^engineNormal) (void) = ^{
            [newShip normalFlame];
            [newShip normalSound];
        };
        
        
        void (^removeShip) (void) = ^{
            [gs._ships removeObject:newShip];
            //[self removeChild:newShip cleanup:YES];
        };
        
        id callBlock = [CCCallBlock actionWithBlock:engineNormal];
        id move = [CCMoveTo actionWithDuration:3 position:ccp(gs.winSize.width/2, y_2)];
        id ease = [CCEaseIn actionWithAction:move rate:2];
        id callBlock2 = [CCCallBlock actionWithBlock:engineHigh];
        id move2 = [CCMoveTo actionWithDuration:1 position:ccp(-500, y_2)];
        id scale = [CCScaleTo actionWithDuration:1 scale:10];
        id move3 = [CCMoveTo actionWithDuration:0.7 position:ccp(gs.winSize.width + 500, y_2)];
        id callBlock3 = [CCCallBlock actionWithBlock:removeShip];
        
        [newShip runAction:[CCSequence actions:callBlock, ease, callBlock2, move2, scale, callBlock2, move3, callBlock3, nil]];
    }
    
    else if (time == 35) {
        endLevel = YES;
    }
    
}

-(void)dealloc {
    [super dealloc];
}

@end
