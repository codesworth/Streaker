//
//  Constants.h
//  CWStreaks
//
//  Created by Mensah Shadrach on 11/1/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

#import <CoreFoundation/CoreFoundation.h>
#import <UIKit/UIKit.h>


typedef void(^Execute)(void);
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
#define IS_ZOOMED (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_iPadPro (SCREEN_MAX_LENGTH == 1366)

@interface Constants : NSObject

extern NSString* _Nonnull GAME_HIGH_SCORE;
extern NSString* _Nonnull  ALL_TOTAL_GAMESCORE;
extern NSString* _Nonnull GAME_HIGH_STREAK;
extern NSString* _Nullable GAME_HIGH_SCORE_GAME_COUNT;
extern NSString* _Nullable GAME_COUNT_LIFETIME;
extern NSString* _Nullable PERCENTAGE_LIFETIME;
extern NSString* _Nullable SEGUE_STARTUPVC_MAINVC;
extern NSString* _Nullable REG_HIGH_SCORE;
extern NSString* _Nullable REG_HIGH_STREAK;
extern NSString* _Nullable CLASSIC_HIGH_SCORE;
extern NSString* _Nullable HIGH_STREAK;
extern NSString* _Nullable USER_UID__;
extern NSString* _Nullable SCORES_VC;
extern NSString* _Nullable SEGUE_LOGGED_IN;
extern NSString* _Nullable DID_LOG_IN_;
extern NSString* _Nullable SEGUE_LEAD_USER;
extern NSString* _Nullable REGL_GAME_COUNT_;
extern NSString* _Nullable CLSSC_GAME_COUNT_;
extern NSString* _Nullable GM_LSSN_STRK;
extern NSString* _Nullable FIR_DB_NOTIF_;
extern NSString* _Nullable FIR_DB_LISTED;
extern NSString* _Nullable AUTO_SAVEPHOTO;
extern NSString* _Nullable game_SFX;
extern NSString* _Nullable STRKR_CHLLNG_ID_REGL_;
extern NSString* _Nullable STRKR_CHLLNG_ID_CLSSC_;
extern NSString* _Nullable STRKR_CHLLNG_ID_LSNSTRKR_;
extern NSString* _Nullable SEGUE_CHALL_RESULTS;
extern NSString* _Nullable SEGUE_CHALL_NXTCHLL_;
extern NSString* _Nullable CHLLNG_OVERTIME__;
extern NSString* _Nullable CHLLNG_OT_SCORES;
extern NSString* _Nullable FIR_DB_LSSN_STRK;
extern NSString* _Nullable FIR_DB_RGL_GM_COUNT;
extern NSString* _Nullable ALL_REGL_GAME_SCORE;
extern NSString* _Nullable GAD_APP_ID;
extern NSString* _Nullable GAD_AD_UNIT_ID__;
extern NSString* _Nullable SEGUE_SETTINGS_OUT;
extern NSString* _Nullable SEGUE_SETTINGS_ACC_HELP;
extern NSString* _Nullable FIR_NOTIF_TP_GAMESTOPLAY;
extern NSString* _Nullable FIR_NOTIF_TP_MESSAGERECIEVED;
//==================================================================== CHALLENGE GAMES
extern NSString* _Nullable GAME1;
extern NSString* _Nullable GAME2;
extern NSString* _Nullable GAME3;
extern NSString* _Nullable GAME4;
extern NSString* _Nullable GAME5;
extern NSString* _Nullable GAME6;
extern NSString* _Nullable GAME7;
extern NSString* _Nullable CHLLNG_SCTN_RQST;
extern NSString* _Nullable CHLLNG_SCTN_ACTV ;
extern NSString* _Nullable CHLLNG_SCTN_CMPLTD;
extern NSString* _Nullable FIR_DB_LOCALITY_;
extern NSString* _Nullable _LOCALITY_LONG_;
extern NSString* _Nullable _LOCALITY_LAT_;
extern NSString* _Nullable _SEGUE_EXPLORE_USR;
//====================================================================
/*TABLEVIEWCELLS*/

