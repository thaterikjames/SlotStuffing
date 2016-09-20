//
//  UserDataManager.h
//  FourDots
//
//  Created by Erik James on 6/8/14.
//  Copyright (c) 2014 Gangsta Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDataManager : NSObject


+ (UserDataManager *)sharedInstance;


-(BOOL)checkFirstTimeAchievement:(NSString *)achievementID;
-(int)getGameSpeed;

-(void)setGameSpeed:(NSInteger)speed;

-(NSInteger)getBestScore;

-(void)setBestScore:(NSInteger)bestTime;

-(NSInteger)getCurrentScore;

-(void)setCurrentScore:(NSInteger)currentScore;

-(int)getGameDots;

-(void)setGameDots:(NSInteger)dots;

-(BOOL)getSoundsMuted;
-(void)setSoundsMuted:(BOOL)muted;

-(BOOL)getPreviouslyRun;

-(void)setPreviouslyRun:(BOOL)firstRun;

-(BOOL)getMusicMuted;

-(void)setMusicMuted:(BOOL)muted;

-(BOOL)getNotificationsDisabled;
-(void)setNotificationsDisabled:(BOOL)muted;

-(BOOL)getAdsDisabled;
-(void)setAdsDisabled:(BOOL)disabled;

-(BOOL)getBWMode;
-(void)setBWMode:(BOOL)mode;

-(int)getCurrentLevel;

-(void)setLevel:(NSInteger)level;


-(NSInteger)getPowerup3DotMax;
-(void)setPowerup3DotMax:(NSInteger)max;

-(NSInteger)getPowerup3DotAmount;
-(void)setPowerup3DotAmount:(NSInteger)amount;

-(NSInteger)getPowerupHalfDotMax;
-(void)setPowerupHalfDotMax:(NSInteger)max;

-(NSInteger)getPowerupHalfDotAmount;
-(void)setPowerupHalfDotAmount:(NSInteger)amount;

-(NSInteger)getPowerupSkipMax;
-(void)setPowerupSkipMax:(NSInteger)max;

-(NSInteger)getPowerupSkipAmount;
-(void)setPowerupSkipAmount:(NSInteger)amount;

-(NSInteger)getPowerupMoreBonusesMax;
-(void)setPowerupMoreBonusesMax:(NSInteger)max;

-(NSInteger)getPowerupMoreBonusesAmount;
-(void)setPowerupMoreBonusesAmount:(NSInteger)amount;

-(NSInteger)secureIntegerForKey:(NSString *)key;
-(void)secureSetInteger:(NSInteger)intVal forKey:(NSString *)key;


-(void)reset;
@end
