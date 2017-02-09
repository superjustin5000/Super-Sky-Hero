//
//  Explode.m
//  ShootEmUp
//
//  Created by Justin Fletcher on 8/13/12.
//  Copyright 2012 Happy Fox. All rights reserved.
//

#import "Explode.h"

static CCArray *_explosions;




@implementation Explode

+(CCArray*)getExplosions {
    if (_explosions == NULL)
        _explosions = [[CCArray alloc] init];
    return _explosions;
}



+(id)ExplodeWithType:(int)eType {
    return [[[self alloc] initWithType:eType] autorelease];
}

-(id)initWithType:(int)eType {
    
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"bulletHitPlayer1.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"bulletHitEnemy1.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"player_punchPilot1.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"player_punchPilot2.wav"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"player_punchPilot3.wav"];
    
    gs = [GameState sharedGameState];
    
    NSString *spriteFrameName;
    NSMutableArray *animFrames = [NSMutableArray array];
    
    switch (eType) {
        case kExplodePlayerNormal:
            spriteFrameName = @"explode_player_normal1.png";
            animFrames = [gs framesWithFrameName:@"explode_player_normal" fromFrame:1 toFrame:4];
            animDelay = 0.1f;
            [[SimpleAudioEngine sharedEngine] playEffect:@"bulletHitPlayer1.wav"];
            break;
        case kExplodeBlueEnergy:
            spriteFrameName = @"blueEnergy1.png";
            animFrames = [gs framesWithFrameName:@"blueEnergy" fromFrame:1 toFrame:7];
            animDelay = 0.04f;
            break;
        case kExplode1:
            spriteFrameName = @"explode11.png";
            animFrames = [gs framesWithFrameName:@"explode1" fromFrame:1 toFrame:4];
            animDelay = 0.05f;
            [[SimpleAudioEngine sharedEngine] playEffect:@"bulletHitEnemy1.wav"];
            break;
        case kExplode2:
            spriteFrameName = @"Explode21.png";
            animFrames = [gs framesWithFrameName:@"Explode2" fromFrame:1 toFrame:5];
            animDelay = 0.04f;
            break;
        case kExplode3:
            spriteFrameName = @"Explode31.png";
            animFrames = [gs framesWithFrameName:@"Explode3" fromFrame:1 toFrame:4];
            animDelay = 0.05f;
            [[SimpleAudioEngine sharedEngine] playEffect:@"bulletHitEnemy1.wav"];
            break;
        case kExplodeWalkingEnemyBurst:
            spriteFrameName = @"walkingEnemyBurst1.png";
            animFrames = [gs framesWithFrameName:@"walkingEnemyBurst" fromFrame:1 toFrame:4];
            animDelay = 0.05f;
            break;
            
            
        case kExplodeFigthingPilotHitBurst:
            spriteFrameName = @"fightingPilotHitBurst1.png";
            animFrames = [gs framesWithFrameName:@"fightingPilotHitBurst" fromFrame:1 toFrame:4];
            animDelay = 0.05f;
            break;
        
        case kExplodeBlood1:
            spriteFrameName = @"bloodShot1_1.png";
            animFrames = [gs framesWithFrameName:@"bloodShot1_" fromFrame:1 toFrame:4];
            animDelay = 0.05f;
            break;
            
        default:
            break;
    }
    
    
    
    if ((self = [super initWithSpriteFrameName:spriteFrameName])) {
        explodeAnim = [[CCAnimation alloc] initWithSpriteFrames:animFrames delay:animDelay];
        
        canCollide = NO;
        
        [_explosions addObject:self];
    }
    
    return self;
    
}

-(void)explode {
    CCAnimate *animate = [CCAnimate actionWithAnimation:explodeAnim];
    id animdone = [CCCallFunc actionWithTarget:self selector:@selector(explodeDone)];
    [self runAction:[CCSequence actions:animate, animdone, nil]];
}
-(void)explodeDone {
    [self kill];
    [_explosions removeObject:self];
    [self removeFromParentAndCleanup:YES];;
}


-(void)dealloc {
    [explodeAnim release];
    explodeAnim = nil;
    
    [super dealloc];
}

@end
