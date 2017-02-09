//
//  EnemyFlyingSaucer.m
//  ShootEmUp
//
//  Created by Justin Fletcher on 11/16/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import "EnemyFlyingSaucer.h"

#import "Bullet.h"
#import "EngineSmoke.h"

@implementation EnemyFlyingSaucer


-(id)initWithLeftWall:(int)lwall RightWall:(int)rwall {
    
    if ((self = [super initWithSpriteFrameName:@"flyingSaucer.png" health:50 speed:CGPointMake(1, 0) shootTime:-1 spawnDifficulty:10 leftWall:lwall rightWall:rwall])) {
        
        /*
        NSArray *frames = [gs framesWithFrameName:@"soldier_walk0" fromFrame:0 toFrame:5];
        walkAnim = [CCAnimation animationWithSpriteFrames:frames delay:0.05];
        
        [self runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:walkAnim]]];
        */
        startX = 0;
        
        isBusy = NO;
        AS = attackSequence3; ////3 is nothing, the starting sequence.
        slowFlyTimes = 4;
        
        
        
        
        EngineSmoke* smoke = [EngineSmoke smokeWithPosition:ccp(0,-10) Intensity:2 Direction:kdirectionDown Distance:20 Time:0.7];
        [self addChild:smoke z:self.zOrder -1];
        [smoke start];
        
        f1 = [CCSprite spriteWithFile:@"EngineFlameCruiserSmall.png"];
        f1.position = ccp(self.contentSize.width/2, -f1.contentSize.height/2 + 2);
        f1.scale = 1.2;
        f1.opacity = 200;
        [self addChild:f1 z:self.zOrder-1];
        
        
        [self schedule:@selector(flashFlames:) interval:0.02];
        
    }
    return self;
}



-(void)die {
    [super die];
    [self remove];
    /*
    NSArray *frames = [gs framesWithFrameName:@"soldier_die0" fromFrame:0 toFrame:4];
    dieAnim = [CCAnimation animationWithSpriteFrames:frames delay:0.12];
    
    [self stopAllActions];
    
    
    id die = [CCAnimate actionWithAnimation:dieAnim];
    id remove = [CCCallFunc actionWithTarget:self selector:@selector(remove)];
    
    [self runAction:[CCSequence actionOne:die two:remove]];
     */
}



-(void)shootWithDirection:(int)direction Type:(int)type Origin:(Shooter *)o {
    Bullet *b1 = [Bullet bulletWithSpriteFrameName:@"bulletEnemy1.png" Power:10 Velocity:CGPointMake(1.5, -1.5) Direction:direction Movement:kbulletMoveStraight Type:kbulletWalkingEnemy Origin:o ExplodeType:kExplodeWalkingEnemyBurst];
    b1.position = ccp(self.position.x + 13, self.position.y - self.contentSize.height/2);
    b1.rotation = -45;
    
    
    Bullet *b2 = [Bullet bulletWithSpriteFrameName:@"bulletEnemy1.png" Power:10 Velocity:CGPointMake(-1.5, -1.5) Direction:direction Movement:kbulletMoveStraight Type:kbulletWalkingEnemy Origin:o ExplodeType:kExplodeWalkingEnemyBurst];
    b2.position = ccp(self.position.x - 13, self.position.y - self.contentSize.height/2);
    b2.rotation = 45;
    b2.scaleX = -1;

    
    /*
    CCSprite *flash = [CCSprite spriteWithSpriteFrameName:@"bulletEnemyFlash1.png"];
    flash.position = b1.position;
    [self addChild:flash];
    flash.position = [self convertToWorldSpace:flash.position];
    */
    
    [parent_ addChild:b1];
    [parent_ addChild:b2];
    
    /*
    void (^removeFlash)(void)  = ^{
        [flash removeFromParentAndCleanup:YES];
    };
    ///animate the bullet flash.
    NSArray *f = [gs framesWithFrameName:@"bulletEnemyFlash" fromFrame:1 toFrame:3];
    CCAnimation *a = [CCAnimation animationWithSpriteFrames:f delay:0.05];
    id animate = [CCAnimate actionWithAnimation:a];
    id remove = [CCCallBlock actionWithBlock:removeFlash];
    [flash runAction:[CCSequence actionOne:animate two:remove]];
     */
}






-(void)flashFlames:(ccTime)dt {
    if (f1.opacity == 200) {
        f1.opacity = 0;
    }
    else if (f1.opacity == 0) {
        f1.opacity = 200;
    }
}





