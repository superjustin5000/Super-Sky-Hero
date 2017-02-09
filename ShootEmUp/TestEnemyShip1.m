//
//  TestEnemyShip1.m
//  ThisShipWillSelfDestruct
//
//  Created by Justin Fletcher on 6/1/12.
//  Copyright 2012 Happy Fox. All rights reserved.
//

#import "TestEnemyShip1.h"


@implementation TestEnemyShip1

-(id)init {
    
    if ((self = [super initWithFileName:@"ship2.png" startingHealth:10 jumpPos:ccp(20, 0) speed:CGPointMake(1, 2) shootTime:.5])) {
        
        
        //canCollide = YES;
        
        //[self scheduleUpdate];
        
        self.scale = 0.7;
        
    }
    
    return self;
    
}



-(void)player:(ccTime)dt {
    self.scaleX = -1;
}

-(void)noPlayer:(ccTime)dt {
    
}




-(void)shootWithDirection:(int)direction Type:(int)type Ship:(Ship *)ship {
}


-(void)update:(ccTime)dt {
}


-(void)dealloc {
    [super dealloc];
}

@end
