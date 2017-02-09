//
//  ScreenText.h
//  ShootEmUp
//
//  Created by Justin Fletcher on 9/17/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "JHudNode.h"

@interface ScreenText : JHudNode {
    CCLabelTTF *text;
    CCLabelTTF *text2; ///if needed.
    float textTimer;
}

+(id)textWithString:(NSString*)s andColor:(ccColor3B)c andSecondColor:(ccColor3B)c2;
+(id)textWithString:(NSString*)s andColor:(ccColor3B)c;
-(id)initWithString:(NSString*)s andColor:(ccColor3B)c andSecondColor:(ccColor3B)c2;

@end
