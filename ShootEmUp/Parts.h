//
//  Parts.h
//  ShootEmUp
//
//  Created by Justin Fletcher on 5/29/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Parts : JSprite {
    int partsType;
}

+(id)partsWithType:(int)type;
-(id)initWithType:(int)type;

@end
