//
//  Turret1.m
//  ShootEmUp
//
//  Created by Justin Fletcher on 7/22/12.
//  Copyright 2012 Happy Fox. All rights reserved.
//

#import "Turret1.h"
#import "Bullet.h"

@implementation Turret1

-(id)init {
    if ((self = [super initWithFileName:@"turret1.png" startingHealth:2 jumpPos:CGPointMake(0, 0) speed:CGPointMake(kShipSpeedNormal, 0) shootTime:1])) {
        
        canHavePlayer = NO;
        
        EngineSmoke *smoke = [EngineSmoke smokeWithPosition:ccp(0, -10) Intensity:0.2 Direction:kdirectionDown Distance:10 Time:1];
        smoke.position = ccp(self.contentSize.width/2, 0-smoke.contentSize.height/2);
        [self addChild:smoke];
        [smoke start];
        
    }
    
    return self;
}

-(void)shootWithDirection:(int)direction Type:(int)type Ship:(Ship *)ship{
    Bullet *bullet = [Bullet bulletWithFile:@"bullet_basic.png" Power:2 Velocity:CGPointMake(2.2, 2) Direction:direction Movement:kbulletMoveStraight Type:type Origin:ship ExplodeType:kExplode1];
    Bullet *bullet2 = [Bullet bulletWithFile:@"bullet_basic.png" Power:2 Velocity:CGPointMake(2.2, -2) Direction:direction Movement:kbulletMoveStraight Type:type Origin:ship ExplodeType:kExplode1];
    bullet.position = ccp(self.position.x - 10, self.position.y);
    bullet2.position = bullet.position;
    bullet.scale = 1.5;
    bullet2.scale = bullet.scale;
    [parent_ addChild:bullet];
    [parent_ addChild:bullet2];
}

-(void)dealloc {
    [super dealloc];
}

@end
