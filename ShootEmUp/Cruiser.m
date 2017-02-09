//
//  Cruiser.m
//  ShootEmUp
//
//  Created by Justin Fletcher on 3/15/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import "Cruiser.h"

#import "SpawnSwitch.h"
#import "Player.h"
#import "Wall.h"
#import "Bullet.h"
#import "Explode.h"
#import "PowerUp.h"

#import "Birds.h"


#import "EnemyFlyingDroid2.h"


@implementation Reactor

@synthesize isDestroyed;

-(void)initJSprite {
    startH = 10;
    maxH = startH;
    curH = maxH;
    
    canCollide = NO;
    canColMove = NO;
    
    isDestroyed = NO;
    
    [[CCTextureCache sharedTextureCache] addImage:@"ReactorCruiserDestroyed.png"];
    
}

-(CGRect)newSpriteRect {
    Player *player = (Player*)gs.player;
    
    int parentX = 0;
    int parentY = 0;
    
    if (self.parent != player.parent) {
        ///get the x and y of the lower left corner of the parent. so the positioning is relative to the world.
        parentX = parent_.position.x - parent_.contentSize.width/2;
        parentY = parent_.position.y - parent_.contentSize.height/2;
    }
    //NSLog(@"rect location.x = %0.2f", spriteRect.origin.x + parentX);
    return CGRectMake(spriteRect.origin.x + parentX, spriteRect.origin.y + parentY, spriteRect.size.width, spriteRect.size.height);
}


-(void)checkCollisions {
    Bullet *b;
    CCARRAY_FOREACH(gs._bullets, b) {
        if (CGRectIntersectsRect(spriteRect, b.spriteRect)) {
            [b hitShip:self];
            [self takeDamage:b.strength];
            [self flash];
        }
    }
}

-(void)kill {
    [super kill];
    [self destroyReactor];
}

-(void)destroyReactor {
    isDestroyed = YES;
    [self setTexture:[[CCTextureCache sharedTextureCache] textureForKey:@"ReactorCruiserDestroyed.png"]];
    [self.texture setAliasTexParameters];
    
    Explode *e = [Explode ExplodeWithType:kExplode2];
    e.position = self.position;
    [parent_ addChild:e z:kZBullets];
    [e explode];
    
    [self schedule:@selector(explosions:) interval:.3];
}



-(void)explosions:(ccTime)dt {
    int eType = kExplode1;
    if (rand() % 2 == 0) eType = kExplode3;
    Explode *e = [Explode ExplodeWithType:eType];
    
    int randomX = [gs randomNumberFrom:self.position.x - self.contentSize.width/2 To:self.position.x + self.contentSize.width/2];
    int randomY = [gs randomNumberFrom:self.position.y - self.contentSize.height/2 To:self.position.y + self.contentSize.height/2];
    e.position = ccp(randomX, randomY);
    
    [parent_ addChild:e z:kZBullets];
    [e explode];
}



-(void)dealloc {
    [super dealloc];
}

@end







/////////////################# ------------ WINDOW SHARD -------

@implementation WindowShard

-(id)initWithTexture:(CCTexture2D *)texture rect:(CGRect)rect {
    if ((self = [super initWithTexture:texture rect:rect])) {
        gs = [GameState sharedGameState];
        
        Player *player = (Player*)gs.player;
        
        float xVel = [gs random0to1withDeviation:0.5];
        //if ([gs randomNumberFrom:5 To:10] > 5) xVel = -xVel;
        float yVel = -0.2 / 2.5;
        if (player.isJumping) {
            yVel += 0.5f;
            xVel += 0.5;
        }
        
        bounceG = 0.05;
        slowX = .2;
        
        vel = CGPointMake(xVel, yVel);
        
        [self scheduleUpdate];
    }
    return self;
}

