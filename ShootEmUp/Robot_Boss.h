//
//  Robot_Boss.h
//  ShootEmUp
//
//  Created by Justin Fletcher on 11/18/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Robot_Boss : JSprite {
    CCSprite *chestGlow;
    CCSprite *eyeGlow;
}

-(void)startActions;

@end


@interface Laser : JSprite {
    
}

@end
