//
//  ScoreData.m
//  CWStreaks
//
//  Created by Mensah Shadrach on 11/1/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

#import "ScoreData.h"

@implementation ScoreData


+(id)mainData{
    static ScoreData *mainData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mainData = [[self alloc] init];
    });
    return mainData;
}

-(void)initGamedata{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _alltotalgameScore = [defaults integerForKey:ALL_TOTAL_GAMESCORE];
    _gameHighScore = [defaults integerForKey:GAME_HIGH_SCORE];
    _gameHighStreak = [defaults integerForKey:GAME_HIGH_STREAK];
    self.regualarGamescore = [defaults integerForKey:ALL_REGL_GAME_SCORE];
    _lifetimegameCount = [defaults integerForKey:GAME_COUNT_LIFETIME];
    _lifeTimePercentage = [defaults doubleForKey:PERCENTAGE_LIFETIME];
    _regularhighscore = [defaults integerForKey:REG_HIGH_SCORE];
    _classicHighscore = [defaults integerForKey:CLASSIC_HIGH_SCORE];
    _highstreak = [defaults integerForKey:HIGH_STREAK];
    self.regularGameCount = [defaults integerForKey:REGL_GAME_COUNT_];
    self.classicGameCount = [defaults integerForKey:CLSSC_GAME_COUNT_];
    self.loosingStreak = [defaults integerForKey:GM_LSSN_STRK];
}

-(void)initfb_Userdata:(NSDictionary *)dictionary
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [self setLifetimegameCount:[(NSNumber*)[dictionary objectForKey:FIR_DB_REF_ALLTIME_GAMECOUNT]unsignedIntegerValue]];
    [defaults setInteger:_lifetimegameCount forKey:GAME_COUNT_LIFETIME];
    [self setAlltotalgameScore:[(NSNumber*)[dictionary objectForKey:FIR_DB_REF_ALLTIME_GAMESCORE]unsignedIntegerValue]];
    [defaults setInteger:_alltotalgameScore forKey:ALL_TOTAL_GAMESCORE];
    [self setClassicHighscore:[(NSNumber*)[dictionary objectForKey:FIR_DB_REF_CLSSC_GAMEHIGHSCORE]unsignedIntegerValue]];
    [defaults setInteger:_classicHighscore forKey:CLASSIC_HIGH_SCORE];
    [self setHighstreak:[(NSNumber*)[dictionary objectForKey:FIR_DB_REF_HIGHSTREAK]unsignedIntegerValue]];
    [defaults setInteger:_highstreak forKey:HIGH_STREAK];
    [self setRegularhighscore:[(NSNumber*)[dictionary objectForKey:FIR_DB_REF_SC_REGL_GAMEHIGHSCORE]unsignedIntegerValue]];
    [defaults setInteger:_regularhighscore forKey:REG_HIGH_SCORE];

    [self setLoosingStreak:[(NSNumber*)[dictionary objectForKey:FIR_DB_LSSN_STRK]unsignedIntegerValue]];
    [defaults setInteger:_loosingStreak forKey:GM_LSSN_STRK];
    [self setRegularGameCount:[(NSNumber*)[dictionary objectForKey:FIR_DB_RGL_GM_COUNT]unsignedIntegerValue]];
    [defaults setInteger:_regularGameCount forKey:REGL_GAME_COUNT_];
    [self setClassicGameCount:self.lifetimegameCount - self.regularGameCount];
    [defaults setInteger:_classicGameCount forKey:CLSSC_GAME_COUNT_];
    [defaults setInteger:0 forKey:GAME_HIGH_SCORE];
    [defaults setInteger:0 forKey:GAME_HIGH_STREAK];
    [self setLifeTimePercentage:(double)(self.alltotalgameScore / self.lifetimegameCount)* 100];
    [defaults setDouble:_lifeTimePercentage forKey:PERCENTAGE_LIFETIME];
    [self setRegualarGamescore:[(NSNumber*)[dictionary objectForKey:ALL_REGL_GAME_SCORE]unsignedIntegerValue]];
    [defaults setInteger:self.regualarGamescore forKey:ALL_REGL_GAME_SCORE];
}


     


/*
 @property (nonatomic) NSUInteger gameHighScore;
 @property (nonatomic) NSUInteger gameHighStreak;
 @property (nonatomic) NSUInteger highscoreGameCount;
 @property (nonatomic) NSUInteger alltotalgameScore;
 @property (nonatomic) NSUInteger lifetimegameCount;
 @property (nonatomic) NSUInteger regularhighscore;
 @property (nonatomic) NSUInteger regularStreakRecord;
 @property(nonatomic)  NSUInteger classicHighscore;
 @property (nonatomic) NSUInteger classicHighstreak;
 @property (nonatomic) double lifeTimePercentage;
 @property (nonatomic)NSUInteger classicGameCount;
 @property (nonatomic)NSUInteger regularGameCount;
 @property (nonatomic)NSUInteger loosingStreak;
 */
@end
