//
//  Carrier.h
//  ShootEmUp
//
//  Created by Justin Fletcher on 9/2/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "FloatingMass.h"
#import "WallFlying.h"
@interface Carrier : FloatingMass {
    CCArray *_flames;
    WallFlying *ground;
}
-(void)flashFlames:(ccTime)dt;
-(void)addRescueWithType:(int)type;
-(void)addTurretWithX:(float)x UpSideDown:(BOOL)usd;
@end


@interface Carrier1 : Carrier {
    
}

@end


@interface Carrier2 : Carrier {
    
}

@end