extern NSString* _Nullable REUSE_ID_LEADERBOARD_CELLS;
extern NSString* _Nullable REUSE_ID_CHLLNG_CLL;

//====================================================================
/*MARK FIREBASE STRING HOLDERS*/
extern NSString* _Nullable FIR_NOTIF_TP_CHRQUEST;
extern NSString* _Nullable FIR_BASE_CHILD_USERS;
extern NSString* _Nullable FIR_BASE_CHILD_PROFILE;
extern NSString* _Nullable FIR_BASE_CHILD_USERNAME;
extern NSString* _Nullable FIR_BASE_CHILD_PROFILE_IMG_URL;
extern NSString* _Nullable DB_REF_SCORES;
extern NSString* _Nullable FIR_DB_REF_ALLTIME_GAMESCORE;
extern NSString* _Nullable FIR_DB_REF_ALLTIME_GAMECOUNT;
extern NSString* _Nullable FIR_DB_REF_SC_REGL_HIGHSTREAK;
extern NSString* _Nullable FIR_DB_REF_SC_REGL_GAMEHIGHSCORE;
extern NSString* _Nullable FIR_DB_REF_CLSSC_GAMEHIGHSCORE;
extern NSString* _Nullable FIR_DB_REF_HIGHSTREAK;
extern NSString* _Nullable FIR_BASE_CHILD_CHLLNG_REQUEST;
extern NSString* _Nullable FIR_BASE_CHILD_CHLLNG_PND_RQ;
extern NSString* _Nullable FIR_BASE_CHILD_ACTV_CHLLNG_;
extern NSString* _Nullable FIR_BASE_CHILD_RESULTS;
extern NSString* _Nullable FIR_BASE_CHILD_CHLLNG;
extern NSString* _Nullable FIR_BASE_CHILD_CHLLNG_RQST;
extern NSString* _Nullable NOTIF_NAME_USER_FETCHED;
extern NSString* _Nullable SIGNED_OUT;
extern NSString* _Nullable CHLL_PNTS_WN_RCRD;
extern NSString* _Nullable CHLL_PNTS_SRSSWP_PTS;
extern NSString* _Nullable CHLL_PNTS_SRSWN_PTS;
extern NSString* _Nullable CHLL_PNTS_GMWN_PNTS;
extern NSString* _Nullable CHLL_PNTS_LSE_RCRD;
extern NSString* _Nullable FIR_DB_CH_CHT_;
extern NSString* _Nullable SEGUE_CHAT_VIEW;
extern NSString* _Nullable ICON_DEFAULT;
extern NSString* _Nullable ICON_SLEEK;
extern NSString* _Nullable ICON_SENSEI;
extern NSString* _Nullable ICON_AVATAR__NOTIF;
extern NSString* _Nullable SELECT_ICON;
extern NSString* _Nullable USER_INFO;
extern NSString* _Nullable USER_CHALLENGE_SCORE_INFO;
extern NSString* _Nullable FIR_DB_CITY;
extern NSString* _Nullable FILE_DIR_COMPLETED;

#pragma mark - AVATAR FEMALES
extern NSString* _Nullable ICON_KAYLA;
extern NSString* _Nullable ICON_ELENA;
extern NSString* _Nullable ICON_ALICE;
extern NSString* _Nullable ICON_MOIRA;
extern NSString* _Nullable ICON_CAMILLE;
extern NSString* _Nullable ICON_NADIA;
extern NSString* _Nullable ICON_NICOLE;
extern NSString* _Nullable ICON_VELMA;
extern NSString* _Nullable ICON_APRIL;
extern NSString* _Nonnull ICON_SHANICE;
extern NSString* _Nonnull ICON_ANDREA;
extern NSString* _Nullable ICON_AMY;
extern NSString* _Nonnull ICON_DENISE;
extern NSString* _Nonnull ICON_CLARISA;
extern NSString* _Nonnull ICON_DIANNE;
extern NSString* _Nonnull ICON_ALLERIE;
extern NSString* _Nonnull ICON_PHOEBE;
extern NSString* _Nonnull ICON_ENYA;
extern NSString* _Nonnull ICON_BRITTANY;
extern NSString* _Nonnull ICON_LYNEESE;
extern NSString* _Nonnull ICON_INNA;
extern NSString* _Nonnull ICON_LAUREN;
extern NSString* _Nonnull ICON_FIONA;
extern NSString* _Nonnull ICON_SELENA;
extern NSString* _Nonnull ICON_EVA;



