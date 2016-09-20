//
//  GameScene.m
//  SlotStuffing
//
//  Created by Erik James on 11/24/14.
//  Copyright 2014 Blue Shell. All rights reserved.
//

#import "GameScene.h"
//#import "GameDataManager.h"
#import "GameTile.h"

@implementation GameScene
{
    BOOL autoAdvanceTiles;
    BOOL goClicked;
    BOOL locked;
    
    float currentSpeed;
    unsigned long clickOrder;
    unsigned long nextClick;
    NSInteger totalDotsThisLevel;
    int dotsGatheredThisLevel;
    int dotsGeneratedThisLevel;
}

+ (GameScene *)scene
{
    return [[self alloc] init];
}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    currentSpeed = 4.0f;
    totalDotsThisLevel = 20;
    
    return self;
}


-(void)onEnter
{
    [super onEnter];
    
   // GameTile *testTile = [[GameTile alloc] initWithSprite:[self getWrongSprite]];
    
    //[testTile setPosition:ccp(100,100)];
//    CCSprite *testSprite = [CCSprite spriteWithImageNamed:@"square_white.png"];
//    [testSprite setPosition:ccp(testSprite.contentSize.width/2,testSprite.contentSize.height/2)];
//    [self addChild:testSprite];
//    return;
    
    
    tileHolder = [[CCNode alloc] init];
    //tileHolder.positionType = CCPositionTypeNormalized;
    tileHolder.userInteractionEnabled = YES;
    [tileHolder setPosition:ccp(0,0)];
    [self addChild: tileHolder];
    // Enable touch handling on scene node
    self.userInteractionEnabled = YES;
    
//    GameTile * tile = [[GameTile alloc] initWithSprite:[self getTargetSprite]];
//    [tile setPosition:ccp(100,100)];
//    [tileHolder addChild:tile];
    
    [self populate:4];
    
   // [self start];
    
}

-(void)start
{
    dotsGatheredThisLevel = 0;
    
    [self schedule:@selector(updateTiles) interval:0.02f];

}


-(void)populate:(int)amountPerRow
{
    [tileHolder removeAllChildrenWithCleanup:YES];
    
    GameTile * tile = [[GameTile alloc] initWithSprite:[self getTargetSprite]];
    
    float totalHeight = 0;
    float totalWidth = 0;
    float currentX = 0;
    float currentY = -tile.view.contentSize.height;
    float tileHeight = 0;
    
    float windowHeight = self.contentSize.height/3;
    
    BOOL goAdded = NO;
   dotsGeneratedThisLevel = 0;
    
    int clickOrderOffset = (windowHeight/tile.view.contentSize.height) + 1;
    NSLog(@"clickOrderOffset = %i", clickOrderOffset);
    clickOrder = 0;
    
    while(totalHeight  < windowHeight){
        int randomBlankTIle = arc4random() % amountPerRow;
        
        for(int i = 0; i < amountPerRow; i++){
            
            if(i == randomBlankTIle){
                dotsGeneratedThisLevel++;
                if(goAdded || ((totalHeight + tileHeight) < windowHeight )){
                    clickOrder++;
                    tile = [[GameTile alloc] initWithSprite:[self getTargetSprite]];
                    tile.goTile = NO;
                    tile.clickOrder = clickOrderOffset - clickOrder;
                    
                } else {
                    //clickOrder = clickOrderOffset;
                    tile = [[GameTile alloc] initWithSprite:[self getGoSprite]];
                    tile.clickOrder = 0;
                    goAdded = YES;
                    tile.goTile = YES;
                }
                //tile.soundOrder = i;
                NSLog(@"tile.clickOrder = %lu", tile.clickOrder);
                tile.cracked = NO;
            } else{
               tile = [[GameTile alloc] initWithSprite:[self getWrongSprite]];
                tile.cracked = YES;
                
            }
            //tile.bonusStar = NO;
            
            
            [tile setPosition:ccp(currentX + tile.contentSize.width/2, currentY )];
            [tileHolder addChild:tile];
            
            
            tileHeight = tile.view.contentSize.height;
            currentX += tile.view.contentSize.width;
            
        }
        currentX = 0;
        totalHeight += tileHeight;
        currentY += tileHeight;
        totalWidth = 0;
    }
}


