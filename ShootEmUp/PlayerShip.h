//
//  PlayerShip.h
//  ThisShipWillSelfDestruct
//
//  Created by Justin Fletcher on 5/28/12.
//  Copyright 2012 Happy Fox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Ship.h"

@interface PlayerShip : Ship {
    EngineFlame *flame;
    BOOL didCrash;
    ALuint engineSound;
}
@property(nonatomic)BOOL didCrash;

-(void)bigFlame;
-(void)smallFlame;
-(void)normalFlame;

-(void)bigSound;
-(void)smallSound;
-(void)normalSound;

-(void)noFlame;

@end
