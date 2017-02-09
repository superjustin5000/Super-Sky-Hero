//
//  Mine.h
//  ShootEmUp
//
//  Created by Justin Fletcher on 12/19/12.
//  Copyright 2012 Happy Fox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "Destructable.h"

@interface Mine : Destructable {
    BOOL circleFadingOut;
    int circleAlpha;
    
    BOOL isBlinkingRed;
    int nonRedAmount;
    BOOL startBlinking;
    float blinkTime;
    
    JCircle sensorCircle;
}

+(id)mineWithY:(int)y;
-(id)initWithY:(int)y;

@end


@interface MineExplosion : JSprite {
    float lifeTimer;
    float explodeTimer;
}
@end