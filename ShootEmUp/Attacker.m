//
//  Attacker.m
//  ShootEmUp
//
//  Created by Justin Fletcher on 8/27/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import "Attacker.h"
#import "Bullet.h"

@implementation Attacker1

-(id)init {
    if ((self = [super initWithFileName:@"attacker1.png" startingHealth:6 jumpPos:ccp(0,0) speed:ccp(kShipSpeedNormal, kShipSpeedNormal) shootTime:2])) {
        self.scale = 1.5;
        //drawRects = YES;
        
        flame = [CCSprite spriteWithFile:@"EngineFlameCruiserSmall.png"];
        flame.opacity = 200;
        flame.position = ccp(self.contentSize.width - 8, self.contentSize.height/2);
        flame.rotation = -45;
        flame.scale = 0.8;
        [self addChild:flame z:-1];
        
        [self schedule:@selector(flashFlame:) interval:.02f];
        
    }
    return self;
}


-(void)flashFlame:(ccTime)dt {
    if (flame.opacity == 0)
        flame.opacity = 200;
    else if (flame.opacity == 200)
        flame.opacity = 0;
}

-(void)player:(ccTime)dt {
    
    self.scaleX = -1.0;
    
    //smoke.distance = -40;
    
}

-(void)shootWithDirection:(int)direction Type:(int)type Ship:(Ship *)ship {
    
    Bullet *b1 = [Bullet bulletWithSpriteFrameName:@"bullet_energy_green1.png" Power:3 Velocity:ccp(3, 0) Direction:direction Movement:kbulletMoveStraight Type:type Origin:ship ExplodeType:kExplode1];
    Bullet *b2 = [Bullet bulletWithSpriteFrameName:@"bullet_energy_green1.png" Power:3 Velocity:ccp(3, .3) Direction:direction Movement:kbulletMoveStraight Type:type Origin:ship ExplodeType:kExplode1];
    Bullet *b3 = [Bullet bulletWithSpriteFrameName:@"bullet_energy_green1.png" Power:3 Velocity:ccp(3, -.3) Direction:direction Movement:kbulletMoveStraight Type:type Origin:ship ExplodeType:kExplode1];
    
    float angle = 90 / (b2.velocity.x / b2.velocity.y);
    
    b1.position = ccp(self.position.x - 12, self.position.y);
    b2.rotation = angle;
    b3.rotation = -angle;
    
    if (self.scaleX < 0) {
        b1.position = ccp(self.position.x + 12, self.position.y);
        b2.rotation = -angle;
        b3.rotation = angle;
    }
    b2.position = ccp(b1.position.x, b1.position.y + 3);
    b3.position = ccp(b1.position.x, b1.position.y - 3);
    
    [parent_ addChild:b1];
    [parent_ addChild:b2];
    [parent_ addChild:b3];
    
    [b1 setAnimationWithFrameName:@"bullet_energy_green" fromFrame:1 toFrame:3 withReverse:YES andRepeat:YES];
    [b2 setAnimationWithFrameName:@"bullet_energy_green" fromFrame:1 toFrame:3 withReverse:YES andRepeat:YES];
    [b3 setAnimationWithFrameName:@"bullet_energy_green" fromFrame:1 toFrame:3 withReverse:YES andRepeat:YES];
}

-(void)dealloc {
    [super dealloc];
}

@end
