//
//  ShipGroup.m
//  ThisShipWillSelfDestruct
//
//  Created by Justin Fletcher on 6/12/12.
//  Copyright 2012 Happy Fox. All rights reserved.
//

#import "ShipGroup.h"

@implementation ShipGroup

+(id)group {  //////returns the group with the default group's delay time.
    return [[[self alloc] init] autorelease];
}

+(id)groupWithShipType:(int)shipType numShips:(int)num movement:(int)movementType y:(int)y delay:(float)delay {
    return [[[self alloc] initWithShipType:shipType numShips:num movement:movementType y:y delay:delay] autorelease];
}

-(id)initWithShipType:(int)shipType numShips:(int)num movement:(int)movementType y:(int)y delay:(float)delay {
    if ((self = [super init])) {
        gs = [GameState sharedGameState];
        
        _ships = [[CCArray alloc] init];
        shipDelay = delay;
        shipNum = 0;
        numShips = num;
        moveY = y;
        
        
        for (int i=0; i<numShips; i++) {
            //ship types.
            Ship *s;
            switch (shipType) {
                case kShipTypeKami:
                    s = (Kami*)[Kami ship];
                    break;
                case kShipTypeKami2:
                    s = (Kami2*)[Kami2 ship];
                    break;
                case kShipTypeFighter:
                    s = (Fighter1*)[Fighter1 ship];
                    break;
                case kShipTypeMech:
                    s = (Mech1*)[Mech1 ship];
                    break;
                case kShipTypeTurret:
                    s = (Turret1*)[Turret1 ship];
                    break;
                case kShipTypeTrooper:
                    s = (Trooper1*)[Trooper1 ship];
                    break;
                case kShipTypeBomber:
                    s = (Bomber1*)[Bomber1 ship];
                    break;
                default:
                    break;
            }
            
            //movement types.
            switch (movementType) {
                case kMoveTypeRightToLeft:
                    [s moveRightToLeftWithY:moveY];
                    break;
                case kMoveTypeLeftToRight:
                    [s moveLeftToRightWithY:moveY];
                    break;
                case kMoveTypeSin:
                    [s moveSinWaveWithY:moveY];
                    break;
                case kMoveTypeCos:
                    [s moveCosWaveWithY:moveY];
                    break;
                case kMoveTypeSinLTR:
                    [s moveSinWaveFromLeftWithY:moveY];
                    break;
                case kMoveTypeCosLTR:
                    [s moveCosWaveFromLeftWithY:moveY];
                    break;
                case kMoveTypeRoot:
                    [s moveRootCurveWithY:moveY];
                    break;
                case kMoveTypeCornerToCorner13:
                    [s moveCornerToCornerFromQuadrant:1 toQuadrant:3];
                    break;
                case kMoveTypeCornerToCorner31:
                    [s moveCornerToCornerFromQuadrant:3 toQuadrant:1];
                    break;
                case kMoveTypeCornerToCorner24:
                    [s moveCornerToCornerFromQuadrant:2 toQuadrant:4];
                    break;
                case kMoveTypeCornerToCorner42:
                    [s moveCornerToCornerFromQuadrant:4 toQuadrant:2];
                    break;
                case kMoveTypeSemiCircleTop:
                    [s moveSemiCircleFromTop];
                    break;
                case kMoveTypeSemiCircleBottom:
                    [s moveSemiCircleFromTop];
                    break;
                case kMoveTypeEnterFromRightAndStop:
                    [s moveEnterFromRightAndStopWithY:moveY];
                    break;
                case kMoveTypeEnterFromTopLeftAndDown:
                    [s moveEnterFromTopLeftAndDown];
                    break;
                case kMoveTypeEnterFromBottomLeftAndUp:
                    [s moveEnterFromBottomLeftAndUp];
                    break;
                case kMoveTypeEnterAndLeave:
                    [s moveEnterAndLeaveWithY:moveY];
                    break;
                case kMoveTypeEnterSemiCircleExit:
                    [s moveEnterSemiCircleExitWithY:moveY];
                    break;
                case kMoveTypeFollowPlayer:
                    [s moveFollowPlayerWithY:moveY];
                    break;
                case kMoveTypeStepUp:
                    [s moveStepUpWithY:moveY];
                    break;
                case kMoveTypeStepDown:
                    [s moveStepDownWithY:moveY];
                    break;
                case kMoveTypeSplitDiagonalUp:
                    [s moveSplitDiagonalUpWithY:moveY];
                    break;
                case kMoveTypeSplitDiagonalDown:
                    [s moveSplitDiagonalDownWithY:moveY];
                    break;
                default:
                    break;
            }
            
            //add to array.
            [_ships addObject:s];
            
        }
        
        
        
    }
    
    return self;
}






-(void)addShips { ////////// call after adding ships to an nsarray.
    if (shipNum < numShips) {
        Ship *s = [_ships objectAtIndex:shipNum];
        [parent_ addChild:s z:kZShips];
        shipNum = shipNum + 1;
        id delay = [CCDelayTime actionWithDuration:shipDelay];
        id delaydone = [CCCallFunc actionWithTarget:self selector:@selector(addShips)];
        [self runAction:[CCSequence actions:delay, delaydone, nil]];
    }
    else {
        [self removeSelf];
    }
}

-(void)removeSelf {
    [parent_ removeChild:self cleanup:YES];
}


-(void)dealloc {
    _ships = nil;
    [_ships release];
    
    [super dealloc];
}

@end
