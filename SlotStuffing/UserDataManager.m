//
//  UserDataManager.m
//  FourDots
//
//  Created by Erik James on 6/8/14.
//  Copyright (c) 2014 Gangsta Apps. All rights reserved.
//

#import "UserDataManager.h"
#import "GameDataManager.h"

#define ADS_DISABLED_KEY  @"adsDisabled"

#define CURRENT_LEVEL     @"currentLevel"

#define POWERUP_3_DOT_MAX_KEY    @"powerup3DotMax"
#define POWERUP_3_DOT_AMOUNT_KEY    @"powerup3DotAmount"
#define POWERUP_HALF_DOT_MAX_KEY    @"powerupHalfDotMax"
#define POWERUP_HALF_DOT_AMOUNT_KEY    @"powerupHalfDotAmount"
#define POWERUP_SKIP_MAX_KEY    @"powerupSkipMax"
#define POWERUP_SKIP_AMOUNT_KEY    @"powerupSkipAmount"

#define POWERUP_MORE_BONUSES_MAX_KEY    @"powerupMoreBonusesMax"
#define POWERUP_MORE_BONUSES_AMOUNT_KEY    @"powerupMoreBonusesAmount"

#define GAME_SPEED_KEY    @"gameSpeed"
#define GAME_DOTS_KEY     @"gameDots"
#define BEST_SCORE_KEY    @"bestScore"
#define CURRENT_SCORE_KEY @"currentScore"
#define SOUNDS_MUTED_KEY  @"soundsMuted"
#define FIRST_RUN_KEY     @"firstRun"
#define MUSIC_MUTED_KEY   @"musicMuted"
#define BW_MODE           @"bwMode"
#define NOTIFICATIONS_DISABLED_KEY   @"notificationsDisabled"

@implementation UserDataManager{
    NSUserDefaults *userDefaults;
}


+ (UserDataManager *)sharedInstance
{
    static dispatch_once_t once;
    static UserDataManager *instance;
    dispatch_once(&once, ^{
        instance = [[UserDataManager alloc] init];
    });
    return instance;
}

