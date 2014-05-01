#import "TreeLayer.h"


@implementation TreeLayer

-(id)init
{
    if(self=[super init])
    {
        CGSize size = [[CCDirector sharedDirector] winSize];
        CCSprite *background;
		background = [CCSprite spriteWithFile:@"loltree.png"];
        
		background.anchorPoint = CGPointMake(0, 0);
		
		// add the image as a child to this Layer
		[self addChild: background z:0];
        
    }
    return self;
}

@end
