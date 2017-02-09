//
//  BackgroundScroll.h
//  ThisShipWillSelfDestruct
//
//  Created by Justin Fletcher on 6/5/12.
//  Copyright 2012 Happy Fox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface BackgroundScroll : CCNode {
    
    float scrollRatio;
    float riseRatio;
    float speed;
    CCSprite *bg1;
    CCSprite *bg2;
}

+(id)BackgroundWithFile:(NSString*)fileName position:(CGPoint)position scrollRatio:(float)ratio riseRatio:(float)rRatio;
-(id)initWithBackgroundFile:(NSString*)fileName position:(CGPoint)position scrollRatio:(float)ratio riseRatio:(float)rRatio;

-(void)slowDownToStop;
-(void)speedUpToMax;
-(void)slowDownToStop:(ccTime)dt;
-(void)speedUpToMax:(ccTime)dt;
-(void)setOpacity:(int)o;

+(void)setScrollSpeed:(float)newSpeed;
+(void)setAccel:(float)a;
+(void)setNegativeDirection;

@end
