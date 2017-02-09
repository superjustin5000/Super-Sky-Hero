//
//  SpawnPoint.h
//  ShootEmUp
//
//  Created by Justin Fletcher on 3/30/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "EnemyList.h"

@interface SpawnSwitch : CCNode {
    GameState *gs;
    
    int height;
    
    int switchType;
    BOOL isActivated;
    CGRect switchRect;
    
    CCArray *spawnList;
}
@property(nonatomic)int spawnFloor;
@property(nonatomic)int spawnMinX;
@property(nonatomic)int spawnMaxX;

@property(nonatomic, readonly)int height;
@property(nonatomic)int switchType;
@property(nonatomic)BOOL isActivated;
@property(nonatomic, retain)CCArray *spawnList;

+(CCArray*)getSwitches;
+(void)addToSwitches:(SpawnSwitch*)s;

+(id)startWithSpawnList:(EnemyList *)slist SpawnFloor:(int)sfloor SpawnMinX:(int)sminx SpawnMaxX:(int)smaxx;
+(id)stop;

-(id)initWithSwitchType:(int)stype SpawnList:(EnemyList*)slist SpawnFloor:(int)sfloor SpawnMinX:(int)sminx SpawnMaxX:(int)smaxx;
-(void)removeSwitch;

@end
