//
//  Fighter.m
//  ShootEmUp
//
//  Created by Justin Fletcher on 12/20/12.
//  Copyright 2012 Happy Fox. All rights reserved.
//

#import "Fighter.h"
#import "Bullet.h"

@implementation Fighter1

-(id)init {
    if ((self = [super initWithFileName:@"fighter1.png" startingHealth:2 jumpPos:ccp(0,0) speed:CGPointMake(kShipSpeedNormal, 3) shootTime:2])) {
        
        shipDownTexture = [[CCTextureCache sharedTextureCache] addImage:@"fighter1_down.png"];
        shipUpTexture = [[CCTextureCache sharedTextureCache] addImage:@"fighter1_up.png"];
        
        canHavePlayer = NO;
        
    }
    
    return self;
}

-(void)player:(ccTime)dt {
    
    self.scaleX = -1.0;
    
    //smoke.distance = -40;
    
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
