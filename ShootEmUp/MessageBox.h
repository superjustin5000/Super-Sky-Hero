//
//  MessageBox.h
//  ShootEmUp
//
//  Created by Justin Fletcher on 6/11/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "JHudNode.h"

@interface MessageBox : JHudNode {
    NSString *message;
    int messageCharPos;
    float messageDisplayTime;
    float messageDisplayTimer;
    int character;
    float duration;
    float durationTimer;
    
    CCSprite *messageBox;
    CCSprite *picture;
    NSString *picName;
    CCLabelTTF *messageLabel;
}
+(id)mBoxWithMessage:(NSString*)m Character:(int)c Duration:(float)d;
-(id)initWithMessage:(NSString*)m Character:(int)c Duration:(float)d;

-(void)startShowingMessage;
-(void)showMessage;
-(void)unShowMessage;

@end
