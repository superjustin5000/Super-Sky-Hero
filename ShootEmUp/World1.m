//
//  World1.m
//  ShootEmUp
//
//  Created by Justin Fletcher on 1/3/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import "World1.h"


@implementation World1

-(id)initWithNumber:(int)ln DelayStart:(ccTime)delay {
    if ((self = [super initWithNumber:ln DelayStart:delay])) {
        
        bgStatic = [BackgroundScroll BackgroundWithFile:@"bg1.png" position:ccp(0,0) scrollRatio:0 riseRatio:0.00];
        BackgroundScroll *bgMoving4 = [BackgroundScroll BackgroundWithFile:@"bgforest4.png" position:ccp(0,40) scrollRatio:0.01 riseRatio:.4];
        BackgroundScroll *bgMoving3 = [BackgroundScroll BackgroundWithFile:@"bgforest3.png" position:ccp(0,20) scrollRatio:0.05 riseRatio:.25];
        bgMoving1 = [BackgroundScroll BackgroundWithFile:@"bgforest2.png" position:ccp(0,-20) scrollRatio:0.25 riseRatio:0.15];
        bgMoving2 = [BackgroundScroll BackgroundWithFile:@"bgforest1.png" position:ccp(0,-20) scrollRatio:0.5 riseRatio:0.0];
        [self addChild:bgStatic z:kZBackground];
        [self addChild:bgMoving4 z:kZBackground10];
        [self addChild:bgMoving3 z:kZBackground20];
        [self addChild:bgMoving1 z:kZBackground30];
        [self addChild:bgMoving2 z:kZForground];
        
    }
    
    return self;
}


-(void)dealloc {
    [super dealloc];
}

@end