-(void)update:(ccTime)delta {
    timer += delta;
    
    if (vel.x == 0) {
        [self killShard];
    }
    
    if (timer <= 2.5) { ////how many seconds it should stay alive for.
        self.position = ccp(self.position.x + vel.x, self.position.y + vel.y);
        
        Player *player = (Player*)gs.player;
        if (vel.x <= 0) {
            if (self.position.y <= player.floorHeight) {
                if (vel.y != 0) {
                    if (self.position.x > player.leftWall && self.position.x < player.rightWall) {
                        self.position = ccp(self.position.x, player.floorHeight + 1);
                        float velX = vel.x;
                        float velY = 0.2 / timer;
                        if (vel.y == 0) velY = 0;
                        vel = CGPointMake(velX + slowX, velY );
                    }
                    else {
                        vel = CGPointMake(vel.x, vel.y - bounceG);
                    }
                }
            }
            else {
                if (self.position.x > player.leftWall && self.position.x < player.rightWall) {
                    if (vel.y == 0) {
                        self.position = ccp(self.position.x, player.floorHeight);
                    }
                    vel = CGPointMake(vel.x, vel.y - bounceG);
                }
            }
        }
        else {
            if (self.position.x > player.leftWall && self.position.x < player.rightWall) {
                slowX = 0;
                vel = CGPointMake(0, 0);
            }
            else {
                vel.y -= bounceG;
            }
        }
    }
    else {
        [self killShard];
    }
}


-(void)killShard {
    
    void (^destroy)(void) = ^{
        [self removeFromParentAndCleanup:YES];
    };
    
    id fadeout = [CCFadeOut actionWithDuration:0.3];
    id done = [CCCallBlock actionWithBlock:destroy];
    
    [self runAction:[CCSequence actions:fadeout, done, nil]];
}



-(void)dealloc {
    [super dealloc];
}

@end









/////////////##################------------ END REACTOR   ------    START CRUISER 



@implementation Cruiser1

@synthesize playerInside; ///tells the level that the player is inside the cruiser, level turns off spawning.
@synthesize reactorDestroyed; ///tells level the reactor is destroyed. moves the player's ship near the cruisers exit point.
@synthesize reactorDestroyedBackup; ///the ship is completely destroyed.
@synthesize isEnter, isEntered; /// tells level to make ship enter.
@synthesize isMoving, isMoved; /// tells level to move ship to other side.
@synthesize addedStaticEnemies;


+(id)cruiserWithY:(int)y {
    return [[[self alloc] initWithY:y] autorelease];
}

-(id)init {
    gs = [GameState sharedGameState];
    float height = gs.winSize.height/2 - 30;
    return [self initWithY:height];
}

