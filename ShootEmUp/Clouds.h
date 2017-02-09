//
//  CloudsFront.h
//  ThisShipWillSelfDestruct
//
//  Created by Justin Fletcher on 5/31/12.
//  Copyright 2012 Happy Fox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Clouds : CCNode {
    
    GameState *gs;
    
    float cloudSpeed;
    float cloudTime;
    float spawnCloudTime;
    float cloudNum;
    float startingCloudNum;
    
    int fromY;
    int toY;
    
}

@property(nonatomic)float cloudSpeed;
@property(nonatomic)float spawnCloudTime;
@property(nonatomic)int fromY;
@property(nonatomic)int toY;

-(void)addCloud;

@end
