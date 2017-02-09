//
//  EnemyList.m
//  ShootEmUp
//
//  Created by Justin Fletcher on 9/13/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import "EnemyList.h"



@implementation StaticEnemy

@synthesize enemyType, xPos;

-(id)init {
    if ((self = [super init])) {
        
    }
    return self;
}

-(void)dealloc {
    [super dealloc];
}

@end





@implementation EnemyList

-(void)addEnemy:(int)enemy {
    NSNumber *n = [NSNumber numberWithInt:enemy];
    [self addObject:n];
}

-(void)addStaticEnemy:(int)enemy atX:(int)x {
    StaticEnemy *s = [[[StaticEnemy alloc] init] autorelease];
    s.enemyType = enemy;
    s.xPos = x;
    [self addObject:s];
}

@end
