//
//  EngineFlame.h
//  ThisShipWillSelfDestruct
//
//  Created by Justin Fletcher on 6/4/12.
//  Copyright 2012 Happy Fox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface EngineFlame : JSprite {
    
    int flameType;
    
    NSMutableArray *animArray;
    CCAnimation *animation;
    
}

+(id)flameWithType:(int)type;
-(id)initWithTexture:(CCTexture2D *)texture rect:(CGRect)rect type:(int)type;

@end
