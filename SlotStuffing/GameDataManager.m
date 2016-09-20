//
//  GameDataManager.m
//  FourDots
//
//  Created by Erik James on 6/8/14.
//  Copyright (c) 2014 Gangsta Apps. All rights reserved.
//

#import "GameDataManager.h"
#import "UserDataManager.h"
#import "GameScene.h"
#import "AppDelegate.h"

int const  WALK = 1;
int const  JOG = 2;
int const  RUN = 3;
int const  SUPER_SPEED = 4;
int const  TIMER = 5;
int const  ZEN = 6;
int const  BLACK_AND_WHITE = 7;
int const  AMAZING = 8;

int const  DEFAULT_SPEED = JOG;
int const  DEFAULT_DOTS = 4;

int const  STARTING_3_DOT_POWERUP_MAX = 2;
int const  STARTING_3_DOT_POWERUP_AMOUNT = 2;
int const  STARTING_HALF_DOT_POWERUP_MAX = 2;
int const  STARTING_HALF_DOT_POWERUP_AMOUNT = 2;
int const  STARTING_SKIP_POWERUP_MAX = 2;
int const  STARTING_SKIP_POWERUP_AMOUNT = 2;
int const  STARTING_MORE_BONUSES_POWERUP_MAX = 2;
int const  STARTING_MORE_BONUSES_POWERUP_AMOUNT = 2;

NSString *const GAME_FONT = @"GujaratiSangamMN";
NSString *const GAME_FONT_BOLD = @"GujaratiSangamMN-Bold";
NSString *const GAME_ART_PREFIX = @"dd_";



//
@implementation ButtonInfo


+ (id) infoWithText:(NSString *)text buttonColor:(CCColor *)regColor buttonDwnColor:(CCColor *)dwnColor buttonSelectedColor:(CCColor *)selColor labelRegColor:(CCColor *)lRColor labelSelectedColor:(CCColor *)lSColor
         buttonSize:(ButtonSize)size fontSize:(int)theFontSize andFont:(NSString *)font
{
	return [[ButtonInfo alloc] initWithText:text buttonColor:regColor buttonDwnColor:dwnColor buttonSelectedColor:selColor labelRegColor:lRColor labelSelectedColor:lSColor buttonSize:size fontSize:theFontSize andFont:font];
}


- (id) initWithText:(NSString *)text buttonColor:(CCColor *)regColor buttonDwnColor:(CCColor *)dwnColor buttonSelectedColor:(CCColor *)selColor labelRegColor:(CCColor *)lRColor labelSelectedColor:(CCColor *)lSColor
         buttonSize:(ButtonSize)size fontSize:(int)theFontSize andFont:(NSString *)font
{
	if ((self = [super init])) {
		_buttonRegColor = regColor;
        _buttonDownColor = dwnColor;
        _buttonSelectedColor = selColor;
        _labelRegColor = lRColor;
        _labelSelectedColor = lRColor;
        _buttonText = text;
        _buttonSize = size;
        _fontSize = theFontSize;
        _buttonFont = font;
	}
	return self;
}


@end
//

@implementation GameDataManager{
    NSUserDefaults *userDefaults;
    NSDictionary *_colorLookup;
    int currentLevelDots;
    NSDate *lastDotChangeTime;
    
}
    

+ (GameDataManager *)sharedInstance
{
    static dispatch_once_t once;
    static GameDataManager *instance;
    dispatch_once(&once, ^{
        instance = [[GameDataManager alloc] init];
    });
    return instance;
}

-(id)init
{
    
    if(self = [super init]){
        userDefaults = [NSUserDefaults standardUserDefaults];
                lastDotChangeTime = [NSDate date];
        _powerup3DotsActive = NO;
        _powerupHalfDotsActive = NO;
        _interstitialCountdown = 3;
    }
    return self;
}


-(int)getGameSpeed
{
  
    return [[UserDataManager sharedInstance] getGameSpeed];
}

-(int)getGameDots
{
   
    return [[UserDataManager sharedInstance] getGameDots];
    
}