#pragma mark - AVATAR FEMALES

extern NSString* _Nonnull ICON_LESLIE;
extern NSString* _Nonnull ICON_NATHAN;
extern NSString* _Nonnull ICON_AIDAN;
extern NSString* _Nonnull ICON_LEONARD;
extern NSString* _Nonnull ICON_PETE;
extern NSString* _Nonnull ICON_JARED;
extern NSString* _Nonnull ICON_FABRICE;
extern NSString* _Nonnull ICON_NICK;
extern NSString* _Nonnull ICON_CAESAR;
extern NSString* _Nonnull ICON_RALPH;
extern NSString* _Nonnull ICON_FYNN;
extern NSString* _Nonnull ICON_FRED;
extern NSString* _Nonnull ICON_RYAN;
extern NSString* _Nonnull ICON_STEFAN;
extern NSString* _Nonnull ICON_JEROME;
extern NSString* _Nonnull ICON_JAMAL;
extern NSString* _Nonnull ICON_JESSE;
extern NSString* _Nonnull ICON_REUBEN;
extern NSString* _Nonnull ICON_XAVIER;
extern NSString* _Nonnull ICON_LOGAN;
extern NSString* _Nonnull ICON_SCOTT;
extern NSString* _Nonnull ICON_HARRY;
extern NSString* _Nonnull ICON_MARK;
extern NSString* _Nonnull ICON_TERRENCE;
extern NSString* _Nonnull ICON_TYLER;
extern BOOL skip;
    //=====================================================================
/* MARK BOOLEAN HOLDERS*/
extern BOOL __LOGGED_IN;

//=====================================================================

/*MARK: STORYBOARD IDs*/
extern NSString* _Nonnull ID_LOG_IN_VC;
extern NSString* _Nonnull ID_START_UP_VC;


//====================================================================
+(UIAlertController*_Nullable)createDefaultAlert:(NSString*_Nonnull)withTittle title:(NSString*_Nullable)withmessage message :(NSString*_Nonnull)with ;
+(NSArray*_Nonnull)avatar;
+(NSString*_Nullable)stringFromDate:(NSDate*_Nonnull)date;
+(id _Nullable )createGradientColors:(NSNumber* _Nullable)exception;
+(void)imageBoundSetup:(CALayer* _Nonnull)layer delay:(double)time isInView:(BOOL)isView;
+(void)delayWithSeconds:(double)time exec:(nullable Execute)completion;
+(NSString* _Nonnull)uid;
+(UIViewController* _Nonnull)initLogInVC;
+(NSString* _Nullable)countHelper:(NSUInteger)count;
+(NSArray<NSString*>* _Nonnull)openSLs;
+(NSURL* _Nullable)createdocumentsUrlFor:(NSString* _Nonnull)pathString;
+(BOOL)fileExists:(NSString* _Nonnull)filePath;
+(NSString* _Nullable)create_return_Directory:(NSString* _Nonnull)name;
+(NSString* _Nullable)createDirectoryForChat:(NSString* _Nonnull)challengeKey;
+(void)dynamicOverlay:(CALayer*_Nullable)layer with:(NSUInteger)index did:(Execute _Nullable )onComplete;
//+(void)dynamicOverlay:(CALayer*_Nullable)layer did:(Execute _Nullable )onComplete;
+(void)dynamicOverlay:(CALayer*_Nullable)layer color:(id _Nullable )color did:(Execute _Nullable )onComplete;
//+(NSString* _Nullable)filePath;


@end

