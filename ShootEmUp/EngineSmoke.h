//
//  EngineSmoke.h
//  ShootEmUp
//
//  Created by Justin Fletcher on 7/18/12.
//  Copyright 2012 Happy Fox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface EngineSmoke : CCNode {
    float intensity;
    float direction;
    CGPoint position;
    int distance;
    float duration;
    
    BOOL isOn;
}

@property(nonatomic)float intensity;
@property(nonatomic)float direction;
@property(nonatomic)int distance;
@property(nonatomic)float duration;

+(id)smokeWithPosition:(CGPoint)pos Intensity:(float)iLevel Direction:(int)facing Distance:(int)length Time:(float)time;
-(id)initWithPosition:(CGPoint)pos Intensity:(float)iLevel Direction:(int)facing Distance:(int)length Time:(float)time;

-(void)start;
-(void)stop;

@end



@interface smokeParticle : CCSprite

@end


