//
//  Mech1.m
//  ShootEmUp
//
//  Created by Justin Fletcher on 7/3/12.
//  Copyright 2012 Happy Fox. All rights reserved.
//

#import "Mech1.h"

#import "Bullet.h"

@implementation Mech1

-(id)init {
    if ((self = [super initWithFileName:@"Mech1.png" startingHealth:5 jumpPos:ccp(-3, 12) speed:CGPointMake(kShipSpeedNormal, 2) shootTime:0.5])) {
        
        shipDownTexture = [[CCTextureCache sharedTextureCache] addImage:@"Mech1_Down.png"];
        shipUpTexture = [[CCTextureCache sharedTextureCache] addImage:@"Mech1_Up.png"];
        
        self.scale = 1.2;
        
        shootTime = 1.6;
        delayShootTime = 2;
        
        hasEnemyPilot = YES;
        
        smoke = [EngineSmoke smokeWithPosition:ccp(10,-2) Intensity:1 Direction:kdirectionDown Distance:20 Time:0.7];
        [self addChild:smoke];
        [smoke start];
        
    }
    return self;
}

-(void)player:(ccTime)dt {
}

-(void)shootWithDirection:(int)direction Type:(int)type Ship:(Ship *)ship {
    Bullet *bullet = [Bullet bulletWithFile:@"bullet_basic.png" Power:5 Velocity:CGPointMake(8, 0) Direction:direction Movement:kbulletMoveStraight Type:type Origin:ship ExplodeType:kExplode1];
    bullet.position = ccp(self.position.x, self.position.y + 4);
    Bullet *bullet2 = [Bullet bulletWithFile:@"bullet_basic.png" Power:5 Velocity:CGPointMake(8, 0) Direction:direction Movement:kbulletMoveStraight Type:type Origin:ship ExplodeType:kExplode1];
    bullet2.position = ccp(self.position.x, self.position.y + 8);
    
    [parent_ addChild:bullet];
    [parent_ addChild:bullet2];
}


-(void)dealloc {
    [super dealloc];
}

@end
