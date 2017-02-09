//
//  Level.m
//  ThisShipWillSelfDestruct
//
//  Created by Justin Fletcher on 5/28/12.
//  Copyright 2012 Happy Fox. All rights reserved.
//

#import "Level.h"
#import "LevelStats.h"
#import "SimpleAudioEngine.h"

#import "HealthBar.h"
#import "PartsBar.h"
#import "JetPackBar.h"
#import "Bullet.h"
#import "SpawnSwitch.h"
#import "Cruiser.h"
#import "Boss.h"
#import "Boss1.h"
#import "EnemyPilot.h"
#import "WallFlying.h"

#import "TestEnemy.h"
#import "EnemySoldier.h"
#import "EnemyGoldRobo.h"
#import "EnemyFlyingDroid.h"
#import "EnemyFlyingDroid2.h"

#import "Explode.h"

#import "Birds.h"



#import "Kamcord/Kamcord.h"


@implementation Level

+(id)level { ////returns the current levels init method which calls super initwithnumber:delaystart:
    return [[[self alloc] init] autorelease];
}

+(id)levelWithNumber:(int)ln DelayStart:(ccTime)delay {
    return [[[self alloc] initWithNumber:ln DelayStart:delay] autorelease];
}

-(id)initWithNumber:(int)ln DelayStart:(ccTime)delay {
    if ((self = [super init])) {
        
        
        ////// ######## gamedock stuff.
        
        GameDockReaderView *control = [[GameDockReaderView alloc] initWithFrame:CGRectZero];
        [[[CCDirector sharedDirector] view] addSubview:control];
        control.active = YES;
        control.delegate = (id)self;
        [control release];
        
        //////////////////////////////////////
        
        ////preload audio
        [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"BGM1.mp3"];
        
        
        
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"explode.plist" textureFilename:@"explode.png"];
        
        playerShip = [PlayerShip ship];
        playerShip.position = ccp(100, 160);
        playerShip.scale = 1.25;
        playerShip.hasPlayer = YES;
        playerShip.curH = 100;
        [self addChild:playerShip z:kZPlayerShip];
        
        player = [Player shooter];
        player.position = ccp(100, 160);
        player.opacity = 0;
        [self addChild:player z:kZPlayer];
        
        
        
        shipHasPlayer = YES;
        
        
        ///////// HUD NODES. ... don't add child because they do that automatically.
        [HealthBar node];
        [PartsBar node];
        [JetPackBar node];
        
        
        
        //////ZOOMING 
        startingZoom = 1.0f; ///what zoom you scale to when jumping.
        zoomTime = 0;
        startingZoomTime = 0.7f; ///how fast you zoom out when jumping.
        zoomFactor = startingZoom; ///the initial zoom of the game.
        zoomOutFromJumpAmount = 0;
        maxZoom = 3.5f; ////the maximum zoom.
        walkingZoom = 2.7f;
        zoomOutFromHitAmount = 0.05f;
        zoomOutFromHitStart = zoomOutFromHitAmount;
        zoomOutFromHitAccel = zoomOutFromHitAmount * 50;
        zoomOutFromHitTime = 1;
        zoomOutFromHitTimer = 0;
        isZoomingFromHit = NO;
        
        
        
        ///populate spawn list.
        spawnList = [[EnemyList alloc] init];
        spawnTime = 3;
        spawnTimer = 0;
        
        
        
        
        
        
        levelNum = ln;
        levelDelay = delay;
        
        levelTime = 0;
        [self schedule:@selector(delayStart:)];
        
        
        
        endLevel = NO; ///not the end of the level when it starts.
        
        
        ///different y pos for ships spawning.
        yTop = gs.winSize.height - 20;
        yBottom = 50;
        y_2 = gs.winSize.height / 2;
        y_3 = gs.winSize.height / 3;
        y_3_2 = y_3 * 2;
        y_4 = y_2 / 2;
        y_4_3 = y_4 * 3;
        y_5 = gs.winSize.height / 5;
        y_5_2 = y_5 * 2;
        y_5_3 = y_5 * 3;
        y_5_4 = y_5_2 * 2;
        y_6 = y_3 / 2;
        y_6_5 = y_6 * 5;
        
        
        
        
        
        
        
        
        [self playerEnterShip:playerShip]; //////last thing to happen, since it's something that happens when the level has begun, after init.
        
        
        
        //[Kamcord startRecording];
        
    }
    
    return self;
}


-(void)resetGameStateLevelVars {
    gs.playerPos = CGPointMake(0, 0);
    gs.playerRect = CGRectMake(0, 0, 0, 0);
    
    [gs._ships removeAllObjects];
    [gs._bullets removeAllObjects];
    [gs._enemies removeAllObjects];
    [gs._otherShooters removeAllObjects];
}

