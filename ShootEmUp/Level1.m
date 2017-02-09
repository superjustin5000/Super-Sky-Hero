//
//  Level1.m
//  ShootEmUp
//
//  Created by Justin Fletcher on 11/30/12.
//  Copyright 2012 Happy Fox. All rights reserved.
//

#import "Level1.h"

#import "Turret1.h"
#import "Mine.h"

@implementation Level1

-(id)init {
    if ((self = [super initWithNumber:1 DelayStart:0])) {
        
    }
    
    return self;
}


-(void)levelTime:(ccTime)time {
    
    if (time == 2) {
        [MessageBox mBoxWithMessage:@"You've Got Enemies Up Ahead!" Character:kHudFaceRoxie1 Duration:3];
    }
    else if (time == 6) {
        [MessageBox mBoxWithMessage:@"I'm on it!" Character:kHudFacePilot1 Duration:2];
    }
    
    
    
    if (time == 9) {
        ShipGroup *s = [ShipGroup groupWithShipType:kShipTypeKami numShips:5 movement:kMoveTypeEnterSemiCircleExit y:y_3_2 delay:0.2];
        [self addChild:s];
    }
    else if (time == 11) {
        ShipGroup *s = [ShipGroup groupWithShipType:kShipTypeKami numShips:5 movement:kMoveTypeEnterSemiCircleExit y:y_2 delay:0.2];
        [self addChild:s];
    }
    
    
    
    
    else if (time == 14) {
        Fighter1 *f = [Fighter1 ship];
        [f moveEnterFromRightAndStopWithY:y_3_2];
        [self addChild:f z:kZShips];
    }
    else if (time == 15) {
        ShipGroup *s = [ShipGroup groupWithShipType:kShipTypeKami numShips:3 movement:kMoveTypeStepUp y:y_3 delay:0.2];
        [self addChild:s];
    }
    
    
    
    
    else if (time == 18) {
        ShipGroup *s = [ShipGroup groupWithShipType:kShipTypeKami numShips:4 movement:kMoveTypeStepDown y:y_4_3 delay:0.2];
        [self addChild:s];
    }
    else if (time == 19) {
        ShipGroup *s = [ShipGroup groupWithShipType:kShipTypeKami numShips:5 movement:kMoveTypeRightToLeft y:y_3 delay:0.2];
        [self addChild:s];
    }
    
    
    
    
    else if (time == 22) {
        ShipGroup *s = [ShipGroup groupWithShipType:kShipTypeFighter numShips:3 movement:kMoveTypeEnterSemiCircleExit y:y_4_3 delay:0.6];
        [self addChild:s];
    }
    else if (time == 23) {
        Fighter1 *f = [Fighter1 ship];
        [f moveEnterFromRightAndStopWithY:y_3];
        [self addChild:f z:kZShips];
    }
    
    
    
    else if (time== 25) {
        ShipGroup *s = [ShipGroup groupWithShipType:kShipTypeKami numShips:5 movement:kMoveTypeSin y:y_3_2 delay:0.2];
        [self addChild:s];
        
    }
    else if (time == 26) {
        ShipGroup *s = [ShipGroup groupWithShipType:kShipTypeFighter numShips:3 movement:kMoveTypeEnterSemiCircleExit y:y_3 delay:0.6];
        [self addChild:s];
    }
    
    
    
    
    else if (time == 29) {
        ShipGroup *s = [ShipGroup groupWithShipType:kShipTypeKami numShips:5 movement:kMoveTypeSin y:y_3 delay:0.2];
        [self addChild:s];
    }
    else if (time == 30) {
        ShipGroup *s = [ShipGroup groupWithShipType:kShipTypeFighter numShips:3 movement:kMoveTypeRightToLeft y:y_3_2 delay:0.6];
        [self addChild:s];
    }
    
    
    
    else if (time == 32) {
        endLevel = YES;
    }
    
}



-(void)dealloc {
    [super dealloc];
}

@end
