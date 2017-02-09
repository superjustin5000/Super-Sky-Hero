//
//  Level7.m
//  ShootEmUp
//
//  Created by Justin Fletcher on 9/25/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import "Level7.h"

#import "Kamcord/Kamcord.h"
@implementation Level7

-(id)init {
    if ((self = [super initWithNumber:7 DelayStart:0])) {
        
        robot = [Robot_Boss spriteWithFile:@"Boss_Robot_Test.png"];
        robot.position = ccp(gs.winSize.width + robot.contentSize.width/2, gs.winSize.height/2 - 110);
        [self addChild:robot z:kZShips];
        
    }
    return self;
}

-(void)levelTime:(ccTime)time {
    
    if (time == 1) {
    }
    
    if (time == 5) {
        [robot startActions];
    }
    
    if (time == 14) {
        [Kamcord stopRecording];
        [Kamcord showView];
    }
    
}


-(void)dealloc {
    [super dealloc];
}
@end
