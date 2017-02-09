//
//  Wall.h
//  ShootEmUp
//
//  Created by Justin Fletcher on 4/17/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
@class JSprite;
@interface Wall : CCNode {
    GameState *gs;
    int parentX;
    int parentY;
    CGRect rect;
    BOOL canCollide;
    BOOL showMarker;
    CCSprite *marker;
    
    BOOL bulletsGoThrough;
}
@property(nonatomic)CGRect rect;

+(id)wallWithWidth:(int)w Height:(int)h Position:(CGPoint)p;
+(id)wallWithWidth:(int)w Height:(int)h Position:(CGPoint)p BulletsGoThrough:(BOOL)bgt;
-(id)initWithWidth:(int)w Height:(int)h Position:(CGPoint)p BulletsGoThrough:(BOOL)bgt;

-(void)addSprite:(NSString*)file;

-(void)checkCollision;

@end