-(void)updateTiles
{
    //    if(currentSlowDown > 0){
    //        currentSlowDown--;
    //    }
    
    
        //NSLog(@"currentSpeed = %f", currentSpeed);
    [self updateScrollWithAmount:currentSpeed andAmountPerRow:4];
    
}

-(void)updateScrollWithAmount:(float)amount andAmountPerRow:(int)amountPerRow
{
    
    
    float windowHeight = self.contentSize.height;
    
    float tileHeight;
    
    NSArray *tiles = [tileHolder children];
    GameTile *tile;
    for(int i = 0; i < tiles.count; i++){
        tile = tiles[i];
        tileHeight = tile.view.contentSize.height;
        [tile setPosition:ccp(tile.position.x, tile.position.y + amount)];
    }
    float bottomY = windowHeight;
    
    for(int i = 0; i < tiles.count; i++){
        tile = tiles[i];
        bottomY = min(bottomY, tile.position.y);
        if(tile.position.y >= (windowHeight + tile.view.contentSize.height)){
            
            if(tile.cracked == NO && tile.hasBeenClicked == NO){
                locked = YES;
                [self stop];
                
                // Missed a click
                
            }
            
            [tileHolder removeChild:tile];
        }
    }
    
   
    
    if(bottomY > 0 && (dotsGeneratedThisLevel < totalDotsThisLevel)){
        float totalWidth = 0;
        float currentX = 0;
        float currentY = bottomY-tileHeight;
        int randomBlankTile = arc4random() % amountPerRow;
        for(int i = 0; i < amountPerRow; i++){
            GameTile *tile;
            if(i == randomBlankTile){
                dotsGeneratedThisLevel++;
                clickOrder++;
                tile = [[GameTile alloc] initWithSprite:[self getTargetSprite]];
                tile.cracked = NO;
                tile.goTile = NO;
                tile.clickOrder = clickOrder;
                tile.soundOrder = i;
                tile.bonusStar = NO;
            } else {
                
                
                tile = [[GameTile alloc] initWithSprite:[self getWrongSprite]];
                tile.cracked = YES;
                //tile.view.opacity = currentWrongOpacity;
                tile.goTile = NO;
                
            }
            [tile setPosition:ccp(currentX, currentY)];
            [tileHolder addChild:tile];
            
            totalWidth += tile.view.contentSize.width;
            currentX += tile.view.contentSize.width;
            
        }
    }
}

-(CCSprite *)getTargetSprite
{
    return [CCSprite spriteWithImageNamed:@"square_white.png"];
}

-(CCSprite *)getWrongSprite
{
    return [CCSprite spriteWithImageNamed:@"square_black.png"];
}

-(CCSprite *)getGoSprite
{
    return [CCSprite spriteWithImageNamed:@"square_go.png"];
}

-(void)stopTimers
{
    [self unschedule:@selector(updateTiles)];
}

-(void)stop
{
    locked = YES;
    [self stopTimers];
    
}


