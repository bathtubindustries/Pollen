//
//  PlayerSprite.m
//
//  Created by Eric Nelson on 4/12/14.
//  Copyright 2014 bathtubindustries. All rights reserved.
//

#import "PlayerSprite.h"

#import "Flower.h"

#import "SimpleAudioEngine.h"
#import "GameUtility.h"
#import "SpriteLayer.h"

@implementation PlayerSprite

@synthesize velocity = velocity_;
@synthesize extraYVelocity = extraYVel_;
@synthesize pollenMeter = pollenMeter_;
@synthesize state = state_;
@synthesize dead = dead_;

-(id) init {
    NSString *fn;
    if([GameUtility equippedItem] == 0) {
        fn = @"pollenManWand";
    }
    else if([GameUtility equippedItem] == 1) {
        fn = @"pollenManHammer";
    }
    
    if(self = [super initWithFile:[NSString stringWithFormat:@"%@.pvr.ccz", fn] capacity:16]) {
        size = [[CCDirector sharedDirector] winSize];
        
        animationFrames = [[NSMutableArray alloc] init];
        [animationFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"%@Ground.png", fn]]];
        for(int i = 0; i < 3; i++) {
            [animationFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"%@Idle%i.png", fn, i]]];
        }
        for(int i = 0; i < 4; i++) {
            [animationFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"%@Up%i.png", fn, i]]];
        }
        for(int i = 0; i < 4; i++) {
            [animationFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"%@Down%i.png", fn, i]]];
        }
        for(int i = 0; i < 4; i++) {
            [animationFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"%@Side%i.png", fn, i]]];
        }
        
        //start with ground frame
        playerSprite_ = [CCSprite spriteWithSpriteFrame:[animationFrames objectAtIndex:0]];
        [playerSprite_ setScale:0.81f];
        [self addChild: playerSprite_];
        
        self.position = ccp(size.width/2, [self boundingBox].size.height/2);
        self.velocity = CGPointZero;
        self.extraYVelocity = 0;
        
        state_ = OnGround;
        self.dead = NO;
        attackResetTimer_ = 0;
        self.pollenMeter = 0.f;
        
        gravityIncrement_ = 0;
        jumpIncrement_ = 0;
        
        //sounds
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"redFlowerHit.aif"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"blueFlowerHit.aif"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"greenFlowerHit.aif"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"slurp.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"swipe.wav"];
    }
    return self;
}

//MESSAGES
-(void) startAttack {
    [self startAttack:0];
} //direction: 1 = up, 2 = down, 3 = side
-(void) startAttack:(unsigned short)dir {
    if(dir == 0) dir = 3;
    else if(dir != 0 && attackResetTimer_ < PLAYER_ATTACK_FRAME_DELAY) {
        //reset if starting another attack before extra timer delay has run down
        attackResetTimer_ = 0;
        [playerSprite_ stopAllActions];
        state_ = Jumping;
    }

    if(state_ == OnGround) {
        //start jumping if on ground
        state_ = Jumping;
        [playerSprite_ setDisplayFrame:[animationFrames objectAtIndex:1]];
        
        self.velocity = ccp(self.velocity.x, PLAYER_INITAL_JUMP);
        self.rotation = 0;
    } else if(state_ == Jumping || state_ == Boosting) {
        if(state_ == Boosting) {
            if(pollenMeter_ > PLAYER_SWIPE_AMOUNT*2)
                pollenMeter_ = PLAYER_SWIPE_AMOUNT/2;
            else if(pollenMeter_ < PLAYER_SWIPE_AMOUNT*2 && pollenMeter_ > PLAYER_SWIPE_AMOUNT)
                pollenMeter_ = PLAYER_SWIPE_AMOUNT/4;
            else if(pollenMeter_ < PLAYER_SWIPE_AMOUNT)
                pollenMeter_ = 0;

            [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        }
        
        //start attacking
        state_ = Attacking;
        attackResetTimer_ = PLAYER_ATTACK_RESET;
        
        CCAnimation *attackAnimation = [CCAnimation animationWithSpriteFrames:[animationFrames subarrayWithRange:NSMakeRange(4*dir, 4)]
                                                                        delay:PLAYER_ATTACK_FRAME_DELAY];
        CCAction *animationAction = [CCAnimate actionWithAnimation:attackAnimation];
        [playerSprite_ stopAllActions];
        [playerSprite_ runAction:animationAction];
    }
}
-(void) startJump {
    if(self.pollenMeter < PLAYER_MAX_POLLEN)
        self.pollenMeter += FLOWER_POLLEN_AMOUNT;
    if(self.pollenMeter > PLAYER_MAX_POLLEN)
        self.pollenMeter = PLAYER_MAX_POLLEN;
    
    self.velocity = ccp(self.velocity.x, PLAYER_JUMP+jumpIncrement_);

    switch([GameUtility randInt:0 :2]) {
        case 0:
            [[SimpleAudioEngine sharedEngine] playEffect:@"redFlowerHit.aif"];
            break;
        case 1:
            [[SimpleAudioEngine sharedEngine] playEffect:@"blueFlowerHit.aif"];
            break;
        case 2:
        default:
            [[SimpleAudioEngine sharedEngine] playEffect:@"greenFlowerHit.aif"];
            break;
    }
}
-(void) startSpiddderJump {
    if(self.pollenMeter > PLAYER_MAX_POLLEN)
        self.pollenMeter = PLAYER_MAX_POLLEN;
    self.velocity = ccp(self.velocity.x, PLAYER_SPIDDDER_JUMP);
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"slurp.wav"];
}
-(void) startSwipe {
    if(state_ != Boosting) {
        self.pollenMeter -= PLAYER_SWIPE_AMOUNT;
        if(self.pollenMeter < 0)
            self.pollenMeter = 0;

        self.velocity = ccp(self.velocity.x, PLAYER_JUMP+jumpIncrement_);
        
        [[SimpleAudioEngine sharedEngine] playEffect:@"swipe.wav"];
    }
}

