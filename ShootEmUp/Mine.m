//
//  Mine.m
//  ShootEmUp
//
//  Created by Justin Fletcher on 12/19/12.
//  Copyright 2012 Happy Fox. All rights reserved.
//

#import "Mine.h"
#import "Player.h"
#import "Ship.h"

#import "Explode.h"

@implementation Mine

+(id)mineWithY:(int)y {
    return [[[self alloc] initWithY:y] autorelease];
}


-(id)initWithY:(int)y {
    
    if ((self = [super initWithFileName:@"mine.png" Strength:20 StartingHealth:5 Velocity:ccp(1, 0)])) {
        
        self.position = ccp(gs.winSize.width + self.contentSize.width/2, y);
        
        id rotate = [CCRotateBy actionWithDuration:3 angle:-360];
        [self runAction:[CCRepeatForever actionWithAction:rotate]];
        
        circleAlpha = 255;
        circleFadingOut = YES;
        
        nonRedAmount = 255;
        isBlinkingRed = YES;
        startBlinking = NO;
        blinkTime = 0.0f;
        
        [self scheduleUpdate];
        
    }
    
    return self;
}

-(void)kill {
}



-(void)explodeMine {
    MineExplosion *m = [MineExplosion spriteWithSpriteFrameName:@"Explode21.png"];
    m.position = ccp(self.position.x, self.position.y);
    [parent_ addChild:m z:kZExplode];
    m.opacity = 0;
    
    [self kill2]; ////remove the mine.
}


-(void)update:(ccTime)delta {
    
    if (curH <= 0) {
        [self explodeMine];
    }
    
    if (!startBlinking) {
        sensorCircle = [JSprite JCircleWithCenter:ccp(self.position.x, self.position.y) andRadius:30];
        
        Player *player = (Player*)gs.player;
        Ship *s = player.currentShip;
        
        if (s != NULL) {
            if ([JSprite JCircle:sensorCircle intersectsRect:s.spriteRect]) {
                startBlinking = YES;
                ///// maybe add something else, like a trigger sound.
            }
        }
    }
    else {
        blinkTime += gs.gameDelta;
        
        if (blinkTime >= 2) {
            /////explode.
            [self explodeMine];
        }
        
        if (isBlinkingRed)
            nonRedAmount -= 10;
        else
            nonRedAmount += 10;
        
        if (nonRedAmount <= 0) {
            nonRedAmount = 0;
            isBlinkingRed = NO;
        }
        else if (nonRedAmount >= 255) {
            nonRedAmount = 255;
            isBlinkingRed = YES;
        }
        [self setColor:ccc3(255, (const GLubyte)nonRedAmount, (const GLubyte)nonRedAmount)];
    }
    
    
    if (circleFadingOut)
        circleAlpha -= 10;
    else
        circleAlpha += 10;
    
    if (circleAlpha <= 0) {
        circleAlpha = 0;
        circleFadingOut = NO;
    }
    else if (circleAlpha >= 255) {
        circleAlpha = 255;
        circleFadingOut = YES;
    }
    
}


-(void) draw {
    
    [super draw];
    
    ccDrawColor4B(255, 0, 0, (const GLubyte)circleAlpha);
    ccDrawCircle(ccp(self.contentSize.width/2, self.contentSize.height/2), 30, 0, 100, NO);
    
}

-(void)dealloc {
    [super dealloc];
}

@end







@implementation MineExplosion

-(void)initJSprite {
    isCircle = YES;
    [self schedule:@selector(explosions:)];
}

-(JCircle)newSpriteCircle {
    return [JSprite JCircleWithCenter:ccp(self.position.x, self.position.y) andRadius:30];
}


-(void)didCollideWith:(JSprite *)sprite {
    Player *player = (Player*)gs.player;
    if (sprite == player.currentShip) {
        ////collided with ship.
        Ship *s = (Ship*)sprite;
        [s hitByBullet:kdamageBlinkingStrength];
    }
}

-(void)explosions:(ccTime)dt {
    NSLog(@"explosions");
    if (lifeTimer >= 1.5) {
        [self destroyJSprite]; ///stop exploding after x seconds.
    }
    else {
        lifeTimer += gs.gameDelta;
        
        if (explodeTimer >= 0.1) { ////call new explosion every x seconds.
            explodeTimer = 0;
            int eType = kExplode1;
            if (rand() % 2 == 0) eType = kExplode3;
            Explode *e = [Explode ExplodeWithType:eType];
            
            ////figuring out the position of the explosion. it can't be outside the radius of the MineExplosion.
            int randX = [gs randomNumberFrom:0 To:spriteCircle.radius];
            int maxY = sqrtf( (spriteCircle.radius*spriteCircle.radius) - (randX*randX) ); ////the max y of a triangle with 2 sides x and radius.
            int randY = [gs randomNumberFrom:0 To:maxY];
            
            if (rand() % 2 == 0) randX = -randX;
            if (rand() % 2 == 0) randY = -randY;
            
            e.position = ccp(self.position.x + randX, self.position.y + randY);
            
            [parent_ addChild:e z:kZExplode];
            [e explode];
            
        }
        
        else {
            explodeTimer += gs.gameDelta;
        }
        
    }
    
}

-(void)dealloc {
    [super dealloc];
}

@end

