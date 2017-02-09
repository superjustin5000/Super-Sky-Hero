//
//  Robot_Boss.m
//  ShootEmUp
//
//  Created by Justin Fletcher on 11/18/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import "Robot_Boss.h"
#import "EngineSmoke.h"
#import "Ship.h"
#import "Player.h"
#import "Explode.h"


@implementation Robot_Boss

-(void)initJSprite {

    ////left side smoke
    
    EngineSmoke *e1 = [EngineSmoke smokeWithPosition:ccp(-self.contentSize.width/2 + 26, self.contentSize.height/2 - 105) Intensity:1 Direction:kdirectionDown Distance:40 Time:0.7];
    EngineSmoke *e2 = [EngineSmoke smokeWithPosition:ccp(-self.contentSize.width/2 + 34, self.contentSize.height/2 - 118) Intensity:1 Direction:kdirectionDown Distance:40 Time:0.7];
    EngineSmoke *e3 = [EngineSmoke smokeWithPosition:ccp(-self.contentSize.width/2 + 65, self.contentSize.height/2 - 124) Intensity:1 Direction:kdirectionDown Distance:40 Time:0.7];
    
    e1.rotation = 30;
    
    [self addChild:e1];
    [self addChild:e2];
    [self addChild:e3];
    
    [e1 start];
    [e2 start];
    [e3 start];
    
    /////right side smoke
    
    EngineSmoke *e4 = [EngineSmoke smokeWithPosition:ccp(self.contentSize.width/2 - 21, self.contentSize.height/2 - 105) Intensity:1 Direction:kdirectionDown Distance:40 Time:0.7];
    EngineSmoke *e5 = [EngineSmoke smokeWithPosition:ccp(self.contentSize.width/2 - 29, self.contentSize.height/2 - 118) Intensity:1 Direction:kdirectionDown Distance:40 Time:0.7];
    EngineSmoke *e6 = [EngineSmoke smokeWithPosition:ccp(self.contentSize.width/2 - 60, self.contentSize.height/2 - 124) Intensity:1 Direction:kdirectionDown Distance:40 Time:0.7];
    
    
    [self addChild:e4];
    [self addChild:e5];
    [self addChild:e6];
    
    [e4 start];
    [e5 start];
    [e6 start];
    
    
    chestGlow = [CCSprite spriteWithSpriteFrameName:@"Boss_Robot_glowyellow1.png"];
    chestGlow.opacity = 0;
    NSMutableArray *f = [gs framesWithFrameName:@"Boss_Robot_glowyellow" fromFrame:1 toFrame:7];
    CCAnimation *a = [CCAnimation animationWithSpriteFrames:f delay:0.08];
    [chestGlow runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:a]]];
    
    chestGlow.position = ccp(self.contentSize.width/2, self.contentSize.height - 100);
    chestGlow.scale = 2;
    
    [self addChild:chestGlow];
    
    
    
    eyeGlow = [CCSprite spriteWithSpriteFrameName:@"Boss_Robot_glowred1.png"];
    eyeGlow.opacity = 0;
    NSMutableArray *f2 = [gs framesWithFrameName:@"Boss_Robot_glowred" fromFrame:1 toFrame:10];
    CCAnimation *a2 = [CCAnimation animationWithSpriteFrames:f2 delay:0.08];
    [eyeGlow runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:a2]]];
    
    eyeGlow.position = ccp(self.contentSize.width/2 - 14, self.contentSize.height - 33);
    eyeGlow.scale = 2;
    
    [self addChild:eyeGlow];
}


-(void)glowChest {
    if (chestGlow.opacity == 255) chestGlow.opacity = 0;
    else chestGlow.opacity = 255;
}

-(void)shootLaser {
    eyeGlow.opacity = 255;
    
    void (^hideGlow) (void) = ^{
        eyeGlow.opacity = 0;
    };
    
    Laser *laser = [Laser spriteWithFile:@"Boss_Robot_Laser.png"];
    laser.anchorPoint = ccp(0.5, 0.991);
    laser.position = ccp(eyeGlow.position.x, eyeGlow.position.y);
    laser.rotation = 90;
    
    laser.opacity = 180;
    
    [self addChild:laser];
    
    /*
    id rotate = [CCRotateBy actionWithDuration:1 angle:90];
    id rotateback = [CCRotateBy actionWithDuration:1 angle:-90];
    [laser runAction:[CCSequence actionOne:rotate two:rotateback]];
     */
}

-(void)startActions {
    
    id move = [CCMoveBy actionWithDuration:5 position:ccp(-200, 0)];
    id chest = [CCCallFunc actionWithTarget:self selector:@selector(glowChest)];
    id delay = [CCDelayTime actionWithDuration:2];
    id chest2 = [CCCallFunc actionWithTarget:self selector:@selector(glowChest)];
    id delay2 = [CCDelayTime actionWithDuration:0.5];
    id shootLaser = [CCCallFunc actionWithTarget:self selector:@selector(shootLaser)];
    
    [self runAction:[CCSequence actions:move, chest, delay, chest2, delay2, shootLaser, nil]];
}

@end




@implementation Laser

-(void)initJSprite {
    [self scheduleUpdate];
    //drawRects = YES;
}

-(void)update:(ccTime)delta {
    Player *player = (Player*)gs.player;
    Ship *ship = player.currentShip;
    
    
    if (CGRectIntersectsRect(ship.spriteRect, self.spriteRect)) {
    
        
        Explode *e;
        if (rand() % 2 == 0) e = [Explode ExplodeWithType:kExplode2];
        else e = [Explode ExplodeWithType:kExplode3];
        e.position = ccp(ship.position.x, ship.position.y);
        [parent_.parent addChild:e z:kZExplode];
        [e explode];
        
        //ship.isCrashing = YES;
        
    
    }
    
}

@end