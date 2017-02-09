//
//  Boss.m
//  ShootEmUp
//
//  Created by Justin Fletcher on 5/21/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import "Boss.h"

#import "Ship.h"


@implementation Boss

@synthesize didEnter;
@synthesize _bossNodes;
@synthesize bossDone;

+(id)boss {
    return [[[self alloc] init] autorelease];
}

-(id)initWithSpriteFrameName:(NSString *)framename Health:(float)h {
    
    if ((self = [super initWithSpriteFrameName:framename])) {
        
        maxH = startH = curH = h;
        
        self.position = ccp(0,0);
        
        
        stopEnterX = gs.winSize.width - 100;
        [self setVelocity:ccp(1,0)];
        
        collideStrength = 20;
        
        _bossNodes = [[CCArray alloc] init];
        
        bossDone = NO;
        
        [self schedule:@selector(updateBoss:)];
        
    }
    
    return self;
}

-(id)initWithFileName:(NSString *)filename Health:(float)h {
    CCTexture2D *tex = [[CCTextureCache sharedTextureCache] addImage:filename];
    CGRect rect = CGRectZero;
    rect.size = tex.contentSize;
    CCSpriteFrame *frame = [CCSpriteFrame frameWithTexture:tex rect:rect];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:frame name:filename];
    
    return [self initWithSpriteFrameName:filename Health:h];
}

-(void)addBossNodes {
    CCSprite *node;
    CCARRAY_FOREACH(_bossNodes, node) {
        [parent_ addChild:node z:kZShips];
    }
}




-(void)checkCollisions { ///override jsprite collision detection.
    
    ///////// collission with player's ship.
    ////////// also collission with the jumping player?
    if (curH > 0) {
        for (Ship *s in gs._ships) {
            if (s.hasPlayer && s.canCollide) {
                if (CGRectIntersectsRect(self.spriteRect, s.spriteRect)) {
                    [s hitByBullet:collideStrength];
                }
            }
        }
        
    }
    
    
}



-(void)updateBoss:(ccTime)dt {
    
    
    if (curH <= 0) {
        curH = 0;
        bossDone = YES;
    }
    
    
    if (!didEnter) {
        CCSprite *primaryNode = [_bossNodes objectAtIndex:0];
        if (primaryNode.position.x > stopEnterX) {
            CCSprite *node;
            CCARRAY_FOREACH(_bossNodes, node) {
                node.position = ccp(node.position.x - velocity.x, node.position.y);
            }
        }
        else {
            didEnter = YES;
        }
    }
    
}




-(void)dealloc {
    [_bossNodes release];
    _bossNodes = nil;
    
    [super dealloc];
}

@end
