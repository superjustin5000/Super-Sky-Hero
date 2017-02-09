//
//  Level3.m
//  ShootEmUp
//
//  Created by Justin Fletcher on 1/3/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import "Level3.h"
#import "Mine.h"
#import "Carrier.h"


@implementation Level3

-(id)init {
    if ((self = [super initWithNumber:3 DelayStart:0])) {
        
        
        
    }
    return self;
}

-(void)levelTime:(ccTime)time {
    
    
    
    if (time == 2) {
        Carrier1 *f = [Carrier1 floatingMassWithY:y_3];
        [self addChild:f z:kZShips];
        [f addRescueWithType:krescue_male1];
    }
    else if (time == 3) {
        Carrier2 *f = [Carrier2 floatingMassWithY:y_3_2];
        [self addChild:f z:kZShips];
    }
    
    else if (time == 6) {
        ShipGroup *s = [ShipGroup groupWithShipType:kShipTypeKami numShips:6 movement:kMoveTypeRightToLeft y:y_2 delay:0.2];
        [self addChild:s];
    }
    
    
    else if (time == 8) {
        ShipGroup *s = [ShipGroup groupWithShipType:kShipTypeFighter numShips:3 movement:kMoveTypeEnterSemiCircleExit y:y_4_3 delay:0.6];
        [self addChild:s];
    }
    else if (time == 9) {
        Carrier2 *f = [Carrier2 floatingMassWithY:y_2];
        [self addChild:f z:kZShips];
    }
    else if (time == 10) {
        ShipGroup *s = [ShipGroup groupWithShipType:kShipTypeKami numShips:6 movement:kMoveTypeStepUp y:y_5 delay:0.2];
        [self addChild:s];
    }
    
    
    
    
    else if (time == 12) {
        Fighter1 *f = [Fighter1 ship];
        [f moveEnterFromRightAndStopWithY:y_4_3];
        [self addChild:f z:kZShips];
    }
    else if (time == 13) {
        ShipGroup *s = [ShipGroup groupWithShipType:kShipTypeKami numShips:5 movement:kMoveTypeSin y:y_4 delay:0.2];
        [self addChild:s];
    }
    
    else if (time == 15) {
        Fighter1 *f = [Fighter1 ship];
        [f moveEnterFromRightAndStopWithY:y_4];
        [self addChild:f z:kZShips];
    }
    
    
    else if (time == 18) {
        Carrier1 *f = [Carrier1 floatingMassWithY:y_3];
        [self addChild:f z:kZShips];
    }
    else if (time == 19) {
        ShipGroup *s = [ShipGroup groupWithShipType:kShipTypeFighter numShips:3 movement:kMoveTypeEnterSemiCircleExit y:y_3_2 delay:0.6];
        [self addChild:s];
    }
    
    else if (time == 21) {
        Turret1 *t = [Turret1 ship];
        [t moveRightToLeftWithY:y_3];
        [self addChild:t z:kZShips];
    }
    else if (time == 23) {
        Carrier2 *f = [Carrier2 floatingMassWithY:y_3];
        [self addChild:f z:kZShips];
    }
    
    else if (time == 25) {
        ShipGroup *s = [ShipGroup groupWithShipType:kShipTypeKami numShips:5 movement:kMoveTypeSin y:y_2 delay:0.2];
        [self addChild:s];
    }
    else if (time == 26) {
        Carrier2 *f = [Carrier2 floatingMassWithY:y_3_2];
        [self addChild:f z:kZShips];
    }
    else if (time == 27) {
        ShipGroup *s = [ShipGroup groupWithShipType:kShipTypeKami numShips:6 movement:kMoveTypeRightToLeft y:y_5 delay:0.2];
        [self addChild:s];
    }
    else if (time == 28) {
        ShipGroup *s = [ShipGroup groupWithShipType:kShipTypeFighter numShips:3 movement:kMoveTypeEnterAndLeave y:y_5_4 delay:0.6];
        [self addChild:s];
    }
    
    else if (time == 31) {
        Carrier2 *f = [Carrier2 floatingMassWithY:y_2];
        [self addChild:f z:kZShips];
    }
    else if (time == 32) {
        Turret1 *t = [Turret1 ship];
        [t moveRightToLeftWithY:y_3_2];
        [self addChild:t z:kZShips];
        
        Turret1 *t2 = [Turret1 ship];
        [t2 moveRightToLeftWithY:y_3];
        [self addChild:t2 z:kZShips];
    }
    
    
    else if (time == 35) {
        Mech1 *m = [Mech1 ship];
        [m moveEnterFromRightAndStopWithY:y_3_2];
        [self addChild:m z:kZShips];
        
        Mech1 *m2 = [Mech1 ship];
        [m2 moveEnterFromRightAndStopWithY:y_3];
        [self addChild:m2 z:kZShips];
    }
    
    else if (time == 36) {
        endLevel = YES;
    }
}


-(void)dealloc {
    [super dealloc];
}

@end
