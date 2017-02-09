//
//  Bomber1.m
//  ShootEmUp
//
//  Created by Justin Fletcher on 9/23/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import "Bomber1.h"
#import "EngineSmoke.h"
#import "Bullet.h"


@implementation Bomber1

-(id)init {
    if ((self = [super initWithFileName:@"bomber1.png" startingHealth:5 jumpPos:ccp(0,0) speed:ccp(kShipSpeedNormal, kShipSpeedNormal) shootTime:0.7f])) {
        //self.scale = 1.5;
        //drawRects = YES;
        
        f1 = [CCSprite spriteWithFile:@"EngineFlameCruiserSmall.png"];
        f1.position = ccp(self.contentSize.width/2, -f1.contentSize.height/2 + 4);
        f1.scale = 1.5;
        f1.opacity = 200;
        [self addChild:f1 z:self.zOrder-1];
        
        EngineSmoke *e = [EngineSmoke smokeWithPosition:ccp(0, -20) Intensity:.2 Direction:kdirectionDown Distance:20 Time:1];
        [self addChild:e];
        //[e start];
        
        [self schedule:@selector(flashFlames:) interval:0.02];
        
    }
    return self;
}

-(void)player:(ccTime)dt {
    if ([JPad getPad].touchDown) {
        f1.position = ccp(self.contentSize.width/2, -f1.contentSize.height/2 + 6);
    }
    else if ([JPad getPad].touchUp) {
        f1.position = ccp(self.contentSize.width/2, -f1.contentSize.height/2 + 2);
    }
    else {
        f1.position = ccp(self.contentSize.width/2, -f1.contentSize.height/2 + 4);
    }
}

-(void)flashFlames:(ccTime)dt {
    if (f1.opacity == 200) {
        f1.opacity = 0;
    }
    else if (f1.opacity == 0) {
        f1.opacity = 200;
    }
}


-(void)shootWithDirection:(int)direction Type:(int)type Ship:(Ship *)ship {
    Bullet *b1 = [Bullet bulletWithSpriteFrameName:@"bomberBomb1.png" Power:5 Velocity:ccp(0,-1) Direction:direction Movement:kbulletMoveStraight Type:type Origin:ship ExplodeType:kExplode1];
    b1.position = ccp(self.position.x, self.position.y - self.contentSize.height/2);
    [parent_ addChild:b1];
    [b1 setAnimationWithFrameName:@"bomberBomb" fromFrame:1 toFrame:3 withReverse:YES andRepeat:YES];
}


-(void)dealloc {
    [super dealloc];
}

@end
