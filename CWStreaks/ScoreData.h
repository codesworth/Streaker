//
//  ScoreData.h
//  CWStreaks
//
//  Created by Mensah Shadrach on 11/1/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "DataService.h"

@class ScoreData;
@interface ScoreData : NSObject

@property (nonatomic) NSUInteger gameHighScore;
@property (nonatomic) NSUInteger gameHighStreak;
@property (nonatomic) NSUInteger regualarGamescore;
@property (nonatomic) NSUInteger alltotalgameScore;
@property (nonatomic) NSUInteger lifetimegameCount;
@property (nonatomic) NSUInteger regularhighscore;
@property(nonatomic)  NSUInteger classicHighscore;
@property (nonatomic) NSUInteger highstreak;
@property (nonatomic) double lifeTimePercentage;
@property (nonatomic)NSUInteger classicGameCount;
@property (nonatomic)NSUInteger regularGameCount;
@property (nonatomic)NSUInteger loosingStreak;
-(void)initGamedata;
-(void)initfb_Userdata:(NSDictionary* _Nonnull)dictionary;
+(nonnull id)mainData;
@end

