//
//  ViewController.h
//  CWStreaks
//
//  Created by Mensah Shadrach on 10/31/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CW-Predef_Header.h"


@import AVFoundation;
@import Firebase;
@import FirebaseDatabase;
@interface ViewController : UIViewController<GADInterstitialDelegate>

@property (nonatomic) NSUInteger gamescore;
@property (nonatomic) NSUInteger streakScore;
@property (nonatomic) NSUInteger highscore;
@property (nonatomic) NSUInteger highStreak;
@property (nonatomic) NSUInteger allGamesCount;
@property (nonatomic) NSUInteger regularhighscore;
@property (nonatomic) NSUInteger regularStreakRecord;
@property(nonatomic)  NSUInteger classicHighscore;
@property (nonatomic) NSUInteger classicHighstreak;
@property (weak, nonatomic) IBOutlet FloatingViews * _Nullable challengeoverView;
@property (weak, nonatomic) IBOutlet UILabel * _Nullable challengeScore;
@property (strong, nonatomic) IBOutlet UIView * _Nullable challengeScoreView;

@property(nonatomic) BOOL isRegularSession;
@property(nonatomic) BOOL isClassicSession;
@property(nonatomic) BOOL isPaused;
@property (strong,nonnull,nonatomic) ScoreData *manager;
@property(strong, nonnull, nonatomic) DatabaseService* service;
@property (nonatomic) double winPercentage;
@property (nonatomic) double lifeTimeWinPercentage;
@property(nonatomic, strong, nonnull)Challenge* challenge;
@property(nonatomic)BOOL isChallenging;
@property (nonatomic)BOOL isOvertiming;
@property(nonatomic, strong, nullable)NSMutableDictionary* overtimeDict;
@property(strong, nonatomic,nullable)GADInterstitial* interstitialAdView;
@property (weak, nonatomic) IBOutlet UIButton * _Nullable playAgainBttn;
@property (strong, nonatomic) IBOutlet UIView * _Nullable megScoreView;
@end

