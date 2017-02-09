//
//  EnemyList.h
//  ShootEmUp
//
//  Created by Justin Fletcher on 9/13/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface StaticEnemy : NSObject {
    
}
@property(nonatomic)int enemyType;
@property(nonatomic)int xPos;
@end

@interface EnemyList : CCArray {
    
}

-(void)addEnemy:(int)enemy;
-(void)addStaticEnemy:(int)enemy atX:(int)x;
@end
