//
//  SawBlade.m
//  ShootEmUp
//
//  Created by Justin Fletcher on 5/31/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import "SawBlade.h"
#import "Ship.h"
#import "Player.h"

@implementation SawBlade

+(id)saw {
    return [[[self alloc] init] autorelease];
}

-(id)init {
    
    NSString *filename = @"sawBlade1.png";
    CCTexture2D *tex = [[CCTextureCache sharedTextureCache] addImage:filename];
    CGRect rect = CGRectZero;
    rect.size = tex.contentSize;
    CCSpriteFrame *frame = [CCSpriteFrame frameWithTexture:tex rect:rect];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:frame name:filename];
    
    if ((self = [super initWithSpriteFrameName:filename])) {
        
        isCircle = YES;
        //rectRelativeToParent = YES;
        
        [self scheduleUpdate];
    
    }
    return self;
}


-(void)didCollideWith:(JSprite *)sprite {
    Player *player = (Player*)gs.player;
    
    if (sprite == player) { ///collides directly with player.
        
        
        
    }
    else { ////collides with the players ship he is in.
        Ship *playerShip = player.currentShip;
        if (sprite == playerShip) {
            
            playerShip.curH = 0;
            
        }
    }
    
}



-(void)update:(ccTime)delta {
    
    self.rotation -= 6;
    
}


-(void)dealloc {
    [super dealloc];
}


@end