-(id)init
{
    if(self = [super init]){
        userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}


-(int)getCurrentLevel
{
    NSInteger currentLevel = [self secureIntegerForKey:CURRENT_LEVEL];
    
    if(currentLevel == 0){
        currentLevel = 1;
        [self setLevel:currentLevel];
    }
    return (int)currentLevel;
}


-(void)setLevel:(NSInteger)level
{
    [self secureSetInteger:level forKey:CURRENT_LEVEL];
    
}


-(int)getGameSpeed
{
    NSInteger gameSpeed = [userDefaults integerForKey:GAME_SPEED_KEY];
    
    if(gameSpeed == 0){
        gameSpeed = DEFAULT_SPEED;
        [self setGameSpeed:gameSpeed];
    }
    return (int)gameSpeed;
}

-(void)setGameSpeed:(NSInteger)speed
{
    [userDefaults setInteger:speed forKey:GAME_SPEED_KEY];
    [userDefaults synchronize];
}

-(BOOL)checkFirstTimeAchievement:(NSString *)achievementID
{
    NSInteger *val = [self secureIntegerForKey:achievementID];
    [self secureSetInteger:1 forKey:achievementID];
    return val == 0;
}

-(int)getGameDots
{
    NSInteger gameDots = [userDefaults integerForKey:GAME_DOTS_KEY];
    
    if(gameDots == 0){
        gameDots = DEFAULT_DOTS;
        [self setGameDots:gameDots];
    }
    return (int)gameDots;
}

-(void)setGameDots:(NSInteger)dots
{
    [userDefaults setInteger:dots forKey:GAME_DOTS_KEY];
    [userDefaults synchronize];
}


-(NSInteger)getBestScore
{
    NSInteger bestTime = [self secureIntegerForKey:BEST_SCORE_KEY];
    
    return bestTime;
}

-(void)setBestScore:(NSInteger)bestTime
{
    [self secureSetInteger:bestTime forKey:BEST_SCORE_KEY];
    
}

-(NSInteger)getCurrentScore
{
    NSInteger currentScore = [userDefaults integerForKey:CURRENT_SCORE_KEY];
    
    return currentScore;
}

-(void)setCurrentScore:(NSInteger)currentScore
{
    [userDefaults setInteger:currentScore forKey:CURRENT_SCORE_KEY];
    [userDefaults synchronize];
    
    if(currentScore > [self getBestScore]){
        [self setBestScore:currentScore];
    }
}

-(BOOL)getSoundsMuted
{
    return [userDefaults boolForKey:SOUNDS_MUTED_KEY];
}

-(void)setSoundsMuted:(BOOL)muted
{
    [userDefaults setBool:muted forKey:SOUNDS_MUTED_KEY];
    [userDefaults synchronize];
}

-(BOOL)getMusicMuted
{
    return [userDefaults boolForKey:MUSIC_MUTED_KEY];
}

-(void)setMusicMuted:(BOOL)muted
{
    [userDefaults setBool:muted forKey:MUSIC_MUTED_KEY];
    [userDefaults synchronize];
}

-(BOOL)getNotificationsDisabled
{
    return [userDefaults boolForKey:NOTIFICATIONS_DISABLED_KEY];
}

-(void)setNotificationsDisabled:(BOOL)muted
{
    [userDefaults setBool:muted forKey:NOTIFICATIONS_DISABLED_KEY];
    [userDefaults synchronize];
}

-(BOOL)getPreviouslyRun
{
    return [self secureIntegerForKey:FIRST_RUN_KEY] == 0;
}

-(void)setPreviouslyRun:(BOOL)firstRun
{
    [self secureSetInteger:firstRun forKey:FIRST_RUN_KEY];
    
}

-(BOOL)getAdsDisabled
{
    return [self secureIntegerForKey:ADS_DISABLED_KEY] > 0;
}

-(void)setAdsDisabled:(BOOL)disabled
{
    [self secureSetInteger:disabled forKey:ADS_DISABLED_KEY];
    
}
-(BOOL)getBWMode
{
    return [userDefaults boolForKey:BW_MODE];
}

-(void)setBWMode:(BOOL)mode
{
    [userDefaults setBool:mode forKey:BW_MODE];
    [userDefaults synchronize];
}

-(NSInteger)getPowerup3DotMax
{
    NSInteger max = [self secureIntegerForKey:POWERUP_3_DOT_MAX_KEY];
    
    if(max == 0){
        max = STARTING_3_DOT_POWERUP_MAX;
        [self setPowerup3DotMax:max];
    }
    return (int)max;
}

-(void)setPowerup3DotMax:(NSInteger)max
{
    [self secureSetInteger:max forKey:POWERUP_3_DOT_MAX_KEY];
    
}

-(NSInteger)getPowerup3DotAmount
{
    NSInteger amount = [self secureIntegerForKey:POWERUP_3_DOT_AMOUNT_KEY];
    
    if(amount == 0){
        amount = STARTING_3_DOT_POWERUP_AMOUNT;
        [self setPowerup3DotAmount:amount];
        amount++;
    }
    return (int)amount - 1;
}

-(void)setPowerup3DotAmount:(NSInteger)amount
{
    [self secureSetInteger:amount + 1 forKey:POWERUP_3_DOT_AMOUNT_KEY];
    
}


-(NSInteger)getPowerupHalfDotMax
{
    NSInteger max = [self secureIntegerForKey:POWERUP_HALF_DOT_MAX_KEY];
    
    if(max == 0){
        max = STARTING_HALF_DOT_POWERUP_MAX;
        [self setPowerupHalfDotMax:max];
    }
    return (int)max;
}

-(void)setPowerupHalfDotMax:(NSInteger)max
{
    [self secureSetInteger:max forKey:POWERUP_HALF_DOT_MAX_KEY];
    
}

-(NSInteger)getPowerupHalfDotAmount
{
    NSInteger amount = [self secureIntegerForKey:POWERUP_HALF_DOT_AMOUNT_KEY];
    
    if(amount == 0){
        amount = STARTING_HALF_DOT_POWERUP_AMOUNT;
        [self setPowerupHalfDotAmount:amount];
        amount++;
    }
    return (int)amount - 1;
}

-(void)setPowerupHalfDotAmount:(NSInteger)amount
{
    [self secureSetInteger:amount + 1 forKey:POWERUP_HALF_DOT_AMOUNT_KEY];
    
}


-(NSInteger)getPowerupSkipMax
{
    NSInteger max = [self secureIntegerForKey:POWERUP_SKIP_MAX_KEY];
    
    if(max == 0){
        max = STARTING_SKIP_POWERUP_MAX;
        [self setPowerupSkipMax:max];
    }
    return (int)max;
}



-(void)setPowerupSkipMax:(NSInteger)max
{
    [self secureSetInteger:max forKey:POWERUP_SKIP_MAX_KEY];
    
}

-(NSInteger)getPowerupSkipAmount
{
    NSInteger amount = [self secureIntegerForKey:POWERUP_SKIP_AMOUNT_KEY];
    
    if(amount == 0){
        amount = STARTING_SKIP_POWERUP_AMOUNT;
        [self setPowerupSkipAmount:amount];
        amount++;
    }
    return (int)amount - 1;
}

-(void)setPowerupSkipAmount:(NSInteger)amount
{
    [self secureSetInteger:amount + 1 forKey:POWERUP_SKIP_AMOUNT_KEY];
    
}

-(void)reset
{
    [self setPowerupSkipMax:2];
    [self setPowerupSkipAmount:2];
    [self setPowerupHalfDotMax:2];
    [self setPowerupHalfDotAmount:2];
    
    [self setPowerup3DotMax:2];
    [self setPowerup3DotAmount:2];
    
    [self setAdsDisabled:0];
    [self setPreviouslyRun:0];
    [self setBestScore:0];
    [self setCurrentScore:0];
    [self setLevel:0];
    [self setGameDots:0];
    [self setGameSpeed:0];
    
    [[GameDataManager sharedInstance] resetAchievements];
}

@end