-(id)initWithY:(int)y { ////subclass of cruiser should override init and call [super init]
    if ((self = [super initWithFileName:@"Cruiser1_Inside.png" startingHealth:10000 jumpPos:ccp(0,0) speed:ccp(1, 0.5) shootTime:1])) {
        
        self.position = ccp(gs.winSize.width+self.contentSize.width/2, y);
        spriteRect = [self newSpriteRect];////set the spriterect so it doesn't wait a frame to do it again.
        
        canCollide = YES;
        canHavePlayer = NO;
        
        addedSpawnPoints = NO;
        doorOpen = NO;
        playerInside = NO;
        
        reactorDestroyed = NO;
        reactorDestroyedBackup = NO;
        isEnter = NO;
        isEntered = NO;
        isMoving = NO;
        isMoved = NO;
        
        
        cruiserOutside = [CCSprite spriteWithFile:@"Cruiser1.png"];
        [cruiserOutside.texture setAliasTexParameters];
        cruiserOutside.anchorPoint = ccp(0,0);
        cruiserOutside.position = ccp(0,0);
        [self addChild:cruiserOutside z:self.zOrder+1];
        
        
        doorPosX = self.contentSize.width - 50;
        int doorGap = 18;
        ///walls and floors.
        Wall *wall1 = [Wall wallWithWidth:10 Height:75 Position:ccp(doorPosX - 5, 112)];
        Wall *wall2 = [Wall wallWithWidth:10 Height:75 Position:ccp(wall1.position.x + wall1.contentSize.width/2 + doorGap + 5, wall1.position.y)];
        Wall *floor1 = [Wall wallWithWidth:200 Height:10 Position:ccp(self.contentSize.width - 100, 42)];
        
        
        [self addChild:wall1];
        [self addChild:wall2];
        [self addChild:floor1];
        
        ///init reactor.
        reactor = [Reactor spriteWithFile:@"ReactorCruiser.png"];
        reactor.position = ccp(self.contentSize.width - 82 - reactor.contentSize.width/2, floor1.position.y + floor1.contentSize.height/2 + reactor.contentSize.height/2 + 1);
        [self addChild:reactor];
        
        ////this wall is invisible and blocks the player from getting close to the reactor
        Wall *wall3 = [Wall wallWithWidth:10 Height:reactor.contentSize.height Position:ccp(reactor.position.x + reactor.contentSize.width/2 - 5, reactor.position.y) BulletsGoThrough:YES];
        [self addChild:wall3];
        
        ////wall blocking player from exiting the cruiser. this will be removed when the reactor is destroyed.
        reactorWindow = [Wall wallWithWidth:10 Height:wall3.contentSize.height Position:ccp(self.contentSize.width + 3, wall3.position.y)];
        [reactorWindow addSprite:@"ReactorWindow.png"];
        [self addChild:reactorWindow];
        
        
        
        
        
        
        
        
        ///engine flames.
        _engineFlames = [[CCArray alloc] init];
        
        CCSprite *flame1 = [CCSprite spriteWithFile:@"EngineFlameCruiser.png"];
        flame1.position = ccp(50, 81);
        flame1.opacity = 200;
        [self addChild:flame1 z:self.zOrder+1];
        [_engineFlames addObject:flame1];
        
        CCSprite *flame2 = [CCSprite spriteWithFile:@"EngineFlameCruiser.png"];
        flame2.position = ccp(flame1.position.x + 105, flame1.position.y - 20);
        flame2.opacity = flame1.opacity;
        [self addChild:flame2 z:self.zOrder+1];
        [_engineFlames addObject:flame2];
        
        CCSprite *flame3 = [CCSprite spriteWithFile:@"EngineFlameCruiser.png"];
        flame3.position = ccp(flame2.position.x + 125, flame2.position.y);
        flame3.opacity = flame2.opacity;
        [self addChild:flame3 z:self.zOrder+1];
        [_engineFlames addObject:flame3];
        
        CCSprite *flame4 = [CCSprite spriteWithFile:@"EngineFlameCruiser.png"];
        flame4.position = ccp(flame3.position.x + 125, flame3.position.y);
        flame4.opacity = flame3.opacity;
        [self addChild:flame4 z:self.zOrder+1];
        [_engineFlames addObject:flame4];
        
        
        [self schedule:@selector(flashFlames:) interval:0.02];
        
        
        
        
        
        
        
        explosionTime = 0.0;
        explosionTimer = 0.0;
        
        
        
        
        _staticEnemies = [[EnemyList alloc] init];
        [self setStaticEnemies];
        addedStaticEnemies = NO;
        
        
        [self schedule:@selector(updateCruiser:)];
        
    }
    return self;
}

-(void)didCollideWith:(JSprite *)sprite {
    Player *player = (Player*)gs.player;
    if (sprite == player) { /// collided with cruiser. now check if you landed on top.
        int collisionLandHeight = 30;
        int collisionLandPosMax = self.position.y + self.contentSize.height/2;
        int collisionLandPosMin = collisionLandPosMax - collisionLandHeight;
        if (player.footPosition.y < collisionLandPosMax && player.footPosition.y > collisionLandPosMin) { //player foot is in the collision area.
            ////only let the player land if their velocity is negative, which means they're falling and not jumping up.
            if (player.velocity.y <= 0) {
                [player landOnGround:self];
                player.position = ccp(player.position.x, collisionLandPosMax + player.contentSize.height/2); //position on top of cruiser.
                player.floorHeight = collisionLandPosMax;
                canCollide = NO; ///player can't collide with cruiser anymore so this method never gets called again.
                
                // add spawn switches.
                if (!addedSpawnPoints) {
                    [self addSpawnPoints];
                    addedSpawnPoints = YES;
                }
                
            }
        }
    }
}


-(void)addSpawnPoints {
    ////override in subclass
}

-(void)setStaticEnemies {
    /////overrride in subclass
}

-(void)addStaticEnemies {
    
    addedStaticEnemies = YES;
    
    if ([_staticEnemies count] > 0) {
        
        Player *player = (Player*)gs.player;
        
        Enemy *e;
        StaticEnemy *s;
        CCARRAY_FOREACH(_staticEnemies, s) {
            
            
            switch (s.enemyType) {
                case kEnemyTypeFlyingDroid2:
                    e = (EnemyFlyingDroid2*)[EnemyFlyingDroid2 enemyWithLeftWall:0 RightWall:gs.winSize.width];
                    e.position = ccp(self.position.x - self.contentSize.width/2 + s.xPos, player.floorHeight + 20);
                    break;
                    
                default:
                    break;
            }
            
            [parent_ addChild:e z:kZPlayer];
            [e schedule:@selector(updateEnemy:)];
            
        }
        
    }
}