-(void) startBoost {
    state_ = Boosting;
    
    CCAnimation *boostAnimation = [CCAnimation animationWithSpriteFrames:[animationFrames subarrayWithRange:NSMakeRange(5, 2)] delay:PLAYER_ATTACK_FRAME_DELAY];
    CCAction *animationAction = [CCAnimate actionWithAnimation:boostAnimation];
    [playerSprite_ stopAllActions];
    [playerSprite_ runAction:[CCRepeatForever actionWithAction:(CCActionInterval*)animationAction]];
    
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"plucked.mp3"];
}
-(void)startComboBoost {
    state_=ComboBoost;
    
    CCAnimation *boostAnimation = [CCAnimation animationWithSpriteFrames:[animationFrames subarrayWithRange:NSMakeRange(5, 2)] delay:PLAYER_ATTACK_FRAME_DELAY];
    CCAction *animationAction = [CCAnimate actionWithAnimation:boostAnimation];
    [playerSprite_ stopAllActions];
    [playerSprite_ runAction:[CCRepeatForever actionWithAction:(CCActionInterval*)animationAction]];
}

-(void) handleHeight:(float)h {
    #warning hacky and will not scale automatically
    if(h > 300 && gravityIncrement_ != 1 && !(self.spawnLayer.treeLevel > 1)) {
        gravityIncrement_ = 1;
        jumpIncrement_ = 75;
        NSLog(@"reached first checkpoint");
        self.spawnLayer.treeLevel=1;
    }
    else if(h > 800 && gravityIncrement_ == 1) {
        gravityIncrement_ = 2.5;
        jumpIncrement_ = 175;
        NSLog(@"reached second checkpoint");
        self.spawnLayer.treeLevel=2;
    }
    else if(h > 1500 && gravityIncrement_ == 2.5) {
        gravityIncrement_ = 4;
        jumpIncrement_ = 225;
        NSLog(@"reached third checkpoint");
        self.spawnLayer.treeLevel=3;
    }
    else if(h > 2000 && gravityIncrement_ == 4) {
        gravityIncrement_ = 7;
        jumpIncrement_ = 290;
        NSLog(@"reached fourth checkpoint");
        self.spawnLayer.treeLevel=4;
    }
    else if(h > 4000 && gravityIncrement_ == 7) {
        gravityIncrement_ = 10.75; //meant to be pretty hard (still playable... screwy with old boost mode)
        jumpIncrement_ = 350;
        NSLog(@"reached fifth and final checkpoint");
        self.spawnLayer.treeLevel = 4;
    }
}

