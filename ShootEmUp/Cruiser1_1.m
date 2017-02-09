//
//  Cruiser1_1.m
//  ShootEmUp
//
//  Created by Justin Fletcher on 5/17/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import "Cruiser1_1.h"

#import "SpawnSwitch.h"
#import "Player.h"


@implementation Cruiser1_1

-(void)addSpawnPoints {
    ///example of making a spawn list array.
    EnemyList *e = [EnemyList array];
    [e addEnemy:kEnemyTypeSoldier1];
    
    Player *player = (Player*)gs.player;
    
    SpawnSwitch *start1 = [SpawnSwitch startWithSpawnList:e SpawnFloor:player.floorHeight SpawnMinX:self.position.x - self.contentSize.width/2 SpawnMaxX:self.position.x + self.contentSize.width/2];
    start1.position = ccp(self.position.x - self.contentSize.width/2 + 20, self.position.y + self.contentSize.height/2 + start1.height);
    [parent_ addChild:start1];
}


-(void)setStaticEnemies {
    
    [_staticEnemies addStaticEnemy:kEnemyTypeFlyingDroid2 atX:250];
    
}


@end


@implementation Cruiser1_Test

-(void)addSpawnPoints {
    ///example of making a spawn list array.
    EnemyList *e = [EnemyList array];
    [e addEnemy:kEnemyTypeSoldier1];
    [e addEnemy:kEnemyTypeFlyingDroid];
    [e addEnemy:kEnemyTypeGoldRobo];
    
    Player *player = (Player*)gs.player;
    
    SpawnSwitch *start1 = [SpawnSwitch startWithSpawnList:e SpawnFloor:player.floorHeight SpawnMinX:self.position.x - self.contentSize.width/2 SpawnMaxX:self.position.x + self.contentSize.width/2];
    start1.position = ccp(self.position.x - self.contentSize.width/2 + 20, self.position.y + self.contentSize.height/2 + start1.height);
    //[parent_ addChild:start1];
}


-(void)setStaticEnemies {
    
    [_staticEnemies addStaticEnemy:kEnemyTypeFlyingDroid2 atX:250];
    
}


@end
