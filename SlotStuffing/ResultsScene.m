//
//  ResultsScene.m
//  SlotStuffing
//
//  Created by Erik James on 11/25/14.
//  Copyright 2014 Blue Shell. All rights reserved.
//

#import "ResultsScene.h"
#import "SlotSymbol.h"
#import "IntroScene.h"
#import "GameScene.h"

@implementation ResultsScene
{
    NSArray *resultsArray;
}

+ (ResultsScene *)sceneWithResults:(NSArray *)results
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
    buttonsLayout.anchorPoint = ccp(0.5, 0.5);
    buttonsLayout.spacing = 1.0f;
    buttonsLayout.direction = CCLayoutBoxDirectionVertical;
    [buttonsLayout layout];
    buttonsLayout.positionType = CCPositionTypeNormalized;
    buttonsLayout.position = ccp(0.5f, 0.6f);
    
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
    
    int grandTotal = 0;
    
    for (int i = 0; i < [fruit count]; i++){
        CCLayoutBox *rowLayout = [[CCLayoutBox alloc] init];
        
        rowLayout.anchorPoint = ccp(0.5, 0.5);
        rowLayout.spacing = 0.0f;
        rowLayout.direction = CCLayoutBoxDirectionHorizontal;
        
        [rowLayout layout];
        rowLayout.positionType = CCPositionTypeNormalized;
        rowLayout.position = ccp(0.5f, 0.5f);
        
        SlotSymbol *symbol = [SlotSymbol spriteWithSymbolNamed:[fruit objectAtIndex:i]];
        symbol.positionType = CCPositionTypeNormalized;
        [symbol setScale:0.7f];
        symbol.position = ccp(0.5f, 0.5f);
        
        CCNodeColor *column1 = [CCNodeColor nodeWithColor:[CCColor blackColor] width:100 height:50];
        column1.positionType = CCPositionTypeNormalized;
        [column1 addChild:symbol];
//        CCSprite *column1 = [CCSprite spriteWithImageNamed:@"results_column1.png"];
//        column1.positionType = CCPositionTypeNormalized;
//        [column1 addChild:symbol];
        [rowLayout addChild:column1];
        
        
        NSMutableString *scores = [[NSMutableString alloc] init];
        NSArray *scoresArray = [results objectForKey:[fruit objectAtIndex:i]];
        if([scoresArray count] == 0){
            [scores appendString:@"-"];
        } else {
            for(int j = 0; j < [scoresArray count]; j++){
                [scores appendFormat:@"%lix ", (long)[[scoresArray objectAtIndex:j] integerValue]];
            }

        }
        
        CCLabelTTF *combos = [CCLabelTTF labelWithString:scores fontName:@"Avenir-Black" fontSize:24.0f];
        [combos setHorizontalAlignment:CCTextAlignmentLeft];
        combos.anchorPoint = ccp(0.0, 0.5);
        combos.positionType = CCPositionTypeNormalized;
        combos.color = [CCColor whiteColor];
        combos.position = ccp(0.1f, 0.5f);
        
        CCNodeColor *column2 = [CCNodeColor nodeWithColor:[CCColor blackColor] width:100 height:50];
        column2.positionType = CCPositionTypeNormalized;
        [column2 addChild:combos];
        [rowLayout addChild:column2];
        
        grandTotal += [(NSNumber *)[totalScores objectForKey:[fruit objectAtIndex:i]] intValue];
        
        CCLabelTTF *score = [CCLabelTTF labelWithString:[ResultsScene returnFormattedDollarAmount:[(NSNumber *)[totalScores objectForKey:[fruit objectAtIndex:i]] intValue]] fontName:@"Avenir-Black" fontSize:24.0f];
        [score setHorizontalAlignment:CCTextAlignmentRight];
        score.anchorPoint = ccp(1.0, 0.5);
        score.positionType = CCPositionTypeNormalized;
        score.color = [CCColor whiteColor];
        score.position = ccp(0.8f, 0.5f);
        
        CCNodeColor *column3 = [CCNodeColor nodeWithColor:[CCColor blackColor] width:120 height:50];
        column3.positionType = CCPositionTypeNormalized;
        [column3 addChild:score];
        [rowLayout addChild:column3];
        
        [buttonsLayout addChild:rowLayout];
    }
    
    [self addChild:buttonsLayout];
    
    
    CCLabelTTF *score = [CCLabelTTF labelWithString:[ResultsScene returnFormattedDollarAmount:
                                                     grandTotal] fontName:@"Avenir-Black" fontSize:24.0f];
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
