//
//  ContinueLayer.m
//  PollenBug
//
//  Created by Eric Nelson on 5/24/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "ContinueLayer.h"

@implementation ContinueLayer




-(id) init {
    if(self = [super initWithColor:ccc4(0, 0, 0, 0)]) {
        
        size = [[CCDirector sharedDirector] winSize];
        
        warned=NO;
        
        float scaleFactor=1;
        //menu items and setup
        scaleFactor = size.height/size.width;
        [CCMenuItemFont setFontName:@"Futura"];
        [CCMenuItemFont setFontSize:(24*scaleFactor)];
        haikuNum=[GameUtility savedHaikuCount];
        
       
        
        
        
        
        CCMenuItem *itemResume = [CCMenuItemFont itemWithString:@"YES" block:^(id sender) {
            if ([GameUtility savedHaikuCount]>0){
                [self resumeWithContinue];
                [GameUtility saveHaikuCount:([GameUtility savedHaikuCount]-1)];
            }
            else{
                if (!warned){
                warningLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"You have no haiku charges left"]
                                                fontName:@"Futura" fontSize:12*scaleFactor];
                warningLabel.position = ccp(size.width/2, size.height - (3*size.height)/4);
                [self addChild:warningLabel];
                [warningLabel setColor:ccRED];
                warned=YES;
                }
            }
        }];
        
        
        [itemResume setColor:ccWHITE];
        CCMenuItem *itemGameOver = [CCMenuItemFont itemWithString:@"NO" block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[GameOverLayer sceneWithScore:_playerScore]]];
        }];
        
        [itemGameOver setColor:ccWHITE];
        
        
        
        continueMenu_ = [CCMenu menuWithItems:itemResume, itemGameOver,nil];
        
        [continueMenu_ alignItemsHorizontallyWithPadding: 9*scaleFactor];
        [continueMenu_ setPosition: ccp(size.width/2, size.height*.30)];
        
        
        continueLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Consume a Haiku to continue?"]
                                           fontName:@"Futura" fontSize:14*scaleFactor];
        continueLabel.position = ccp(size.width/2, size.height - 64);
        [continueLabel setColor:ccWHITE];
        [self addChild:continueLabel];
        [continueLabel setVisible:NO];
        
        haikuCounter_ = [CCSprite spriteWithFile:@"haikuUI.png"];
        haikuCounter_.scale=.5;
        haikuCounter_.position = ccp(continueLabel.position.x, continueLabel.position.y-[haikuCounter_ boundingBox].size.height*.9);
        [self addChild: haikuCounter_ ];
        haikuCounter_.visible=NO;
        
        haikuLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"X%i", [GameUtility savedHaikuCount]]
                                         fontName:@"Futura" fontSize:18*scaleFactor];
        haikuLabel.anchorPoint = ccp(0, 1);
        haikuLabel.position = ccp(haikuCounter_.position.x+[haikuCounter_ boundingBox].size.width/2,haikuCounter_.position.y);
        [self addChild:haikuLabel];
        [haikuLabel setVisible:NO];
        
        
        [continueMenu_ setEnabled:NO];
        [continueMenu_ setVisible:NO];
        
        [self addChild:continueMenu_];
    }
    return self;
}




-(void) onEnter {
    [super onEnter];
    [self registerWithTouchDispatcher];
}
-(void) onExit {
    [super onExit];
    [[CCDirector sharedDirector].touchDispatcher removeDelegate:self];
}

//TOUCHES
-(void) registerWithTouchDispatcher {
    [[CCDirector sharedDirector].touchDispatcher
     addTargetedDelegate:self priority:-2 swallowsTouches:NO];
}


-(void) checkForContinue {
    [continueMenu_ setVisible:YES];
    [continueMenu_ setEnabled:YES];
    [continueLabel setVisible:YES];
     [haikuLabel setVisible:YES];
    haikuCounter_.visible=YES;

    if (!_paused)
        _paused=YES;
    
    
    [self setOpacity:210];
    
    
    
    
}
-(void) resumeWithContinue {
    if(_paused )
        _paused = NO;
    
    [self setOpacity:0];

    [continueMenu_ setVisible:NO];
    [continueMenu_ setEnabled:NO];
    [continueLabel setVisible:NO];
     [haikuLabel setVisible:NO];
    haikuCounter_.visible=NO;
    
    [gameScene makeReviveCall];
    //reset on near flower
}

+(CCScene*) scene{
    CCScene *scene = [CCScene node];
    ContinueLayer *layer = [[[ContinueLayer alloc] init] autorelease];
    [scene addChild:layer];
    return scene;
}

-(void) setScene:(GameplayScene *)s{
    gameScene = s;
}

-(void) update:(ccTime)dt{
    haikuNum=[GameUtility savedHaikuCount];
    float scaleFactor=1;
    //menu items and setup
    scaleFactor = size.height/size.width;
    
    [haikuLabel setString: [NSString stringWithFormat:@"X%i", haikuNum]];
    
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    return YES;
}


@end
