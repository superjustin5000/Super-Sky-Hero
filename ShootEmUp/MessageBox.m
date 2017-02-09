//
//  MessageBox.m
//  ShootEmUp
//
//  Created by Justin Fletcher on 6/11/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import "MessageBox.h"


@implementation MessageBox

+(id)mBoxWithMessage:(NSString *)m Character:(int)c Duration:(float)d {
    return [[[self alloc] initWithMessage:m Character:c Duration:d] autorelease];
}

-(id)initWithMessage:(NSString *)m Character:(int)c Duration:(float)d {
    if ((self = [super init])) {
        
        message = m;
        character = c;
        duration = d;
        
        messageCharPos = 1;
        messageDisplayTime = 0.01f;
        messageDisplayTimer = 0.0f;
        
        
        messageBox = [CCSprite spriteWithFile:@"messageBoxTest.png"];
        messageBox.position = ccp(gs.winSize.width/2, gs.winSize.height - messageBox.contentSize.height/2 - 20);
        messageBox.opacity = 200;
        messageBox.scaleY = 0;
        [self addChild:messageBox];
        
        
        NSMutableArray *picFrames;
        CCAnimation *picAnimation;
        BOOL havePic = YES;
        switch (character) {
            case kHudFaceStatic:
                picName = @"faceStatic1.png";
                picFrames = [gs framesWithFrameName:@"faceStatic" fromFrame:1 toFrame:5];
                break;
            case kHudFacePilot1:
                picName = @"pilotHeadAngry1.png";
                picFrames = [gs framesWithFrameName:@"pilotHeadAngry" fromFrame:1 toFrame:2];
                break;
                
            case kHudFaceRoxie1:
                picName = @"roxieNorm1.png";
                picFrames = [gs framesWithFrameName:@"roxieNorm" fromFrame:1 toFrame:2];
                break;
                
            default:
                havePic = NO;
                break;
        }
        
        int roomForPicture = 40;
        int padding = 10;
        int messageX = roomForPicture + (padding*2);
        
        
        
        
        if (havePic) {
            picAnimation = [CCAnimation animationWithSpriteFrames:picFrames delay:0.1];
            picture = [CCSprite spriteWithSpriteFrameName:picName];
            picture.anchorPoint = ccp(0,0);
            picture.position = ccp(padding, padding);
            picture.scale = 1.7f;
            [picture runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:picAnimation]]];
            [messageBox addChild:picture];
        }
        
        
        messageLabel = [CCLabelTTF labelWithString:@"" fontName:gs.gameFont fontSize:10];
        messageLabel.dimensions = CGSizeMake(messageBox.contentSize.width - messageX - padding, messageBox.contentSize.height - (padding*2));
        messageLabel.anchorPoint = ccp(0,1);
        messageLabel.position = ccp(messageX, messageBox.contentSize.height - padding);
        [messageBox addChild:messageLabel];
        
        [self startShowingMessage];
        
    }
    return self;
}


-(void)startShowingMessage {
    id scale = [CCScaleTo actionWithDuration:0.2 scale:1];
    id scaledone = [CCCallFunc actionWithTarget:self selector:@selector(showMessage)];
    [messageBox runAction:[CCSequence actionOne:scale two:scaledone]];
}
-(void)showMessage {
    [self schedule:@selector(showMessage:)];
}
-(void)showMessage:(ccTime)dt {
    if (durationTimer < duration) {
    
        durationTimer += dt;
        
        if (messageCharPos < ([message length] + 1)) {
            
            ////show the next character after the displayTime.
            if (messageDisplayTimer >= messageDisplayTime) {
                
                NSString *newMessage = [message substringToIndex:messageCharPos];
                [messageLabel setString:newMessage];
                
                messageCharPos++; ///go to next char pos the next time.
                messageDisplayTimer = 0.0f; ///reset timer.
            
            }
            else {
                messageDisplayTimer += dt;
            }
            
        }
        else {
            if (character != kHudFaceStatic) {
                [picture stopAllActions];
                [picture setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:picName]];
            }
        }
        
    }
    else {
        
        [self unShowMessage];
        
    }
}


-(void)unShowMessage {
    [messageBox removeChild:messageLabel cleanup:YES];
    id scale = [CCScaleTo actionWithDuration:0.2 scaleX:1 scaleY:0];
    id scaledone = [CCCallFunc actionWithTarget:self selector:@selector(destroyMessage)];
    [messageBox runAction:[CCSequence actionOne:scale two:scaledone]];
}


-(void)destroyMessage {
    [self removeFromParentAndCleanup:YES];
}


-(void)dealloc {
    [super dealloc];
}

@end
