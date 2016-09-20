//
//  ResultsScene.m
//  SlotStuffing
//
//  Created by Erik James on 11/25/14.
//  Copyright 2014 Blue Shell. All rights reserved.
//

#import "ResultsSceneAlt.h"
#import "SlotSymbol.h"
#import "IntroScene.h"
#import "GameScene.h"

@implementation ResultsSceneAlt
{
    NSArray *resultsArray;
}

+ (ResultsSceneAlt *)sceneWithResults:(NSArray *)results
{
    return [[self alloc] initWithResults:results];
}


- (id)initWithResults:(NSArray *)results
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    resultsArray = results;
    
    return self;
}

-(void)onEnter
{
    [super onEnter];
    
    CCSprite *bkg = [CCSprite spriteWithImageNamed:@"bg-results.png"];
    [bkg setPosition:ccp(320/2, 568/2)];
    [self addChild:bkg];
    
    NSLog(@"resultsArray = %@", resultsArray);
    
    CCLayoutBox *buttonsLayout = [[CCLayoutBox alloc] init];
    buttonsLayout.anchorPoint = ccp(0.5, 1.0);
    buttonsLayout.spacing = -5.0f;
    buttonsLayout.direction = CCLayoutBoxDirectionVertical;
    [buttonsLayout layout];
    buttonsLayout.positionType = CCPositionTypeNormalized;
    buttonsLayout.position = ccp(0.5f, 0.85f);
    
    NSArray *fruit = @[@"watermelon",@"pear",@"lemon", @"cherry", @"apple"];
    
    NSDictionary *payLines =
    @{@"apple" : @[@0, @2, @10, @100, @1000, @10000, @100000, @1000000],
      @"cherry" : @[@0, @2, @10, @100, @1000, @10000, @100000, @1000000],
      @"lemon" : @[@0, @2, @10, @100, @1000, @10000, @100000, @1000000],
      @"pear" : @[@0, @5, @20, @100, @1000, @10000, @100000, @1000000],
      @"watermelon" : @[@0, @5, @20, @100, @1000, @10000, @100000, @1000000]
      };
    
    NSMutableDictionary *results = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < [fruit count]; i++){
        [results setObject:[[NSMutableArray alloc] init] forKey:[fruit objectAtIndex:i]];
    }
    
    NSMutableDictionary *totalScores = [[NSMutableDictionary alloc] init];
    
    [totalScores setObject:@0 forKey:@"apple"];
    [totalScores setObject:@0 forKey:@"cherry"];
    [totalScores setObject:@0 forKey:@"lemon"];
    [totalScores setObject:@0 forKey:@"pear"];
    [totalScores setObject:@0 forKey:@"watermelon"];
    
    
    NSString *lastSymbol = @"";
    NSString *thisSymbol;
    int currentSymbolCount = 1;
    for(int i = 0; i < [resultsArray count]; i++){
        thisSymbol = [resultsArray objectAtIndex:i];
        if([thisSymbol isEqualToString:lastSymbol]){
            currentSymbolCount++;
            
            if(currentSymbolCount > 1 && i==([resultsArray count]-1)){
                [(NSMutableArray *)[results objectForKey:lastSymbol] addObject:[NSNumber numberWithLong:currentSymbolCount]];
                
                NSNumber *thisPay = [[payLines objectForKey:lastSymbol] objectAtIndex:currentSymbolCount - 1];
                long currentPay = [[totalScores objectForKey:lastSymbol] integerValue];
                long newTotal = [thisPay integerValue] + currentPay;
                
                [totalScores setObject:[NSNumber numberWithLong:newTotal] forKey:lastSymbol];
            }
            
        } else if(![lastSymbol isEqualToString:@""]){
            if(currentSymbolCount > 1){
                [(NSMutableArray *)[results objectForKey:lastSymbol] addObject:[NSNumber numberWithInt:currentSymbolCount]];
                
                NSNumber *thisPay = [[payLines objectForKey:lastSymbol] objectAtIndex:currentSymbolCount - 1];
                long currentPay = [[totalScores objectForKey:lastSymbol] integerValue];
                long newTotal = [thisPay integerValue] + currentPay;
                
                [totalScores setObject:[NSNumber numberWithLong:newTotal] forKey:lastSymbol];
            }
            currentSymbolCount = 1;
        } else {
            currentSymbolCount = 1;
        }
        
        lastSymbol = thisSymbol;
    }
    
    NSMutableArray *groups = [[NSMutableArray alloc] init];
    [groups addObject:[[NSMutableArray alloc] init]];
    [groups addObject:[[NSMutableArray alloc] init]];
    [groups addObject:[[NSMutableArray alloc] init]];
    [groups addObject:[[NSMutableArray alloc] init]];
    [groups addObject:[[NSMutableArray alloc] init]];
    [groups addObject:[[NSMutableArray alloc] init]];
    [groups addObject:[[NSMutableArray alloc] init]];
    [groups addObject:[[NSMutableArray alloc] init]];
    [groups addObject:[[NSMutableArray alloc] init]];
    
    int grandTotal = 0;
    int totalAdded = 0;
    CCLayoutBox *rowLayout;
    
    for (int i = 0; i < [fruit count]; i++){
        
        NSArray *scoresArray = [results objectForKey:[fruit objectAtIndex:i]];
        grandTotal += [(NSNumber *)[totalScores objectForKey:[fruit objectAtIndex:i]] intValue];
        for(int j = 0; j < [scoresArray count]; j++){
            totalAdded++;
            rowLayout = [[CCLayoutBox alloc] init];
            
            rowLayout.anchorPoint = ccp(0.5, 0.5);
            rowLayout.spacing = 0.0f;
            rowLayout.direction = CCLayoutBoxDirectionHorizontal;
            
            [rowLayout layout];
            rowLayout.positionType = CCPositionTypeNormalized;
            rowLayout.position = ccp(0.5f, 0.5f);
            
            CCNodeColor *column1 = [CCNodeColor nodeWithColor:[CCColor blackColor] width:100 height:50];
            column1.zOrder = 5;
            column1.positionType = CCPositionTypeNormalized;
            column1.anchorPoint = ccp(0.0f, 0.5f);
            int numberOfFruit = (int)[(NSNumber *)[scoresArray objectAtIndex:j] integerValue];
            
            CCLayoutBox *fruitLayout = [[CCLayoutBox alloc] init];
            
            fruitLayout.anchorPoint = ccp(0.0, 0.5);
            fruitLayout.spacing = -25.0f;
            fruitLayout.direction = CCLayoutBoxDirectionHorizontal;
            
            for(int k = 0; k < numberOfFruit; k++){
                SlotSymbol *symbol = [SlotSymbol spriteWithSymbolNamed:[fruit objectAtIndex:i]];
                symbol.positionType = CCPositionTypeNormalized;
                [symbol setScale:0.5f];
                [fruitLayout addChild:symbol];
                [symbol bounce];
            }
            
            [fruitLayout layout];
            fruitLayout.positionType = CCPositionTypeNormalized;
            fruitLayout.position = ccp(0.0f, 0.5f);
            
            
            [column1 addChild:fruitLayout];
            [rowLayout addChild:column1];
            
            CCNodeColor *column2 = [CCNodeColor nodeWithColor:[CCColor blackColor] width:100 height:50];
            column2.zOrder = 2;
            column2.positionType = CCPositionTypeNormalized;
            //[column2 addChild:combos];
            [rowLayout addChild:column2];
            NSNumber *thisPay = [[payLines objectForKey:[fruit objectAtIndex:i]] objectAtIndex:[(NSNumber *)[scoresArray objectAtIndex:j] integerValue] - 1];
            
            
            CCLabelTTF *score = [CCLabelTTF labelWithString:[ResultsSceneAlt returnFormattedDollarAmount:(int)[thisPay longValue]] fontName:@"Avenir-Black" fontSize:24.0f];
            
            [score setHorizontalAlignment:CCTextAlignmentRight];
            score.anchorPoint = ccp(1.0, 0.5);
            score.positionType = CCPositionTypeNormalized;
            score.color = [CCColor whiteColor];
            score.position = ccp(0.8f, 0.5f);
            
            CCNodeColor *column3 = [CCNodeColor nodeWithColor:[CCColor blackColor] width:120 height:50];
            column3.positionType = CCPositionTypeNormalized;
            [column3 addChild:score];
            [rowLayout addChild:column3];
            
            if(totalAdded < 7)
                [buttonsLayout addChild:rowLayout];
            
        }
        

    }
    
    [self addChild:buttonsLayout];
    
    
    CCLabelTTF *score = [CCLabelTTF labelWithString:[ResultsSceneAlt returnFormattedDollarAmount:
                                                     grandTotal] fontName:@"Avenir-Black" fontSize:28.0f];
    [score setHorizontalAlignment:CCTextAlignmentRight];
    score.positionType = CCPositionTypeNormalized;
    score.color = [CCColor whiteColor];
    score.anchorPoint = ccp(1.0, 0.5);
    score.position = ccp(0.92f, 0.29f);
    [self addChild:score];
    
    
    CCButton *menuButton = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"button-back.png"]];
    menuButton.positionType = CCPositionTypeNormalized;
    menuButton.position = ccp(0.2f, 0.08f);
    [menuButton setTarget:self selector:@selector(onMenuClicked:)];
    [self addChild:menuButton];
    
    CCButton *againButton = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"button-again.png"]];
    againButton.positionType = CCPositionTypeNormalized;
    againButton.position = ccp(0.7f, 0.08f);
    [againButton setTarget:self selector:@selector(onAgainClicked:)];
    [self addChild:againButton];
    
    
}

+(NSString *)returnFormattedDollarAmount:(int)amount
{
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    return [NSString stringWithFormat:@"$%@", [formatter stringFromNumber:[NSNumber numberWithInt:amount]]];
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onMenuClicked:(id)sender
{
    // start spinning scene with transition
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    [audio playEffect:@"all-ui-buttons-default.wav" loop:NO];
    [[OALSimpleAudio sharedInstance] stopBg];
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]];
}


- (void)onAgainClicked:(id)sender
{
    // start spinning scene with transition
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    [audio playEffect:@"all-ui-buttons-default.wav" loop:NO];
    
    [[CCDirector sharedDirector] replaceScene:[GameScene scene]];
}



@end