//UPDATE
-(void) update:(ccTime)dt
{
    //ATTACK STATE UPDATE
    if (state_ != ComboBoost && state_ != Combo)
    {
        if(state_ == Attacking) {
#warning idk jumpincrement stuff seems v hacky
            if(attackResetTimer_ > 0) {
                attackResetTimer_ -= dt;
                
                if(jumpIncrement_ < 75)
                gravityIncrement_ = PLAYER_GRAVITY*0.4f;
            } else {
                state_ = Jumping;
                [playerSprite_ setDisplayFrame:[animationFrames objectAtIndex:1]];
                
                if(jumpIncrement_ < 75)
                gravityIncrement_ = PLAYER_GRAVITY*0.25f;
            }
        }
        
        //CHECK+HANDLE BOOSTING
        if(state_ == Boosting) {
            self.velocity = ccp(self.velocity.x, 40.0 + PLAYER_BOOST_JUMP * ((self.pollenMeter/(PLAYER_MAX_POLLEN*5))) );
            self.pollenMeter -= PLAYER_BOOST_DECREMENT*dt;
            if(self.pollenMeter <= 0) {
                state_ = Jumping;
                [playerSprite_ stopAllActions];
                [playerSprite_ setDisplayFrame:[animationFrames objectAtIndex:1]];
                [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
            }
        }
        
        if(state_ == Jumping) {
            if((self.velocity.y + self.extraYVelocity > 0) &&
               (self.velocity.y + self.extraYVelocity < 60)) {
                [playerSprite_ setDisplayFrame:[animationFrames objectAtIndex:2]];
            }
            else if(self.velocity.y < 0) {
                [playerSprite_ setDisplayFrame:[animationFrames objectAtIndex:3]];
            }
            
            //NSLog(@"y velocity: %f, extra y velocity: %f", self.velocity.y, self.extraYVelocity);
        }
        
        //Y BOUNDS AND VELOCITIES
        //update if above bottom edge
        if(state_ != OnGround) {
            if(self.position.y > -[self boundingBox].size.height/2) {
                
                //update the velocity with gravity
                if(self.extraYVelocity > 0)
                    self.extraYVelocity += PLAYER_GRAVITY-gravityIncrement_;
                if(self.extraYVelocity < 0)
                    self.extraYVelocity = 0;

                if(self.extraYVelocity < -(PLAYER_GRAVITY-gravityIncrement_)) {
                    self.velocity = ccp(self.velocity.x,
                                        self.velocity.y + (PLAYER_GRAVITY-gravityIncrement_) + self.extraYVelocity);
                
                }
                if (self.comboEnding)
                {
                    //self.velocity= CGPointMake(self.velocity.x, self.velocity.y+850);
                    self.comboEnding=NO;
                    self.pollenMeter = PLAYER_MAX_POLLEN-1;
                }
                
            } else {
                self.velocity = CGPointZero;
                self.dead = YES;
                [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
            }
        } else {
            //reset to bottom edge if below (do not account for rotated box)
            if(self.position.y < self.contentSize.height*self.scale/2) {
                self.position = ccp(self.position.x, self.contentSize.height*self.scale/2);
                //zero velocity if below bottom edge
                self.velocity = CGPointZero;
            }
        }
    }
    //X BOUNDS AND VELOCITIES
    //bound x within screen
    if(self.position.x > size.width - [self boundingBox].size.width/2) {
        self.velocity = ccp(0, self.velocity.y);
        self.position = ccp(size.width - [self boundingBox].size.width/2,
                            self.position.y);
    } else if(self.position.x < [self boundingBox].size.width/2) {
        self.velocity = ccp(0, self.velocity.y);
        self.position = ccp([self boundingBox].size.width/2,
                            self.position.y);
    }

    if(state_ != OnGround) {
        //bound velocity to max speed
        if(self.velocity.x > PLAYER_XMAXSPEED)
            self.velocity = ccp(PLAYER_XMAXSPEED, self.velocity.y);
        else if(self.velocity.x < -PLAYER_XMAXSPEED)
            self.velocity = ccp(-PLAYER_XMAXSPEED, self.velocity.y);

        //round down small velocities
        if(abs(self.velocity.x) < 20.f) { //was 0.05f) {
            self.velocity = ccp(0, self.velocity.y);
        }
    } else {
        //rotate w x vel
        int minVel = 15;
        if(self.velocity.x > minVel) {
            self.rotation = 9;
            self.position = ccp(size.width/2 + 12, self.position.y);
        }
        else if(self.velocity.x < -minVel) {
            self.rotation = -9;
            self.position = ccp(size.width/2 - 12, self.position.y);
        }
        else if(abs(self.velocity.x) < minVel-2 && self.velocity.x != 0) {
            self.rotation = 0;
            self.position = ccp(size.width/2, self.position.y);
        }
        
        self.velocity = ccp(0, self.velocity.y);
    }
    
    //UPDATE
    //update sprite with velocity
    if (state_ != ComboBoost )
    {
        self.position = ccp(self.position.x + self.velocity.x*dt,
                        self.position.y + self.velocity.y*dt);
    }
    //rise to spidder altitude if in comboboost
    else if (state_ == ComboBoost)
    {
        self.velocity = ccp(self.velocity.x/4, PLAYER_COMBO_BOOST);
        self.extraYVelocity=PLAYER_COMBO_BOOST;
        
        if (self.position.y >= size.height*.5)
        {
            self.velocity = ccp(self.velocity.x, 0);
            self.position = ccp(self.position.x + self.velocity.x*dt,
                                size.height*.5);
        }
        else
        {
            self.position = ccp(self.position.x + self.velocity.x*dt,
                                self.position.y + self.velocity.y*dt);
        }
    }
    
    
    //HANDLE EXTRA Y VEL
    if(self.position.y > size.height/2 && state_!=ComboBoost && state_ != Combo) {
        self.extraYVelocity = self.velocity.y;
        self.velocity = ccp(self.velocity.x, 0);
        self.position = ccp(self.position.x, size.height/2);
    }
}

//OVERRIDES
-(CGPoint) position { return playerSprite_.position; }
-(void) setPosition:(CGPoint)position {
    playerSprite_.position = position;
}

-(float) rotation { return playerSprite_.rotation; }
-(void) setRotation:(float)rotation {
    playerSprite_.rotation = rotation;
}

-(CGRect) boundingBox {
    return  CGRectMake(self.position.x - PLAYER_WIDTH/2, self.position.y - PLAYER_HEIGHT/2, PLAYER_WIDTH, PLAYER_HEIGHT);
}

@end