- (CGPoint) positionOfTouch:(UITouch *)touch
{
    // Get the position of the touch.  For some reason this uses a coordinate system with (0, 0) being the
    // top-left of the screen, so adjust it so (0, 0) is the bottom-left.
    
    CGPoint touchPosition = [touch locationInView:[touch view]];
    touchPosition.y = [[CCDirector sharedDirector] viewSize].height - touchPosition.y;
    return touchPosition;
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if(locked)
        return;
    
    
    CGPoint touchPoint = [self positionOfTouch:touch];
    
    
    
    touchPoint.y -= self.position.y;
    // NSLog(@"click");
    NSArray *theChildren = [tileHolder children];
    
    
    for (GameTile *child in theChildren){
        
        if(CGRectContainsPoint([child getRect], touchPoint)){
            
            if(child.cracked){
                [child clicked];
                
                locked = YES;
                [self stop];
                return;
            }
            
            if(goClicked ){
                NSLog(@"-------------");
                NSLog(@"child.clickOrder = %lu. nextClick == %lu", child.clickOrder,nextClick);
                NSLog(@"-------------");
                if(child.clickOrder == nextClick){
                    NSLog(@">>>> Clicked %@", [child clicked]);
                    //[self updateScore];
                    
                    [self correctClick:child];
                    
                    CCSprite *outline = [self getTargetSprite];
                    [outline setPosition:ccp(outline.contentSize.width/2, outline.contentSize.height/2)];
                    
                    [outline setOpacity:0.8f];
                    [child addChild:outline];
                    
                    CCActionCallBlock *removeMySprite = [CCActionCallBlock actionWithBlock:^{
                        [outline removeFromParentAndCleanup:YES];
                    }];
                    
                    CCActionSpawn *spawn = [CCActionSpawn actionOne:[CCActionScaleTo actionWithDuration:0.3f scale:2.0f] two:[CCActionFadeTo actionWithDuration:0.3f opacity:0.0f]];
                    
                    [outline runAction:
                     [CCActionSequence actions:
                      spawn,removeMySprite,
                      nil]];
                    
                    nextClick++;
                    
                    
                    // if(currentSpeed < 10){
                    
//                    if(autoAdvanceTiles){
//                        if(nextClick % nextLevel == 0){
//                            currentSpeed+= speedIncreaseAmount;
//                            //                            if(currentWrongOpacity < 1.0f){
//                            //                                currentWrongOpacity += 0.1f;
//                            //                            }
//                        }
//                    } else{
//                        //[self updateScrollWithAmount:timerAdvance andAmountPerRow:totalPerRow];
//                        timerUpdates += timePixelAdvanceAmount;
//                    }
                    // }
                }
                
            } else if(child.goTile){
                
//                if(nufScreenUp){
//                    nufScreenUp = NO;
//                    [self removeChild:nufScreen];
//                }
                
                nextClick++;
                goClicked = YES;
                [child clicked];
                [self start];
                
                [self correctClick:child];
                
                CCSprite *outline = [self getTargetSprite];
                
                [outline setPosition:ccp(outline.contentSize.width/2, outline.contentSize.height/2)];
                
                [outline setOpacity:0.8f];
                [child addChild:outline];
                
                CCActionCallBlock *removeMySprite = [CCActionCallBlock actionWithBlock:^{
                    [outline removeFromParentAndCleanup:YES];
                }];
                
                CCActionSpawn *spawn = [CCActionSpawn actionOne:[CCActionScaleTo actionWithDuration:0.3f scale:2.0f] two:[CCActionFadeTo actionWithDuration:0.3f opacity:0.0f]];
                
                [outline runAction:
                 [CCActionSequence actions:
                  spawn,removeMySprite,
                  nil]];
                
               
                
            }
            
            [child.view runAction:[CCActionSequence actionOne:[CCActionScaleTo actionWithDuration:0.1f scale:0.6f]
                                                          two:[CCActionScaleTo actionWithDuration:0.1f scale:0.9f]]];
            
            
            
            return;
            
        }
        
        //NSLog(@"------------");
    }
    
    
}

-(void)correctClick:(GameTile *)tile
{
    NSArray *theChildren = [tileHolder children];
    GameTile *child;
    for (int i = 0; i < theChildren.count; i++){
        
        child = theChildren[i];
        if(child.cracked == NO){
            continue;
        }
        if(ABS(child.position.y - tile.position.y) < 10){
            //[child.view setOpacity:0.3f];
            
            float fadeTime = ABS((child.position.x - tile.position.x)/child.view.contentSize.width) * .3f;
            float scaleSize = 1.0f - ABS((child.position.x - tile.position.x)/child.view.contentSize.width) * .15f;
            
            [child.view runAction:[CCActionFadeTo actionWithDuration:fadeTime opacity:0.1f]];
            [child.view runAction:[CCActionScaleTo actionWithDuration:fadeTime scale:scaleSize]];
            
        }
        
        
    }
    
    if( ++dotsGatheredThisLevel >= totalDotsThisLevel){
        locked = YES;
        [self stopTimers];
        [self performSelector:@selector(stop) withObject:self afterDelay:0.5f];
        
    }
    NSLog(@"dotsGatheredThisLevel = %i", dotsGatheredThisLevel);
    NSLog(@"totalDotsThisLevel = %li", (long)totalDotsThisLevel);
}


@end
