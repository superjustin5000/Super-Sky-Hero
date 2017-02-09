//
//  Cruiser.h
//  ShootEmUp
//
//  Created by Justin Fletcher on 3/15/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "Ship.h"
#import "Wall.h"
#import "Timer.h"
#import "EnemyList.h"

@interface Reactor : JSprite {
    BOOL isDestroyed;
}
@property(nonatomic)BOOL isDestroyed;
-(void)destroyReactor;
@end

@interface WindowShard : CCSprite {
    GameState *gs;
    ccTime timer;
    CGPoint vel;
    float bounceG;
    float slowX;
}
-(void)killShard;
@end



@interface Cruiser1 : Ship {
    BOOL addedSpawnPoints;
    BOOL doorOpen;
    BOOL playerInside;
    BOOL reactorDestroyed;
    BOOL reactorDestroyedBackup;
    
    BOOL isEnter;
    BOOL isEntered;
    BOOL isMoving;
    BOOL isMoved;
    
    CCSprite *cruiserOutside;
    int doorPosX;
    Reactor *reactor;
    Wall *reactorWindow;
    Timer *reactorTimer;
    
    CCArray *_engineFlames;
    
    ccTime explosionTime;
    ccTime explosionTimer;
    
    EnemyList *_staticEnemies;
    BOOL addedStaticEnemies;
}
@property(nonatomic)BOOL playerInside;
@property(nonatomic)BOOL reactorDestroyed, reactorDestroyedBackup;
@property(nonatomic)BOOL isEnter;
@property(nonatomic)BOOL isEntered;
@property(nonatomic)BOOL isMoving;
@property(nonatomic)BOOL isMoved;
@property(nonatomic)BOOL addedStaticEnemies;

+(id)cruiserWithY:(int)y;
-(id)initWithY:(int)y;

-(void)addSpawnPoints;
-(void)setStaticEnemies;
-(void)addStaticEnemies;
-(void)updateCruiser:(ccTime)dt;

-(void)enterLevel;


-(void)flashFlames:(ccTime)dt;
-(void)breakWindow;

-(void)addBirds;

@end

