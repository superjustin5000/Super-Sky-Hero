//
//  Level.h
//  ThisShipWillSelfDestruct
//
//  Created by Justin Fletcher on 5/28/12.
//  Copyright 2012 Happy Fox. All rights reserved.
//

#ifndef __LEVEL_H__
#define __LEVEL_H__


#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "GameDockReaderView.h"

#import "Player.h"
#import "PlayerShip.h"
#import "ShipGroup.h"

#import "MessageBox.h"
#import "PowerUp.h"
#import "BackgroundScroll.h"

@class EnemyList;
@class Cruiser1;

@interface Level : JLevel<GameDockEventDelegate> {
    
    int levelNum;
    
    Player *player;
    PlayerShip *playerShip;
    Ship *playerShipToJumpIn;
    BOOL shipHasPlayer;
    BOOL shipHasEnemyPilot;
    
    BackgroundScroll *bgStatic;
    BackgroundScroll *bgMoving1;
    BackgroundScroll *bgMoving2;
    
    
    BOOL movingToFocus;
    CCSprite *focusObject;
    float moveToFocusTime;
    CGPoint moveToFocusFrom;
    
    float startingZoom;
    float startingZoomTime;
    float zoomTime;
    float zoomFactor;
    float zoomOutFromJumpAmount;
    float maxZoom;
    float walkingZoom;
    float zoomOutFromHitAmount;
    float zoomOutFromHitStart;
    float zoomOutFromHitAccel;
    float zoomOutFromHitTime;
    float zoomOutFromHitTimer;
    BOOL isZoomingFromHit;
    BOOL isZooming;
    
    BOOL startCruiser;
    BOOL isCruiser;
    Cruiser1 *currentCruiser;
    int spawnFloor;
    int spawnMinX;
    int spawnMaxX;
    EnemyList *spawnList;
    BOOL isSpawning;
    ccTime spawnTime; ///when to spawn.
    ccTime spawnTimer;///current time until spawn.
    
    
    
    ccTime levelTime;
    ccTime levelDelay;
    
    BOOL endLevel; ///set to true when level has been beaten.
    
    ///LEVEL Y POSITIONS
    float yTop;
    float yBottom;
    float y_2;
    float y_3;
    float y_3_2;
    float y_4;
    float y_4_3;
    float y_5;
    float y_5_2;
    float y_5_3;
    float y_5_4;
    float y_6;
    float y_6_5;
    
    
}
+(id)level;
+(id)levelWithNumber:(int)ln DelayStart:(ccTime)delay;
-(id)initWithNumber:(int)ln DelayStart:(ccTime)delay;

-(void)moveToFocus:(CCSprite*)focus;
-(void)moveToFocusDone;

-(void)playerEnterShip:(Ship*)ship;

-(void)startSpawn;
-(void)stopSpawn;
-(void)spawnEnemy;


-(void)delayStart:(ccTime)timer;
-(void)updateLevel:(ccTime)dt;
-(void)countSeconds:(ccTime)second;
-(void)levelTime:(ccTime)time;
-(void)pauseLevelTime;
-(void)resumeLevelTime;


-(void)retry;
-(void)gameOver;

-(void)endLevel;
-(void)checkEndLevel:(ccTime)dt;
-(void)levelEnded;

@end

#endif
