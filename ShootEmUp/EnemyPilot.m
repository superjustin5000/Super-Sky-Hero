//
//  EnemyPilot.m
//  ShootEmUp
//
//  Created by Justin Fletcher on 5/6/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import "EnemyPilot.h"
#import "Explode.h"

static EnemyPilot *enemyPilot = NULL;



@implementation EnemyPilot

+(EnemyPilot*)getPilot {
    return enemyPilot;
}

+(id)pilot {
    return [self spriteWithSpriteFrameName:@"fightingPilot1.png"]; ////get different pilot images. A calculation will be in this method to know which one to use.
}

-(void)initJSprite {
    maxH = 5;
    startH = maxH;
    curH = startH;
    
    difficulty = 1; ///this will be calculated based on the overall game difficulty.
    velocity = ccp(0.0f, 1.0f); /////for how fast they fall when they die.
    enemyPilot = self;
    [self scheduleUpdate];
}




-(void)hit {
    curH -= 1;
    NSMutableArray *hitFrames = [gs framesWithFrameName:@"fightingPilot" fromFrame:1 toFrame:2 andReverse:YES andAntiAlias:NO];
    CCAnimation *hitAnim = [CCAnimation animationWithSpriteFrames:hitFrames delay:0.1];
    id wait = [CCDelayTime actionWithDuration:0.2];
    id animate = [CCAnimate actionWithAnimation:hitAnim];
    
    [self runAction:[CCSequence actionOne:wait two:animate]];
    
    /////add a small spark for getting hit.
    Explode *spark = [Explode ExplodeWithType:kExplodeFigthingPilotHitBurst];
    spark.position = ccp(4, 6);
    [self addChild:spark];
    [spark explode];
    
    int randSound = random() % 3;
    NSString *soundNumber = [NSString stringWithFormat:@"player_punchPilot%i.wav", randSound+1];
    [[SimpleAudioEngine sharedEngine] playEffect:soundNumber];
    
    ////and blood
    Explode *blood = [Explode ExplodeWithType:kExplodeBlood1];
    blood.position = ccp(11, 9);
    [self addChild:blood];
    [blood explode];
}


-(void)kill {
    [super kill];
    enemyPilot = NULL; ///tells pilot and level that the pilot is dead.
    [self stopAllActions];
    [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"fightingPilotFall.png"]];
}

-(void)destroyPilot {
    [parent_ removeChild:self cleanup:YES];
}

-(void)update:(ccTime)delta {
    if (enemyPilot) {
        ////punch based on difficulty.
    }
    else {
        self.position = ccp(self.position.x - velocity.x, self.position.y - velocity.y);     //////falling when dead.
        if (self.position.y < -self.contentSize.height/2) { ///removechild when below the screen.
            [self destroyPilot];
        }
    }
}

-(void)dealloc {
    [super dealloc];
}

@end
