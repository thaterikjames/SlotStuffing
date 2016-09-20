//
//  BlankTile.m
//  Dont Tap the Crack
//
//  Created by Erik James on 6/1/14.
//  Copyright 2014 Gangsta Apps. All rights reserved.
//

#import "GameTile.h"
#import "GameDataManager.h"
#import "UserDataManager.h"
#import "SlotSymbol.h"

@implementation GameTile
{
    NSMutableArray *symbols;
    BOOL stopRequested;
    
    
    
}

-(id)initWithSprite:(CCSprite *)sprite
{
    if(self = [self init]){
        
        CCNodeColor *scissorRect = [CCNodeColor nodeWithColor:[CCColor clearColor] width:sprite.contentSize.width height:sprite.contentSize.height];
        //[scissorRect setAnchorPoint:ccp(0.5,0.5f)];
        //[scissorRect setPosition:ccp(240,160)];
        
        
        scissor = [CCClippingNode clippingNodeWithStencil:scissorRect];
        [scissor setContentSize:self.contentSize];
        //[scissor setPositionType:CCPositionTypeNormalized];
        [scissor setAlphaThreshold:0.0];
        
         [self setView:sprite];
        [self addChild:_view];
        [self addChild:scissor];
        [sprite setPosition:ccp(sprite.contentSize.width/2, sprite.contentSize.height/2)];
        //[sprite setScale:0.9f];
       //  [self addChild:scissor];
        _hasBeenClicked = NO;
    }
    
   
    return self;
}

-(id)init
{
    if(self = [super init])
    {
        self.userInteractionEnabled = YES;
        
        
        
    }
    return self;
}

    
-(void)onEnter{
    
    [super onEnter];
    
    _locked = NO;
    NSArray *symbolNames = @[@"cherries",@"lemon",@"orange"];
    
    symbols = [[NSMutableArray alloc] init];
    
    int totalSymbols = (arc4random() % 8) + 3;
     for(int i = 0; i < totalSymbols; i++){
         [symbols addObject:[SlotSymbol spriteWithSymbolNamed:[symbolNames objectAtIndex:arc4random() % [symbolNames count]] ]];
     }
    
    
    if(!_cracked && !_goTile){
        stopRequested = NO;
        CCSprite *symbol;
        for(int i = 0; i < [symbols count]; i++){
            symbol = [symbols objectAtIndex:i];
            [symbol setScale:0.5f];
            [symbol setPosition:ccp(40,40 + (i * 80))];
            //[symbol setPositionType:CCPositionTypeNormalized];
            [scissor addChild:symbol];
        }
         [self schedule:@selector(updateSymbols) interval:0.02f];
    }
    
   
}

-(void)updateSymbols
{
    CCSprite *symbol;
    for(int i = 0; i < [symbols count]; i++){
        symbol = [symbols objectAtIndex:i];
        [symbol setPosition:ccp(symbol.position.x, symbol.position.y - 8)];
        if(symbol.position.y <= -40){
            [symbol setPosition:ccp(symbol.position.x, symbol.position.y + ([symbols count] * 80))];
        }
        if(stopRequested && symbol.position.y == 40){
            [self unschedule:@selector(updateSymbols)];
        }
    }
}

-(NSString *)clicked
{
    if(_hasBeenClicked)
        return @"";
    
    _hasBeenClicked = YES;
    

    CCSprite *sprite;
    
    sprite = [CCSprite spriteWithImageNamed:@"tile_selected.png"];
    
    
    
//    [sprite setScale:0.5f];
    [sprite setPosition:ccp(_view.contentSize.width/2, _view.contentSize.height/2)];
    [self addChild:sprite];
//
    [sprite runAction:[CCActionFadeTo actionWithDuration:0.2f opacity:0.3f]];
    
    if(!_cracked && !_goTile){
        stopRequested = YES;
        
        SlotSymbol *symbol;
        for(int i = 0; i < [symbols count]; i++){
            symbol = [symbols objectAtIndex:i];
            if(MIN(MAX(symbol.position.y,40), 120) == symbol.position.y){
                return [symbol symbolName];
            }
        }
        
    }
    
    
    return @"";
}

-(CGRect)getRect
{
    return CGRectMake(self.position.x, self.position.y, _view.contentSize.width, _view.contentSize.height);
}

-(void)setCrackCallback:(SEL)theCallback forId:(id)theId{
    callback = theCallback;
    callBackObject = theId;
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CCLOG(@"Received a touch");
}
-(void)onExit
{
    [super onExit];
}

@end
