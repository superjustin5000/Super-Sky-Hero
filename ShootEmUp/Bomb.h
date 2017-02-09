//
//  Bomb.h
//  ShootEmUp
//
//  Created by Justin Fletcher on 5/28/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Bomb : JSprite {
    float bombTimer;
    float bombDamageTimer;
}
-(void)explode;
-(void)doDamage:(int)damage;
@end
