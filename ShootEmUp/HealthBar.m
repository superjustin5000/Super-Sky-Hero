//
//  HealthBar.m
//  ShootEmUp
//
//  Created by Justin Fletcher on 1/1/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import "HealthBar.h"

#import "Ship.h"

static HealthBar *healthBar;


@implementation HealthBar

@synthesize healthBarPos;

+(HealthBar*)getHealthBar {
    return healthBar;
}


-(id)init {
    
    if ((self = [super init])) {
        
        player = (Player*)gs.player;
        
        int left = 25;
        int top = 10;
        
        CCSprite *healthIcon = [CCSprite spriteWithFile:@"healthIcon.png"];
        healthIcon.anchorPoint = ccp(0,1);
        healthIcon.position = ccp(left, gs.winSize.height - top);
        [self addChild:healthIcon];
        [healthIcon.texture setAliasTexParameters];
        
        CCSprite *healthBarOuterShip = [CCSprite spriteWithFile:@"healthBarOuter.png"];
        healthBarOuterShip.anchorPoint = ccp(0,1);
        healthBarOuterShip.position = ccp(left + healthIcon.contentSize.width + 5, gs.winSize.height - top);
        
        healthBarPos = ccp(healthBarOuterShip.position.x, healthBarOuterShip.position.y);
        
        healthBarMeterShip = [CCSprite spriteWithFile:@"healthBarRed.png"];
        healthBarMeterShip.anchorPoint = ccp(0,0);
        healthBarMeterShip.position = ccp(0,0);
        [healthBarOuterShip addChild:healthBarMeterShip];
        
        healthBarOuterShip.opacity = 100;
        healthBarOuterShip.scaleY = 0.6f;
        healthBarMeterShip.opacity = 200;
        
        
        //int spacing = 10;
        /*
        CCSprite *healthBarOuter = [CCSprite spriteWithFile:@"healthBarOuter.png"];
        healthBarOuter.anchorPoint = ccp(0,1);
        healthBarOuter.position = ccp(left, healthBarOuterShip.position.y - healthBarOuterShip.contentSize.height/2 - spacing);
        
        healthBarMeter = [CCSprite spriteWithFile:@"healthBarRed.png"];
        healthBarMeter.anchorPoint = ccp(0,0);
        healthBarMeter.position = ccp(0,0);
        [healthBarOuter addChild:healthBarMeter];
        
        healthBarOuter.opacity = 100;
        healthBarOuter.scaleY = 0.3f;
        healthBarMeter.opacity = 200;
        */
        
        
        float scale = 0.7;
        healthBarOuterShip.scaleX = scale;
        //healthBarOuter.scaleX = scale / 2;
        
        
        [self addChild:healthBarOuterShip];
        //[self addChild:healthBarOuter];
        
        [self scheduleUpdate];
        
        
        
        healthBar = self;
        
    }
    
    return self;
}

-(void)update:(ccTime)delta {
    
    ////get player's ship.
    Ship *playerShip = NULL;
    Ship *s;
    CCARRAY_FOREACH(gs._ships, s) {
        if (s.hasPlayer) {
            playerShip = s;
            break;
        }
    }
    if (playerShip) {
        float scale = playerShip.curH / playerShip.maxH;
        if (scale <= 0) {
            scale = 0;
        }
        healthBarMeterShip.scaleX = scale;
    }
    
    /*
    float scale = player.curH / player.maxH;
    if (scale <= 0) {
        scale = 0;
    }
    healthBarMeter.scaleX = scale;
     */
}

-(void)dealloc {
    [super dealloc];
}

@end
