//
//  Level4.m
//  ShootEmUp
//
//  Created by Justin Fletcher on 5/20/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import "Level4.h"
#import "Cruiser1_1.h"

@implementation Level4

-(id)init {
    if ((self = [super initWithNumber:4 DelayStart:0])) {
        
    }
    return self;
}


-(void)levelTime:(ccTime)time {
    
    if (time == 2) {
        Mech1 *m = [Mech1 ship];
        [m moveEnterAndLeaveWithY:y_4_3];
        [self addChild:m z:kZShips];
    }
    else if (time == 3) {
        Mech1 *m = [Mech1 ship];
        [m moveEnterAndLeaveWithY:y_4];
        [self addChild:m z:kZShips];
    }
    else if (time == 4) {
        ShipGroup *s = [ShipGroup groupWithShipType:kShipTypeKami numShips:5 movement:kMoveTypeSin y:y_2 delay:0.2];
        [self addChild:s];
    }
    
    
    
    
    else if (time == 7) {
        Mech1 *m = [Mech1 ship];
        [m moveEnterAndLeaveWithY:y_3_2];
        [self addChild:m z:kZShips];
    }
    else if (time == 8) {
        Mech1 *m = [Mech1 ship];
        [m moveEnterAndLeaveWithY:y_3];
        [self addChild:m z:kZShips];
    }
    
    
    
    
    else if (time == 17) {
        Cruiser1_1 *c = [Cruiser1_1 ship];
        [self addChild:c];
    }
    
    else if (time == 18) {
        endLevel = YES;
    }
}


-(void)dealloc {
    [super dealloc];
}
@end