-(void)delayStart:(ccTime)dt {
    if (levelDelay <= 0) {
        [self unschedule:@selector(delayStart:)];
        [self schedule:@selector(updateLevel:)];
        [self schedule:@selector(countSeconds:)]; ////does a crazy calculation, to call levelTime only at close values of actual seconds.
    } else {
        levelDelay = levelDelay - gs.gameDelta;
    }
}


-(void)countSeconds:(ccTime)second { //////////// counting seconds so that events can happen at particular seconds
    levelTime = levelTime + gs.gameDelta;///using gamedelta so that if the frame rate drops, seconds counted will also be slower.
    float remainder = levelTime - floorf(levelTime); // current level time minus nearest bottom integer gives the remainder.
    if (remainder < gs.gameDelta) {////the closest to 0 is if the remainder is anywhere in the range of the gaemdelta.
        float newLevelTime = floorf(levelTime); ////this way it's an actual integer that gets sent.
        [self levelTime:newLevelTime];
    }
}

-(void)levelTime:(ccTime)time {
    /////override this for each level's events.
    /*
        if (time == 5) {
            ///make some ships apear
        }
        else if (time == 100) {
            ///make BOSS APPEAR!
        }
    */
}

-(void)pauseLevelTime {
    [self unschedule:@selector(countSeconds:)];
}
-(void)resumeLevelTime {
    [self schedule:@selector(countSeconds:)];
}






-(void)playerEnterShip:(Ship *)ship {
    ship.hasPlayer = YES;
    [ship setZOrder:kZPlayerShip];
    [ship resetVelocityToInit];
    shipHasPlayer = YES; ////layers variable letting us know that a ship does have the player.
    [player landInShip:ship];
    [self moveToFocus:ship];
    isZooming = NO;
    
    if (ship.scaleX > 0 && ship != playerShip) {
        ship.scaleX = ship.scaleX * -1; ///reverse the ship scale if it's scale is positive.
    }
    
    ////create a flash.
    if ( (ship != player.previousShip)  && (levelTime > 0.0f) ) { ////////don't flash at the beginning of the level(time == 0)
        Explode *e = [Explode ExplodeWithType:kExplodeBlueEnergy];
        e.position = ship.position;
        e.scale = 3.0f;
        [self addChild:e z:kZExplode];
        [e explode];
    }
}










//###
///// SPAWNING ENEMIES
//###

//find switches.


-(void)startSpawn {
    isSpawning = YES;
}

-(void)stopSpawn {
    isSpawning = NO;
}

-(void)spawnEnemy {
    
    
    ///get a random number from 0 to the size of the array - 1.
    int spawnListSize = [spawnList count];
    int randomEnemy;
    if (spawnListSize == 1) {
        randomEnemy = 0;
    } else {
        randomEnemy = [gs randomNumberFrom:0 To:spawnListSize-1];
    }
    NSNumber *chosenEnemy = (NSNumber*)[spawnList objectAtIndex:randomEnemy]; ////use the random number to figure out what the kEnemyType is.
    int enemyType = [chosenEnemy intValue];
    
    
    
    ///pick a side to spawn. 75% chance in front of player 25% behind.
    int startingX = 0;
    int startingScale = 1;
    
    float viewingArea = gs.winSize.width / zoomFactor;
    float leftright = (gs.winSize.width - viewingArea) / 2;
    float distanceToAddBehind = 0;
    float distanceToAddFront = 0;
    
    ////if the scene is at the left or right bounds of the screen, the player will walk away from the center. so the monster spawn points will be slightly different.
    if (self.position.x >= leftright*zoomFactor) {
        float playerDistanceLeft = gs.player.position.x;
        distanceToAddFront = (viewingArea/2) - playerDistanceLeft; ///gets the players distance from the left side of the viewing area.
    }
    else if (self.position.x <= -leftright*zoomFactor) {
        float playerDistanceRight = gs.winSize.width - gs.player.position.x;
        distanceToAddBehind = (viewingArea/2) - playerDistanceRight;   ////the players distance from the right sie of the viewing area.
    }
    
    
    int spawnDistance = viewingArea / 2;
    
    int randomNum = [gs randomNumberFrom:1 To:100];
    
    if (randomNum > 25) { ///spawn in front.
        startingX = gs.player.position.x + spawnDistance + distanceToAddFront;
    } else { ///spawn behind.
        startingX = gs.player.position.x - spawnDistance - distanceToAddBehind;
        startingScale = -1;
    }
    
    
    //check valid x if it's outside min or max x, put it on other side.
    int spawnMinMaxBuffer = 5;
    if (startingX < spawnMinX+spawnMinMaxBuffer) { ///if it's too far back, spawn in front
        startingX = gs.player.position.x + spawnDistance + distanceToAddFront;
        startingScale = 1;
    }
    else if (startingX > spawnMaxX-spawnMinMaxBuffer) { ////too far forward spawn in back.
        startingX = gs.player.position.x - spawnDistance - distanceToAddBehind;
        startingScale = -1;
    }
    
    
    
    ////spawn based off kEnemyType.
    Enemy *enemy;
    
    switch (enemyType) {
        case kEnemyTypeTest:
            enemy = (TestEnemy*)[TestEnemy enemyWithLeftWall:spawnMinX RightWall:spawnMaxX];
            enemy.position = ccp(startingX, spawnFloor + enemy.contentSize.height/2);
            enemy.scaleX = startingScale;
            break;
        case kEnemyTypeSoldier1:
            enemy = (EnemySoldier*)[EnemySoldier enemyWithLeftWall:spawnMinX RightWall:spawnMaxX];
            enemy.position = ccp(startingX, spawnFloor + enemy.contentSize.height/2);
            enemy.scaleX = startingScale;
            break;
        case kEnemyTypeGoldRobo:
            enemy = (EnemyGoldRobo*)[EnemyGoldRobo enemyWithLeftWall:spawnMinX RightWall:spawnMaxX];
            enemy.position = ccp(startingX, spawnFloor + enemy.contentSize.height/2);
            enemy.scaleX = startingScale;
            break;
        case kEnemyTypeFlyingDroid:
            enemy = (EnemyFlyingDroid*)[EnemyFlyingDroid enemyWithLeftWall:spawnMinX RightWall:spawnMaxX];
            enemy.position = ccp(startingX, spawnFloor + enemy.contentSize.height/2 + 20);
            enemy.scaleX = startingScale;
            break;
        case kEnemyTypeFlyingDroid2:
            enemy = (EnemyFlyingDroid2*)[EnemyFlyingDroid2 enemyWithLeftWall:spawnMinX RightWall:spawnMaxX];
            enemy.position = ccp(startingX, spawnFloor + enemy.contentSize.height/2 + 20);
            enemy.scaleX = startingScale;
            break;
            
        default:
            break;
    }
    [self addChild:enemy z:kZPlayer];
    [enemy schedule:@selector(updateEnemy:)];
}





