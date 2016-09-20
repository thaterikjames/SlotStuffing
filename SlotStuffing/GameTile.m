
#import "GameTile.h"
#import "SlotSymbol.h"

#define TILE_HEIGHT 96.0f

@implementation GameTile
{
    NSMutableArray *symbols;
    BOOL stopRequested;
    
}

-(id)initWithSprite:(CCSprite *)sprite
{
    if(self = [self init]){
        
        CCNodeColor *scissorRect = [CCNodeColor nodeWithColor:[CCColor clearColor] width:sprite.contentSize.width height:sprite.contentSize.height];
        scissor = [CCClippingNode clippingNodeWithStencil:scissorRect];
        [scissor setContentSize:self.contentSize];
        //[scissor setPositionType:CCPositionTypeNormalized];
        [scissor setAlphaThreshold:0.0];
        
         [self setView:sprite];
        [self addChild:_view];
        [self addChild:scissor];
        [sprite setPosition:ccp(sprite.contentSize.width/2, sprite.contentSize.height/2)];
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
    NSArray *symbolNames = @[@"apple",@"cherry",@"lemon", @"pear", @"watermelon"];
    
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
            [symbol setPosition:ccp(35,TILE_HEIGHT/2 + (i * TILE_HEIGHT))];
            [scissor addChild:symbol];
        }
         [self schedule:@selector(updateSymbols) interval:0.02f];
    }
    
   
}

-(void)updateSymbols
{
    SlotSymbol *symbol;
    for(int i = 0; i < [symbols count]; i++){
        symbol = [symbols objectAtIndex:i];
        [symbol setPosition:ccp(symbol.position.x, symbol.position.y - 8)];
        if(symbol.position.y <= -TILE_HEIGHT/2){
            [symbol setPosition:ccp(symbol.position.x, symbol.position.y + ([symbols count] * TILE_HEIGHT))];
        }
        if(stopRequested && symbol.position.y == TILE_HEIGHT/2){
            [self unschedule:@selector(updateSymbols)];
            [callBackObject performSelector:callback withObject:[symbol symbolName]];
            [symbol bounce];
        }
    }
}

-(NSString *)clicked
{
    if(_hasBeenClicked)
        return @"";
    
    _hasBeenClicked = YES;
    
    if(_cracked){
        CCSprite *sprite;
        
        sprite = [CCSprite spriteWithImageNamed:@"tile-empty-touch.png"];
        [sprite setPosition:ccp(_view.contentSize.width/2, _view.contentSize.height/2)];
        [self addChild:sprite];
    }
    
    if(!_cracked && !_goTile){
        stopRequested = YES;
        
        SlotSymbol *symbol;
        for(int i = 0; i < [symbols count]; i++){
            symbol = [symbols objectAtIndex:i];
            if(min(max(symbol.position.y,TILE_HEIGHT/2), TILE_HEIGHT * 1.5) == symbol.position.y){
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

-(void)setComboCallback:(SEL)theCallback forId:(id)theId{
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
