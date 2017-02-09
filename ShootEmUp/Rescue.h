//
//  Rescue.h
//  ShootEmUp
//
//  Created by Justin Fletcher on 9/16/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Rescue : JSprite {
    
    CCAnimation *baseAnim;
    CCSprite *light;
    
}

+(id)rescueWithType:(int)type;
-(id)initWithType:(int)type;
-(void)rescued;
@end
