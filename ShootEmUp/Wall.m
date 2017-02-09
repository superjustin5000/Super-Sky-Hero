//
//  Wall.m
//  ShootEmUp
//
//  Created by Justin Fletcher on 4/17/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import "Wall.h"

#import "Player.h"
#import "Bullet.h"

@implementation Wall

@synthesize rect;

+(id)wallWithWidth:(int)w Height:(int)h Position:(CGPoint)p {
    return [[[self alloc] initWithWidth:w Height:h Position:p BulletsGoThrough:NO] autorelease];
}


+(id)wallWithWidth:(int)w Height:(int)h Position:(CGPoint)p BulletsGoThrough:(BOOL)bgt {
    return [[[self alloc] initWithWidth:w Height:h Position:p BulletsGoThrough:bgt] autorelease];
}

-(id)initWithWidth:(int)w Height:(int)h Position:(CGPoint)p BulletsGoThrough:(BOOL)bgt {
    
    if ((self = [super init])) {
        gs = [GameState sharedGameState];
        
        self.contentSize = CGSizeMake(w, h);
        
        self.position = p;
        rect = CGRectMake(self.position.x - self.contentSize.width/2, self.position.y - self.contentSize.height/2, self.contentSize.width, self.contentSize.height);
        
        canCollide = YES;
        bulletsGoThrough = bgt;
        
        //showMarker = YES; ///comment out if you dont want them to be drawn.
        
        if (showMarker) {
            /*
            if (w >= h) {
                marker = [CCSprite spriteWithFile:@"floorTest.png"];
            } else {
                marker = [CCSprite spriteWithFile:@"wallTest.png"];
            }
            marker.anchorPoint = ccp(0,0);
            marker.position = ccp(0 - self.contentSize.width/2, 0-self.contentSize.height/2);
            [self addChild:marker];
             */
        }
        
        [self scheduleUpdate];
    
    }
    
    return self;
}




-(void)addSprite:(NSString *)file {
    CCSprite *s = [CCSprite spriteWithFile:file];
    s.anchorPoint = ccp(0,0);
    s.position = ccp(0 - self.contentSize.width/2, 0-self.contentSize.height/2);
    [self addChild:s];
}




-(void)checkCollision {
    Player *player = (Player*)gs.player;
    
    if (CGRectIntersectsRect(player.spriteRect, rect)) {
        
        CGRect collisionRect = CGRectIntersection(player.spriteRect, rect);
        if ( !CGRectIsNull(collisionRect) ) { ///make sure the rect is not null. which means there is a collision.
            int width = collisionRect.size.width;
            int height = collisionRect.size.height;
            
            
            int groundX = parentX + self.position.x;
            int groundY = parentY + self.position.y;
            
            if (width > height) { ////it's a floor collision.
                if (player.position.y >= groundY) { ////player above, so land on ground.
                    if (player.velocity.y <= 0) {
                        [player landOnGround:self];
                        NSLog(@"new ground");
                        player.position = ccp(player.position.x, groundY + self.contentSize.height/2 + player.contentSize.height/2);
                        player.floorHeight = groundY + self.contentSize.height/2;
                        canCollide = NO;
                    }
                    
                }
                else { //player below, maybe hits head.
                }
            }
            else  {  /////////////////it's a wall collision.
                if (player.position.x >= groundX) { ////player to the right, so don't let him walk more left.
                    if (![JPad getPad].touchRight) {
                        player.position = ccp(groundX + rect.size.width/2 + player.spriteRect.size.width/2, player.position.y);
                    }
                }
                if (player.position.x <= groundX) { ///player left, don't walk more right.
                    if (![JPad getPad].touchLeft) {
                        /*
                         int playerActualWidthMinusRectWidth = (player.position.x + player.contentSize.width/2) - (player.spriteRect.origin.x + player.spriteRect.size.width);
                        playerActualWidthMinusRectWidth = abs(playerActualWidthMinusRectWidth);
                        NSLog(@"that value is %i", playerActualWidthMinusRectWidth);
                        */
                        player.position = ccp(groundX - rect.size.width/2 - player.spriteRect.size.width/2 + 3, player.position.y);
                    }
                }
            }
        }
        
    }
    
    
    
    if (!bulletsGoThrough) {
        Bullet *b;
        CCARRAY_FOREACH(gs._bullets, b) {
            if (CGRectIntersectsRect(rect, b.spriteRect)) {
                [b hitShip:NULL];
            }
        }
    }
    
    
}



-(void)update:(ccTime)delta {
    
    Player *player = (Player*)gs.player;
    if (!canCollide) {
        if (player.playerGround != self) {
            canCollide = YES;
        }
    }
    
    
    if (self.parent != player.parent) {
        ///get the x and y of the lower left corner of the parent. so the positioning is relative to the world.
        parentX = parent_.position.x - parent_.contentSize.width/2;
        parentY = parent_.position.y - parent_.contentSize.height/2;
        
    }
    
    rect = CGRectMake(self.position.x - self.contentSize.width/2 + parentX, self.position.y - self.contentSize.height/2 + parentY, self.contentSize.width, self.contentSize.height);
    //rect = CGRectMake(self.position.x - self.contentSize.width/2, self.position.y - self.contentSize.height/2, self.contentSize.width, self.contentSize.height);
    
    
    if (!canCollide) {   ////if you can't collide,
        if (!CGRectIntersectsRect(player.spriteRect, rect)) {  // and you're not colliding with the player, make it so you can collide.
            if (self != player.playerGround) { ///also you can't be the ground of the player. otherwise the player would keep falling.
            }
        }
    } else { ///// if you can collide. do normal collision checks.
        [self checkCollision];
    }

}







-(void)draw {
    
    if (showMarker) {
        
        glLineWidth(0.5f);
        
        CGPoint verts[4] = {
            ccp(-rect.size.width/2, -rect.size.height/2),
            ccp(rect.size.width/2, -rect.size.height/2),
            ccp(rect.size.width/2, rect.size.height/2),
            ccp(-rect.size.width/2, rect.size.height/2)
        };
        
        ccDrawColor4B(0, 255, 0, 255);
        ccDrawPoly(verts, 4, YES);
        
        
        //NSLog(@"Rect lower left = %0.2f", spriteRect.origin.x);
        
    }
    [super draw];
}








-(void)dealloc {
    [super dealloc];
}

@end

