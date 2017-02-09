//
//  PartsBar.h
//  ShootEmUp
//
//  Created by Justin Fletcher on 5/30/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "JHudNode.h"

@interface PartsBar : JHudNode {
    CCSprite *partsBarMeter;
}
+(PartsBar*)getPartsBar;
-(void)addParts:(int)type;

@end
