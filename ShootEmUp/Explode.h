//
//  Explode.h
//  ShootEmUp
//
//  Created by Justin Fletcher on 8/13/12.
//  Copyright 2012 Happy Fox. All rights reserved.
//




#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "SimpleAudioEngine.h"

@interface Explode : JSprite {
    CCAnimation *explodeAnim;
    float animDelay;
}

+(CCArray*)getExplosions;

+(id)ExplodeWithType:(int)eType;
-(id)initWithType:(int)eType;

-(void)explode;
-(void)explodeDone;

@end
