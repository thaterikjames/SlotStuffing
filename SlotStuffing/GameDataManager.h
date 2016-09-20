//
//  GameDataManager.h
//  FourDots
//
//  Created by Erik James on 6/8/14.
//  Copyright (c) 2014 Gangsta Apps. All rights reserved.
//

#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "GameScene.h"

#define SCALE_FONT(font) (IS_IPAD ? font * 2.0f : font)
#define ADJUST_SPEED(speed) (IS_IPAD ? speed * 1.5f : speed)
#define ADJUST_DOTS(dots) (IS_IPAD ? (dots == 3 ? dots + 1 : ( dots == 4 ? dots + 2 : (dots == 5 ? dots + 2 : dots + 2 ) )) : dots)

typedef enum{
    PLAY_LEVELS, PLAY_FREE, MAIN_MENU, FACEBOOK, TWITTER, START_GAME, START_LEVEL, BUTTON_BACK,
    SPEED_SLOW, SPEED_MEDIUM, SPEED_FAST, SPEED_SUPER, SPEED_AMAZING, SPEED_ZEN, SPEED_TIMER, RESET_BUTTON,
    ACHIEVEMENTS, HOME_BUTTON, FREE_PLAY_OPTIONS, REMOVE_ADS, RESUME_BUTTON, RESTART_BUTTON
    
} ButtonType;

typedef enum{
    BUTTON_LARGE, BUTTON_MEDIUM, BUTTON_SMALL, BUTTON_TINY
    
} ButtonSize;

typedef enum{
    FREE_MODE_DONE, LEVEL_MODE_COMPLETE, LEVEL_MODE_INCOMPLETE
    
} PopupType;

typedef enum{
    POWERUP_3_DOTS, POWERUP_HALF_DOTS, POWERUP_SKIP, POWERUP_MORE_BONUSES
    
} PowerupType;

@interface ButtonInfo : NSObject
{

}

@property (atomic, readwrite) CCColor  *buttonRegColor;
@property (atomic, readwrite) CCColor  *buttonSelectedColor;
@property (atomic, readwrite) CCColor  *buttonDownColor;
@property (atomic, readwrite) CCColor  *labelRegColor;
@property (atomic, readwrite) CCColor  *labelSelectedColor;
@property (atomic, readwrite) NSString *buttonText;
@property (atomic, readwrite) ButtonSize buttonSize;
@property (atomic, readwrite) float fontSize;
@property (atomic, readwrite) NSString *buttonFont;


+ (id) infoWithText:(NSString *)text buttonColor:(CCColor *)regColor buttonDwnColor:(CCColor *)dwnColor buttonSelectedColor:(CCColor *)selColor labelRegColor:(CCColor *)lRColor labelSelectedColor:(CCColor *)lSColor
         buttonSize:(ButtonSize)size fontSize:(int)theFontSize andFont:(NSString *)font;

@end


@interface GameDataManager : NSObject



extern int const  WALK;
extern int const  JOG;
extern int const  RUN;
extern int const  SUPER_SPEED;
extern int const  TIMER;
extern int const  ZEN;
extern int const  BLACK_AND_WHITE;
extern int const  AMAZING;

extern int const  STARTING_HALF_DOT_POWERUP_AMOUNT;
extern int const  STARTING_HALF_DOT_POWERUP_MAX;
extern int const  STARTING_SKIP_POWERUP_AMOUNT;
extern int const  STARTING_SKIP_POWERUP_MAX;
extern int const  STARTING_MORE_BONUSES_POWERUP_AMOUNT;
extern int const  STARTING_MORE_BONUSES_POWERUP_MAX;
extern int const  STARTING_3_DOT_POWERUP_AMOUNT;
extern int const  STARTING_3_DOT_POWERUP_MAX;

extern int const  DEFAULT_SPEED;
extern int const  DEFAULT_DOTS;
extern NSString *const GAME_FONT;
extern NSString *const GAME_FONT_BOLD;
extern NSString *const GAME_ART_PREFIX;

+ (GameDataManager *)sharedInstance;

+(CCSprite *)getTargetSprite;
+(CCSprite *)getWrongSprite;
+(CCSprite *)getGoSprite;
+(CCButton *)getButton:(NSString *)buttonName selectedName:(NSString *)selected withText:(NSString *)text fontColor:(CCColor *)color fontSize:(NSInteger)size;

+(CCButton *)getButton:(NSString *)buttonName;

+(CCSprite *)getDot:(NSString *)color;

+(CCSprite *)getSprite:(NSString *)spriteName;

+(CCButton *)getButton:(NSString *)buttonName selectedName:(NSString *)selected;
+(CCButton *)makeButton:(ButtonType)buttonType;
+(NSArray *)returnPhraseForScore:(int)theScore;

-(CCSprite *)makePopup:(PopupType)type withDelegate:(id)delegate;
-(void)loginToGameCenter;
-(int)getGameDots;
-(int)getTimeBetweenBonuses;
-(int)getGameSpeed;
-(void)reportScore;
+(CCSprite *)getConfetti;
+(void)buttonClick;
+(void)whoosh;
-(void)resetAchievements;

@property (atomic, retain)     GameScene *activeGame;
@property (atomic, readwrite)  BOOL alreadyLoggedIn;
@property (atomic, readwrite)  BOOL gameCenterLoginNeeded;
@property (atomic, readwrite)  BOOL levelMode;
@property (nonatomic, readonly)  NSInteger totalDotsThisLevel;
@property (nonatomic, readonly)  NSInteger gameSpeed;
@property (atomic, readwrite)  BOOL powerup3DotsActive;
@property (atomic, readwrite)  BOOL powerupHalfDotsActive;
@property (atomic, readwrite)  BOOL powerupSkipActive;
@property (atomic, readwrite)  int interstitialCountdown;
//@property (atomic, readwrite)  int dotsGatheredThisLevel;


@end
