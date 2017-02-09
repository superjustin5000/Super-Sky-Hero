//
//  GroundTurret.m
//  ShootEmUp
//
//  Created by Justin Fletcher on 9/24/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import "GroundTurret.h"
#import "Bullet.h"


@implementation GroundTurret

+(id)turretUpSideDown:(BOOL)usd {
    return [[[self alloc] initUpsideDown:usd] autorelease];
}

-(id)initUpsideDown:(BOOL)usd {
    if ((self = [super initWithSpriteFrameName:@"groundTurret_left.png" health:6 speed:ccp(0,0) shootTime:2])) {
        
        if (usd) {
            self.scaleY = -1;
        }
        
        [gs._otherShooters addObject:self]; ////a
        
        [self scheduleUpdate];
    }
    return self;
}

-(void)die {
    [gs._otherShooters removeObject:self];
    [super die];
}


-(void)update:(ccTime)delta {
    float leftXTrigger = self.position.x - 30;
    float rightXTrigger = self.position.x + 30;
    if (gs.playerPos.x <= leftXTrigger) {
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"groundTurret_left.png"]];
    }
    else if (gs.playerPos.x >= rightXTrigger) {
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"groundTurret_right.png"]];
    }
    else {
        [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"groundTurret_up.png"]];
    }
    
    self.position = ccp(self.position.x - velocity.x, self.position.y);
    
    if (self.position.x <= -self.contentSize.width/2 || !alive)
        [self destroyJSprite];
}

-(void)shootWithDirection:(int)direction Type:(int)type Origin:(Shooter *)o {
    Bullet *b;
    float leftXTrigger = self.position.x - 30;
    float rightXTrigger = self.position.x + 30;
    
    if (gs.playerPos.x <= leftXTrigger) {
        b = [Bullet bulletWithSpriteFrameName:@"bullet_big.png" Power:5 Velocity:ccp(1.5,self.scaleY) Direction:direction Movement:kbulletMoveStraight Type:kbulletEnemy Origin:o ExplodeType:kExplode1];
        b.position = ccp(self.position.x - self.contentSize.width/2, self.position.y + self.scaleY*(self.contentSize.height/2));
    }
    else if (gs.playerPos.x >= rightXTrigger) {
        b = [Bullet bulletWithSpriteFrameName:@"bullet_big.png" Power:5 Velocity:ccp(-1.5,self.scaleY) Direction:direction Movement:kbulletMoveStraight Type:kbulletEnemy Origin:o ExplodeType:kExplode1];
        b.position = ccp(self.position.x + self.contentSize.width/2, self.position.y + self.scaleY*(self.contentSize.height/2));
    }
    else {
        b = [Bullet bulletWithSpriteFrameName:@"bullet_big.png" Power:5 Velocity:ccp(0,self.scaleY) Direction:direction Movement:kbulletMoveStraight Type:kbulletEnemy Origin:o ExplodeType:kExplode1];
        b.position = ccp(self.position.x, self.position.y + self.scaleY*(self.contentSize.height/2));
    }
    
    [parent_ addChild:b];
}



-(void)dealloc {
    [super dealloc];
}

@end