-(void)initColors
{
    _colorLookup = @{@"" : [CCColor colorWithRed:1 green:1 blue:1 alpha:1]};
}

//[CCColor colorWithCcColor3b:ccc3(119, 194, 152)]

+(ButtonInfo *)colorLookup:(ButtonType)element
{
    switch(element){
        case PLAY_FREE:
           return [ButtonInfo infoWithText:NSLocalizedString(@"FREE_PLAY", nil)
                               buttonColor:[CCColor colorWithCcColor3b:ccc3(113,141,191)]
                            buttonDwnColor:[self darkenColor:[CCColor colorWithCcColor3b:ccc3(113,141,191)]]
                       buttonSelectedColor:[self darkenColor:[CCColor colorWithCcColor3b:ccc3(113,141,191)]]
                             labelRegColor:[CCColor whiteColor]
                        labelSelectedColor:[CCColor colorWithCcColor3b:ccc3(119, 194, 152)]
                                buttonSize:BUTTON_LARGE
                                  fontSize:18.0f
                                   andFont:GAME_FONT];
        case PLAY_LEVELS:
            return [ButtonInfo infoWithText:NSLocalizedString(@"LEVEL_PLAY", nil)
                                buttonColor:[CCColor colorWithCcColor3b:ccc3(119, 194, 152)]
                             buttonDwnColor:[self darkenColor:[CCColor colorWithCcColor3b:ccc3(119, 194, 152)]]
                        buttonSelectedColor:[self darkenColor:[CCColor colorWithCcColor3b:ccc3(119, 194, 152)]]
                              labelRegColor:[CCColor whiteColor]
                         labelSelectedColor:[CCColor colorWithCcColor3b:ccc3(119, 194, 152)]
                                 buttonSize:BUTTON_LARGE
                                   fontSize:20.0f
                                    andFont:GAME_FONT];
            
        case MAIN_MENU:
            return [ButtonInfo infoWithText:NSLocalizedString(@"MAIN_MENU", nil)
                                buttonColor:[CCColor colorWithCcColor3b:ccc3(250,116,108)]
                             buttonDwnColor:[self darkenColor:[CCColor colorWithCcColor3b:ccc3(250,116,108)]]
                        buttonSelectedColor:[self darkenColor:[CCColor colorWithCcColor3b:ccc3(250,116,108)]]
                              labelRegColor:[CCColor whiteColor]
                         labelSelectedColor:[CCColor colorWithCcColor3b:ccc3(250,116,108)]
                                 buttonSize:BUTTON_MEDIUM
                                   fontSize:20.0f
                                    andFont:GAME_FONT];
            
        case FACEBOOK:
            return [ButtonInfo infoWithText:NSLocalizedString(@"FACEBOOK", nil)
                                buttonColor:[CCColor colorWithCcColor3b:ccc3(218,221,224)]
                             buttonDwnColor:[self darkenColor:[CCColor colorWithCcColor3b:ccc3(218,221,224)]]
                        buttonSelectedColor:[self darkenColor:[CCColor colorWithCcColor3b:ccc3(218,221,224)]]
                              labelRegColor:[CCColor colorWithCcColor3b:ccc3(70,87,102)]
                         labelSelectedColor:[CCColor colorWithCcColor3b:ccc3(250,116,108)]
                                 buttonSize:BUTTON_TINY
                                   fontSize:11.5f
                                    andFont:GAME_FONT];
            
        case TWITTER:
            return [ButtonInfo infoWithText:NSLocalizedString(@"TWITTER", nil)
                                buttonColor:[CCColor colorWithCcColor3b:ccc3(218,221,224)]
                             buttonDwnColor:[self darkenColor:[CCColor colorWithCcColor3b:ccc3(218,221,224)]]
                        buttonSelectedColor:[self darkenColor:[CCColor colorWithCcColor3b:ccc3(218,221,224)]]
                              labelRegColor:[CCColor colorWithCcColor3b:ccc3(70,87,102)]
                         labelSelectedColor:[CCColor colorWithCcColor3b:ccc3(250,116,108)]
                                 buttonSize:BUTTON_TINY
                                   fontSize:11.5f
                                    andFont:GAME_FONT];
            
        case BUTTON_BACK:
            return [ButtonInfo infoWithText:NSLocalizedString(@"BACK", nil)
                                buttonColor:[CCColor colorWithCcColor3b:ccc3(218,221,224)]
                             buttonDwnColor:[self darkenColor:[CCColor colorWithCcColor3b:ccc3(218,221,224)]]
                        buttonSelectedColor:[self darkenColor:[CCColor colorWithCcColor3b:ccc3(218,221,224)]]
                              labelRegColor:[CCColor colorWithCcColor3b:ccc3(70,87,102)]
                         labelSelectedColor:[CCColor colorWithCcColor3b:ccc3(250,116,108)]
                                 buttonSize:BUTTON_TINY
                                   fontSize:11.5f
                                    andFont:GAME_FONT];
            
        case START_GAME:
            return [ButtonInfo infoWithText:NSLocalizedString(@"START_GAME", nil)
                                buttonColor:[CCColor colorWithCcColor3b:ccc3(218,221,224)]
                             buttonDwnColor:[self darkenColor:[CCColor colorWithCcColor3b:ccc3(218,221,224)]]
                        buttonSelectedColor:[self darkenColor:[CCColor colorWithCcColor3b:ccc3(218,221,224)]]
                              labelRegColor:[CCColor colorWithCcColor3b:ccc3(70,87,102)]
                         labelSelectedColor:[CCColor colorWithCcColor3b:ccc3(250,116,108)]
                                 buttonSize:BUTTON_SMALL
                                   fontSize:14.0f
                                    andFont:GAME_FONT];
            
        case START_LEVEL:
            return [ButtonInfo infoWithText:NSLocalizedString(@"START_LEVEL", nil)
                                buttonColor:[CCColor colorWithCcColor3b:ccc3(218,221,224)]
                             buttonDwnColor:[self darkenColor:[CCColor colorWithCcColor3b:ccc3(218,221,224)]]
                        buttonSelectedColor:[self darkenColor:[CCColor colorWithCcColor3b:ccc3(218,221,224)]]
                              labelRegColor:[CCColor colorWithCcColor3b:ccc3(70,87,102)]
                         labelSelectedColor:[CCColor colorWithCcColor3b:ccc3(250,116,108)]
                                 buttonSize:BUTTON_SMALL
                                   fontSize:14.0f
                                    andFont:GAME_FONT];
            
            
        case SPEED_SLOW:
            return [ButtonInfo infoWithText:NSLocalizedString(@"SLOW", nil)
                                buttonColor:[self darkenColor:[CCColor colorWithCcColor3b:ccc3(218,221,224) ]]
                             buttonDwnColor:[CCColor colorWithCcColor3b:ccc3(218,221,224)]
                        buttonSelectedColor:[CCColor colorWithCcColor3b:ccc3(218,221,224)]
                              labelRegColor:[CCColor colorWithCcColor3b:ccc3(70,87,102)]
                         labelSelectedColor:[CCColor colorWithCcColor3b:ccc3(250,116,108)]
                                 buttonSize:BUTTON_SMALL
                                   fontSize:14.0f
                                    andFont:GAME_FONT];
            
        case SPEED_MEDIUM:
            return [ButtonInfo infoWithText:NSLocalizedString(@"MEDIUM", nil)
                                buttonColor:[self darkenColor:[CCColor colorWithCcColor3b:ccc3(218,221,224)]]
                             buttonDwnColor:[CCColor colorWithCcColor3b:ccc3(218,221,224)]
                        buttonSelectedColor:[CCColor colorWithCcColor3b:ccc3(218,221,224)]
                              labelRegColor:[CCColor colorWithCcColor3b:ccc3(70,87,102)]
                         labelSelectedColor:[CCColor colorWithCcColor3b:ccc3(250,116,108)]
                                 buttonSize:BUTTON_SMALL
                                   fontSize:14.0f
                                    andFont:GAME_FONT];
            
        case SPEED_FAST:
            return [ButtonInfo infoWithText:NSLocalizedString(@"FAST", nil)
                                buttonColor:[self darkenColor:[CCColor colorWithCcColor3b:ccc3(218,221,224)]]
                             buttonDwnColor:[CCColor colorWithCcColor3b:ccc3(218,221,224)]
                        buttonSelectedColor:[CCColor colorWithCcColor3b:ccc3(218,221,224)]
                              labelRegColor:[CCColor colorWithCcColor3b:ccc3(70,87,102)]
                         labelSelectedColor:[CCColor colorWithCcColor3b:ccc3(250,116,108)]
                                 buttonSize:BUTTON_SMALL
                                   fontSize:14.0f
                                    andFont:GAME_FONT];
            
        case SPEED_SUPER:
            return [ButtonInfo infoWithText:NSLocalizedString(@"SUPER", nil)
                                buttonColor:[self darkenColor:[CCColor colorWithCcColor3b:ccc3(218,221,224)]]
                             buttonDwnColor:[CCColor colorWithCcColor3b:ccc3(218,221,224)]
                        buttonSelectedColor:[CCColor colorWithCcColor3b:ccc3(218,221,224)]
                              labelRegColor:[CCColor colorWithCcColor3b:ccc3(70,87,102)]
                         labelSelectedColor:[CCColor colorWithCcColor3b:ccc3(250,116,108)]
                                 buttonSize:BUTTON_SMALL
                                   fontSize:14.0f
                                    andFont:GAME_FONT];
            
        case SPEED_AMAZING:
            return [ButtonInfo infoWithText:NSLocalizedString(@"AMAZING", nil)
                                buttonColor:[self darkenColor:[CCColor colorWithCcColor3b:ccc3(218,221,224)]]
                             buttonDwnColor:[CCColor colorWithCcColor3b:ccc3(218,221,224)]
                        buttonSelectedColor:[CCColor colorWithCcColor3b:ccc3(218,221,224)]
                              labelRegColor:[CCColor colorWithCcColor3b:ccc3(70,87,102)]
                         labelSelectedColor:[CCColor colorWithCcColor3b:ccc3(250,116,108)]
                                 buttonSize:BUTTON_SMALL
                                   fontSize:14.0f
                                    andFont:GAME_FONT];
            
        case SPEED_TIMER:
            return [ButtonInfo infoWithText:NSLocalizedString(@"TIMER", nil)
                                buttonColor:[self darkenColor:[CCColor colorWithCcColor3b:ccc3(218,221,224)]]
                             buttonDwnColor:[CCColor colorWithCcColor3b:ccc3(218,221,224)]
                        buttonSelectedColor:[CCColor colorWithCcColor3b:ccc3(218,221,224)]
                              labelRegColor:[CCColor colorWithCcColor3b:ccc3(70,87,102)]
                         labelSelectedColor:[CCColor colorWithCcColor3b:ccc3(250,116,108)]
                                 buttonSize:BUTTON_SMALL
                                   fontSize:14.0f
                                    andFont:GAME_FONT];
            
        case SPEED_ZEN:
            return [ButtonInfo infoWithText:NSLocalizedString(@"ZEN", nil)
                                buttonColor:[self darkenColor:[CCColor colorWithCcColor3b:ccc3(218,221,224)]]
                             buttonDwnColor:[CCColor colorWithCcColor3b:ccc3(218,221,224)]
                        buttonSelectedColor:[CCColor colorWithCcColor3b:ccc3(218,221,224)]
                              labelRegColor:[CCColor colorWithCcColor3b:ccc3(70,87,102)]
                         labelSelectedColor:[CCColor colorWithCcColor3b:ccc3(250,116,108)]
                                 buttonSize:BUTTON_SMALL
                                   fontSize:14.0f
                                    andFont:GAME_FONT];
            
        case RESET_BUTTON:
            return [ButtonInfo infoWithText:NSLocalizedString(@"RESET_GAME", nil)
                                buttonColor:[CCColor colorWithCcColor3b:ccc3(218,221,224)]
                             buttonDwnColor:[self darkenColor:[CCColor colorWithCcColor3b:ccc3(218,221,224)]]
                        buttonSelectedColor:[CCColor colorWithCcColor3b:ccc3(218,221,224)]
                              labelRegColor:[CCColor colorWithCcColor3b:ccc3(70,87,102)]
                         labelSelectedColor:[CCColor colorWithCcColor3b:ccc3(250,116,108)]
                                 buttonSize:BUTTON_MEDIUM
                                   fontSize:14.0f
                                    andFont:GAME_FONT];
        case ACHIEVEMENTS:
            return [ButtonInfo infoWithText:NSLocalizedString(@"ACHIEVEMENTS", nil)
                                buttonColor:[CCColor colorWithCcColor3b:ccc3(113,141,191)]
                             buttonDwnColor:[self darkenColor:[CCColor colorWithCcColor3b:ccc3(113,141,191)]]
                        buttonSelectedColor:[self darkenColor:[CCColor colorWithCcColor3b:ccc3(113,141,191)]]
                              labelRegColor:[CCColor whiteColor]
                         labelSelectedColor:[CCColor colorWithCcColor3b:ccc3(119, 194, 152)]
                                 buttonSize:BUTTON_LARGE
                                   fontSize:18.0f
                                    andFont:GAME_FONT];
            
        case HOME_BUTTON:
            return [ButtonInfo infoWithText:NSLocalizedString(@"RETURN_HOME", nil)
                                buttonColor:[CCColor colorWithCcColor3b:ccc3(113,141,191)]
                             buttonDwnColor:[self darkenColor:[CCColor colorWithCcColor3b:ccc3(113,141,191)]]
                        buttonSelectedColor:[self darkenColor:[CCColor colorWithCcColor3b:ccc3(113,141,191)]]
                              labelRegColor:[CCColor whiteColor]
                         labelSelectedColor:[CCColor colorWithCcColor3b:ccc3(119, 194, 152)]
                                 buttonSize:BUTTON_LARGE
                                   fontSize:18.0f
                                    andFont:GAME_FONT];
            
        case FREE_PLAY_OPTIONS:
            return [ButtonInfo infoWithText:NSLocalizedString(@"FREE_PLAY_OPTIONS", nil)
                                buttonColor:[CCColor colorWithCcColor3b:ccc3(113,141,191)]
                             buttonDwnColor:[self darkenColor:[CCColor colorWithCcColor3b:ccc3(113,141,191)]]
                        buttonSelectedColor:[self darkenColor:[CCColor colorWithCcColor3b:ccc3(113,141,191)]]
                              labelRegColor:[CCColor whiteColor]
                         labelSelectedColor:[CCColor colorWithCcColor3b:ccc3(119, 194, 152)]
                                 buttonSize:BUTTON_LARGE
                                   fontSize:18.0f
                                    andFont:GAME_FONT];
            
        case REMOVE_ADS:
            return [ButtonInfo infoWithText:NSLocalizedString(@"REMOVE_ADS", nil)
                                buttonColor:[CCColor colorWithCcColor3b:ccc3(113,141,191)]
                             buttonDwnColor:[self darkenColor:[CCColor colorWithCcColor3b:ccc3(113,141,191)]]
                        buttonSelectedColor:[self darkenColor:[CCColor colorWithCcColor3b:ccc3(113,141,191)]]
                              labelRegColor:[CCColor whiteColor]
                         labelSelectedColor:[CCColor colorWithCcColor3b:ccc3(119, 194, 152)]
                                 buttonSize:BUTTON_LARGE
                                   fontSize:18.0f
                                    andFont:GAME_FONT];
            
        case RESUME_BUTTON:
            return [ButtonInfo infoWithText:NSLocalizedString(@"RESUME_GAME", nil)
                                buttonColor:[CCColor colorWithCcColor3b:ccc3(113,141,191)]
                             buttonDwnColor:[self darkenColor:[CCColor colorWithCcColor3b:ccc3(113,141,191)]]
                        buttonSelectedColor:[self darkenColor:[CCColor colorWithCcColor3b:ccc3(113,141,191)]]
                              labelRegColor:[CCColor whiteColor]
                         labelSelectedColor:[CCColor colorWithCcColor3b:ccc3(119, 194, 152)]
                                 buttonSize:BUTTON_LARGE
                                   fontSize:18.0f
                                    andFont:GAME_FONT];
            
        case RESTART_BUTTON:
            return [ButtonInfo infoWithText:NSLocalizedString(@"RESTART_GAME", nil)
                                buttonColor:[CCColor colorWithCcColor3b:ccc3(113,141,191)]
                             buttonDwnColor:[self darkenColor:[CCColor colorWithCcColor3b:ccc3(113,141,191)]]
                        buttonSelectedColor:[self darkenColor:[CCColor colorWithCcColor3b:ccc3(113,141,191)]]
                              labelRegColor:[CCColor whiteColor]
                         labelSelectedColor:[CCColor colorWithCcColor3b:ccc3(119, 194, 152)]
                                 buttonSize:BUTTON_LARGE
                                   fontSize:18.0f
                                    andFont:GAME_FONT];
            
    }
}


