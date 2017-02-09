//
//  PlayerShip.m
//  ThisShipWillSelfDestruct
//
//  Created by Justin Fletcher on 5/28/12.
//  Copyright 2012 Happy Fox. All rights reserved.
//

#import "PlayerShip.h"

#import "Bullet.h"
#import "Player.h"

#import "SimpleAudioEngine.h"


@implementation PlayerShip

@synthesize didCrash;


-(id)init {
    
    if ((self = [super initWithFileName:@"pship.png" startingHealth:100 jumpPos:ccp(10, 0) speed:CGPointMake(2.5, 3) shootTime:1])) {
        
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"shootPlayer1.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"bulletHitPlayer1.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"shipEngineNormal.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"shipEngineHigh.wav"];
        
        /////some ship texture stuff.
        shipDownTexture = [[CCTextureCache sharedTextureCache] addImage:@"pshipdown.png"];
        shipUpTexture = [[CCTextureCache sharedTextureCache] addImage:@"pshipup.png"];
        
        
        flame = [EngineFlame flameWithType:kengineFlameSmallBlue];
        flame.position = ccp(0, 8);
        [self addChild:flame z:self.zOrder - 1];
        
        gs.playerShipLevel = 1;
        
        
        //drawRects = YES;
        
    }
    
    return self;
}





-(CGRect)newSpriteRect { ///trying to make the collision rect for the ship a bit smaller to give the player the benefit of the doubt.
    int topbottom = 10;
    int leftright = 4;
    int yShift = 0;
    if (upTime) yShift = 5;
    else if (downTime) yShift = -2;
    return CGRectMake(self.position.x - self.contentSize.width/2 + leftright, self.position.y - self.contentSize.height/2 + topbottom + yShift, self.contentSize.width-(leftright*2), self.contentSize.height-(topbottom*2));
}



-(void)bigFlame {
    flame.position = ccp(-2, 8);
    flame.scale = 1.5;
    
}

-(void)smallFlame {
    flame.position = ccp(2, 8);
    flame.scale = 1;
}

-(void)normalFlame {
    flame.position = ccp(0, 8);
    flame.scale = 1;
}

-(void)bigSound {
    [[SimpleAudioEngine sharedEngine] stopEffect:engineSound];
    engineSound = [[SimpleAudioEngine sharedEngine] playEffect:@"shipEngineHigh.wav" loop:NO];
}
-(void)smallSound {
    [[SimpleAudioEngine sharedEngine] stopEffect:engineSound];
    engineSound = [[SimpleAudioEngine sharedEngine] playEffect:@"shipEngineNormal.wav" pitch:1 pan:0.5 gain:0.05f loop:YES];
}
-(void)normalSound {
    [[SimpleAudioEngine sharedEngine] stopEffect:engineSound];
    engineSound = [[SimpleAudioEngine sharedEngine] playEffect:@"shipEngineNormal.wav" pitch:1 pan:0.5 gain:0.05f loop:YES];
}


-(void)noFlame {
    flame.opacity = 0;
    [[SimpleAudioEngine sharedEngine] stopEffect:engineSound];
}

-(void)player:(ccTime)dt {
    
    if ([JPad getPad].touchLeft) { ///////// ############## TOUCHING LEFT AND RIGHT MAKES THE SHIPS FLAME MOVE
        [self smallFlame];
    }
    else if ([JPad getPad].touchRight) {
        [self bigFlame];
    }
    else {
        [self normalFlame];
    }
    
    /* ////this makes the ship speed up when holding A
    if ([JPad getPad].touchA) {
        if (!isCrashing) {
            [self setVelocity:ccp(3.7, 3.5)];
        }
    }
    else {
        [self setVelocity:ccp(2.5, 3)];
    }
     */
}






-(void)shootWithDirection:(int)direction Type:(int)type Ship:(Ship *)ship {
    //AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    if (gs.playerShipLevel == 0) {
        Bullet* bullet = [Bullet bulletWithFile:@"normal_white.png" Power:1 Velocity:CGPointMake(5, 0) Direction:direction Movement:kbulletMoveStraight Type:type Origin:ship ExplodeType:kExplodePlayerNormal];
        [parent_ addChild:bullet];
        bullet.position = ccp(self.position.x + 25, self.position.y - 4);
        [[SimpleAudioEngine sharedEngine] playEffect:@"shootPlayer1.wav"];
    }
    else if (gs.playerShipLevel == 1) {
        Bullet* bullet = [Bullet bulletWithFile:@"normal_white.png" Power:1 Velocity:CGPointMake(5, 0) Direction:direction Movement:kbulletMoveStraight Type:type Origin:ship ExplodeType:kExplodePlayerNormal];
        [parent_ addChild:bullet];
        bullet.position = ccp(self.position.x + 25, self.position.y - 1);
        
        Bullet* bullet1 = [Bullet bulletWithFile:@"normal_white.png" Power:1 Velocity:CGPointMake(5, 0) Direction:direction Movement:kbulletMoveStraight Type:type Origin:ship ExplodeType:kExplodePlayerNormal];
        [parent_ addChild:bullet1];
        bullet1.position = ccp(self.position.x + 25, self.position.y - 7);
        
        [[SimpleAudioEngine sharedEngine] playEffect:@"shootPlayer1.wav"];
    }
    else {
        Bullet* bullet = [Bullet bulletWithFile:@"normal_white.png" Power:1 Velocity:CGPointMake(5, 0) Direction:direction Movement:kbulletMoveStraight Type:type Origin:ship ExplodeType:kExplodePlayerNormal];
        [parent_ addChild:bullet];
        bullet.position = ccp(self.position.x + 25, self.position.y - 1);
        
        Bullet* bullet1 = [Bullet bulletWithFile:@"normal_white.png" Power:1 Velocity:CGPointMake(5, 0) Direction:direction Movement:kbulletMoveStraight Type:type Origin:ship ExplodeType:kExplodePlayerNormal];
        [parent_ addChild:bullet1];
        bullet1.position = ccp(self.position.x + 25, self.position.y - 7);
        
        [[SimpleAudioEngine sharedEngine] playEffect:@"shootPlayer1.wav"];
    }
    
}






-(void)dealloc {
    [super dealloc];
}

@end
