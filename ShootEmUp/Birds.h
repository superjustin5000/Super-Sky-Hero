//
//  Birds.h
//  ShootEmUp
//
//  Created by Justin Fletcher on 9/10/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Birds : JSprite {
    BOOL fly;
    JSprite *birdGround;
}
@property(nonatomic,retain)JSprite* birdGround;
+(CCArray*)getBirds;
+(void)addBird:(Birds*)b;
+(id)birds;

-(void)fly;

@end


@interface BirdGroup : CCNode {
    
}

+(id)groupWithNumberOfBirds:(int)n andPos:(CGPoint)pos andParent:(CCNode*)p;
+(id)groupWithRandomNumberOfBirdsAndPos:(CGPoint)pos andParent:(CCNode*)p;

+(id)groupWithNumberOfBirds:(int)n andPos:(CGPoint)pos andParent:(CCNode*)p andGround:(JSprite*)g;
+(id)groupWithRandomNumberOfBirdsAndPos:(CGPoint)pos andParent:(CCNode*)p andGround:(JSprite*)g;

-(id)initWithNumberOfBirds:(int)n andPos:(CGPoint)pos andParent:(CCNode*)p andGround:(JSprite*)g;

@end