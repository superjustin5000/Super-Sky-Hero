//
//  EngineSmoke.m
//  ShootEmUp
//
//  Created by Justin Fletcher on 7/18/12.
//  Copyright 2012 Happy Fox. All rights reserved.
//

#import "EngineSmoke.h"

#import "Ship.h"


@implementation EngineSmoke

@synthesize intensity;
@synthesize direction;
@synthesize distance;
@synthesize duration;

+(id)smokeWithPosition:(CGPoint)pos Intensity:(float)iLevel Direction:(int)facing Distance:(int)length Time:(float)time {
    return [[[self alloc] initWithPosition:pos Intensity:iLevel Direction:facing Distance:length Time:time] autorelease];
}


-(id)initWithPosition:(CGPoint)pos Intensity:(float)iLevel Direction:(int)facing Distance:(int)length Time:(float)time {
    if ((self = [super init])) {
        
        position = pos;     //location relative to center of parent.
        intensity = iLevel; //higher intensity = more smoke particles per second.
        direction = facing; //direction smoke travels.
        distance = length;  //how far smoke travels.
        duration = time;    //lifespan of smoke particle.
        
    }
    
    return self;
}

-(void)start {
    if (!isOn) {
        isOn = YES;
        [self schedule:@selector(update:) interval:(1/(30*intensity))];
    }
}
-(void)stop {
    if (isOn) {
        isOn = NO;
        [self unschedule:@selector(update:)];
    }
}


-(void)update:(ccTime)dt {
    smokeParticle *smoke = [smokeParticle spriteWithFile:@"smokeParticle.png"];
    
    
    float randomX = [[GameState sharedGameState] randomNumberFrom:0 To:4] + [[GameState sharedGameState] random0to1withDeviation:0];
    if ([[GameState sharedGameState] random0to1withDeviation:0] >= 0.5) { randomX = -randomX; }
    
    CGPoint parentPos = CGPointMake(parent_.position.x + ([parent_ scaleX] * position.x), parent_.position.y + ([parent_ scaleY] * position.y));
    
    smoke.position = ccp(parentPos.x+randomX, parentPos.y);
    
    if (direction == kdirectionLeft || direction == kdirectionRight) {
        smoke.position = ccp(parentPos.x, parentPos.y+randomX);
    }
    
    smoke.scale = 1.8;
    smoke.opacity = 200;
    
    
    [[parent_ parent] addChild:smoke z:[parent_ zOrder] + 1];
    
    float moveX = -randomX;
    float moveY = -distance;
    
    if (direction == kdirectionUp) {
        moveY = -moveY;
    }
    else if (direction == kdirectionLeft) {
        float temp = moveY;
        moveY = moveX;
        moveX = temp;
    }
    else if (direction == kdirectionRight) {
        float temp = -moveY;
        moveY = moveX;
        moveX = temp;
    }
    else if (direction == kdirectionDown) {
        
    }
        
    id move = [CCMoveBy actionWithDuration:duration position:ccp(moveX, moveY)];
    [smoke runAction:move];
    
    id fadeout = [CCFadeTo actionWithDuration:duration opacity:0];
    [smoke runAction:fadeout];
    
    id scaledown = [CCScaleTo actionWithDuration:duration scale:0.5];
    [smoke runAction:scaledown];
}



-(void)dealloc {
    [super dealloc];
}

@end






@implementation smokeParticle

-(id)initWithTexture:(CCTexture2D *)texture rect:(CGRect)rect {
    if ((self = [super initWithTexture:texture rect:rect])) {
        [self scheduleUpdate];
    }
    return self;
}

-(void)update:(ccTime)delta {
    if ([self opacity] <= 0 || self.position.x < 0-self.contentSize.width/2) {
        [self removeFromParentAndCleanup:YES];
    }
}

-(void)dealloc {
    [super dealloc];
}
@end

