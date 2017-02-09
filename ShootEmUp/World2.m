//
//  World2.m
//  ShootEmUp
//
//  Created by Justin Fletcher on 5/21/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import "World2.h"
#import "BackgroundShips.h"

@implementation World2

-(id)initWithNumber:(int)ln DelayStart:(ccTime)delay {
    if ((self = [super initWithNumber:ln DelayStart:delay])) {
        
        //[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"BGM1.mp3"];
        
        
        bgStatic = [BackgroundScroll BackgroundWithFile:@"bg2.png" position:ccp(0,-100) scrollRatio:0 riseRatio:0];
        BackgroundScroll *bgStatic2 = [BackgroundScroll BackgroundWithFile:@"bgcity3.png" position:ccp(0,-20) scrollRatio:0 riseRatio:0];
        bgMoving1 = [BackgroundScroll BackgroundWithFile:@"bgcity2.png" position:ccp(0,5) scrollRatio:0.05 riseRatio:0.2];
        bgMoving2 = [BackgroundScroll BackgroundWithFile:@"bgcity1.png" position:ccp(0,-30) scrollRatio:0.5 riseRatio:0.05];
        
        BackgroundShips *bs = [BackgroundShips node];
        
        [self addChild:bgStatic z:kZBackground];
        [self addChild:bgStatic2 z:kZBackground10];
        
        [self addChild:bs z:kZBackground30];
        
        [self addChild:bgMoving1 z:kZBackground50];
        [self addChild:bgMoving2 z:kZForground];
        
        barTimer = 0.0f;
        barTime = [gs randomNumberFrom:7 To:15];
        
        [self schedule:@selector(updateWorld:)];
        
    }
    
    return self;
}


-(void)updateWorld:(ccTime)dt {
    
    if (barTimer >= barTime) {
        barTimer = 0.0f;
        barTime = [gs randomNumberFrom:7 To:15];
        
        CCSprite *bar = [CCSprite spriteWithFile:@"forgroundCityBar.png"];
        bar.position = ccp(gs.winSize.width+bar.contentSize.width/2, self.contentSize.height/2);
        [self addChild:bar z:kZForground];
        
        void (^remove) (void) = ^ {
            [bar removeFromParentAndCleanup:YES];
        };
        
        id move = [CCMoveTo actionWithDuration:0.5f position:ccp(0-bar.contentSize.width/2, bar.position.y)];
        id done = [CCCallBlock actionWithBlock:remove];
        
        [bar runAction:[CCSequence actionOne:move two:done]];
        
    }
    else {
        barTimer += dt;
    }
    
}



-(void)dealloc {
    [super dealloc];
}

@end
