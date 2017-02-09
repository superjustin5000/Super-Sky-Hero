//
//  SpawnPoint.m
//  ShootEmUp
//
//  Created by Justin Fletcher on 3/30/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import "SpawnSwitch.h"

static CCArray *_switches;

@implementation SpawnSwitch

@synthesize spawnFloor, spawnMinX, spawnMaxX;

@synthesize height;
@synthesize switchType, isActivated, spawnList;


+(CCArray*)getSwitches {
    if (_switches) {
        return _switches;
    }
    _switches = [[CCArray alloc] init];
    return _switches;
}
+(void)addToSwitches:(SpawnSwitch*)s {
    if (_switches) {
        [_switches addObject:s];
    } else {
        _switches = [[CCArray alloc] init];
        [_switches addObject:s];
    }
}



+(id)startWithSpawnList:(EnemyList *)slist SpawnFloor:(int)sfloor SpawnMinX:(int)sminx SpawnMaxX:(int)smaxx {
    return [[[self alloc] initWithSwitchType:1 SpawnList:slist SpawnFloor:sfloor SpawnMinX:sminx SpawnMaxX:smaxx] autorelease];
}
+(id)stop {
    EnemyList *slist = [[[EnemyList alloc] init] autorelease];
    return [[[self alloc] initWithSwitchType:2 SpawnList:slist SpawnFloor:0 SpawnMinX:0 SpawnMaxX:0] autorelease];
}

-(id)initWithSwitchType:(int)stype SpawnList:(EnemyList *)slist SpawnFloor:(int)sfloor SpawnMinX:(int)sminx SpawnMaxX:(int)smaxx {
    if ((self = [super init])) {
        
        gs = [GameState sharedGameState];
        
        
        self.spawnFloor = sfloor;
        self.spawnMinX = sminx;
        self.spawnMaxX = smaxx;
        
        height = 10;
        
        switchType = stype;
        spawnList = [[EnemyList alloc] initWithArray:slist];
        NSLog(@"list size = %i", [spawnList count]);
        
        [self scheduleUpdate];
        
        [SpawnSwitch addToSwitches:self];
        
    }
    
    return self;
}


-(void)removeSwitch {
    [_switches removeObject:self];
    [self removeFromParentAndCleanup:YES];
}


-(void)update:(ccTime)delta {
    if (!isActivated) {
    
        switchRect = CGRectMake(self.position.x - 5, self.position.y, height, height);
        BOOL intersectsWithPlayer = CGRectIntersectsRect(gs.player.spriteRect, switchRect);
        BOOL playerPassed = gs.player.position.x >= self.position.x;
        
        if (intersectsWithPlayer || playerPassed) {
            isActivated = YES;
        }
        
    }
}



-(void)dealloc {
    [spawnList release];
    spawnList = nil;
    
    [super dealloc];
}

@end
