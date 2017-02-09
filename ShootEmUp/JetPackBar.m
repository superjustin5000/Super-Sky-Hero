//
//  JetPackBar.m
//  ShootEmUp
//
//  Created by Justin Fletcher on 10/3/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import "JetPackBar.h"
#import "Player.h"
#import "HealthBar.h"

@implementation JetPackBar

-(id)init {
    if ((self = [super init])) {
        Player *player = (Player*)gs.player;
        curMeter = player.jetPackMeter/100;
        
        CCSprite *jetPackIcon = [CCSprite spriteWithFile:@"fuelIcon.png"];
        jetPackIcon.anchorPoint = ccp(0,1);
        jetPackIcon.position = ccp(26, [HealthBar getHealthBar].healthBarPos.y - 32);
        jetPackIcon.scale = .75;
        [self addChild:jetPackIcon];
        [jetPackIcon.texture setAliasTexParameters];
        
        
        CCSprite *partsBarMeterBg = [CCSprite spriteWithFile:@"healthBarOuter.png"];
        partsBarMeterBg.anchorPoint = ccp(0,1);
        partsBarMeterBg.position = ccp(jetPackIcon.position.x + jetPackIcon.contentSize.width + 3, [HealthBar getHealthBar].healthBarPos.y - 35);
        partsBarMeterBg.opacity = 100;
        partsBarMeterBg.scale = 0.3;
        
        [self addChild:partsBarMeterBg];
    }
    return self;
}

-(void)deChargeTo:(float)to {
    isMovingMeter = YES;
}
-(void)reCharge {
    isMovingMeter = YES;
}

-(void)drawBar {
    Player *player = (Player*)gs.player;
    
    float actualMeter;
    
    if (!isMovingMeter) {
        prevMeter = curMeter;
        curMeter = player.jetPackMeter / 100;
        if (prevMeter > curMeter) {
            //movingMeter = prevMeter;
            isMovingMeter = YES;
        }
        else if (prevMeter < curMeter) {
            isMovingMeter = YES;
        }
        actualMeter = curMeter;
        if (isMovingMeter) actualMeter = prevMeter;
    }
    else {
        if (prevMeter > curMeter) { /////shrink the meter.
            prevMeter -= 0.1f;
            if (prevMeter <= curMeter) prevMeter = curMeter;
            if (prevMeter == curMeter) isMovingMeter = NO;
        }
        else if (prevMeter < curMeter) { /////grow the meter.
            prevMeter += 0.1f;
            if (prevMeter >= curMeter) prevMeter = curMeter;
            if (prevMeter == curMeter) isMovingMeter = NO;
        }
        else {
            isMovingMeter = NO; ///non of the conditions met, stop moving the meter.
        }
        actualMeter = prevMeter;
        if (!isMovingMeter) actualMeter = curMeter;
    }
    
    float meterSize = actualMeter * 35;
    if (meterSize <= 0) meterSize = 0;
    
    HealthBar *h = [HealthBar getHealthBar];
    
    int x1 = h.healthBarPos.x + 1;
    int x2 = x1 + meterSize;
    int y1 = h.healthBarPos.y - 40;
    int y2 = y1 + 4;
    
    CGPoint verts1[4] = {
        ccp(x1,y1),
        ccp(x1, y2),
        ccp(x2, y2),
        ccp(x2, y1)
    };
    
    CGPoint verts2[4] = {
        ccp(x1, y1),
        ccp(x1, y2),
        ccp(x1+40, y2),
        ccp(x1+40, y1)
    };
    ccDrawSolidPoly(verts1, 4, ccc4f(255, 255, 255, 100));
    //ccDrawPoly(verts2, 4, YES);
    
}

-(void)draw {
    [super draw];
    
    [self drawBar];
}


-(void)dealloc {
    [super dealloc];
}

@end