///////// move the viewing area to the object controlled by the player. ship or player character

-(void)moveToFocus:(CCSprite *)focus {
    focusObject = focus;
    moveToFocusFrom = self.position;
    movingToFocus = YES;
    float focusPosFromCenterX = focus.position.x - 240;
    float focusPosFromCenterY = focus.position.y - 160;
    if (focusPosFromCenterX != 0 || focusPosFromCenterY != 0) {
        
        CGPoint moveTo;
        if (focus == player) {
            moveTo = ccp(0 - focusPosFromCenterX*zoomFactor, 0 - focusPosFromCenterY*zoomFactor);
        }
        else {
            moveTo = ccp(0 - focusPosFromCenterX*zoomFactor, 0 - focusPosFromCenterY*zoomFactor); ///extra 80 pixels so the ship can be closer to the top.
        }
        
        id move = [CCMoveTo actionWithDuration:0.1f position:moveTo];
        id movedone = [CCCallFunc actionWithTarget:self selector:@selector(moveToFocusDone)];
        
        [self runAction:[CCSequence actions:move, movedone, nil]];
        
    }
}
-(void)moveToFocusDone {
    if (focusObject == player) {
        player.opacity = 255;
        [player jump];
    }
    movingToFocus = NO;
}



///////////////
//////########========------- UPDATE LEVEL

