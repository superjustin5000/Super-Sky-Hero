//
//  Rescue.m
//  ShootEmUp
//
//  Created by Justin Fletcher on 9/16/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import "Rescue.h"

#import "Player.h"
#import "ScreenText.h"

@implementation Rescue

+(id)rescueWithType:(int)type {
    return [[[self alloc] initWithType:type] autorelease];
}

-(id)initWithType:(int)type {
    
    NSString *frameName;
    NSString *animFrameName;
    
    switch (type) {
        case krescue_male1:
            animFrameName = @"rescueM1_";
            break;
        case krescue_female1:
            break;
            
        default:
            break;
    }
    
    frameName = [animFrameName stringByAppendingString:@"1.png"];
    
    if ((self = [super initWithSpriteFrameName:frameName])) {
        
        if (random() % 2 == 0) self.scaleX = -1;
        
        NSArray *frames = [gs framesWithFrameName:animFrameName fromFrame:1 toFrame:4 andReverse:YES andAntiAlias:NO];
        baseAnim = [CCAnimation animationWithSpriteFrames:frames delay:0.08];
        [self runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:baseAnim]]];
        
        light = NULL;
        
        [self scheduleUpdate];
        
    }
    
    return self;
    
}

-(void)rescued {
    //////turn self invisible.
    self.opacity = 0;
    canCollide = NO; ///so this doesn't run again.
    
    ////add the rescue text.
    [ScreenText textWithString:@"SAVED!" andColor:ccc3(255, 255, 255) andSecondColor:ccc3(100, 100, 255)];
    
    
    ////create the light flash on the sprite.
    light = [CCSprite spriteWithSpriteFrameName:@"rescueLight1.png"];
    light.position = ccp(self.position.x, self.position.y - self.contentSize.height/2 + light.contentSize.height/2);
    [parent_ addChild:light];
    
    void (^removeLight) (void) = ^{
        [light removeFromParentAndCleanup:YES]; ////remove the light.
        [self removeFromParentAndCleanup:YES];  ////remove the rescue.
    };
    
    NSArray *f = [gs framesWithFrameName:@"rescueLight" fromFrame:1 toFrame:5];
    CCAnimation *a = [CCAnimation animationWithSpriteFrames:f delay:0.1f];
    id animate = [CCAnimate actionWithAnimation:a];
    id callblock = [CCCallBlock actionWithBlock:removeLight];
    
    [light runAction:[CCSequence actionOne:animate two:callblock]];
}

-(void)didCollideWith:(JSprite *)sprite {
    Player *player = (Player*)gs.player;
    if (sprite == player) {
        [self rescued];
    }
}


-(void)update:(ccTime)delta {
    self.position = ccp(self.position.x - velocity.x, self.position.y - velocity.y);
    
    if (light != NULL)
        light.position = ccp(light.position.x - velocity.x, light.position.y - velocity.y);
}



-(void)dealloc {
    [super dealloc];
}

@end
