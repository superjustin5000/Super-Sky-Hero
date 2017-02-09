//
//  EngineFlame.m
//  ThisShipWillSelfDestruct
//
//  Created by Justin Fletcher on 6/4/12.
//  Copyright 2012 Happy Fox. All rights reserved.
//

#import "EngineFlame.h"


@implementation EngineFlame

+(id)flameWithType:(int)type {
    
    static BOOL addedSpriteSheet = NO;
    if (!addedSpriteSheet) {
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"flames.plist" textureFilename:@"flames.png"];
        addedSpriteSheet = YES;
    }
    
    CCTexture2D *tex; ////create dynamic texture
    CGRect rect;      ////and the rect that will get set based on what texture is given based on the if statement that runs below.
    
    if (type == kengineFlameSmallBlue) {
        tex = [[CCTextureCache sharedTextureCache] textureForKey:@"flameBlueSmall1.png"];
    }
    else if (type == kengineFlameSmallRed) {
        tex = [[CCTextureCache sharedTextureCache] textureForKey:@"flameRedSmall1.png"];
    }
    
    ////and automagically it works.
    rect = CGRectZero;
    rect.size = tex.contentSize;
    return [[[self alloc] initWithTexture:tex rect:rect type:type] autorelease];
}

-(id)initWithTexture:(CCTexture2D *)texture rect:(CGRect)rect type:(int)type {
    if ((self = [super initWithTexture:texture rect:rect])) {
        
        float delay;
        
        if (type == kengineFlameSmallBlue) {
            animArray = [gs framesWithFrameName:@"flameBlueSmall" fromFrame:1 toFrame:3 andReverse:YES andAntiAlias:NO];
            delay = 0.02;
        }
        else if (type == kengineFlameSmallRed) {
            animArray = [gs framesWithFrameName:@"flameRedSmall" fromFrame:1 toFrame:3 andReverse:YES andAntiAlias:NO];
            delay = 0.1;
        }
        
        animation = [CCAnimation animationWithSpriteFrames:animArray delay:delay];
        [self runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]]];
        
    }
    
    return self;
}


-(void)dealloc {
    [super dealloc];
}

@end
