//
//  CloudsFront.m
//  ThisShipWillSelfDestruct
//
//  Created by Justin Fletcher on 5/31/12.
//  Copyright 2012 Happy Fox. All rights reserved.
//

#import "Clouds.h"

@implementation Clouds

@synthesize cloudSpeed;
@synthesize spawnCloudTime;
@synthesize fromY;
@synthesize toY;

-(id)init {
    if ((self = [super init])) {
        
        gs = [GameState sharedGameState];
        
        
        cloudSpeed = 1;
        spawnCloudTime = 1;
        cloudTime = spawnCloudTime;
        
        fromY = 320;
        toY = 380;
        
        startingCloudNum = 40;
        
        [self scheduleUpdate];
        
    }
    
    return self;
}


-(void)update:(ccTime)dt {
    
    cloudTime += dt;
    
    if (cloudNum <= startingCloudNum) {
        for (int i=0; i<=startingCloudNum; i++) { ////adding the first 60 clouds so they're there from the start.
            cloudNum++;
            [self addCloud];
        }
    }
    
    if (cloudTime >= spawnCloudTime) {
        cloudTime = 0;
        float timeRand = [gs random0to1withDeviation:0];
        timeRand = timeRand / 7;
        spawnCloudTime = timeRand/cloudSpeed;
    
        [self addCloud];
    }
    
}




-(void)addCloud {
    
    float cloudtype = (arc4random() % 2) + 1;
	
	CCSprite *cloud;
	
	if (cloudtype == 1) {
		cloud = [CCSprite spriteWithFile:@"cloud1.png"];
	}
	else if (cloudtype == 2) {
		cloud = [CCSprite spriteWithFile:@"cloud2.png"];
	}
	
	
    float randomScale = [gs random0to1withDeviation:0.9];
	
	float willFlipX = (arc4random() % 2);
	if (willFlipX == 0) {
		cloud.scaleX = randomScale;
		cloud.scaleY = randomScale;
	}
	else if (willFlipX == 1) {
		cloud.scaleX = -randomScale;
		cloud.scaleY = randomScale;
	}
	
	
	float opac = [gs randomNumberFrom:40 To:210];
	cloud.opacity = opac;
	
	float cloudYPos = [gs randomNumberFrom:fromY To:toY];
    float cloudXPos = 480 + cloud.contentSize.width*cloud.scaleY;
    
	
	float cloudMoveRand = [gs random0to1withDeviation:2.5];
	float cloudMoveSpeed = [gs randomNumberFrom:cloudMoveRand To:cloudMoveRand+3];
    
    int cloudZ = kZCloudFront;
    
    if (randomScale <= 1.3) {   /////////////////// Makes it so if the cloud is small, make it look like it's further in the background by lowering it and slowing it down.
        cloudMoveRand = [gs random0to1withDeviation:5.0];
        cloudMoveSpeed = [gs random0to1withDeviation:1.5] + cloudMoveRand;
        cloud.opacity = cloud.opacity - 40; if (cloud.opacity <= 0) { cloud.opacity = 10; }
        cloudYPos = cloudYPos - 40;
        cloudZ = kZCloudBack;
    }
    if (cloudNum <= startingCloudNum) {
        cloudXPos = [gs randomNumberFrom:1 To:500]; ////overwrite x pos for starting clouds so they populate the sky from the start.
    }
    
    
    cloud.position = ccp(cloudXPos, cloudYPos);
	[parent_ addChild:cloud z:cloudZ];
    
	id move = [CCMoveTo actionWithDuration:cloudMoveSpeed/cloudSpeed position:ccp(0-cloud.contentSize.width, cloud.position.y)];
	id done = [CCCallFuncN actionWithTarget:self selector:@selector(removeCloud:)];
	[cloud runAction:[CCSequence actions:move, done, nil]];
}

-(void)removeCloud:(id)sender {
    CCSprite *cloud = (CCSprite*)sender;
    [parent_ removeChild:cloud cleanup:YES];
}



-(void)dealloc {
    [super dealloc];
}

@end
