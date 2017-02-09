//
//  HealthBar.h
//  ShootEmUp
//
//  Created by Justin Fletcher on 1/1/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "JHudNode.h"
#import "Player.h"

@interface HealthBar : JHudNode {
    Player *player;
    CCSprite *healthBarMeter;
    CCSprite *healthBarMeterShip;
    CGPoint healthBarPos;
}
@property(nonatomic)CGPoint healthBarPos;

+(HealthBar*)getHealthBar;

@end
