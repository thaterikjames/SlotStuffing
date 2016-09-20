//
//  GameScene.m
//  SlotStuffing
//
//  Created by Erik James on 11/24/14.
//  Copyright 2014 Blue Shell. All rights reserved.
//

#import "GameScene.h"
#import "ComboDisplay.h"
#import "GameTile.h"
#import "ResultsScene.h"
#import "ResultsSceneAlt.h"
#import "UserDataManager.h"
#import "ScrollingGradient.h"

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
    NSDictionary *payLines;
    
    NSMutableArray *currentResults;
    
    CCLabelTTF *bankDisplay;
    CCLabelTTF *linesDisplay;
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
    
    currentSpeed = 4.5f;
    totalDotsThisLevel = [[UserDataManager sharedInstance] getLines];
    
    payLines =
    @{@"apple" : @[@0, @2, @10, @100, @1000, @10000, @100000, @1000000],
      @"cherry" : @[@0, @2, @10, @100, @1000, @10000, @100000, @1000000],
      @"lemon" : @[@0, @2, @10, @100, @1000, @10000, @100000, @1000000],
      @"pear" : @[@0, @5, @20, @100, @1000, @10000, @100000, @1000000],
      @"watermelon" : @[@0, @5, @20, @100, @1000, @10000, @100000, @1000000]
      };
    
    return self;
}


-(void)onEnter
{
    [super onEnter];
    
    totalDotsThisLevel = [[UserDataManager sharedInstance] getLines];
    
    ScrollingGradient *gradient = [[ScrollingGradient alloc] init];
    [gradient setPosition:ccp(320/2, 568/2)];
    [self addChild:gradient];
    
    CCSprite *bkg = [CCSprite spriteWithImageNamed:@"middle-path.png"];
    [bkg setPosition:ccp(320/2, 568/2)];
    [self addChild:bkg];
  
    
    tileHolder = [[CCNode alloc] init];
    tileHolder.userInteractionEnabled = YES;
    [tileHolder setPosition:ccp(20,0)];
    [self addChild: tileHolder];
    // Enable touch handling on scene node
    self.userInteractionEnabled = YES;
    
    [self populate:4];
    
    CCSprite *hudBKG = [CCSprite spriteWithImageNamed:@"hud-top-bg.png"];
    [hudBKG setPosition:ccp(320/2, 568 - (hudBKG.contentSize.height/2))];
    [self addChild:hudBKG];
    
    
    bankDisplay = [CCLabelTTF labelWithString:[ResultsScene returnFormattedDollarAmount:
                                                     [[UserDataManager sharedInstance] getBank]] fontName:@"Avenir-Black" fontSize:36.0f];
    [bankDisplay setHorizontalAlignment:CCTextAlignmentRight];
    bankDisplay.positionType = CCPositionTypeNormalized;
    bankDisplay.color = [CCColor whiteColor];
    bankDisplay.position = ccp(0.5f, 0.96f);
    [self addChild:bankDisplay];
    
    
    linesDisplay = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Lines: %li", (long)totalDotsThisLevel] fontName:@"Avenir-Black" fontSize:24.0f];
    [linesDisplay setHorizontalAlignment:CCTextAlignmentRight];
    linesDisplay.positionType = CCPositionTypeNormalized;
    linesDisplay.color = [CCColor greenColor];
    linesDisplay.position = ccp(0.5f, 0.9f);
    [self addChild:linesDisplay];
    
    NSTimeInterval theTimeInterval = 8;
    
    [[OALSimpleAudio sharedInstance] preloadBg:@"Tropicool & Peitzke - Cat Call.mp3" seekTime:theTimeInterval];
    
}

-(void)updateBank
{
    [bankDisplay setString:[ResultsScene returnFormattedDollarAmount:
                            [[UserDataManager sharedInstance] getBank]]];
}

