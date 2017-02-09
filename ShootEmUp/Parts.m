//
//  Parts.m
//  ShootEmUp
//
//  Created by Justin Fletcher on 5/29/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import "Parts.h"
#import "Ship.h"

#import "PartsBar.h"

@implementation Parts

+(id)partsWithType:(int)type {
    return [[[self alloc] initWithType:type] autorelease];
}

-(id)initWithType:(int)type {
    
    //////get a particular image file based on the type.
    NSString *file;
    
    int random = rand();
    NSLog(@"random = %i", random);
    if ((random % 2) == 0) { file = @"Parts1.png"; NSLog(@"1"); }
    else { file = @"Parts2.png"; NSLog(@"2"); }
    
    CCTexture2D *tex = [[CCTextureCache sharedTextureCache] addImage:file];
    CGRect rect = CGRectZero;
    rect.size = tex.contentSize;
    CCSpriteFrame *frame = [CCSpriteFrame frameWithTexture:tex rect:rect];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFrame:frame name:file];
    
    if ((self = [super initWithSpriteFrameName:file])) {
        
        partsType = type;
        velocity = ccp(1,0);
        
        
        [self scheduleUpdate];
        
    }
    
    
    return self;
    
}


-(void)checkCollisions {
    
    Ship *s;
    CCARRAY_FOREACH(gs._ships, s) {
        if (s.hasPlayer) {
            if (CGRectIntersectsRect(spriteRect, s.spriteRect)) {
                [[PartsBar getPartsBar] addParts:partsType];
                [self destroyJSprite];
            }
        }
    }
    
}


-(void)update:(ccTime)delta {
    
    if (self.position.x < -self.contentSize.width/2 || self.position.x > gs.winSize.width + self.contentSize.width/2) {
        [self destroyJSprite];
    }
    
    self.position = ccp(self.position.x - velocity.x, self.position.y);
    self.rotation -= 3;
}



-(void)dealloc {
    [super dealloc];
}

@end
