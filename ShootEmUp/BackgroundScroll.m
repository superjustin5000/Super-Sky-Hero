//
//  BackgroundScroll.m
//  ThisShipWillSelfDestruct
//
//  Created by Justin Fletcher on 6/5/12.
//  Copyright 2012 Happy Fox. All rights reserved.
//




/////////////#############################
/////////////////// ########################################   Consider adding this to the JLevel class. That would be cool.!!!
/////////////############################

#import "BackgroundScroll.h"

static float maxScrollSpeed = 4, initScrollSpeed = 4, scrollSpeed = 4, scrollAccel = 0.025;
static BOOL negativeDirection = NO;

@implementation BackgroundScroll

+(id)BackgroundWithFile:(NSString *)fileName position:(CGPoint)position scrollRatio:(float)ratio riseRatio:(float)rRatio {
    return [[[self alloc] initWithBackgroundFile:fileName position:position scrollRatio:ratio riseRatio:rRatio] autorelease];
}

-(id)initWithBackgroundFile:(NSString *)fileName position:(CGPoint)position scrollRatio:(float)ratio riseRatio:(float)rRatio {
    
    if ((self = [super init])) {
        
        self.anchorPoint = ccp(0,0);
        self.position = position;
        
        bg1 = [CCSprite spriteWithFile:fileName];
        bg1.anchorPoint = ccp(0,0);
        bg1.position = ccp(0, 0);
        [bg1.texture setAliasTexParameters];
        [self addChild:bg1];
        
        bg2 = NULL;
        
        if (ratio != 0) {
        
            bg2 = [CCSprite spriteWithFile:fileName];
            bg2.anchorPoint = ccp(0,0);
            bg2.position = ccp(bg1.position.x + bg1.contentSize.width, bg1.position.y);
            [bg2.texture setAliasTexParameters];
            [self addChild:bg2];
            
            scrollRatio = ratio;
            speed = scrollSpeed * scrollRatio;
            if (scrollSpeed == 0) speed = 0;
            
            [self scheduleUpdate];
            
        }
        
        riseRatio = rRatio;
        scrollSpeed = initScrollSpeed;
        
        
    }
    
    return self;
    
}


-(void)update:(ccTime)dt {
    
    speed = scrollSpeed * scrollRatio;
    if (scrollSpeed == 0) speed = 0;
    
    float playerY = [GameState sharedGameState].playerPos.y;
    float yAdjust = 0;
    if (playerY >= 140) {
        yAdjust = 0 + ((playerY - 140) * riseRatio);
    }
    if (yAdjust >= (200 - bg1.contentSize.height)) {
        yAdjust = 200 - bg1.contentSize.height;
    }
    
    bg1.position = ccp(bg1.position.x, yAdjust);
    bg2.position = ccp(bg2.position.x, yAdjust);
    
    if (speed > 0) {
        bg1.position = ccp(bg1.position.x - speed, bg1.position.y);
        bg2.position = ccp(bg2.position.x - speed, bg2.position.y);
        
        if (bg1.position.x <= -bg1.contentSize.width) {
            bg1.position = ccp(bg2.position.x + bg2.contentSize.width, bg1.position.y);
        }
        if (bg2.position.x <= -bg2.contentSize.width) {
            bg2.position = ccp(bg1.position.x + bg1.contentSize.width, bg2.position.y);
        }
    }
    
    
    else if (speed < 0) {
        bg1.position = ccp(bg1.position.x - speed, bg1.position.y);
        bg2.position = ccp(bg2.position.x - speed, bg2.position.y);
        
        if (bg1.position.x >= bg1.contentSize.width) {
            bg1.position = ccp(bg2.position.x - bg2.contentSize.width, bg1.position.y);
        }
        if (bg2.position.x >= bg2.contentSize.width) {
            bg2.position = ccp(bg1.position.x - bg1.contentSize.width, bg2.position.y);
        }
    }
    
}


-(void)slowDownToStop {
    [self schedule:@selector(slowDownToStop:)];
}
-(void)slowDownToStop:(ccTime)dt {
    if (!negativeDirection) {
        if (scrollSpeed <= 0) {
            scrollSpeed = 0;
            [self unschedule:@selector(slowDownToStop:)];
            [self unschedule:@selector(update:)];
            return;
        }
        scrollSpeed -= scrollAccel;
    }
    else {
        if (scrollSpeed >= 0) {
            scrollSpeed = 0;
            [self unschedule:@selector(slowDownToStop:)];
            [self unschedule:@selector(update:)];
            return;
        }
        scrollSpeed += scrollAccel;
    }
}

-(void)speedUpToMax {
    [self schedule:@selector(speedUpToMax:)];
}
-(void)speedUpToMax:(ccTime)dt {
    if (!negativeDirection) {
        if (scrollSpeed >= maxScrollSpeed) {
            scrollSpeed = initScrollSpeed;
            [self unschedule:@selector(speedUpToMax:)];
        }
        scrollSpeed += scrollAccel;
    }
    else {
        if (scrollSpeed <= -maxScrollSpeed) {
            scrollSpeed = -initScrollSpeed;
            [self unschedule:@selector(speedUpToMax:)];
        }
        scrollSpeed -= scrollAccel;
    }
}


-(void)setOpacity:(int)o {
    bg1.opacity = o;
    if (bg2 != NULL) bg2.opacity = o;
}





+(void)setScrollSpeed:(float)newSpeed {
    scrollSpeed = newSpeed;
}
+(void)setAccel:(float)a {
    scrollAccel = a;
}
+(void)setNegativeDirection {
    negativeDirection = YES;
    [BackgroundScroll setScrollSpeed:-initScrollSpeed];
}


-(void)dealloc {
    [super dealloc];
}

@end
