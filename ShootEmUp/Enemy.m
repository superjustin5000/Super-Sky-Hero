//
//  Enemy.m
//  ShootEmUp
//
//  Created by Justin Fletcher on 3/18/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import "Enemy.h"

#import "Explode.h"

@implementation Enemy

@synthesize spawnDifficulty;
@synthesize leftWall, rightWall;


+(id)enemyWithLeftWall:(int)lwall RightWall:(int)rwall {
    return [[[self alloc] initWithLeftWall:lwall RightWall:rwall] autorelease]; //calling subclasses init method which will call this initwithfile method.
}

/////override in subclass, so this one is not called.
-(id)initWithLeftWall:(int)lwall RightWall:(int)rwall {
    NSLog(@"ERROR REPORT - ENEMY RETURNED NULL - override initWithLeftWall method in subclass");
    return NULL;
}

-(id)initWithFileName:(NSString *)fileName health:(float)startHealth speed:(CGPoint)spd shootTime:(float)stime spawnDifficulty:(int)sDiff leftWall:(int)lwall rightWall:(int)rwall {

    
    if ((self = [super initWithFileName:fileName health:startHealth speed:spd shootTime:stime])) {
        
        canCollide = YES;
        //drawRects = YES;
        
        spawnDifficulty = sDiff;
        leftWall = lwall;
        rightWall = rwall;
        
        dirFacing = -1; //////this is to tell the bullets to fire negative because enemies coming from the front face negative, and enemies coming from behind are backwards enemies. It's wierd.
        bulletType = kbulletWalkingEnemy;
        
        [self schedule:@selector(updateEnemy:)];
        
        [gs._enemies addObject:self];
        
    }
    
    return self;
}







-(id)initWithSpriteFrameName:(NSString *)frameName health:(float)startHealth speed:(CGPoint)spd shootTime:(float)stime spawnDifficulty:(int)sDiff leftWall:(int)lwall rightWall:(int)rwall {
    
    
    if ((self = [super initWithSpriteFrameName:frameName health:startHealth speed:spd shootTime:stime])) {
        
        canCollide = YES;
        //drawRects = YES;
        
        spawnDifficulty = sDiff;
        leftWall = lwall;
        rightWall = rwall;
        
        dirFacing = -1; //////this is to tell the bullets to fire negative because enemies coming from the front face negative, and enemies coming from behind are backwards enemies. It's wierd.
        bulletType = kbulletWalkingEnemy;
        
        
        [gs._enemies addObject:self];
        
    }
    
    return self;
}







-(void)didCollideWith:(JSprite *)sprite {
    [super didCollideWith:sprite];
    
    
}

-(void)remove {
    [gs._enemies removeObject:self];
    [self removeFromParentAndCleanup:YES];
}

-(void)die {
    [super die];
    [self unschedule:@selector(updateEnemy:)];
    [self unschedule:@selector(updateShooter:)];
    
    
    canCollide = NO;
    Explode *e = [Explode ExplodeWithType:kExplode2];
    e.position = self.position;
    [parent_ addChild:e z:kZBullets];
    [e explode];
}



-(void)updateEnemy:(ccTime)dt {
    
    if ( ((self.position.x - self.contentSize.width/2) <= leftWall) || ((self.position.x + self.contentSize.width/2) >= rightWall) ) { ////turn enemy around if they reach the left or right wall so they don't walk off the level.
        self.scaleX = self.scaleX * -1;
    }
    
    [self updateMovement];

}



///////// OVERRIDE THESE METHODS
-(void)shootWithDirection:(int)direction Type:(int)type Origin:(Shooter *)o {
    
}

-(void)updateMovement {
    
}





-(void)dealloc {
    [super dealloc];
}

@end
