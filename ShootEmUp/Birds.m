//
//  Birds.m
//  ShootEmUp
//
//  Created by Justin Fletcher on 9/10/13.
//  Copyright 2013 Happy Fox. All rights reserved.
//

#import "Birds.h"
#import "Player.h"
#import "Explode.h"

static CCArray *_birds;


@implementation Birds

@synthesize birdGround;

+(CCArray*)getBirds {
    if (!_birds) _birds = [[CCArray alloc] init];
    return _birds;
}

+(void)addBird:(Birds *)b {
    [[Birds getBirds] addObject:b];
}


+(id)birds {
    return [[[self alloc] initWithSpriteFrameName:@"birds.png"] autorelease];
}

-(void)initJSprite {
    fly = NO;
    birdGround = NULL;
    
    
    if (rand() % 2 == 0) self.scaleX = -1;
    
    [Birds addBird:self];
    
    [self scheduleUpdate];
}


-(void)update:(ccTime)delta {
    
    Player *player = (Player*)gs.player;
    
    if (!fly) {
        if (birdGround != NULL) {
            self.position = ccp(self.position.x - birdGround.velocity.x, self.position.y);
        }
        
        if (player.isWalking) {   ////////////////////////////// birds watch out if the player is walking.
            float diffX = self.position.x - player.position.x;
            float diffY = self.position.y - player.position.y;
            float dist = sqrtf(diffX*diffX + diffY*diffY); //////// a circular perimeter of the players distance around the birds.
            
            if (dist <= 20) { ////if the circle is smaller than 20.
                [self fly];
            }
        }
        
        //////birds also watch out for explosions
        if ([[Explode getExplosions] count] > 0) {
            Explode *e;
            CCARRAY_FOREACH([Explode getExplosions], e) {
                float diffX = self.position.x - e.position.x;
                float diffY = self.position.y - e.position.y;
                float dist = sqrtf(diffX*diffX + diffY*diffY); //////// a circular perimeter of the explosions distance around the birds.
                
                if (dist <= 20) { ////if the circle is smaller than 20.
                    [self fly];
                }
            }
        }
    
    }
    else {
        self.position = ccp(self.position.x + (0.5*self.scaleX), self.position.y + 1);
        
        if (self.position.x <= 0 || self.position.x >= gs.winSize.width) {
            [self destroyJSprite];
        }
    }
    
    
    
}


-(void)fly {
    fly = YES;
    birdGround = NULL; ////if the ground is not null, set it to null, since the bird is flying.
    [_birds removeObject:self];
    NSArray *f = [gs framesWithFrameName:@"birds" fromFrame:1 toFrame:3 andReverse:YES andAntiAlias:NO];
    [self runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:[CCAnimation animationWithSpriteFrames:f delay:0.05]]]];
}

-(void)dealloc {
    [super dealloc];
}

@end













@implementation BirdGroup

+(id)groupWithRandomNumberOfBirdsAndPos:(CGPoint)pos andParent:(CCNode*)p {
    int r = [[GameState sharedGameState] randomNumberFrom:1 To:6];
    return [BirdGroup groupWithNumberOfBirds:r andPos:pos andParent:p];
}
/////with null ground.
+(id)groupWithNumberOfBirds:(int)n andPos:(CGPoint)pos andParent:(CCNode*)p {
    return [[[self alloc] initWithNumberOfBirds:n andPos:pos andParent:p andGround:NULL] autorelease];
}

/////with specified ground.
+(id)groupWithRandomNumberOfBirdsAndPos:(CGPoint)pos andParent:(CCNode*)p andGround:(JSprite *)g {
    int r = [[GameState sharedGameState] randomNumberFrom:1 To:6];
    return [BirdGroup groupWithNumberOfBirds:r andPos:pos andParent:p andGround:g];
}

+(id)groupWithNumberOfBirds:(int)n andPos:(CGPoint)pos andParent:(CCNode*)p andGround:(JSprite *)g {
    return [[[self alloc] initWithNumberOfBirds:n andPos:pos andParent:p andGround:g] autorelease];
}


-(id)initWithNumberOfBirds:(int)n andPos:(CGPoint)pos andParent:(CCNode*)p andGround:(JSprite *)g {
    
    if ((self = [super init])) {
        
        int prevX = 0;
        
        for (int i = 0; i < n; i++) {
            
            int newX = pos.x;
            int diff = abs(newX - prevX);
            
            if (diff <= 5) {
                newX = pos.x + 4; if (rand()%2 == 0) newX = pos.x - 4;
            }
            
            prevX = newX;
            
            Birds *b = [Birds birds];
            b.birdGround = g;
            b.position = ccp(newX, pos.y + b.contentSize.height/2);
            [p addChild:b z:kZShips + 1];
            
            
        }
        
    }
    
    return self;
    
}

-(void)dealloc {
    [super dealloc];
}

@end