+(CCColor *)darkenColor:(CCColor *)original
{
    return [CCColor colorWithRed:original.red * .5 green:original.green * .5 blue:original.blue * .5];
}


-(NSString *)returnSizeName:(ButtonSize)size
{
    switch(size){
        case BUTTON_LARGE:
            return @"_large";
        case BUTTON_MEDIUM:
            return @"_medium";
        case BUTTON_SMALL:
            return @"_small";
        case BUTTON_TINY:
            return @"_tiny";
    }
}



+(CCSprite *)getTargetSprite
{
    return [CCSprite spriteWithImageNamed:[NSString stringWithFormat:@"%@%@dot_%li.png", GAME_ART_PREFIX, ([[UserDataManager sharedInstance ] getBWMode]? @"black" : @"green"), (long)[[GameDataManager sharedInstance] getGameDots]]];
}

+(CCSprite *)getWrongSprite
{
    return [CCSprite spriteWithImageNamed:[NSString stringWithFormat:@"%@%@dot_%li.png", GAME_ART_PREFIX, ([[UserDataManager sharedInstance ] getBWMode]? @"black" : @"green"), (long)[[GameDataManager sharedInstance] getGameDots]]];
}

+(CCSprite *)getGoSprite
{
    return [CCSprite spriteWithImageNamed:[NSString stringWithFormat:@"%@godot%@_%li.png", GAME_ART_PREFIX, ([[UserDataManager sharedInstance ] getBWMode]? @"black" : @""), (long)[[GameDataManager sharedInstance] getGameDots]]];
}

+(CCSprite *)getDot:(NSString *)color
{
    return [CCSprite spriteWithImageNamed:[NSString stringWithFormat:@"%@%@dot_%li.png", GAME_ART_PREFIX, color, (long)[[UserDataManager sharedInstance] getGameDots]]];
}

+(CCSprite *)getSprite:(NSString *)spriteName
{
    NSLog(@"returning %@", [NSString stringWithFormat:@"%@%@.png", GAME_ART_PREFIX, spriteName]);
    return [CCSprite spriteWithImageNamed:[NSString stringWithFormat:@"%@%@.png", GAME_ART_PREFIX, spriteName]];
}

+(CCSprite *)getConfetti
{
    return [GameDataManager getSprite:@"confetti"];
}



+(void)buttonClick
{
    if([[UserDataManager sharedInstance] getSoundsMuted] == NO){
        OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
        [audio playEffect:@"click.wav" loop:NO];
    }
}

+(void)whoosh
{
    if([[UserDataManager sharedInstance] getSoundsMuted] == NO){
        OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
        [audio playEffect:@"whoosh.wav" loop:NO];
    }
}

@end



