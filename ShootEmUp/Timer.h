//
//  Timer.h
//  ShootEmUp
//
//  Created by Justin Fletcher on 9/1/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "JHudNode.h"

@interface Timer : JHudNode {
    float timer;
    NSString *timerString;
    CCLabelTTF *timerLabel;
}

+(id)timerWithStartTime:(float)start;
-(id)initWithStartTime:(float)start;

@end
