//
//  Level2.m
//  ShootEmUp
//
//  Created by Justin Fletcher on 12/27/12.
//  Copyright 2012 Happy Fox. All rights reserved.
//

#import "Level2.h"

#import "Kamcord/Kamcord.h"

@implementation Level2


-(id)init {
    if ((self = [super initWithNumber:2 DelayStart:0])) {
        
    }
    
    return self;
}


-(void)levelTime:(ccTime)time {
    ////////////////////////////////
    if (time == 1) {
        PowerUp *p = [PowerUp powerUpWithType:kPowerupHoming];
        p.position = ccp(gs.winSize.width, y_4_3);
        [self addChild:p z:kZCollectables];
    }
    /////////////////////////////////
    
    if (time == 2) {
        ShipGroup *s = [ShipGroup groupWithShipType:kShipTypeKami numShips:5 movement:kMoveTypeEnterSemiCircleExit y:y_4_3 delay:.2];
        [self addChild:s];
    }
    else if (time == 3) {
        ShipGroup *s = [ShipGroup groupWithShipType:kShipTypeKami numShips:5 movement:kMoveTypeEnterSemiCircleExit y:y_2 delay:.2];
        [self addChild:s];
    }
    else if (time == 4) {
        ShipGroup *s = [ShipGroup groupWithShipType:kShipTypeKami numShips:3 movement:kMoveTypeStepUp y:y_4 delay:.2];
        [self addChild:s];
    }
    
    
    
    
    else if (time == 7) {
        ShipGroup *s = [ShipGroup groupWithShipType:kShipTypeKami numShips:5 movement:kMoveTypeSin y:y_3_2 delay:.2];
        [self addChild:s];
    }
    else if (time == 8) {
        ShipGroup *s = [ShipGroup groupWithShipType:kShipTypeKami numShips:5 movement:kMoveTypeSin y:y_3 delay:.2];
        [self addChild:s];
    }
    
    
    
    
    else if (time == 11) {
        ShipGroup *s = [ShipGroup groupWithShipType:kShipTypeFighter numShips:3 movement:kMoveTypeEnterAndLeave y:y_4_3 delay:.6];
        [self addChild:s];
    }
    else if (time == 12) {
        ShipGroup *s = [ShipGroup groupWithShipType:kShipTypeFighter numShips:3 movement:kMoveTypeEnterAndLeave y:y_2 delay:.6];
        [self addChild:s];
    }
    else if (time == 13) {
        ShipGroup *s = [ShipGroup groupWithShipType:kShipTypeFighter numShips:3 movement:kMoveTypeEnterAndLeave y:y_4 delay:.6];
        [self addChild:s];
    }
    
    
    
    
    else if (time == 17) {
        ShipGroup *s = [ShipGroup groupWithShipType:kShipTypeKami numShips:5 movement:kMoveTypeStepUp y:y_3 delay:.2];
        [self addChild:s];
    }
    else if (time == 19) {
        ShipGroup *s = [ShipGroup groupWithShipType:kShipTypeKami numShips:5 movement:kMoveTypeStepDown y:y_3_2 delay:.2];
        [self addChild:s];
    }
    else if (time == 20) {
        Turret1 *t = [Turret1 ship];
        [t moveRightToLeftWithY:y_3];
        [self addChild:t z:kZShips];
    }
    else if (time == 21) {
        Turret1 *t = [Turret1 ship];
        [t moveRightToLeftWithY:y_3_2];
        [self addChild:t z:kZShips];
    }
    
    
    else if (time == 24) {
        Turret1 *t = [Turret1 ship];
        [t moveRightToLeftWithY:y_3_2];
        [self addChild:t z:kZShips];
    }
    else if (time == 25) {
        Turret1 *t = [Turret1 ship];
        [t moveRightToLeftWithY:y_3];
        [self addChild:t z:kZShips];
    }
    else if (time == 26) {
        ShipGroup *s = [ShipGroup groupWithShipType:kShipTypeKami numShips:5 movement:kMoveTypeSin y:y_2 delay:.2];
        [self addChild:s];
    }
    
    
    
    
    else if (time == 29) {
        Turret1 *t = [Turret1 ship];
        [t moveRightToLeftWithY:y_3];
        [self addChild:t z:kZShips];
    }
    else if (time == 30) {
        ShipGroup *s = [ShipGroup groupWithShipType:kShipTypeFighter numShips:5 movement:kMoveTypeEnterSemiCircleExit y:y_3_2 delay:.2];
        [self addChild:s];
    }
    
    
    
    
    else if (time == 31) {
        //[Kamcord stopRecording];
        //[Kamcord showView];
        endLevel = YES;
    }
}



-(void)dealloc {
    [super dealloc];
}



@end
