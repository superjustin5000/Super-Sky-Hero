//
//  PowerUp.h
//  ShootEmUp
//
//  Created by Justin Fletcher on 5/22/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class Player;
@class EngineFlame;

@interface PowerUp : JSprite {
    int powerupType;
}
@property(nonatomic)int powerupType;

+(CCArray*)getPowerups;
+(void)removeFromPowerups:(PowerUp*)p;
+(id)powerUpWithType:(int)type;
-(id)initWithType:(int)type;

@end





@interface PowerUpNode : JSprite {
    Player *player;
    
    BOOL stateWalking;
    BOOL stateFlying;
    BOOL stateLanding;
    BOOL stateStartFlying;
    
    BOOL isWalking;
    BOOL enemyLeft;
    BOOL enemyRight;
    float lastFloorHeight;
    
    NSString *bulletFile;
    BOOL addBulletSmoke;
    int powerupType;
    int moveType;
    float shootTime;
    float shootTimer;
    
    EngineFlame *flame;
    
    NSString *walkFrame;
    NSString *standFrame;
    NSString *transformFrame;
    NSString *flyFrame;
}
+(id)powerupWithFile:(NSString*)filename type:(int)type;
+(id)powerupWithSpriteFrameName:(NSString*)spriteFrameName type:(int)type;
-(id)initWithFile:(NSString*)filename type:(int)type;
-(id)initWithSpriteFrameName:(NSString*)spriteFrameName type:(int)type;

-(void)stateWalking;
-(void)stateFlying;
-(void)stateLanding;
-(void)stateStartFlying;

-(void)shootWithDirection:(int)direction type:(int)type;

@end
