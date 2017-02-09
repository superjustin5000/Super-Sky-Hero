//
//  Carrier.m
//  ShootEmUp
//
//  Created by Justin Fletcher on 9/2/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import "Carrier.h"
#import "Player.h"

#import "Rescue.h"
#import "Birds.h"
#import "GroundTurret.h"

@implementation Carrier

-(id)initWithFileName:(NSString*)filename andY:(int)y {
    if ((self = [super initWithFileName:filename Invincibility:YES Y:y])) {
        
        _flames = [[CCArray alloc] init];
        [self schedule:@selector(flashFlames:) interval:0.02];
        
        ground = [WallFlying wallWithWidth:self.contentSize.width Height:10 Position:ccp(self.contentSize.width/2, 9)];
        [self addChild:ground];
        
        
        
        
        ////// 50 50 chance of birds.
        if (random() % 2 == 0) {
            int birdX = [gs randomNumberFrom:self.position.x - self.contentSize.width/2 + 10 To:self.position.x + self.contentSize.width/2 - 10];
            CGPoint birdPos = ccp(birdX, self.position.y - self.contentSize.height/2 + 15);
            [BirdGroup groupWithRandomNumberOfBirdsAndPos:birdPos andParent:gs.gameScene.curLevel andGround:self];
        }
        
        
        
        [self scheduleUpdate];
        
    }
    return self;
}



-(CGRect)newSpriteRect {
    spriteRect = CGRectMake(self.position.x - self.contentSize.width/2, self.position.y - self.contentSize.height/2 + 3, self.contentSize.width, 11);
    return spriteRect;
}

-(void)flashFlames:(ccTime)dt {
    CCSprite *f;
    CCARRAY_FOREACH(_flames, f) {
        if (f.opacity > 0) f.opacity = 0;
        else f.opacity = 200;
    }
}



-(void)addRescueWithType:(int)type {
    
    Rescue *r = [Rescue rescueWithType:type];
    int randomX = [gs randomNumberFrom:(self.position.x - self.contentSize.width/2 + 10) To:(self.position.x + self.contentSize.width/2 - 10)];
    r.position = ccp(randomX, self.position.y - self.contentSize.height/2 + 14 + r.contentSize.height/2);
    
    [r setInitVelocity:self.velocity]; ///////so the rescue moves with the platform.
    
    [parent_ addChild:r z:kZCollectables];
    
}




-(void)addTurretWithX:(float)x UpSideDown:(BOOL)usd {
    GroundTurret *g = [GroundTurret turretUpSideDown:usd];
    float y = self.position.y - self.contentSize.height/2 + g.contentSize.height/2 + 14;
    if (usd) y = self.position.y - self.contentSize.height/2 - g.contentSize.height/2 + 4;
    g.position = ccp(x, y);
    [g setInitVelocity:self.velocity];
    
    [parent_ addChild:g z:kZShips];
}



-(void)update:(ccTime)delta {
    Player *player = (Player*)gs.player;
    if (player.playerGround == ground && !player.isJumping) {
        if (player.position.x >= player.contentSize.width/2)
            player.position = ccp(player.position.x - self.velocity.x, player.position.y);
        else
            player.position = ccp(player.contentSize.width/2, player.position.y);
    }
}


-(void)dealloc {
    [_flames release];
    _flames = nil;
    
    [super dealloc];
}



@end







/////////////////
/////////////////
/////////////////--------------------- SUBCLASSES OF CARRIER.
/////////////////
/////////////////
/////////////////





@implementation Carrier1

-(id)initWithY:(int)y { ///should always be init with y for subclass.
    if ((self = [super initWithFileName:@"floatingMassTest1.png" andY:y])) {
        
        CCSprite *f1 = [CCSprite spriteWithFile:@"EngineFlameCruiserSmall.png"];
        f1.position = ccp(f1.contentSize.width/2 + 6, -2);
        
        CCSprite *f2 = [CCSprite spriteWithFile:@"EngineFlameCruiserSmall.png"];
        f2.position = ccp(self.contentSize.width - f1.contentSize.width/2 - 6, f1.position.y);
        
        [self addChild:f1];
        [self addChild:f2];
        
        [_flames addObject:f1];
        [_flames addObject:f2];
        
    }
    return self;
}


-(void)dealloc {
    [super dealloc];
}

@end






@implementation Carrier2

-(id)initWithY:(int)y { ///should always be init with y for subclass.
    if ((self = [super initWithFileName:@"floatingMassTest2.png" andY:y])) {
        
        CCSprite *f1 = [CCSprite spriteWithFile:@"EngineFlameCruiserSmall.png"];
        f1.position = ccp(f1.contentSize.width/2 + 6, -2);
        
        CCSprite *f2 = [CCSprite spriteWithFile:@"EngineFlameCruiserSmall.png"];
        f2.position = ccp(self.contentSize.width - f1.contentSize.width/2 - 6, f1.position.y);
        
        CCSprite *f3 = [CCSprite spriteWithFile:@"EngineFlameCruiserSmall.png"];
        f3.position = ccp(self.contentSize.width/2, f1.position.y);
        
        [self addChild:f1];
        [self addChild:f2];
        [self addChild:f3];
        
        [_flames addObject:f1];
        [_flames addObject:f2];
        [_flames addObject:f3];
        
    }
    return self;
}


-(void)dealloc {
    [super dealloc];
}

@end

