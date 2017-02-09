//
//  JetPackBar.h
//  ShootEmUp
//
//  Created by Justin Fletcher on 10/3/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "JHudNode.h"

@interface JetPackBar : JHudNode {
    float curMeter;
    float prevMeter;
    //float movingMeter;
    BOOL isMovingMeter;
}

@end
