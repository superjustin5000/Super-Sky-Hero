//
//  Trooper1.m
//  ShootEmUp
//
//  Created by Justin Fletcher on 8/27/12.
//  Copyright 2012 Happy Fox. All rights reserved.
//

#import "Trooper1.h"
#import "Bullet.h"

@implementation Trooper1

-(id)init {
    if ((self = [super initWithFileName:@"paratrooperWhite.png" startingHealth:1 jumpPos:CGPointMake(0, 0) speed:CGPointMake(kShipSpeedNormal, 0) shootTime:1])) {
        
        canHavePlayer = NO;
        
        EngineSmoke *smoke = [EngineSmoke smokeWithPosition:ccp(0,0) Intensity:0.2 Direction:kdirectionDown Distance:10 Time:0.7];
        smoke.position = ccp(self.contentSize.width/2 + 3, 0-smoke.contentSize.height/2);
        [self addChild:smoke];
        [smoke start];
        
    }
    
    return self;
}

-(void)dealloc {
    [super dealloc];
}

@end