-(void)updateMovement {
    
    
    
        
    if (AS == attackSequence3) {
        
        if (startX == 0) {
            startX = self.position.x;
        }
        
        if (rand() % 2 == 0) {
            ////fly left.
            ////fly right.
            [self stopAllActions];
            id rotate = [CCRotateTo actionWithDuration:0.3f angle:-15];
            id move = [CCMoveBy actionWithDuration:1.0 position:ccp(-100, 0)];
            id ease = [CCEaseInOut actionWithAction:move rate:2];
            [self runAction:rotate];
            [self runAction:ease];
        } else {
            ////fly right.
            [self stopAllActions];
            id rotate = [CCRotateTo actionWithDuration:0.3f angle:15];
            id move = [CCMoveBy actionWithDuration:1.0 position:ccp(100, 0)];
            id ease = [CCEaseInOut actionWithAction:move rate:2];
            [self runAction:rotate];
            [self runAction:ease];
        }
        
        AS = attackSequence1;
        slowFlyTimes -=1;
    }
    
    else if (AS == attackSequence1) {
        /////////////flying fast state.
        bulletTime = -1;
        
        int distFromStartX = abs(self.position.x - startX);
        if (distFromStartX >= 100) { ////too far from center.
            
            
            float moveTime = 2.0f;
            int moveDistance = 200;
            
            if (slowFlyTimes == 1) { ///last time flying, go back to center.
                
                
                id rotate = [CCRotateTo actionWithDuration:0.3f angle:0];
                [self runAction:rotate];
                
                slowFlyTimes -= 1;
            }
            
            else if (slowFlyTimes <= 0) { ///stop flying.
                
                int newX = -99;
                if (self.position.x > startX) { ///which direction to move.
                    newX = 99;
                }
                self.position = ccp(startX + newX, self.position.y);
                
                slowFlyTimes = 4; ///reset the number of times to fly.
                isBusy = NO;
                AS = attackSequence2; ///goto sequence 2.
            }
            
            else if (slowFlyTimes > 1) {  ///////////////// fly a specific direction.
                if (self.position.x < startX) { ///to the left, fly right.
                    self.position = ccp(startX - 99, self.position.y);
                    [self stopAllActions];
                    id rotate = [CCRotateTo actionWithDuration:0.3f angle:15];
                    id move = [CCMoveBy actionWithDuration:moveTime position:ccp(moveDistance, 0)];
                    id ease = [CCEaseInOut actionWithAction:move rate:2];
                    [self runAction:rotate];
                    [self runAction:ease];
                    slowFlyTimes -= 1;
                }
                else if (self.position.x > startX) { ////to the right, fly left.
                    self.position = ccp(startX + 99, self.position.y);
                    [self stopAllActions];
                    id rotate = [CCRotateTo actionWithDuration:0.3f angle:-15];
                    id move = [CCMoveBy actionWithDuration:moveTime position:ccp(-moveDistance, 0)];
                    id ease = [CCEaseInOut actionWithAction:move rate:2];
                    [self runAction:rotate];
                    [self runAction:ease];
                    slowFlyTimes -= 1;
                }
            }
            
        }
    } ///////////end attack sequence 1.
        
        
    else if (AS == attackSequence2) {
        ////////////fly slow sequence. And shoot.
        
        
        void (^attack1) (void) = ^{
            AS = attackSequence1; ///go back to as1, which won't do anything until you've reached the other side.
        };
        
        void (^moveAndShoot) (void) = ^{
            
            bulletTime = 0.5f; ///start shooting.
            int moveX = 100;
            if (self.position.x > startX) { ///which direction to move.
                moveX = -100;
            }
            id move = [CCMoveTo actionWithDuration:5 position:ccp(startX + moveX, self.position.y)];
            id callblock = [CCCallBlock actionWithBlock:attack1];
            [self runAction:[CCSequence actionOne:move two:callblock]];
            
            
        };
        
        
        if (!isBusy) {
            isBusy = YES;
            
            id delay = [CCDelayTime actionWithDuration:2];
            id callblock = [CCCallBlock actionWithBlock:moveAndShoot];
            
            [self runAction:[CCSequence actionOne:delay two:callblock]];
            
        }
        
    } ////end attack sequence 2.
    
    
    //self.position = ccp(self.position.x - self.scaleX, self.position.y);
}



-(void)dealloc {
    [super dealloc];
}



@end
