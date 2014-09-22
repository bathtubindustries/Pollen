//
//  ContinueLayer.m
//  PollenBug
//
//  Created by Eric Nelson on 5/24/14.
//  Copyright (c) 2014 bathtubindustries. All rights reserved.
//

#import "ContinueLayer.h"
#import "HaikuSpawner.h"

@implementation ContinueLayer




-(id) init{
    if(self = [super initWithColor:ccc4(0, 0, 0, 0)]) {
        
        size = [[CCDirector sharedDirector] winSize];
        
        warned=NO;
        haikuCost=1;
        
        float scaleFactor=1;
        //menu items and setup
        scaleFactor = size.height/size.width;
        [CCMenuItemFont setFontName:@"Chalkduster"];
        [CCMenuItemFont setFontSize:(24*scaleFactor)];
        haikuNum=[GameUtility savedHaikuCount];
        
        randSpawner = [[HaikuSpawner alloc] init];
       
        
        CCMenuItemImage *itemRevive = [CCMenuItemImage itemWithNormalImage:@"menuBoxLeft.png" selectedImage:@"menuBoxLeft.png" disabledImage:nil block:^(id sender){
            if ([GameUtility savedHaikuCount]>= haikuCost){
                [GameUtility saveHaikuCount:([GameUtility savedHaikuCount]-haikuCost)];
                [self resumeWithContinue];
            }
            else{
                if (!warned){
                    warningLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"not enough haiku charges left"]
                                                      fontName:@"Chalkduster" fontSize:12*scaleFactor];
                    warningLabel.position = ccp(size.width/2, size.height - ((3*size.height)/4) + 20*scaleFactor) ;
                    [self addChild:warningLabel];
                    [warningLabel setColor:ccRED];
                    warned=YES;
                }
            }
        
        }];
        itemRevive.scale=1.2;
        CCLabelTTF *reviveText = [CCLabelTTF labelWithString:@"continue" fontName:@"Chalkduster" fontSize:14*scaleFactor];
        [reviveText setColor:ccc3(255, 224, 51)];
        [itemRevive addChild:reviveText];
        reviveText.scale=1*(1/itemRevive.scale);
        
        CCMenuItemImage *itemScores = [CCMenuItemImage itemWithNormalImage:@"menuBoxRight.png" selectedImage:@"menuBoxRight.png" disabledImage:nil block:^(id sender){
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[GameOverLayer sceneWithScore:self.playerScore]]];
        
        }];
        itemScores.scale=1.2;
        CCLabelTTF *scoreText = [CCLabelTTF labelWithString:@"next>" fontName:@"Chalkduster" fontSize:18*scaleFactor];
        [scoreText setColor:ccc3(255, 224, 51)];
        [itemScores addChild:scoreText];
        scoreText.scale=1.0*(1/itemRevive.scale);
        
        
        
        continueMenu_ = [CCMenu menuWithItems:itemRevive, itemScores, nil];
        
        [continueMenu_ alignItemsHorizontallyWithPadding: 1*scaleFactor];
        [continueMenu_ setPosition: ccp(size.width/2, size.height*.19)];
        
        
        
        reviveText.position = ccp(itemRevive.contentSize.width/2 - 2*scaleFactor,
                                  itemRevive.contentSize.height/2 + 3*scaleFactor);
        scoreText.position = ccp(itemScores.contentSize.width/2 + 1*scaleFactor,
                                 itemScores.contentSize.height/2 - 3*scaleFactor);
        
        CCSprite *haikuSubtract = [CCSprite spriteWithFile:@"haikuUI.png"];
        haikuSubtract.scaleY=.15 *(1/itemRevive.scale);
        haikuSubtract.scaleX=.15*(1/itemRevive.scale);
        haikuSubtract.position=ccp(reviveText.position.x-[haikuSubtract boundingBox].size.width/2, reviveText.position.y-haikuSubtract.boundingBox.size.height+8*scaleFactor);
        [itemRevive addChild:haikuSubtract];
        
        reviveHaikuText = [CCLabelTTF labelWithString:[NSString stringWithFormat:@" -%d",haikuCost ] fontName:@"Chalkduster" fontSize:14*scaleFactor];
        [reviveHaikuText setColor:ccc3(255, 224, 51)];
        [itemRevive addChild:reviveHaikuText];
        
        reviveHaikuText.position= ccp(haikuSubtract.position.x+20*scaleFactor, haikuSubtract.position.y);
        
        continueLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"you fell"]
                                           fontName:@"Chalkduster" fontSize:18*scaleFactor];
        continueLabel.position = ccp(size.width/2, size.height - 64);
        [continueLabel setColor:ccWHITE];
        [self addChild:continueLabel];
        [continueLabel setVisible:NO];
        
        /*haikuCounter_ = [CCSprite spriteWithFile:@"haikuUI.png"];
        haikuCounter_.scale=.80;
        haikuCounter_.position = ccp((size.width/2)-10*scaleFactor , (size.height/2)+10*scaleFactor);
        [self addChild: haikuCounter_ ];
        haikuCounter_.visible=NO;
        id trigger = [CCCallFuncND actionWithTarget:self selector:@selector(triggerRepeatBounceForSprite:) data:(CCSprite*)haikuCounter_];
        [haikuCounter_ runAction:trigger];*/
        toFeature =[[Haiku alloc] initHardCoded];
        toFeature.scale=1.0;
        toFeature.position=ccp((size.width/2)-10*scaleFactor , (size.height/2)+20*scaleFactor);
        [self addChild:toFeature];
        toFeature.visible=NO;
        id trigger = [CCCallFuncND actionWithTarget:self selector:@selector(triggerRepeatBounceForSprite:) data:(CCSprite*)toFeature];
        [toFeature runAction:trigger];
    
        haikuLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"X%i", [GameUtility savedHaikuCount]]
                                        fontName:@"Futura" fontSize:18*scaleFactor];
        haikuLabel.anchorPoint = ccp(0, 1);
        haikuLabel.position = ccp(toFeature.position.x-7*scaleFactor+toFeature.contentSize.width/2,toFeature.position.y-toFeature.contentSize.height/2);
        
        [toFeature addChild:haikuLabel];
        
        CCSprite *frown = [CCSprite spriteWithFile: @"frowns.png"];
        frown.position=ccp(haikuCounter_.position.x-10*scaleFactor, haikuCounter_.position.y-103*scaleFactor);
        [haikuCounter_ addChild:frown];
        frown.scale=(1/haikuCounter_.scale);
        
        
        
        
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
    float scaleFactor = size.height/size.width;
    
    [gameScene hidePause];
    
    [continueMenu_ setOpacity:0];
    [continueMenu_ runAction:[CCFadeIn actionWithDuration:0.75f]];
    [self scheduleOnce:@selector(setMenuEnabled) delay:0.75f];
    
    [continueMenu_ setEnabled:NO];
    [continueMenu_ setVisible:YES];
    [continueLabel setVisible:YES];
    
    [toFeature removeChild:haikuLabel];
    [self removeChild:toFeature];
    toFeature =[randSpawner getRandomHaiku];
    toFeature.visible=YES;
    toFeature.position=ccp((size.width/2)-10*scaleFactor , (size.height/2)+20*scaleFactor);
    [self addChild:toFeature];
    id trigger = [CCCallFuncND actionWithTarget:self selector:@selector(triggerRepeatBounceForSprite:) data:(CCSprite*)toFeature];
    [toFeature runAction:trigger];
    
    
    haikuLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"X%i", [GameUtility savedHaikuCount]]
                                    fontName:@"Futura" fontSize:18*scaleFactor];
    haikuLabel.position = ccp(toFeature.position.x-30*scaleFactor+toFeature.contentSize.width/2,toFeature.position.y-50*scaleFactor -toFeature.contentSize.height/2);
    haikuLabel.anchorPoint = ccp(0, 1);
    [toFeature addChild:haikuLabel];
   
    [haikuLabel setVisible:YES];
    
    [reviveHaikuText setString:[NSString stringWithFormat:@" -%d",haikuCost ]];
    
    if(!_paused)
        _paused=YES;
    
    [self setOpacity:210];
}
-(void) resumeWithContinue {
    
    
    if(_paused )
        _paused = NO;
    [gameScene showPause];
    [self setOpacity:0];
    
    
    
    [continueMenu_ setVisible:NO];
    [continueMenu_ setEnabled:NO];
    [continueLabel setVisible:NO];
     [haikuLabel setVisible:NO];
    toFeature.visible=NO;
    //haikuCounter_.visible=NO;
    
    haikuCost++;
    
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

-(void) setMenuEnabled {
    [continueMenu_ setEnabled:YES];
}

- (void) triggerRepeatBounceForSprite:(CCSprite*) sprite
{

    float scaleFactor = size.height/size.width;
    float dur1 = [GameUtility randDub:.3 :.45];
    float dur2 = dur1-.1;
    float dur3 = dur2-.05;
    
    CCMoveBy * down00 =[CCMoveBy actionWithDuration:dur3 position:CGPointMake(0, -.5*scaleFactor)];
    CCMoveBy * down0 =[CCMoveBy actionWithDuration:dur2 position:CGPointMake(0, -1.3*scaleFactor)];
    CCMoveBy * down1 =[CCMoveBy actionWithDuration:dur1 position:CGPointMake(0, -3*scaleFactor)];
    CCMoveBy * down2 =[CCMoveBy actionWithDuration:dur2 position:CGPointMake(0, -1.3*scaleFactor)];
    CCMoveBy * down3 =[CCMoveBy actionWithDuration:dur3 position:CGPointMake(0, -.5*scaleFactor)];
    id seq = [CCSequence actions: down00, down0, down1,down2,down3,[down3 reverse],[down2 reverse],[down1 reverse], [down0 reverse], [down00 reverse], nil];
    id repeat = [CCRepeatForever actionWithAction:seq];
    
    [sprite runAction:repeat];
}


@end
