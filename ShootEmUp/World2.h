//
//  World2.h
//  ShootEmUp
//
//  Created by Justin Fletcher on 5/21/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Level.h"
@interface World2 : Level {
    
    float barTimer;
    float barTime;
    
}

-(void)updateWorld:(ccTime)dt;

@end
