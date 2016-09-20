//
//  IntroScene.m
//  SlotStuffing
//
//  Created by Erik James on 11/24/14.
//  Copyright Blue Shell 2014. All rights reserved.
//
// -----------------------------------------------------------------------

// Import the interfaces
#import "IntroScene.h"
#import "GameScene.h"
#import "ResultsScene.h"
#import "UserDataManager.h"
#import "ScrollingGradient.h"

// -----------------------------------------------------------------------
#pragma mark - IntroScene
// -----------------------------------------------------------------------

@implementation IntroScene
{
    CCLabelTTF *betDisplay;
    CCLabelTTF *linesDisplay;
    
    int betAmount;
    int lines;
}

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (IntroScene *)scene
{
	return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    

    
    ScrollingGradient *gradient = [[ScrollingGradient alloc] init];
    [gradient setPosition:ccp(320/2, 568/2)];
    [self addChild:gradient];
    
    
    CCSprite *title = [CCSprite spriteWithImageNamed:@"home-logo.png"];
    title.positionType = CCPositionTypeNormalized;
    title.position = ccp(0.5f, 0.9f);
    [self addChild:title];
    
    
    CCSprite *panel = [CCSprite spriteWithImageNamed:@"game-panel-01.png"];
    panel.positionType = CCPositionTypeNormalized;
    panel.position = ccp(0.5f, 0.5f);
    [self addChild:panel];
    
    
    
    
    CCButton *playButton = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"button-play.png"]];
    playButton.positionType = CCPositionTypeNormalized;
    playButton.position = ccp(0.68f, 0.28f);
    [playButton setTarget:self selector:@selector(onPlayClicked:)];
    [self addChild:playButton];
    
    
    CCButton *betButton = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"button-denom.png"]];
    betButton.positionType = CCPositionTypeNormalized;
    betButton.position = ccp(0.28f, 0.295f);
    [betButton setTarget:self selector:@selector(onBetClicked:)];
    [self addChild:betButton];

    
    CCSprite *bottomRocker = [CCSprite spriteWithImageNamed:@"home-hud-bottom.png"];
    bottomRocker.positionType = CCPositionTypeNormalized;
    bottomRocker.anchorPoint = ccp(0.5, 0.0);
    bottomRocker.position = ccp(0.5f, 0.0f);
    [self addChild:bottomRocker];
    
    
    CCLabelTTF *score = [CCLabelTTF labelWithString:[ResultsScene returnFormattedDollarAmount:
                        [[UserDataManager sharedInstance] getBank]] fontName:@"Avenir-Black" fontSize:36.0f];
    [score setHorizontalAlignment:CCTextAlignmentRight];
    score.positionType = CCPositionTypeNormalized;
    score.color = [CCColor whiteColor];
    score.position = ccp(0.5f, 0.08f);
    [self addChild:score];
    
    
    betDisplay = [CCLabelTTF labelWithString:[ResultsScene returnFormattedDollarAmount:
                                                     [[UserDataManager sharedInstance] getBet]] fontName:@"Avenir-Black" fontSize:20.0f];
    [betDisplay setHorizontalAlignment:CCTextAlignmentLeft];
    betDisplay.positionType = CCPositionTypeNormalized;
    betDisplay.color = [CCColor colorWithCcColor3b:ccc3(255, 233, 0)];
    betDisplay.position = ccp(0.25f, 0.74f);
    [betButton addChild:betDisplay];
    
    
    linesDisplay = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i Rows", [[UserDataManager sharedInstance] getLines] ] fontName:@"Avenir-Black" fontSize:16.0f];
    [linesDisplay setHorizontalAlignment:CCTextAlignmentRight];
    linesDisplay.positionType = CCPositionTypeNormalized;
    linesDisplay.color = [CCColor colorWithCcColor3b:ccc3(95, 43, 167)];
    linesDisplay.position = ccp(0.33f, 0.23f);
    [self addChild:linesDisplay];
    
    // done
	return self;
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onPlayClicked:(id)sender
{
    // start spinning scene with transition
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    [audio playEffect:@"all-ui-buttons-default.wav" loop:NO];
    
    [[CCDirector sharedDirector] replaceScene:[GameScene scene]];
}


- (void)onBetClicked:(id)sender
{
    // start spinning scene with transition
    OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
    [audio playEffect:@"all-ui-buttons-default.wav" loop:NO];
    
    int currentBet = [[UserDataManager sharedInstance] getBet] + 10;
    if((currentBet) > 60){
        currentBet = 20;
    }
    
    [[UserDataManager sharedInstance] setLines:currentBet];
    [[UserDataManager sharedInstance] setBet:currentBet];
    
    [self updateDisplays];
}

-(void)updateDisplays
{
    [betDisplay setString:[ResultsScene returnFormattedDollarAmount:
                           [[UserDataManager sharedInstance] getBet]]];
    [linesDisplay setString:[NSString stringWithFormat:@"%i Rows", [[UserDataManager sharedInstance] getLines] ]];
}

// -----------------------------------------------------------------------
@end
