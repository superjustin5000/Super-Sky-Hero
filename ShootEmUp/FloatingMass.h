//
//  FloatingMass.h
//  ShootEmUp
//
//  Created by Justin Fletcher on 5/19/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Destructable.h"

@interface FloatingMass : Destructable {
    
}
+(id)floatingMassWithY:(int)y;
-(id)initWithY:(int)y; //for subclass
-(id)initWithFileName:(NSString*)filename Invincibility:(BOOL)inv Y:(int)y;
@end
