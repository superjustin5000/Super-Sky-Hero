//
//  Timer.m
//  ShootEmUp
//
//  Created by Justin Fletcher on 9/1/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import "Timer.h"


@implementation Timer

+(id)timerWithStartTime:(float)start {
    return [[[self alloc] initWithStartTime:start] autorelease];
}

-(id)initWithStartTime:(float)start {
    if ((self = [super init])) {
        timer = start;
        
        timerString = [NSString stringWithFormat:@"%0.2f", timer];
        timerLabel = [CCLabelTTF labelWithString:timerString fontName:gs.gameFont fontSize:20];
        
        timerLabel.position = ccp(gs.winSize.width/2, gs.winSize.height - timerLabel.contentSize.height - 20);
        [self addChild:timerLabel];
        
        
        [self scheduleUpdate];
    }
    return self;
}


-(void)update:(ccTime)delta {
    
    
    timerString = [NSString stringWithFormat:@"%0.2f", timer];
    [timerLabel setString:timerString];
    
    
    timer -= delta;
    
    if (timer <= 0.00f) {
        timer = 0.00f;
        timerString = [NSString stringWithFormat:@"%0.2f", timer];
        [timerLabel setString:timerString];
        [self unscheduleUpdate];
    }
    
    
    if (timer <= 10.00f) {
        [timerLabel setColor:ccc3(200, 20, 20)];
    }
    
}



-(void)dealloc {
    [super dealloc];
}

@end
