//
//  Level9.m
//  ShootEmUp
//
//  Created by Justin Fletcher on 11/18/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import "Level9.h"
#import "BackgroundRobot.h"


@implementation Level9
-(id)init {
    if ((self = [super initWithNumber:7 DelayStart:0])) {
    
        BackgroundRobot *br = [BackgroundRobot node];
        
        
        [self addChild:br z:kZBackground];
        
    }
    return self;
}

-(void)dealloc {
    [super dealloc];
}
@end
