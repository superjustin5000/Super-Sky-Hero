//
//  ShipGroup.h
//  ThisShipWillSelfDestruct
//
//  Created by Justin Fletcher on 6/12/12.
//  Copyright 2012 Happy Fox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "Ship.h"
#import "GameState.h"



#import "Kami.h"
#import "Fighter.h"
#import "Mech1.h"
#import "Turret1.h"
#import "Trooper1.h"
#import "Bomber1.h"

@interface ShipGroup : CCNode {
    GameState *gs;
    
    CCArray *_ships;
    float shipDelay;
    int shipNum;
    int numShips;
    int moveY;
}

+(id)group;
+(id)groupWithShipType:(int)shipType numShips:(int)num movement:(int)movementType y:(int)y delay:(float)delay;
-(id)initWithShipType:(int)shipType numShips:(int)num movement:(int)movementType y:(int)y delay:(float)delay;

-(void)addShips;
-(void)removeSelf;

@end