-(void)enterLevel {
    [self schedule:@selector(enterLevelTimer:)];
}
-(void)enterLevelTimer:(ccTime)dt {
    int positionToStopX = gs.winSize.width/2 + self.contentSize.width/2 - 20;
    if (self.position.x > positionToStopX) {
        self.position = ccp(self.position.x - velocity.x, self.position.y);
        
        if (!isMoving) {///so it only moves birds once per frame.
            CCArray *birds = [Birds getBirds];
            if ([birds count] > 0) {
                Birds *b;
                CCARRAY_FOREACH(birds, b) {
                    if (b.birdGround == NULL) ////cruiser birds have null ground.
                        b.position = ccp(b.position.x - self.velocity.x, b.position.y);
                }
            }
        }
    
        
    }
    else {
        isEnter = NO;
        isEntered = YES;
        [self unschedule:@selector(enterLevelTimer:)];
    }
}




-(void)flashFlames:(ccTime)dt {
    CCSprite *f;
    CCARRAY_FOREACH(_engineFlames, f) {
        if (f.opacity > 0) f.opacity = 0;
        else f.opacity = 200;
    }
}



-(void)breakWindow {
    for (int i = 0; i<30; i++) {
        WindowShard *w = [WindowShard spriteWithFile:@"WindowShard.png"];
        int reactorY = self.position.y - self.contentSize.height/2 + reactorWindow.position.y;
        int yPos = [gs randomNumberFrom:reactorY - reactorWindow.contentSize.height/2 To:reactorY + reactorWindow.contentSize.height/2];
        w.position = ccp(self.position.x + self.contentSize.width/2, yPos);
        [parent_ addChild:w z:self.zOrder + 1];
    }
}


-(void)addBirds {
    ////// add birds on top.
    int birdX = [gs randomNumberFrom:self.position.x - self.contentSize.width/2 + 30 To:self.position.x + self.contentSize.width/2 - 30];
    CGPoint birdPos = ccp(birdX, self.position.y + self.contentSize.height/2);
    [BirdGroup groupWithRandomNumberOfBirdsAndPos:birdPos andParent:parent_];
}




-(void)crashCruiser:(ccTime)dt {
    /////randomly timed explosions.
    if (explosionTimer >= explosionTime) {
        int explodsionNum = [gs randomNumberFrom:1 To:5]; /// a random number of explsions for each timer.
        for (int i = 0; i < explodsionNum; i++) {
            [self crashExplosion];
        }
        explosionTimer = 0.0; ///reset explosoin timer.
        explosionTime = [gs random0to1withDeviation:0.1f]; /// a new random explsion time.
        if (explosionTime > 0.6) explosionTime -= 0.5; ///keep the time in a certain range.
    } else {
        explosionTimer += dt;
    }
    
    ////make crusier move downward and left.
    self.position = ccp(self.position.x - (velocity.x / 4), self.position.y - (velocity.y / 4));
    if (self.position.x < (-self.contentSize.width/2)) { ///once it's out of the screen delete it.
        [self unschedule:@selector(crashCruiser:)];
        [self kill];
    }
}

-(void)crashExplosion {
    int randomX = [gs randomNumberFrom:0 To:(self.position.x + self.contentSize.width/2)];
    int randomY = [gs randomNumberFrom:(self.position.y - self.contentSize.height/2) To:(self.position.y + self.contentSize.height/2)];
    Explode *e = [Explode ExplodeWithType:kExplode1];
    e.position = ccp(randomX, randomY);
    [parent_ addChild:e z:kZExplode];
    [e explode];
}






