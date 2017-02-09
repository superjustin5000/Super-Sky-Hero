//
//  GroundTurret.h
//  ShootEmUp
//
//  Created by Justin Fletcher on 9/24/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Shooter.h"

@interface GroundTurret : Shooter {
    
}
+(id)turretUpSideDown:(BOOL)usd;
-(id)initUpsideDown:(BOOL)usd;
@end
