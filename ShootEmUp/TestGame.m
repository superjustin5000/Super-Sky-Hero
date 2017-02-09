//
//  TestGame.m
//  ThisShipWillSelfDestruct
//
//  Created by Justin Fletcher on 5/27/12.
//  Copyright 2012 Happy Fox. All rights reserved.
//

#import "TestGame.h"

#import "Kamcord/Kamcord.h"


#import "ShipGroup.h"
#import "Mech1.h"
#import "Missile1.h"
#import "Turret1.h"
#import "Cruiser1_1.h"
#import "Carrier.h"
#import "Bomber1.h"
#import "GroundTurret.h"
#import "EnemyFlyingSaucer.h"

@implementation TestGame



-(id)init {
    
    if ((self = [super initWithNumber:0 DelayStart:0])) {
        
        
        
        /*
        Bomber1 *b = [Bomber1 ship];
        [b moveRightToLeftWithY:y_3_2];
        [self addChild:b z:kZShips];
        */
         
        
        PowerUp *p = [PowerUp powerUpWithType:kPowerupHoming];
        p.position = ccp(gs.winSize.width, y_4_3);
        [self addChild:p];
        
        
        
        Cruiser1_Test *c = [Cruiser1_Test ship];
        //c = (Cruiser1*)c;
        //c.position = ccp(gs.winSize.width + c.contentSize.width/2 + 20, 160);
        [self addChild:c];
        
        
        
        /*
        Carrier1 *c = [Carrier1 floatingMassWithY:y_2];
        [self addChild:c z:kZShips];
        [c addTurretWithX:c.position.x UpSideDown:NO];
        [c addTurretWithX:c.position.x UpSideDown:YES];
        */
        
        
        /*
        Missile1 *m = [Missile1 destructable];
        m.position = ccp(300, 160);
        [self addChild:m];
        
        Turret1 *t = [Turret1 ship];
        t.position = ccp(300, 230);
        [self addChild:t z:kZShips];
        
        */
        
        /*
        EnemyFlyingSaucer *e = [EnemyFlyingSaucer enemyWithLeftWall:0 RightWall:gs.winSize.width];
        e.position = ccp(gs.winSize.width - 200, gs.winSize.height/2 + 80);
        [self addChild:e z:kZPlayer];
        [e schedule:@selector(updateEnemy:)];
        */
        
        ////// CHANGE CLOUDS TO STATIC IMAGE INSTEAD OF PROCEDURAL
        
        //Clouds *clouds = [Clouds node];
        //[self addChild:clouds];
        
    }
    
    return self;
    
}



-(void)levelTime:(ccTime)time {
    /*
    if (time == 3) {
        ShipGroup *s = [ShipGroup groupWithShipType:kShipTypeFighter numShips:2 movement:kMoveTypeCornerToCorner31 y:100 delay:1];
        [self addChild:s];
    }
     */
    
    
    if (time == 2) {
        //[Kamcord startRecording];
        
    }
    else if (time == 10) {
        
        [Kamcord stopRecording];
        [Kamcord showView];
    }
    
    else if (time == 30) {
    }
    
}





-(void)dealloc {
    [super dealloc];
}

@end
