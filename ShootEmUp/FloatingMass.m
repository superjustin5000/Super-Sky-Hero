//
//  FloatingMass.m
//  ShootEmUp
//
//  Created by Justin Fletcher on 5/19/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import "FloatingMass.h"

@implementation FloatingMass

+(id)floatingMassWithY:(int)y {
    return [[[self alloc] initWithY:y] autorelease];
}
-(id)initWithY:(int)y {
    ////override this in subclass.
    NSLog(@"CLASS FLOATINGMASS... METHOD INITWITHY... SHOULD BE OVERRIDED BY SUBCLASS!!!");
    return NULL;
}

-(id)initWithFileName:(NSString *)filename Invincibility:(BOOL)inv Y:(int)y {
    if ((self = [super initWithFileName:filename Strength:20 StartingHealth:1 Velocity:ccp(1,0)])) {
        self.position = ccp(gs.winSize.width+self.contentSize.width/2, y);
        invincible = inv;
        
        
    }
    return self;
}



-(void)dealloc {
    [super dealloc];
}
@end