-(void)start
{
    dotsGatheredThisLevel = 0;
    
    currentResults = [[NSMutableArray alloc] init];
    
    [self schedule:@selector(updateTiles) interval:0.02f];

    [[OALSimpleAudio sharedInstance] playBgWithLoop:YES];
    
    int currentBank = [[UserDataManager sharedInstance] getBank] - [[UserDataManager sharedInstance] getBet];
    [[UserDataManager sharedInstance] setBank:currentBank];
    [self updateBank];
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
    clickOrder = 0;
    
    while(totalHeight  < windowHeight){
        int randomBlankTIle = arc4random() % amountPerRow;
        
        for(int i = 0; i < amountPerRow; i++){
            
            if(i == randomBlankTIle){
                
                if(goAdded || ((totalHeight + tileHeight) < windowHeight )){
                    dotsGeneratedThisLevel++;
                    clickOrder++;
                    tile = [[GameTile alloc] initWithSprite:[self getTargetSprite]];
                    tile.goTile = NO;
                    tile.clickOrder = clickOrderOffset - clickOrder;
                    [tile setComboCallback:@selector(addToCombo:) forId:self];
                } else {
                    tile = [[GameTile alloc] initWithSprite:[self getGoSprite]];
                    tile.clickOrder = 0;
                    goAdded = YES;
                    tile.goTile = YES;
                }
                tile.cracked = NO;
            } else{
               tile = [[GameTile alloc] initWithSprite:[self getWrongSprite]];
                tile.cracked = YES;
                
            }
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
        if(tile.position.y >= (windowHeight)){
            
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
                [tile setComboCallback:@selector(addToCombo:) forId:self];
            } else {
                
                tile = [[GameTile alloc] initWithSprite:[self getWrongSprite]];
                tile.cracked = YES;
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
    return [CCSprite spriteWithImageNamed:@"tile-white.png"];
}

-(CCSprite *)getWrongSprite
{
    return [CCSprite spriteWithImageNamed:@"tile-empty.png"];
}

-(CCSprite *)getGoSprite
{
    return [CCSprite spriteWithImageNamed:@"tile-go.png"];
}

-(void)stopTimers
{
    [self unschedule:@selector(updateTiles)];
}

-(void)stop
{
    locked = YES;
    [self stopTimers];
    
    [[CCDirector sharedDirector] replaceScene:[ResultsSceneAlt sceneWithResults:currentResults]];
}


- (CGPoint) positionOfTouch:(UITouch *)touch
{
    // Get the position of the touch.  For some reason this uses a coordinate system with (0, 0) being the
    // top-left of the screen, so adjust it so (0, 0) is the bottom-left.
    
    CGPoint touchPosition = [touch locationInView:[touch view]];
    touchPosition.y = [[CCDirector sharedDirector] viewSize].height - touchPosition.y;
    return touchPosition;
}

-(void)addToCombo:(NSString *)fruit
{
    [currentResults addObject:fruit];
    [self checkForBrokenCombo];
}

-(void)checkForBrokenCombo
{
    if([currentResults count] <3){
        return;
    }
    
    if(!locked && [(NSString *)[currentResults objectAtIndex:[currentResults count] -1] isEqualToString:(NSString *)[currentResults objectAtIndex:[currentResults count] -2]]){
        return;
    }
    
    NSString *lastSymbolName = [currentResults objectAtIndex:[currentResults count]-2];
    
    int lastCheckIndex = (int)[currentResults count] - 3;
    
    if(locked){
        if([(NSString *)[currentResults objectAtIndex:[currentResults count] -1] isEqualToString:(NSString *)[currentResults objectAtIndex:[currentResults count] -2]]){
            lastCheckIndex = (int)[currentResults count] - 2;
        }
    }
    
    
    int comboLength = 1;
    
    for(int i = lastCheckIndex; i >=0; i--){
        if([(NSString *)[currentResults objectAtIndex:i] isEqualToString:lastSymbolName]){
            comboLength++;
        } else {
            break;
        }
    }
    
    if(comboLength > 1){
        ComboDisplay *combo = [ComboDisplay comboWithNumber:comboLength ofFruit:lastSymbolName];
        [combo setPosition:ccp(-320/2, 408 - (combo.contentSize.height/2))];
        [self addChild:combo];
        
        [combo runAction:[CCActionSequence actions:[CCActionEaseElasticOut actionWithAction:[CCActionMoveTo actionWithDuration:0.5f
        position:ccp(320/2, 408 - (combo.contentSize.height/2))] period:0.6f],
        [CCActionDelay actionWithDuration:0.5f], [CCActionMoveTo actionWithDuration:0.15f position:ccp(480, 408 - (combo.contentSize.height/2))],
        [CCActionRemove action],nil]];
        
        int award = [[(NSArray *)[payLines objectForKey:lastSymbolName] objectAtIndex:(comboLength - 1)] intValue];
        
        int currentBank = [[UserDataManager sharedInstance] getBank] + award;
        [[UserDataManager sharedInstance] setBank:currentBank];
        
        CCActionCallBlock *update = [CCActionCallBlock actionWithBlock:^{
            [self updateBank];
        }];
        
        CCLabelTTF *bonusLabel = [CCLabelTTF labelWithString:[ResultsScene returnFormattedDollarAmount:
                                                                                     award] fontName:@"Avenir-Black" fontSize:48.0f];
        [bonusLabel setHorizontalAlignment:CCTextAlignmentCenter];
        bonusLabel.color = [CCColor whiteColor];
        
        
        [bonusLabel setHorizontalAlignment:CCTextAlignmentCenter];
        [bonusLabel setScale:1.0f];
        bonusLabel.position = ccp(combo.contentSize.width/2, combo.contentSize.height/2);
        [combo addChild:bonusLabel];
        [bonusLabel runAction:[CCActionSequence actions:[CCActionFadeTo actionWithDuration:1.0f opacity:0.8f],
                               [CCActionFadeTo actionWithDuration:1.0f opacity:0.0f],nil]];
        
        [bonusLabel runAction:[CCActionSequence actions:[CCActionMoveBy actionWithDuration:1.0f position:ccp(0,100)],update,nil]];
        
        OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
        [audio playEffect:@"combo.wav" loop:NO];
    }
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if(locked)
        return;
    
   CGPoint touchPoint = [self positionOfTouch:touch];
    touchPoint.y -= tileHolder.position.y;
    touchPoint.x -= tileHolder.position.x;
    // NSLog(@"click");
    NSArray *theChildren = [tileHolder children];
    
    
    for (GameTile *child in theChildren){
        
        if(CGRectContainsPoint([child getRect], touchPoint)){
            
            if(child.cracked){
                [child clicked];
                
                OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
                [audio playEffect:@"lose2.wav" loop:NO];
                
                locked = YES;
                [self performSelector:@selector(stop) withObject:self afterDelay:0.5f];
                return;
            }
            
            if(goClicked ){
               
                if(child.clickOrder == nextClick){
                    [child clicked];
                    
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
                    
                }
                
            } else if(child.goTile){

                
                OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
                [audio playEffect:@"tile-touch.wav" loop:NO];
                
                
                nextClick++;
                goClicked = YES;
                [child clicked];
                [self start];
                
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
        
    }
}

-(void)correctClick:(GameTile *)tile
{
    
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    [audio playEffect:@"tile-touch.wav" loop:NO];
    
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
    
     [linesDisplay setString:[NSString stringWithFormat:@"Lines: %li", ((long)totalDotsThisLevel - ++dotsGatheredThisLevel)]];
    
    if( dotsGatheredThisLevel >= totalDotsThisLevel){
        locked = YES;
        //[self stopTimers];
        [self performSelector:@selector(stop) withObject:self afterDelay:2.5f];
        NSLog(@"currentResults = %@", currentResults);
    }
    NSLog(@"dotsGatheredThisLevel = %i", dotsGatheredThisLevel);
}


@end
