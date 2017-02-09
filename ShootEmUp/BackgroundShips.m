//
//  BackgroundShips.m
//  ShootEmUp
//
//  Created by Justin Fletcher on 9/11/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import "BackgroundShips.h"


@implementation BackgroundShips

-(id)init {
    if ((self = [super init])) {
        
        gs = [GameState sharedGameState];
        
        shipTime = [gs random0to1withDeviation:0.2];
        shipTimer = 0.0f;
        
        [self scheduleUpdate];
        
    }
    return self;
}


-(void)addShip {
    
    int randomShipNum = [gs randomNumberFrom:1 To:5];
    
    BackgroundShip *s = [BackgroundShip spriteWithSpriteFrameName:[NSString stringWithFormat:@"backgroundShips%i.png", randomShipNum]];
    
    int randomY = [gs randomNumberFrom:100 To:(200 - s.contentSize.height/2)];
    s.position = ccp(gs.winSize.width + s.contentSize.width/2, randomY);
    s.opacity = 125;
    
    if (rand() % 2 == 0) {
        s.scaleX = -1;
        s.position = ccp(-s.contentSize.width/2, randomY);
    }
    
    [parent_ addChild:s z:self.zOrder];
    
}


-(void)update:(ccTime)delta {

    if (shipTimer >= shipTime) {
        shipTimer = 0;
        shipTime = [gs random0to1withDeviation:0.2];
        
        [self addShip];
    }
    else {
        shipTimer += gs.gameDelta;
    }
    
}




-(void)dealloc {
    [super dealloc];
}

@end













@implementation BackgroundShip

-(id)initWithTexture:(CCTexture2D *)texture rect:(CGRect)rect {
    if ((self = [super initWithTexture:texture rect:rect])) {
        [self scheduleUpdate];
    }
    return self;
}


-(void)update:(ccTime)delta {
    if (self.scaleX > 0) {
        if (self.position.x <= -self.contentSize.width/2) {
            [self removeFromParentAndCleanup:YES];
        }
    }
    else {
        if (self.position.x >= [GameState sharedGameState].winSize.width + self.contentSize.width/2) {
            [self removeFromParentAndCleanup:YES];
        }
    }
    self.position = ccp(self.position.x - (1.6 * self.scaleX), self.position.y);
}


-(void)dealloc {
    [super dealloc];
}

@end