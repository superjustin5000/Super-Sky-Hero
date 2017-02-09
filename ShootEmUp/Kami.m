//
//  Kami.m
//  ShootEmUp
//
//  Created by Justin Fletcher on 11/28/12.
//  Copyright 2012 Happy Fox. All rights reserved.
//

#import "Kami.h"
#import "Bullet.h"

@implementation Kami

-(id)init {
    
    if ((self = [super initWithFileName:@"kami.png" startingHealth:1 jumpPos:CGPointMake(0, 0) speed:CGPointMake(kShipSpeedDouble, 3) shootTime:0])) {
        
        shipDownTexture = [[CCTextureCache sharedTextureCache] addImage:@"kami_down.png"];
        shipUpTexture = [[CCTextureCache sharedTextureCache] addImage:@"kami_up.png"];
        
        canHavePlayer = NO;
        
        EngineFlame *flame = [EngineFlame flameWithType:kengineFlameSmallRed];
        flame.position = ccp(self.contentSize.width/2 + 8, self.contentSize.height/2);
        flame.rotation = -90;
        [self addChild:flame z:self.zOrder - 1];
        
        
        
    }
    
    return self;
    
    
}

-(void)player:(ccTime)dt {
    
    self.scaleX = -1.0;
    
}



-(void)dealloc {
    [super dealloc];
}


@end




@implementation Kami2

-(id)init {
    
    if ((self = [super initWithFileName:@"kami2.png" startingHealth:3 jumpPos:CGPointMake(0, 0) speed:CGPointMake(kShipSpeedNormal, 3) shootTime:2])) {
        
        
        
        
    }
    
    return self;
    
    
}

-(void)player:(ccTime)dt {
    
    self.scaleX = -1.0;
    
}

-(void)shootWithDirection:(int)direction Type:(int)type Ship:(Ship *)ship {
    Bullet *b = [Bullet bulletWithFile:@"bullet_big.png" Power:5 Velocity:CGPointMake(3, 0) Direction:direction Movement:kbulletMoveHoming Type:type Origin:ship ExplodeType:kExplode1];
    b.position = ccp(self.position.x - self.contentSize.width/2 + 5, self.position.y);
    [parent_ addChild:b];
}

-(void)dealloc {
    [super dealloc];
}


@end