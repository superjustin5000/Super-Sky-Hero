//
//  LevelStats.m
//  ShootEmUp
//
//  Created by Justin Fletcher on 12/28/12.
//  Copyright 2012 Happy Fox. All rights reserved.
//

#import "LevelStats.h"

#import "Level1.h"
#import "Level2.h"
#import "Level3.h"
#import "Level4.h"
#import "Level5.h"
#import "Level6.h"
#import "Level7.h"


@implementation LevelStats

+(id)levelStatsWithNextLevelNum:(int)ln {
    return [[[self alloc] initStatsWithNextLevelNum:ln] autorelease];
}
+(id)levelRetryWithNextLevelNum:(int)ln {
    return [[[self alloc] initRetryWithNextLevelNum:ln] autorelease];
}

-(id)initRetryWithNextLevelNum:(int)ln {
    if (( self = [super init])) {
        
        nextLevelNum = ln;
        
    }
    return self;
}


-(id)initStatsWithNextLevelNum:(int)ln {
    if ((self = [super init])) {
        nextLevelNum = ln;
    }
    return self;
}





-(void)startNextLevel {
    
    switch (nextLevelNum) {
        case 1:
            nextLevelScene = [Level1 sceneWithHud];
            break;
        case 2:
            nextLevelScene = [Level2 sceneWithHud];
            break;
        case 3:
            nextLevelScene = [Level3 sceneWithHud];
            break;
        case 4:
            nextLevelScene = [Level4 sceneWithHud];
            break;
        case 5:
            nextLevelScene = [Level5 sceneWithHud];
            break;
        case 6:
            nextLevelScene = [Level6 sceneWithHud];
            break;
        case 7:
            nextLevelScene = [Level7 sceneWithHud];
            break;
        default:
            break;
    }
    
    [[CCDirector sharedDirector] replaceScene:nextLevelScene];
    
}



-(void)dealloc {
    [super dealloc];
}

@end