-(void)updateLevel:(ccTime)dt {
    
    
    if (endLevel) {     //////end of level has been reached.
        [self endLevel];
    }
    
    
    
    
    ///////////////// Player lands in new ship.
    
    
    if (!shipHasEnemyPilot) { /////means that a fight scene with a pilot is not currently running
        
        ///check player on cruiser.
        BOOL canEnterShip = YES;
        if (currentCruiser != NULL) {
            if (player.isWalking && !currentCruiser.reactorDestroyedBackup) {
                canEnterShip = NO;
            }
        }
        
        if (canEnterShip) {
            if (!shipHasPlayer) { ////there is no ship with the player
                Ship *ship;
                CCARRAY_FOREACH(gs._ships, ship) { //////////////look for ships to jump into.
                    if (ship.canHavePlayer) {
                        if (CGRectIntersectsRect(ship.spriteRect, player.spriteRect)) {
                            if (!ship.hasPlayer && !ship.playerJumpedOut) {
                                
                                if (ship.hasEnemyPilot) {   ////////if the ship has an enemy pilot.
                                    [player fightShipPilot:ship]; ////start fight scene.
                                    shipHasEnemyPilot = YES; ////let the level know the fight scene is running.
                                    EnemyPilot *enemyPilot = [EnemyPilot pilot];
                                    enemyPilot.position = ccp(player.position.x + 5, player.position.y - 3);
                                    [self addChild:enemyPilot z:kZPlayer-1];
                                    
                                    playerShipToJumpIn = ship;
                                    ship.velocity = ccp(0,0);
                                    [ship unscheduleShipMovement];
                                }
                                else {
                                    [self playerEnterShip:ship]; ///there's no enemy pilot, just land in the ship
                                }
                                
                                break; ///ship found, stop looking.
                            
                            }
                        } else {
                            if (ship.playerJumpedOut) { ///if the player just jumped out, now they're no longer intersecting so jumped out is no, so he can land in it again.
                                ship.playerJumpedOut = NO;
                            }
                        }
                    }
                }
            } //////end if !shiphasplayer.
            
        } ///// end if canentership.
        
    } ///// end if !shiphasenemypilot. so if it does, it's the fight sequence.
    
    else { ///fight sequence loop.
        
        [self pauseLevelTime];
        EnemyPilot *pilot = [EnemyPilot getPilot]; ///set the pilot from the pilot class.
        
        player.isFighting = YES;
        
        if (!pilot) { ////check to end fight sequence. (when the pilot is null).
            [self playerEnterShip:playerShipToJumpIn];  ///player get's in ship.
            shipHasEnemyPilot = NO; //stop loop.
            [self resumeLevelTime]; //resume the level timer.
            player.isFighting = NO;
        }
        
        else { ////fight loop starts here.
            
            if ([JPad getPad].touchB) {
                if (!player.isPunching) {
                    [pilot hit];
                    [player punch];
                    [gs.gameScene screenShake];
                }
            }
            
        }
        
    }
    
    
    
    
    
    
    //##!!!!
    //////// important things for if the player is walking.
    //##!!!!
    
    if (player.isWalking) {
        
        
        if ([JPad getPad].touchA) {   /////press jump while player is walking. ///smaller than jump from ship.
            if (!player.isHoldingA) {
                player.isHoldingA = YES;
                
                if ([player.playerGround isKindOfClass:[WallFlying class]]) {
                    if (!player.isJumping) {
                        player.isHoldingJump = YES;
                        [player wallFlyingJump];
                    }
                }
                else {
                    [player groundJump];
                }
            }
        } else {
            player.isHoldingJump = NO;
            player.isHoldingA = NO;
        }
        
        
        //###
        /////SPAWING ENEMIES THING.
        //###
        
        if (!isSpawning) { ///if not spawning look for start spawn switches.
            SpawnSwitch *s;
            CCArray *swithces = [SpawnSwitch getSwitches];
            if ([swithces count] > 0) {
                CCARRAY_FOREACH(swithces, s) {
                    if (s.switchType == 1) {
                        if (s.isActivated) {
                            
                            [spawnList removeAllObjects]; ///remove objects and repopulate.
                            [spawnList addObjectsFromArray:s.spawnList];
                            
                            spawnFloor = s.spawnFloor;
                            spawnMinX = s.spawnMinX;
                            spawnMaxX = s.spawnMaxX;
                            
                            [s removeSwitch]; ///so the for loop can't find it again.
                            
                            [self startSpawn];
                        }
                    }
                }
            }
        }
        
        else if (isSpawning) { ///spawn enemy, do calculation for when to spawn next.
            
            int maxEnemies = 20; ///number of enemies before frame rate drop.
            int numEnemies = [gs._enemies count];
            
            if (numEnemies < maxEnemies) {
            
                if (spawnTimer >= spawnTime) {
                    ///spawn here.
                    [self spawnEnemy];
                
                
                    spawnTimer = 0;
                    
                    
                    ///calculate the overrall diff, and how long to set the spawn timer to.
                
                    int totalDifficulty = 0;
                    
                    Enemy *e;
                    CCARRAY_FOREACH(gs._enemies, e) {
                        totalDifficulty = totalDifficulty + e.spawnDifficulty;
                    }
                    
                    float averageDifficulty = 1;
                    if (numEnemies != 0) {
                        averageDifficulty = (float)totalDifficulty/(float)numEnemies;
                    }
                    
                    ////have multiple if-else statements for what to set the spawn time to.
                    if (averageDifficulty > 0) {
                        spawnTime = 2;
                    }
                    
                    int spawnTimeDeviation = 1;
                    spawnTime = [gs randomNumberFrom:spawnTime-spawnTimeDeviation To:spawnTime+spawnTimeDeviation];
                    
                
                } else {
                
                    spawnTimer += gs.gameDelta;
                
                }
                
            }
            
            
            
            
            ///look for stop spawning switches to turn spawning off.  //////// spawning will also stop if you're inside the cruiser, code below.
            SpawnSwitch *s;
            CCArray *swithces = [SpawnSwitch getSwitches];
            CCArray *switchesToRemove = [[[CCArray alloc] init] autorelease];
            if ([swithces count] > 0) {
                CCARRAY_FOREACH(swithces, s) {
                    if (s.switchType == 2 && s.isActivated) {
                        [switchesToRemove addObject:s];
                        [self stopSpawn];
                    }
                }
            }
            if ([switchesToRemove count] > 8) {
                CCARRAY_FOREACH(switchesToRemove, s) {
                    [s removeSwitch]; ///so the for loop can't find it again.
                }
            }
            
            
        }
        
        
        ////########
        ////--------END SPAWNING ENEMIES
        ////########
        
        
        
        
        
        
        
        
        
    } /////// ########======------ END player.iswalking
    
    
    else { ////strictly put stuff here that should happen ONLY when the player is not walking
        
        ////---- like jumping out of a ship.
        
        ////////////////////////////// CONTROLS
        
        
        if ([JPad getPad].touchA) {
            if (!player.isHoldingA) {
                player.isHoldingA = YES;
                
                if (!player.jetPackRecharging) { /////so you can't jump unless the jetpack is full.
                
                    if (shipHasPlayer) {
                        Ship *ship;
                        CCARRAY_FOREACH(gs._ships, ship) {
                            //if (ship.hasPlayer && ship.isCrashing) {////jump out of the ship that has the player in it and it's crashing.
                            if (ship.hasPlayer) { //////jump out and it doesnt have to be crashing.
                                player.position = ccp(ship.position.x + (ship.playerJumpPos.x * ship.scaleX), ship.position.y + ship.playerJumpPos.y);
                                player.isHoldingJump = YES;
                                player.previousShip = ship;
                                [self moveToFocus:player]; //// moves to player, then player jumps.
                                ship.hasPlayer = NO; ///tell ship it no longer has player
                                shipHasPlayer = NO; ///layers variable saying that there is no ship with a player.
                                ship.playerJumpedOut = YES; ////tell ship that player just jumped out.
                                zoomOutFromJumpAmount = zoomFactor - startingZoom; ////////stores the amount that you need to zoom out when jumping.
                                isZooming = YES;
                                break;////stop loooping when the ship with the player has been found.
                            }
                            if (!shipHasPlayer) {
                                break;  ////if at any point looping through ships to find the one that has the player, there suddenly isn't one, stop looping.
                            }
                        }
                    }
                    
                    
                } ////////end if not jetpackrecharging.
            }
        }
        
        else { ////stop pressing A.
            player.isHoldingJump = NO;
            player.isHoldingA = NO;
        }
        
        
        
        
        /////////////////////////   PLAYER DIES IN VARIOUS WAYS WHILE NOT WALKING......
        
        
        ///// the player dies.
        if (!shipHasPlayer) { ////if no ship has the player, check if the player has fallen below the screen.
            if (player.position.y < -player.contentSize.height/2) { ////by going below the ground.
                [self retry]; ///retry.
            }
        }
        else {
            ///// the player ship dies.
            Ship *s = player.currentShip;
            if ([s isKindOfClass:[PlayerShip class]]) { ///look for the main player ship.
                PlayerShip *p = (PlayerShip*)s;
                if (p.hasPlayer && p.didCrash) { ////if it's crashed (below the floor) and the player is in it.
                    [self retry];    ////retry the level....
                }
            }
            else { ///////////////////// if it's not the player's main ship.
                if (s.isCrashing) { ///////////////////////////////see if it's in the process of crashing.
                    if (s.position.y < -s.contentSize.height/2) { ////if so see if it's below the floor.
                        [self retry]; ///retry the level...
                    }
                }
            }
            
        }
        
        ///////////////////////   END - DYING CONDITIONS ---------------------------
        
        
    }
    
    
    
    /////////#######========---------- START CRUISER
    
    
    if (startCruiser) {
        ///////##########
        ///// ----------- CHECK CRUISER STUFF.
        //////###########
        
        [self pauseLevelTime]; ///stop the level timer when a cruiser enters.
        
        ///find the cruiser in the ship array.
        Cruiser1 *cruiser;
        if (currentCruiser == NULL) {
            Ship *s;
            CCARRAY_FOREACH(gs._ships, s) {
                if ([s isKindOfClass:[Cruiser1 class]]) {
                    currentCruiser = (Cruiser1*)s;
                    cruiser = currentCruiser;
                    isCruiser = YES;
                    break;
                }
            }
        }
        else {
            cruiser = currentCruiser; ////so crusier gets set every frame, otherwise, it will be not initialized.
        }
        
        
        if (currentCruiser.reactorDestroyedBackup)
            isCruiser = NO; ///////once the cruiser is completely destoyed, don't do cruiser stuff anymore.
        
        if (!isCruiser) { ///there are no cruisers anymore, stop doing cruiser stuff.
            startCruiser = NO; ////turn off cruiser loop.
            [gs._ships removeObject:currentCruiser];///this can't be a targetable ship anymore.
            currentCruiser = NULL; ///so that some other cruiser can become the cruiser.
            [self resumeLevelTime]; ///resume the level timer, when the cruiser is defeated.
        }
        
        else {
            
            if (!cruiser.isEnter && !cruiser.isEntered) {
                cruiser.isEnter = YES;
                [cruiser enterLevel];
            }
            
            
            if (player.isWalking) {
                
                //////////////////////////////////////------- MAKE SURE NO ENEMIES SHOW UP UNTIL THE SCREEN HAS ZOOMED IN.
                if (zoomFactor != walkingZoom) {
                    [hud disablePad];
                }
                else {
                    if (![hud isPadEnabled]) [hud enablePad];
                    if (!cruiser.addedStaticEnemies) [cruiser addedStaticEnemies];
                }
                
                
                
                if (!cruiser.isMoving && !cruiser.isMoved && cruiser.isEntered) {  ///the cruiser is in the screen it isn't moving left, and it's not done moving left.
                    cruiser.isMoving = YES;
                }
                
                
                if (cruiser.isMoving || cruiser.isEnter) { ////move with the cruiser while it moves.
                    
                    player.position = ccp(player.position.x - cruiser.velocity.x, player.position.y);
                    player.currentPowerUpNode.position = ccp(player.currentPowerUpNode.position.x - cruiser.velocity.x, player.currentPowerUpNode.position.y);
                    
                    spawnMinX = cruiser.position.x - cruiser.contentSize.width/2;
                    spawnMaxX = cruiser.position.x + cruiser.contentSize.width/2;
                    
                    if ([gs._enemies count] > 0) {
                        Enemy *e;
                        CCARRAY_FOREACH(gs._enemies, e) {
                            e.position = ccp(e.position.x - cruiser.velocity.x, e.position.y);
                            e.leftWall = spawnMinX;
                            e.rightWall = spawnMaxX;
                        }
                    }
                    if ([gs._bullets count] > 0) {
                        Bullet *b;
                        CCARRAY_FOREACH(gs._bullets, b) {
                            b.position = ccp(b.position.x - cruiser.velocity.x, b.position.y);
                        }
                    }
                    CCArray *switches = [SpawnSwitch getSwitches];
                    if ([switches count] > 0) {
                        SpawnSwitch *s;
                        CCARRAY_FOREACH(switches, s) {
                            s.position = ccp(s.position.x - cruiser.velocity.x, s.position.y);
                        }
                    }
                
                }
                
                
                
                if (cruiser.playerInside) {
                    [self stopSpawn];////stop spawning enemies on top if you're inside the cruiser.
                    ////and destroy all the enemies.
                    if ([gs._enemies count] > 0) {
                        NSLog(@"remove enemies");
                        Enemy *e;
                        CCARRAY_FOREACH(gs._enemies, e) {
                            if (e) {
                                [self removeChild:e cleanup:YES];
                            }
                        }
                        [gs._enemies removeAllObjects]; ///empty the enemy array
                    }
                }
                
                if (cruiser.reactorDestroyed) {
                    NSLog(@"return player ship");
                    cruiser.reactorDestroyed = NO;
                    playerShip.position = ccp(cruiser.position.x + cruiser.contentSize.width/2 + playerShip.contentSize.width/2 + 30, cruiser.position.y - cruiser.contentSize.height/2 + 50);
                    playerShip.isCrashing = NO; //// the ship is no longer crashing.
                    playerShip.curH = playerShip.maxH; ////give the ship health back.
                    [playerShip unKill];
                }
                
            }///end if walking
            
        } //end else - numcruisers == 0
        
        ///////##########
        ///// ----------- END CRUISER STUFF.
        //////###########
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    ////// ####  FIGURE OUT THE ZOOM THING.
    if (player.isJumping) {
        if (isZoomingFromHit || (isZooming && zoomFactor > 1)) { ////zooming out to 1.
            zoomOutFromHitTimer = 0; ///just as a percaution
            isZoomingFromHit = NO; /////so the first part of this if is not true.
            zoomTime = zoomTime + gs.gameDelta;
            zoomFactor = zoomFactor - (zoomOutFromJumpAmount*(zoomTime/startingZoomTime)); ////zoom out based on time.
            //NSLog(@"called upon jump zoom factor = %f", zoomFactor);
        }
        if (isZooming && zoomFactor <= 1) { //// done zooming out to 1.
            //NSLog(@"now it's set to 1");
            isZooming = NO;
            zoomFactor = 1;
            zoomTime = 0;
        }
    }
    if (shipHasPlayer) {
        
        
        Ship *ship;
        CCARRAY_FOREACH(gs._ships, ship) {
            /*this is the code that zooms in when you get hit.
             
            if (ship.hasPlayer && ship.justHitDmg > 0) {   /////zoom out after ship gets damaged
                float damageRatio = (ship.justHitDmg / ship.startH);
                zoomFactor = zoomFactor + damageRatio;
                ship.justHitDmg = 0;
                if (!isZoomingFromHit) {
                    isZoomingFromHit = YES;
                    zoomOutFromHitTimer = zoomOutFromHitTimer + dt;
                }
            }
             */
            
            if (ship.hasPlayer) {    //////zoom out after landing in ship while zoomed in.
                if (!isZoomingFromHit) {
                    isZoomingFromHit = YES;
                    zoomOutFromHitTimer = zoomOutFromHitTimer + gs.gameDelta;
                }
            }
        }
         
         
         
        if (zoomOutFromHitTimer > 0) {
            zoomOutFromHitTimer = zoomOutFromHitTimer + gs.gameDelta;
            if (zoomOutFromHitTimer >= zoomOutFromHitTime) {  //////// wait a certain amount of time before letting it zoom out.
                
                if (zoomFactor > startingZoom) { ///slowly zoom back out after getting hit.
                    zoomFactor = zoomFactor - zoomOutFromHitAmount;
                    //zoomOutFromHitAmount = zoomOutFromHitAmount + zoomOutFromHitAccel;  ////increase the speed of the zooming out.
                }
                else {
                    zoomFactor = startingZoom;  ////until it is done then stop.
                    zoomOutFromHitAmount = zoomOutFromHitStart;
                    
                    zoomOutFromHitTimer = 0;  //// telling these 3 nested ifs to stop.
                    isZoomingFromHit = NO; //// letting the whole thing start again.
                }
            }
        }
        
    }
    
    
    
    float maxWalkZoom = walkingZoom;
    BOOL shouldZoom = player.isWalking || shipHasEnemyPilot; ///logic to determin if zooming should happen.
    if (shouldZoom) {
        if ([player.playerGround isKindOfClass:[WallFlying class]]) {
            maxWalkZoom = 1.5f;
            //shouldZoom = NO;
        }
    }
    if (shouldZoom && zoomFactor < maxWalkZoom) { /////zoom into the player.
        //start zooming in.
        zoomFactor += 0.025f;
        if (zoomFactor >= maxWalkZoom) zoomFactor = maxWalkZoom;
    }
    
    
    
    if (zoomFactor >= maxZoom) {
        zoomFactor = maxZoom;
    }
    
    self.scale = zoomFactor; ///what ultimately sets the zoom. it's actually the level that scales bigger.
    
    
    
    
    if (!movingToFocus) {
        //testing this.
        if (!shipHasPlayer) {
        //if (player.isJumping || player.isWalking) { ///follow the player and not the ship if player is jumping in air or walking on platform.
            float playerPosFromCenterY = player.position.y - gs.winSize.height/2;
            float playerPosFromCenterX = player.position.x - gs.winSize.width/2;
            
            self.position = ccp(0 - playerPosFromCenterX*zoomFactor, 0 - playerPosFromCenterY*zoomFactor); ///move layer down, same amount that player moves up. needs to multiply by the zoom factor to compensate for the lack of movement when zoomed in.
        }
        
        else {
            Ship *ship;
            CCARRAY_FOREACH(gs._ships, ship) {
                
                if (ship.hasPlayer) {
                    
                    float shipPosFromCenterY = ship.position.y - gs.winSize.height/2;
                    float shipPosFromCenterX = ship.position.x - gs.winSize.width/2;
                    int extraY = 0; //########## for ship be able to be higher than the center without camera following.
                    self.position = ccp(0 - shipPosFromCenterX*zoomFactor, extraY - shipPosFromCenterY*zoomFactor); ///move layer down, same amount that player moves up. needs to multiply by the zoom factor to compensate for the lack of movement when zoomed in.
                }
                    
            }
        }
    
    
    }
    
    /////////////KEEPING THE LAYER IN THE SCREEEN.
    
    float viewingX = gs.winSize.width/zoomFactor;  ////// when moving left and right
    float leftright = (gs.winSize.width - viewingX) / 2;
    if (self.position.x > leftright*zoomFactor) {
        self.position = ccp(leftright*zoomFactor, self.position.y);
        
    }
    else if (self.position.x < -leftright*zoomFactor) {
        self.position = ccp(-leftright*zoomFactor, self.position.y);
    }
    
    
    float viewingY = gs.winSize.height/zoomFactor;  /////// when moving up and down
    float topbottom = (gs.winSize.height - viewingY) / 2;
    if (self.position.y > topbottom*zoomFactor) {
        self.position = ccp(self.position.x, topbottom*zoomFactor);
    }
    else if (self.position.y < -topbottom*zoomFactor) {
    //    self.position = ccp(self.position.x, -topbottom*player.zoomFactor);
    }
    
}










-(void)retry {
    gs.lives -= 1;
    if (gs.lives <= 0) {
        [self gameOver];
    }
    else {
        [self unschedule:@selector(countSeconds:)];
        LevelStats *l = [LevelStats levelRetryWithNextLevelNum:levelNum];
        [self addChild:l];
        [l startNextLevel];
    }
}

-(void)gameOver {
    
}









-(void)endLevel {
    [self unschedule:@selector(countSeconds:)]; ///stop counting seconds.
    [self schedule:@selector(checkEndLevel:)]; ///keep checking.
    endLevel = NO;
    
    [Kamcord stopRecording];
    [Kamcord showView];
    
}
-(void)checkEndLevel:(ccTime)dt {
    Ship *s;
    int shipCount = 0;
    CCARRAY_FOREACH(gs._ships, s) { ///loop through enemy ships and wait for them all to be gone.
        if (!s.hasPlayer) {
            shipCount++;
        }
    }
    if (shipCount == 0) { //once they're all gone.
        
        [self unschedule:@selector(checkEndLevel:)];
        
        id delay = [CCDelayTime actionWithDuration:2]; //let things settle for 2 seconds.
        id disablepad = [CCCallFunc actionWithTarget:hud selector:@selector(disablePad)]; //disable gamepad.
        id endlevel = [CCCallFunc actionWithTarget:self selector:@selector(levelEnded)]; //end the level.
        
        [self runAction:[CCSequence actions:delay, disablepad, endlevel, nil]];
        
    }
}
-(void)levelEnded { ///what happens when the level ends.
    NSLog(@"Level Ended");
    
    int nextLevelNum = levelNum + 1;
    
    if (levelNum == 100) {
        nextLevelNum = 1;
    }
    
    LevelStats *levelStats = [LevelStats levelStatsWithNextLevelNum:nextLevelNum];
    [self addChild:levelStats];
    [levelStats startNextLevel];
    
}










////////////// overrided

-(void)addChild:(CCNode *)node{
    [super addChild:node];
    
    if ([node isKindOfClass:[ShipGroup class]]) {
        ShipGroup *group = (ShipGroup*)node;
        [group addShips];
    }
    else if ([node isKindOfClass:[Bullet class]]) {
        Bullet *b = (Bullet*)node;
        if (b.type == kbulletWalkingEnemy || b.type == kbulletWalkingPlayer) {
            [b setZOrder:kZWalkingBullets];
        } else {
            [b setZOrder:kZBullets];
        }
        [b schedule:@selector(updateJSprite:)];
    }
    else if ([node isKindOfClass:[Cruiser1 class]]) {
        [node setZOrder:kZShips];
        [(Cruiser1*)node addBirds];
        startCruiser = YES;
    }
    else if ([node isKindOfClass:[Boss class]]) {
        Boss *b = (Boss*)node;
        b.didEnter = NO;
        [b addBossNodes];
        if ([node isMemberOfClass:[Boss1 class]]) {
            [BackgroundScroll setAccel:0.017];
        }
        [bgStatic slowDownToStop];
        [self pauseLevelTime];
    }
}















///////////// GAME DOCK METHODS.

-(void)setState:(BOOL)state forButton:(GameDockState)button {
    switch (button) {
        case GameDockButtonA:
            [JPad getPad].touchA = state;
            break;
        case GameDockButtonB:
            [JPad getPad].touchB = state;
            break;
        case GameDockButtonC:
            break;
        case GameDockButtonD:
            break;
        case GameDockButtonE:
            break;
        case GameDockButtonF:
            break;
        case GameDockButtonG:
            break;
        case GameDockButtonH:
            break;
        case GameDockJoystickUp:
            [JPad getPad].touchUp = state;
            break;
        case GameDockJoystickRight:
            [JPad getPad].touchRight = state;
            break;
        case GameDockJoystickDown:
            [JPad getPad].touchDown = state;
            break;
        case GameDockJoystickLeft:
            [JPad getPad].touchLeft = state;
            break;
            
            
        case GameDockButton2A:
            break;
        case GameDockButton2B:
            break;
        case GameDockButton2C:
            break;
        case GameDockButton2D:
            break;
        case GameDockButton2E:
            break;
        case GameDockButton2F:
            break;
        case GameDockButton2G:
            break;
        case GameDockButton2H:
            break;
        case GameDockJoystick2Up:
            break;
        case GameDockJoystick2Right:
            break;
        case GameDockJoystick2Down:
            break;
        case GameDockJoystick2Left:
            break;
            
        default:
            break;
    }
}

-(void)buttonDown:(GameDockState)button {
    [self setState:YES forButton:button];
}
-(void)buttonUp:(GameDockState)button {
    [self setState:NO forButton:button];
}


-(void)stateChanged:(GameDockState)state {}












-(void)dealloc {
    
    [spawnList release];
    spawnList = nil;
    
    [super dealloc];
}







@end
