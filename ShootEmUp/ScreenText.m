//
//  ScreenText.m
//  ShootEmUp
//
//  Created by Justin Fletcher on 9/17/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import "ScreenText.h"


@implementation ScreenText

+(id)textWithString:(NSString *)s andColor:(ccColor3B)c andSecondColor:(ccColor3B)c2 {
    return [[[self alloc] initWithString:s andColor:c andSecondColor:c2] autorelease];
}

+(id)textWithString:(NSString *)s andColor:(ccColor3B)c {
    return [[[self alloc] initWithString:s andColor:c andSecondColor:c] autorelease];
}

-(id)initWithString:(NSString *)s andColor:(ccColor3B)c andSecondColor:(ccColor3B)c2 {
    
    if ((self = [super init])) {
        
        text = [CCLabelTTF labelWithString:s fontName:gs.gameFont fontSize:30];
        [text setColor:c];
        
        text2 = [CCLabelTTF labelWithString:s fontName:gs.gameFont fontSize:30];
        [text2 setColor:c2];
        text2.opacity = 0;
        
        
        text.position = ccp(gs.winSize.width/2, gs.winSize.height/2 + 30);
        [self addChild:text];
        
        text2.position = text.position;
        [self addChild:text2];
        id fadein = [CCFadeIn actionWithDuration:0.5f];
        id fadeout = [CCFadeOut actionWithDuration:0.5f];
        [text2 runAction:[CCRepeatForever actionWithAction:[CCSequence actionOne:fadein two:fadeout]]];
        
        
        
        [self scheduleUpdate];
        
    }
    
    return self;
    
}


-(void)update:(ccTime)delta {
    if (textTimer >= 2) {
        [self unscheduleUpdate];
        
        void (^removeSelf) (void) = ^{
            [self removeFromParentAndCleanup:YES];
        };
        
        id shrink = [CCScaleTo actionWithDuration:0.2 scaleX:1 scaleY:0];
        id shrink2 = [CCScaleTo actionWithDuration:0.2 scaleX:1 scaleY:0];
        id remove = [CCCallBlock actionWithBlock:removeSelf];
        
        [text runAction:[CCSequence actionOne:shrink two:remove]];
        [text2 runAction:shrink2];
    }
    else {
        textTimer += delta;
    }
}



-(void)draw {
    [super draw];
    
    //////////////////////////////////// REALLY LONG SKINNY LINE.
    int x1 = 0;
    int y1 = text.position.y - 10*text.scaleY;
    int width1 = gs.winSize.width;
    int height1 = 20*text.scaleY;
    
    CGPoint verts1[4] = {
        ccp(x1,y1),
        ccp(x1 + width1, y1),
        ccp(x1 + width1, y1 + height1),
        ccp(x1, y1 + height1)
    };
    ccDrawSolidPoly(verts1, 4, ccc4f(0, 0, 0, 255));
    
    
    ////////////////////////////////// BLACK BOX AROUND THE TEXT.
    int x2 = text.position.x - text.contentSize.width/2 - 20;
    int y2 = text.position.y - (text.contentSize.height*text.scaleY)/2 - 20*text.scaleY;
    int width2 = text.contentSize.width + 40;
    int height2 = text.contentSize.height*text.scaleY + 40*text.scaleY;
    
    CGPoint verts2[4] = {
        ccp(x2,y2),
        ccp(x2 + width2, y2),
        ccp(x2 + width2, y2 + height2),
        ccp(x2, y2 + height2)
    };
    
    ccDrawSolidPoly(verts2, 4, ccc4f(0, 0, 0, 255));
}



-(void)dealloc {
    [super dealloc];
}

@end