-(void)updateCruiser:(ccTime)dt {
    
    
    Player *player = (Player*)gs.player;
    
    
    
    
    if (isMoving) {
        int positionToStopX = self.contentSize.width/2 + 20;
        if (self.position.x > positionToStopX) {
            self.position = ccp(self.position.x - velocity.x, self.position.y); ///move cur pos.
            
            CCArray *birds = [Birds getBirds];
            if ([birds count] > 0) {
                Birds *b;
                CCARRAY_FOREACH(birds, b) {
                    if (b.birdGround == NULL)
                        b.position = ccp(b.position.x - self.velocity.x, b.position.y);
                }
            }
            
            
        } else {
            isMoved = YES;
            isMoving = NO; ////so the level stops making the player move with the ship.
        }
    }
    
    
    if (!canCollide && !playerInside) { ///this means the player has landed on it. And he has't gone inside yet.
        if (player.playerGround != self) {
            ////////////////////////// the player has landed on another ground.
            canCollide = YES;
        }
        
        
        
        
        Bullet *b;
        CCARRAY_FOREACH(gs._bullets, b) {
            if (CGRectIntersectsRect(spriteRect, b.spriteRect)) {
                [b hitShip:NULL];
            }
        }
    
        
        
    }
    
    
    if (!playerInside) { ////player is not in ship.
        int doorSize = 20;
        int doorPosition = self.position.x - self.contentSize.width/2 + doorPosX;
        if (player.position.x >= doorPosition && player.position.x <= (doorPosition+doorSize)) {
            doorOpen = YES;
        }
        
        if (doorOpen) {
            if (( player.position.x >= doorPosition && player.position.x <= (doorPosition + doorSize) ) && !player.isJumping) {
                [player fall];
                playerInside = YES;
                
                //////FADE OUT THE OUTSIDE OF THE CRUISER AND SET THE Z INDEX TO BE ABOVE THE PLAYER.
                [cruiserOutside setZOrder:player.zOrder+1];
                id fadeout = [CCFadeTo actionWithDuration:0.2 opacity:0];
                [cruiserOutside runAction:fadeout];
                [self unschedule:@selector(flashFlames:)];
                CCSprite *f;
                CCARRAY_FOREACH(_engineFlames, f) {
                    f.opacity = 0;
                }
            }
        }
    }
    else { ///player is inside ship.
        
        ////no the reactor can be shot.
        reactor.canCollide = YES;
        
        ///move the ship quickly more so that once the reactor is destroyed, there will be room for the player's ship on the right.
        int positionToStopX = 0;
        if (self.position.x > positionToStopX) {
            float moveSpeed = velocity.x * 3;
            self.position = ccp(self.position.x - moveSpeed, self.position.y);
            player.position = ccp(player.position.x - moveSpeed, player.position.y);
            player.currentPowerUpNode.position = ccp(player.currentPowerUpNode.position.x - moveSpeed, player.currentPowerUpNode.position.y);
        }
        
        ////the reactor was just destroyed.
        if (reactor.isDestroyed && !reactorDestroyed && !reactorDestroyedBackup) {
            
            
            if (!reactorDestroyed) { //////start the timer.
                reactorDestroyed = YES;
                //reactorTimer = [Timer timerWithStartTime:5]; /////leave out for the video.
            }
            
            if (CGRectIntersectsRect(player.spriteRect, reactorWindow.rect)) {
                if (reactorWindow) {
                    NSLog(@"remove window");
                    
                    [self breakWindow];
                    
                    [self removeChild:reactorWindow cleanup:YES]; //remove the wall blocking the exit.
                    reactorWindow = NULL;
                }
            }
            
            int playerJumpOutPosX = self.position.x + self.contentSize.width/2 + player.contentSize.width/2;
            if (player.position.x > playerJumpOutPosX) {
                reactorDestroyedBackup = YES; ////////////// now the outer if statement won't run anymore. we dont want it to.
                [self schedule:@selector(crashCruiser:)];
                
                ///// FADE THE CRUISER OUTSIDE BACK IN AND SET THE Z INDEX BACK TO WHERE IT WAS.
                [cruiserOutside setZOrder:self.zOrder+1];
                id fadein = [CCFadeTo actionWithDuration:0.2 opacity:255];
                [cruiserOutside runAction:fadein];
            }
    
        }
    }
    
    
    
}






/////////// OVERRIDED METHODS

//// SHIP METHODS

-(void)hitByBullet:(float)strength {
    ///nothing happens, the cruiser is impervious to bullets.
}








-(void)dealloc {
    
    [_engineFlames release];
    [_staticEnemies release];
    
    _engineFlames = nil;
    _staticEnemies = nil;
    
    [super dealloc];
}

@end







