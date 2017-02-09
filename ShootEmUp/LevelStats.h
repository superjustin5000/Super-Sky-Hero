//
//  LevelStats.h
//  ShootEmUp
//
//  Created by Justin Fletcher on 12/28/12.
//  Copyright 2012 Happy Fox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface LevelStats : CCLayer {
    CCScene *nextLevelScene;
    int nextLevelNum;
}

+(id)levelStatsWithNextLevelNum:(int)ln;
+(id)levelRetryWithNextLevelNum:(int)ln;
-(id)initStatsWithNextLevelNum:(int)ln;
-(id)initRetryWithNextLevelNum:(int)ln;

-(void)startNextLevel;

@end
