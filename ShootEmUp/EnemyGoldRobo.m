//
//  EnemyGoldRobo.m
//  ShootEmUp
//
//  Created by Justin Fletcher on 9/4/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import "EnemyGoldRobo.h"
#import "Bullet.h"
#import "Player.h"

@implementation EnemyGoldRobo


-(id)initWithLeftWall:(int)lwall RightWall:(int)rwall {
    if ((self = [super initWithSpriteFrameName:@"goldRobo_walk00.png" health:1 speed:CGPointMake(1, 0) shootTime:-1 spawnDifficulty:1 leftWall:lwall rightWall:rwall])) {
        
        
        NSArray *frames = [gs framesWithFrameName:@"goldRobo_walk0" fromFrame:0 toFrame:5];
        walkAnim = [CCAnimation animationWithSpriteFrames:frames delay:0.08];
        
        [self runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:walkAnim]]];
        
        
    }
    return self;
}



-(void)die {
    [super die];
    
    NSArray *frames = [gs framesWithFrameName:@"goldRobo_die0" fromFrame:1 toFrame:8];
    dieAnim = [CCAnimation animationWithSpriteFrames:frames delay:0.1];
    
    [self stopAllActions];
    
    
    id die = [CCAnimate actionWithAnimation:dieAnim];
    id remove = [CCCallFunc actionWithTarget:self selector:@selector(remove)];
    
    [self runAction:[CCSequence actionOne:die two:remove]];
}



-(void)attack {
    [super attack];
    
    [self stopAllActions];
    
    NSArray *attackframes = [gs framesWithFrameName:@"goldRobo_attack0" fromFrame:0 toFrame:8];
    attackAnim = [CCAnimation animationWithSpriteFrames:attackframes delay:0.05];
    id stopattack = [CCCallFunc actionWithTarget:self selector:@selector(stopAttack)];
    
    [self runAction:[CCSequence actionOne:[CCAnimate actionWithAnimation:attackAnim] two:stopattack]];
    
    //add energy on both sides.
    EnemyGoldRoboEnergy *e1 = [EnemyGoldRoboEnergy spriteWithSpriteFrameName:@"goldRoboEnergy1.png"];
    EnemyGoldRoboEnergy *e2 = [EnemyGoldRoboEnergy spriteWithSpriteFrameName:@"goldRoboEnergy1.png"];
    e1.position = ccp(self.position.x - 8, self.position.y);
    e2.position = ccp(self.position.x + 8, self.position.y);
    [parent_ addChild:e1 z:self.zOrder];
    [parent_ addChild:e2 z:self.zOrder];
    [e1 start];
    [e2 start];
}
-(void)stopAttack {
    [super stopAttack];
    
    [self stopAllActions];
    NSArray *frames = [gs framesWithFrameName:@"goldRobo_walk0" fromFrame:0 toFrame:5];
    walkAnim = [CCAnimation animationWithSpriteFrames:frames delay:0.08];
    
    [self runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:walkAnim]]];
}


-(void)updateMovement {
    if (!isAttacking)
        self.position = ccp(self.position.x - (velocity.x * self.scaleX), self.position.y);
    
    float disFromPlayer = sqrtf( ( (self.position.x - gs.playerPos.x)*(self.position.x - gs.playerPos.x) ) + ( (self.position.y - gs.playerPos.y)*(self.position.y - gs.playerPos.y) ) );
    
    if (disFromPlayer <= 15) {
        //if (abs(self.position.x - gs.playerPos.x) <= 10) {
            if (!isAttacking) {
                [self attack];
            }
       // }
    }
    
}



-(void)dealloc {
    [super dealloc];
}



@end







@implementation EnemyGoldRoboEnergy

-(void)start {
    NSArray *f = [gs framesWithFrameName:@"goldRoboEnergy" fromFrame:1 toFrame:3 andReverse:YES andAntiAlias:NO];
    CCAnimation *a = [CCAnimation animationWithSpriteFrames:f delay:0.08];
    
    void (^removeSelf) (void) = ^{
        [self destroyJSprite];
    };
    
    id animate = [CCAnimate actionWithAnimation:a];
    id remove = [CCCallBlock actionWithBlock:removeSelf];
    
    [self runAction:[CCSequence actionOne:animate two:remove]];
}

-(void)didCollideWith:(JSprite *)sprite {
    Player *player = (Player*)gs.player;
    if (sprite == player) {
        [player die];
    }
}
-(void)dealloc {
    [super dealloc];
}
@end
