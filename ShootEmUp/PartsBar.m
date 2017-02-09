//
//  PartsBar.m
//  ShootEmUp
//
//  Created by Justin Fletcher on 5/30/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import "PartsBar.h"
#import "ScreenText.h"

static PartsBar *partsBar;

@implementation PartsBar


+(PartsBar*)getPartsBar {
    return partsBar;
}

-(id)init {
    if ((self = [super init])) {
        
        partsBar = self;
        
        CCSprite *partsIcon = [CCSprite spriteWithFile:@"powerIcon.png"];
        partsIcon.anchorPoint = ccp(0,1);
        partsIcon.position = ccp(27, gs.winSize.height - 28);
        partsIcon.scale = .75;
        [self addChild:partsIcon];
        [partsIcon.texture setAliasTexParameters];
        
        CCSprite *partsBarMeterBg = [CCSprite spriteWithFile:@"healthBarOuter.png"];
        partsBarMeterBg.anchorPoint = ccp(0,1);
        partsBarMeterBg.position = ccp(partsIcon.position.x + partsIcon.contentSize.width + 3, gs.winSize.height - 31);
        partsBarMeterBg.opacity = 100;
        
        partsBarMeterBg.scale = 0.3;
        
        partsBarMeter = [CCSprite spriteWithFile:@"healthBarRedToYellow.png"];
        partsBarMeter.anchorPoint = ccp(0,0);
        partsBarMeter.position = ccp(0,0);
        partsBarMeter.opacity = 200;
        
        [self addParts:0];
        
        
        [partsBarMeterBg addChild:partsBarMeter];
        
        [self addChild:partsBarMeterBg];
        
        
    }
    return self;
}

-(void)addParts:(int)type {
    ///how much exp to reach each level.
    int partsLevel1 = 25; ///25 to get to level 1.
    int partsLevel2 = 100;
    int partsLevel3 = 600;
    
    int partsMeterBottom;
    int partsMeterTop;
    
    switch (gs.playerShipLevel) { ////find bottom and top ranges for exp.
        case 0:
            partsMeterBottom = 0;
            partsMeterTop = partsLevel1;
            break;
        case 1:
            partsMeterBottom = partsLevel1;
            partsMeterTop = partsLevel2;
            break;
        case 2:
            partsMeterBottom = partsLevel2;
            partsMeterTop = partsLevel3;
            break;
            
            
        default:
            break;
    }
    
    ///add exp.
    if (gs.playerShipExp < partsMeterBottom) gs.playerShipExp = partsMeterBottom; ///make sure the players exp isn't lower than it should be for whatever reason. TESTING probaably.
    gs.playerShipExp += type;
    
    ///change the meter according to exp.
    float partsRangeMax = partsMeterTop - partsMeterBottom;
    float partsRangeCur = gs.playerShipExp - partsMeterBottom;
    float ratio = partsRangeCur / partsRangeMax;
    partsBarMeter.scaleX = ratio;
    
    if (gs.playerShipExp >= partsMeterTop) {  ///if you surpass max, level up.
        gs.playerShipLevel += 1;
        [self addParts:0]; ///so this method gets called again.
        [ScreenText textWithString:@"POWER UP!" andColor:ccc3(255, 255, 255) andSecondColor:ccc3(255, 100, 100)];
    }
}



-(void)update:(ccTime)delta {
    
        
}

-(void)dealloc {
    [super dealloc];
}

@end
