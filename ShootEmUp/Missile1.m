//
//  Missile1.m
//  ShootEmUp
//
//  Created by Justin Fletcher on 7/17/12.
//  Copyright 2012 Happy Fox. All rights reserved.
//

#import "Missile1.h"
#import "EngineFlame.h"
#import "EngineSmoke.h"

@implementation Missile1

-(id)init {
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"missile1.plist" textureFilename:@"missile1.png"];
    
    if ((self = [super initWithSpriteFrameName:@"missile11.png" Strength:5 StartingHealth:1 Velocity:ccp(10, 0)])) {
        
        NSMutableArray *spinFrames = [gs framesWithFrameName:@"missile1" fromFrame:1 toFrame:4];
        baseAnimation = [[CCAnimation alloc] initWithSpriteFrames:spinFrames delay:0.05];
        [self runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:baseAnimation]]];
        
        EngineFlame *flame = [EngineFlame flameWithType:kengineFlameSmallRed];
        flame.position = ccp(self.contentSize.width + 4, self.contentSize.height/2);
        flame.rotation = -90;
        flame.scale = 1.5;
        [self addChild:flame z:self.zOrder - 1];
        
        EngineSmoke *smoke = [EngineSmoke smokeWithPosition:ccp(self.contentSize.width/2 + 5,0) Intensity:1 Direction:kdirectionRight Distance:20 Time:0.7];
        smoke.position = ccp(flame.position.x, flame.position.y);
        [self addChild:smoke z:self.zOrder - 1];
        [smoke start];
        
    }
    
    return self;
}


-(void)dealloc {
    
    [super dealloc];
}

@end
