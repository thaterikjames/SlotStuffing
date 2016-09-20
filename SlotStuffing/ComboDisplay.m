//
//  ComboDisplay.m
//  SlotStuffing
//
//  Created by Erik James on 11/25/14.
//  Copyright 2014 Blue Shell. All rights reserved.
//

#import "ComboDisplay.h"
#import "SlotSymbol.h"

@implementation ComboDisplay
{
    int amountOfFruit;
    NSString *fruit;
}

+(ComboDisplay *)comboWithNumber:(int)amount ofFruit:(NSString *)fruitType;
{
    return [[self alloc] initWithNumber:amount ofFruit:fruitType];
}

- (id)initWithNumber:(int)amount ofFruit:(NSString *)fruitType
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    amountOfFruit = amount;
    fruit = fruitType;
    
    return self;
}

-(void)onEnter
{
    [super onEnter];
    
    [self addChild:[CCSprite spriteWithImageNamed:@"combo-layer.png"]];
    
    
    CCLayoutBox *vertLayout = [[CCLayoutBox alloc] init];
    vertLayout.anchorPoint = ccp(0.5, 0.5);
    vertLayout.spacing = -10.0f;
    vertLayout.direction = CCLayoutBoxDirectionVertical;
    vertLayout.positionType = CCPositionTypeNormalized;
    vertLayout.position = ccp(0.5f, 0.5f);
    
    CCLabelTTF *combos = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i %@ Combo!", amountOfFruit, fruit] fontName:@"AvenirNext-HeavyItalic" fontSize:24.0f];
    [combos setHorizontalAlignment:CCTextAlignmentCenter];
    combos.positionType = CCPositionTypeNormalized;
    combos.color = [CCColor whiteColor];
    combos.position = ccp(0.5f, 0.25f);
    [vertLayout addChild:combos];
    
    
    CCLayoutBox *rowLayout = [[CCLayoutBox alloc] init];
    rowLayout.anchorPoint = ccp(0.5, 0.5);
    rowLayout.spacing = -10.0f;
    rowLayout.direction = CCLayoutBoxDirectionHorizontal;
    rowLayout.positionType = CCPositionTypeNormalized;
    rowLayout.position = ccp(0.5f, 0.85f);
    for(int i = 0; i < amountOfFruit; i++){
        SlotSymbol *symbol = [SlotSymbol spriteWithSymbolNamed:fruit];
        [symbol setScale:0.65];
        [rowLayout addChild:symbol];
    }
    [rowLayout layout];
    [vertLayout addChild:rowLayout];
    
   
    
    [vertLayout layout];
    [self addChild:vertLayout];
}

@end



