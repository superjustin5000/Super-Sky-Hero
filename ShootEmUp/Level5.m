//
//  Level5.m
//  ShootEmUp
//
//  Created by Justin Fletcher on 5/21/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import "Level5.h"

#import "Boss1.h"

@implementation Level5
-(id)init {
    if ((self = [super initWithNumber:5 DelayStart:0])) {
        b = [Boss1 boss];
    }
    
    return self;
}


-(void)levelTime:(ccTime)time {
    
    ///----------    BOSS #1  -------------- >>>>>>>>>>
    
    if (time == 1) {
        endLevel = YES;
    }
    
    if (time == 2) {
        [self addChild:b];
    }
    
    if (b.bossDone) {
        endLevel = YES;
    }
    
    
}

-(void)dealloc {
    [super dealloc];
}
@end
