//
//  EnemyPilot.h
//  ShootEmUp
//
//  Created by Justin Fletcher on 5/6/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface EnemyPilot : JSprite {
    int difficulty;
}
+(EnemyPilot*)getPilot;
+(id)pilot;

-(void)hit;

-(void)destroyPilot;
@end
