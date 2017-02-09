//
//  Level6.m
//  ShootEmUp
//
//  Created by Justin Fletcher on 8/25/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import "Level6.h"

#import "Carrier.h"
#import "Attacker.h"

@implementation Level6


-(id)init {
    if ((self = [super initWithNumber:6 DelayStart:0])) {
        
    }
    return self;
}


-(void)levelTime:(ccTime)time {
    /////////////////////
    if (time == 1) {
        PowerUp *p = [PowerUp powerUpWithType:kPowerupLaser];
        p.position = ccp(gs.winSize.width, y_4_3);
        [self addChild:p z:kZCollectables];
    }
    /////////////////////
    if (time == 2) {
        Carrier1 *c = [Carrier1 floatingMassWithY:y_2];
        [self addChild:c z:kZShips];
        [c addTurretWithX:c.position.x UpSideDown:NO];
        [c addTurretWithX:c.position.x UpSideDown:YES];
    }
    else if (time == 4) {
        ShipGroup *s = [ShipGroup groupWithShipType:kShipTypeKami numShips:5 movement:kMoveTypeCornerToCorner24 y:0 delay:0.3];
        [self addChild:s];
    }
    else if (time == 5) {
        Carrier2 *c = [Carrier2 floatingMassWithY:y_4];
        [self addChild:c z:kZShips];
        [c addTurretWithX:c.position.x - c.contentSize.width/4 UpSideDown:NO];
        [c addTurretWithX:c.position.x + c.contentSize.width/4 UpSideDown:NO];
    }
    else if (time == 9) {
        ShipGroup *s = [ShipGroup groupWithShipType:kShipTypeFighter numShips:3 movement:kMoveTypeRightToLeft y:y_3_2 delay:0.6];
        [self addChild:s];
    }
    else if (time == 11) {
        ShipGroup *s = [ShipGroup groupWithShipType:kShipTypeFighter numShips:3 movement:kMoveTypeRightToLeft y:y_2 delay:0.6];
        [self addChild:s];
    }
    else if (time == 13) {
        Attacker1 *a = [Attacker1 ship];
        [a moveEnterAndLeaveWithY:y_3];
        [self addChild:a z:kZShips];
    }
    else if (time == 16) {
        ShipGroup *s = [ShipGroup groupWithShipType:kShipTypeKami numShips:5 movement:kMoveTypeCornerToCorner24 y:0 delay:0.3];
        [self addChild:s];
        ShipGroup *s2 = [ShipGroup groupWithShipType:kShipTypeKami numShips:5 movement:kMoveTypeCornerToCorner31 y:0 delay:0.3];
        [self addChild:s2];
    }
    else if (time == 17) {
        Carrier1 *c = [Carrier1 floatingMassWithY:y_4_3];
        [self addChild:c z:kZShips];
        Carrier1 *c1 = [Carrier1 floatingMassWithY:y_4];
        [self addChild:c1 z:kZShips];
        [c addTurretWithX:c.position.x UpSideDown:YES];
        [c1 addTurretWithX:c1.position.x UpSideDown:NO];
    }
    else if (time == 18) {
        ShipGroup *s = [ShipGroup groupWithShipType:kShipTypeKami numShips:5 movement:kMoveTypeCornerToCorner24 y:0 delay:0.3];
        [self addChild:s];
        ShipGroup *s2 = [ShipGroup groupWithShipType:kShipTypeKami numShips:5 movement:kMoveTypeCornerToCorner31 y:0 delay:0.3];
        [self addChild:s2];
    }
    
    else if (time == 21) {
        ShipGroup *s = [ShipGroup groupWithShipType:kShipTypeKami numShips:6 movement:kMoveTypeSin y:y_3_2 delay:0.3];
        [self addChild:s];
        
        ShipGroup *s2 = [ShipGroup groupWithShipType:kShipTypeKami numShips:6 movement:kMoveTypeCos y:y_3 delay:0.3];
        [self addChild:s2];
        
        
        [MessageBox mBoxWithMessage:@"Try a barrel roll!" Character:kHudFaceRoxie1 Duration:2];
    }
    
    else if (time == 25) {
        [MessageBox mBoxWithMessage:@"What!? This ship isn't built for those moves." Character:kHudFacePilot1 Duration:4];
    }
    
    
    else if (time == 26) {
        Attacker1 *a = [Attacker1 ship];
        [a moveSplitDiagonalUpWithY:y_4];
        [self addChild:a z:kZShips];
    }
    
    else if (time == 28) {
        Attacker1 *a = [Attacker1 ship];
        [a moveEnterAndLeaveWithY:y_2];
        [self addChild:a z:kZShips];
    }
    
    else if (time == 29) {
        endLevel = YES;
    }
}


-(void)dealloc {
    [super dealloc];
}

@end
