//
//  Constants.m
//  CWStreaks
//
//  Created by Mensah Shadrach on 11/1/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Constants.h"


@implementation Constants
NSString* REGL_GAME_COUNT_ = @"regularGameCount";
NSString* CLSSC_GAME_COUNT_  = @"classicGameCount";
NSString* GAME_HIGH_SCORE = @"Highscore";
NSString* ALL_TOTAL_GAMESCORE = @"allgameTotal";
NSString* GAME_HIGH_STREAK = @"Highstreak";
NSString* ALL_REGL_GAME_SCORE = @"AllRegularGameScore";
NSString* GAME_COUNT_LIFETIME = @"lifetime";
NSString* PERCENTAGE_LIFETIME = @"lifetimepercent";
NSString* SEGUE_STARTUPVC_MAINVC = @"SHOWTOSTREAKER";
NSString* REG_HIGH_SCORE = @"reghigh";
NSString* REG_HIGH_STREAK = @"regstreak";
NSString* CLASSIC_HIGH_SCORE = @"classicscore";
NSString* HIGH_STREAK = @"HighStreak";
NSString* USER_UID__ = @"userUID";
NSString* SCORES_VC = @"ResultsVC";
NSString* SEGUE_LOGGED_IN = @"LogInnSegue";
NSString* DID_LOG_IN_ = @"boolKey";
NSString* SEGUE_LEAD_USER = @"leaderToUser";
NSString* GM_LSSN_STRK = @"loosingStreak";
NSString* STRKR_CHLLNG_ID_REGL_ = @"ID_REGL";
NSString* STRKR_CHLLNG_ID_CLSSC_ = @"ID_CLSSC";
NSString* STRKR_CHLLNG_ID_LSNSTRKR_ = @"ID_LSNSTRKR";
NSString* SEGUE_CHALL_RESULTS = @"ChallengeToResults";
NSString* SEGUE_CHALL_NXTCHLL_ = @"PLAYNXTCHLL";
NSString* CHLLNG_OVERTIME__ = @"OTDICT";
NSString* CHLLNG_OT_SCORES = @"OTScores";
NSString* FIR_DB_NOTIF_ = @"Notifications";
NSString* SEGUE_SETTINGS_OUT = @"SettingsOut";
NSString* SEGUE_SETTINGS_ACC_HELP = @"SettingsHelper";
NSString* AUTO_SAVEPHOTO = @"Save";
NSString* game_SFX = @"sfx";

NSString* GAME1 = @"GAME1";
NSString* GAME2 = @"GAME2";
NSString* GAME3 = @"GAME3";
NSString* GAME4 = @"GAME4";
NSString* GAME5 = @"GAME5";
NSString* GAME6 = @"GAME6";
NSString* GAME7 = @"GAME7";
NSString* CHLLNG_SCTN_RQST = @"Challenge Requests";
NSString* CHLLNG_SCTN_ACTV = @"Active Challenges";
NSString* CHLLNG_SCTN_CMPLTD = @"Completed Challenges";
NSString* GAD_APP_ID = @"ca-app-pub-3154651331496372~5630360048";
NSString* GAD_AD_UNIT_ID__ = @"ca-app-pub-3154651331496372/2059614849";
//===============================================================================


NSString* FILE_DIR_COMPLETED = @"Completed";


/*@implementation FIREBASE STRINGS*/

NSString* FIR_BASE_CHILD_USERS = @"Users";
NSString* FIR_BASE_CHILD_PROFILE = @"Profile";
NSString* FIR_BASE_CHILD_USERNAME = @"Username";
NSString* FIR_BASE_CHILD_PROFILE_IMG_URL = @"ProfileImageUrl";
NSString* DB_REF_SCORES = @"Scores";
//NSString* FIR_DB_REF_SC_ALLTIME = @"AllTimeStats";
NSString* FIR_DB_REF_ALLTIME_GAMESCORE = @"AlltimeGameScore";
NSString* FIR_DB_REF_ALLTIME_GAMECOUNT = @"AlltimeGameCount";
NSString* FIR_DB_REF_SC_REGL_HIGHSTREAK = @"RegularHighStreak";
NSString* FIR_DB_REF_SC_REGL_GAMEHIGHSCORE = @"RegularGameHighScore";
NSString* FIR_DB_REF_CLSSC_GAMEHIGHSCORE = @"ClassicGameHighScore";
NSString* FIR_DB_REF_HIGHSTREAK = @"HighStreak";
NSString* FIR_BASE_CHILD_CHLLNG = @"Challenges";
NSString* FIR_BASE_CHILD_CHLLNG_RQST = @"ChallengeRequests";
NSString* FIR_BASE_CHILD_CHLLNG_REQUEST = @"Requests";
NSString* FIR_BASE_CHILD_CHLLNG_PND_RQ = @"Pending";
NSString* FIR_BASE_CHILD_ACTV_CHLLNG_ = @"Active";
NSString* FIR_BASE_CHILD_RESULTS = @"Results";
NSString* FIR_DB_LSSN_STRK = @"LoosingStreak";
NSString* FIR_DB_RGL_GM_COUNT = @"RegularGamecount";
NSString* NOTIF_NAME_USER_FETCHED = @"userfetched";
NSString* SIGNED_OUT = @"SignedOut";
NSString* FIR_DB_LOCALITY_ = @"Location";
NSString* _LOCALITY_LONG_ = @"Longitude";
NSString* _LOCALITY_LAT_ = @"Latitude";
NSString* _SEGUE_EXPLORE_USR = @"ExploreUser";
NSString* CHLL_PNTS_WN_RCRD = @"ChallWinRecord";
NSString* CHLL_PNTS_SRSSWP_PTS = @"SeriesSweepPoints";
NSString* CHLL_PNTS_SRSWN_PTS = @"SeriesWinPoints";
NSString* CHLL_PNTS_GMWN_PNTS = @"GameWinPoints";
NSString* CHLL_PNTS_LSE_RCRD = @"ChallLooseRecord";
NSString* FIR_DB_CH_CHT_ = @"Messages";
NSString* ICON_DEFAULT = @"Default";
NSString* ICON_SLEEK = @"Sleek";
NSString* ICON_SENSEI = @"Sensei";
NSString* ICON_AVATAR__NOTIF = @"AvatarSelected";
NSString* SELECT_ICON = @"SelectedIcon";
NSString* USER_INFO = @"userInfo";
NSString* FIR_DB_LISTED = @"AddedUsers";
NSString* USER_CHALLENGE_SCORE_INFO = @"ChallengeScores";
NSString* FIR_DB_CITY = @"City";
#pragma mark - AVATAR FEMALES
NSString* ICON_KAYLA = @"Kayla";//
NSString* ICON_ELENA =@"Elena";
NSString* ICON_MOIRA = @"Moira";//
NSString* ICON_ANNETTE= @"Annette";
NSString* ICON_CAMILLE= @"Camille";
NSString* ICON_NADIA= @"Nadia";//
NSString* ICON_NICOLE= @"Nicole";
NSString* ICON_VELMA = @"Velma";//
NSString* ICON_APRIL= @"April";//
NSString* ICON_SHANICE= @"Shanice";//
NSString* ICON_ANDREA= @"Andrea";//
NSString* ICON_AMY= @"Amy";//
NSString* ICON_DENISE= @"Denise";//
NSString* ICON_CLARISA= @"Clarisa";//
NSString* ICON_DIANNE= @"Dianne";//
NSString* ICON_ALLERIE= @"Allerie";//
NSString* ICON_PHOEBE= @"Phoebe";//
NSString* ICON_ENYA= @"Enya";
NSString* ICON_BRITTANY= @"Brittany";//
NSString* ICON_LYNEESE= @"Lyneese";//
NSString* ICON_INNA= @"Inna";//
NSString* ICON_LAUREN = @"Lauren";
NSString* ICON_FIONA = @"Fiona";
NSString* ICON_SELENA = @"Selena";//
NSString* ICON_EVA = @"Eva";//


#pragma mark - FEMALES
NSString* ICON_LESLIE= @ "Leslie";
NSString* ICON_NATHAN= @ "Nathan";
NSString* ICON_AIDAN= @ "Aidan";
NSString* ICON_LEONARD= @ "Leonard";
NSString* ICON_PETE= @ "Peter";
NSString* ICON_JARED= @ "Jared";
NSString* ICON_FABRICE= @ "Fabrice";
NSString* ICON_NICK= @ "Nick";//
NSString* ICON_CAESAR= @ "Caesar";//
NSString* ICON_RALPH= @ "Ralph";//
NSString* ICON_FYNN= @ "Fynn";//
NSString* ICON_FRED= @ "Fred";//
NSString* ICON_RYAN= @ "Ryan";//
NSString* ICON_STEFAN= @ "Stefan";//
NSString* ICON_JEROME= @ "Jerome";//
NSString* ICON_JAMAL= @ "Jamal";
NSString* ICON_JESSE= @ "Jesse";
NSString* ICON_REUBEN= @ "Reuben";
NSString* ICON_XAVIER= @ "Xavier";//
NSString* ICON_LOGAN= @ "Logan";
NSString* ICON_SCOTT= @ "Scott";
NSString* ICON_HARRY= @ "Harry";//
NSString* ICON_MARK= @ "Mark";//
NSString* ICON_TERRENCE= @ "Terrence";
NSString* ICON_TYLER= @ "Tyler";//



//===============================================================================

//@implementation BOOLEAN__KEYS
BOOL __LOGGED_IN = NO;



NSString* REUSE_ID_LEADERBOARD_CELLS = @"LeaderBoards";
NSString* REUSE_ID_CHLLNG_CLL = @"ChallengeCells";
NSString* SEGUE_CHAT_VIEW = @"chatVC";
NSString* FIR_NOTIF_TP_CHRQUEST = @"/topics/ChallengeRequests";
NSString* FIR_NOTIF_TP_GAMESTOPLAY = @"/topics/GamesToPlay";
NSString* FIR_NOTIF_TP_MESSAGERECIEVED = @"/topics/Messaged";
//=====================================================================

/*MARK: @implementation STORYBOARD IDs*/

NSString* ID_LOG_IN_VC = @"LogInVC";
NSString* ID_START_UP_VC = @"StartupVC";


//===============================================================================

+(UIAlertController*)createDefaultAlert:(NSString*)withTittle title:(NSString*)withmessage message :(NSString*)with {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:withTittle message:withmessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* action = [UIAlertAction actionWithTitle: with style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        //
    }];
    [alert addAction:action];
    return alert;
}

+(NSString*)stringFromDate:(NSDate*)date
{
    NSDateFormatter* format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"dd-MMM-yyyy HH:mm";
    NSString* stringdate = [format stringFromDate:(date)];
    return stringdate;
}

+(void)delayWithSeconds:(double)time exec:(Execute)completion
{
    //dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(NSEC_PER_SEC * time)/NSEC_PER_SEC);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        completion();
    });

}

+(void)imageBoundSetup:(CALayer*)layer delay:(double)time isInView:(BOOL)isView{
    if (isView){
        [Constants delayWithSeconds:time exec:^{
            [UIView animateWithDuration:1.5 delay:0 options:(UIViewAnimationOptionTransitionFlipFromLeft) animations:^{
                layer.backgroundColor = (__bridge CGColorRef _Nullable)[Constants createGradientColors:nil];
            } completion:^(BOOL finished) {
                [Constants imageBoundSetup:layer delay:time isInView:isView];
            }];
        }];
    }
    
}

+(UIViewController*)initLogInVC
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController* log = [storyboard instantiateViewControllerWithIdentifier:ID_LOG_IN_VC];
    return log;
}

+(id)createGradientColors:(NSNumber*)exception
{   /*C - Sky blue 2 white is voilet is  5*/
    CGColorRef a = [[UIColor colorWithRed:1 green:0.0824 blue:0.714 alpha:1]CGColor];
    CGColorRef b = [[UIColor colorWithRed:0.980 green:0.420 blue:0.345 alpha:1] CGColor];
    CGColorRef c = [[UIColor colorWithRed:0.161 green:0.745 blue:1 alpha:1] CGColor];
    CGColorRef d = [[UIColor colorWithRed:0.176 green:0.176 blue:0.176 alpha:1] CGColor];
    CGColorRef e = [[UIColor colorWithRed:0 green:0.133 blue:0.953 alpha:1] CGColor];
    CGColorRef f = [[UIColor colorWithRed:0.725 green:0.467 blue:1 alpha:1] CGColor];
    CGColorRef g = [[UIColor colorWithRed:0.071 green:0.451 blue:0.42 alpha:1]CGColor];
    CGColorRef h = [[UIColor purpleColor] CGColor];
    CGColorRef i = [[UIColor cyanColor]CGColor];
    CGColorRef j = [[UIColor colorWithRed:0.255 green:1 blue:0.4235 alpha:1]CGColor];
    
    NSArray* colors = @[(__bridge id)a,(__bridge id)b,(__bridge id)c,(__bridge id)d,(__bridge id)e, (__bridge id)f, (__bridge id)g, (__bridge id)h, (__bridge id)i, (__bridge id)j];
    NSUInteger index = arc4random_uniform((uint32_t)colors.count);
    if (exception && [exception unsignedIntegerValue] == index) {
        index++;
    }
    return [colors objectAtIndex:index];
    
}

+(void)dynamicOverlay:(CALayer*)layer color:(id)color did:(Execute)onComplete
{

    [Constants delayWithSeconds:2 exec:^{
        [UIView animateWithDuration:2 delay:0 options:(UIViewAnimationOptionTransitionFlipFromLeft) animations:^{
            layer.backgroundColor = (__bridge CGColorRef _Nullable)color;

        } completion:^(BOOL finished) {
            onComplete();
        }];

    }];
}

+(void)dynamicOverlay:(CALayer*)layer with:(NSUInteger)index did:(Execute)onComplete
{
    
    CGColorRef a = [[UIColor colorWithRed:0.247 green:0 blue:0.761 alpha:1]CGColor];
    CGColorRef b = [[UIColor colorWithRed:0.306 green:0 blue:0.761 alpha:1]CGColor];
    CGColorRef c = [[UIColor colorWithRed:0.361 green:0 blue:0.761 alpha:1]CGColor];
    CGColorRef d = [[UIColor colorWithRed:0.420 green:0 blue:0.761 alpha:1]CGColor];
    CGColorRef e = [[UIColor colorWithRed:0.475 green:0 blue:0.761 alpha:1]CGColor];
    CGColorRef f = [[UIColor colorWithRed:0.533 green:0 blue:0.761 alpha:1]CGColor];
    CGColorRef g = [[UIColor colorWithRed:0.588 green:0 blue:0.761 alpha:1]CGColor];
    NSArray* colors = @[(__bridge id)a,(__bridge id)b,(__bridge id)c,(__bridge id)d,(__bridge id)e, (__bridge id)f, (__bridge id)g];
    [Constants delayWithSeconds:3 exec:^{
        [UIView animateWithDuration:3 delay:0 options:(UIViewAnimationOptionTransitionFlipFromLeft) animations:^{
            layer.backgroundColor = (__bridge CGColorRef _Nullable)[colors objectAtIndex:index];
            
        } completion:^(BOOL finished) {
            
            [Constants dynamicOverlay:layer with:index did:nil];
        }];
        
    }];
    index++;
}

+(id)returnOrderdynamicColor:(NSUInteger)index
{
    CGColorRef a = [[UIColor colorWithRed:0.247 green:0 blue:0.761 alpha:1]CGColor];
    CGColorRef b = [[UIColor colorWithRed:0.306 green:0 blue:0.761 alpha:1]CGColor];
    CGColorRef c = [[UIColor colorWithRed:0.361 green:0 blue:0.761 alpha:1]CGColor];
    CGColorRef d = [[UIColor colorWithRed:0.420 green:0 blue:0.761 alpha:1]CGColor];
    CGColorRef e = [[UIColor colorWithRed:0.475 green:0 blue:0.761 alpha:1]CGColor];
    CGColorRef f = [[UIColor colorWithRed:0.533 green:0 blue:0.761 alpha:1]CGColor];
    CGColorRef g = [[UIColor colorWithRed:0.588 green:0 blue:0.761 alpha:1]CGColor];
        NSArray* colors = @[(__bridge id)a,(__bridge id)b,(__bridge id)c,(__bridge id)d,(__bridge id)e, (__bridge id)f, (__bridge id)g];

    //NSLog(@"The index iss %lu",(unsigned long)index);
    return [colors objectAtIndex:index];
}

+(NSString* _Nonnull)uid
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:USER_UID__];
}

BOOL skip = NO;


+(NSArray*)avatar
{
    NSArray* array = @[ICON_DEFAULT,
                       ICON_SLEEK,
                       ICON_LESLIE,
                       ICON_NATHAN,
                       ICON_AIDAN,
                       ICON_LEONARD,
                       ICON_PETE,
                       ICON_JARED,
                       ICON_FABRICE,
                       ICON_NICK,
                       ICON_CAESAR,
                       ICON_RALPH,
                       ICON_FYNN,
                       ICON_FRED,
                       ICON_RYAN,
                       ICON_STEFAN,
                       ICON_JEROME,
                       ICON_JAMAL,
                       ICON_JESSE,
                       ICON_REUBEN,
                       ICON_XAVIER,
                       ICON_LOGAN,
                       ICON_SCOTT,
                       ICON_HARRY,
                       ICON_MARK,
                       ICON_TERRENCE,
                       ICON_TYLER,
                       ICON_SENSEI,
                       ICON_KAYLA,
                       ICON_ELENA,
                       ICON_MOIRA,
                       ICON_ANNETTE,
                       ICON_CAMILLE,
                       ICON_NADIA,
                       ICON_NICOLE,
                       ICON_VELMA,
                       ICON_APRIL,
                       ICON_SHANICE,
                       ICON_ANDREA,
                       ICON_AMY,
                       ICON_DENISE,
                       ICON_CLARISA,
                       ICON_DIANNE,
                       ICON_ALLERIE,
                       ICON_PHOEBE,
                       ICON_ENYA,
                       ICON_BRITTANY,
                       ICON_LYNEESE,
                       ICON_INNA,
                       ICON_LAUREN,
                       ICON_FIONA,
                       ICON_SELENA,
                       ICON_EVA
                       ];
    return array;
}

+(NSString *)countHelper:(NSUInteger)count
{
    
    if (count > 1000000 && count < 10000000){
        NSString* c = [NSString stringWithFormat:@"%lu",(unsigned long)count];
        NSArray* i_c = [c componentsSeparatedByString:@""];
        NSString* s = [NSString stringWithFormat:@"%@.%@%@M", [i_c objectAtIndex:0], [i_c objectAtIndex:1], [i_c objectAtIndex:2]];
        return s;
    }else if (count > 10000000 && count < 100000000){
        NSString* c = [NSString stringWithFormat:@"%lu",(unsigned long)count];
        NSArray* i_c = [c componentsSeparatedByString:@""];
        NSString* s = [NSString stringWithFormat:@"%@%@.%@M", [i_c objectAtIndex:0], [i_c objectAtIndex:1], [i_c objectAtIndex:2]];
        return s;
    }else if (count > 100000000 && count < 1000000000){
        NSString* c = [NSString stringWithFormat:@"%lu",(unsigned long)count];
        NSArray* i_c = [c componentsSeparatedByString:@""];
        NSString* s = [NSString stringWithFormat:@"%@%@%@M", [i_c objectAtIndex:0], [i_c objectAtIndex:1], [i_c objectAtIndex:2]];
        return s;
    }else if (count > 1000000000 && count < 10000000000){
        NSString* c = [NSString stringWithFormat:@"%lu",(unsigned long)count];
        NSArray* i_c = [c componentsSeparatedByString:@""];
        NSString* s = [NSString stringWithFormat:@"%@.%@%@B", [i_c objectAtIndex:0], [i_c objectAtIndex:1], [i_c objectAtIndex:2]];
        return s;
    }else if (count > 10000000000 && count < 100000000000){
        NSString* c = [NSString stringWithFormat:@"%lu",(unsigned long)count];
        NSArray* i_c = [c componentsSeparatedByString:@""];
        NSString* s = [NSString stringWithFormat:@"%@%@.%@B", [i_c objectAtIndex:0], [i_c objectAtIndex:1], [i_c objectAtIndex:2]];
        return s;
    }else if (count > 100000000000 && count < 1000000000000){
        NSString* c = [NSString stringWithFormat:@"%lu",(unsigned long)count];
        NSArray* i_c = [c componentsSeparatedByString:@""];
        NSString* s = [NSString stringWithFormat:@"%@%@%@B", [i_c objectAtIndex:0], [i_c objectAtIndex:1], [i_c objectAtIndex:2]];
        return s;
    }else if (count > 1000000000000){
        //NSString* c = [NSString stringWithFormat:@"%lu",(unsigned long)count];
        //NSArray* i_c = [c componentsSeparatedByString:@""];
        NSString* s = [NSString stringWithFormat:@"1T+"];
        return s;
    }else{
        return [NSString stringWithFormat:@"%lu",(unsigned long)count];
    }
}

+(NSArray<NSString*>*)openSLs
{
    return @[@"Appirater",@"Apple Reachablity",@"MBCircularProgressBar" ,@"CustomBadge",@"JSQMessagesViewController"];
}

+(NSString*)create_return_Directory:(NSString*)name
{
    NSError* error;
    NSString* npath = [NSString stringWithFormat:@"%@",name];
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* path = [paths firstObject];
    NSString* filePath = [path stringByAppendingPathComponent:npath];
    if(![[NSFileManager defaultManager]fileExistsAtPath:filePath]){
        [[NSFileManager defaultManager]createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:@{} error:&error];
        if(error){
            
        }
    }
    return filePath;
}



+(NSURL*)createdocumentsUrlFor:(NSString*)pathString
{
    NSError* error = nil;
    NSURL* path = [[NSFileManager defaultManager]URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:&error];
    if(error){
        //NSLog(@"the error %@",error);
        return nil;
    }
    NSURL* imagePth = [path URLByAppendingPathComponent:pathString];
    return imagePth;
}


+(BOOL)fileExists:(NSString*)filePath
{
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        return YES;
    }
    return NO;
}

+(NSString*)createDirectoryForChat:(NSString*)challengeKey
{
    NSError* error;
    NSString* npath = [NSString stringWithFormat:@"%@", challengeKey];
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* path = [paths firstObject];
    NSString* newPath = [path stringByAppendingPathComponent:npath];
    if(![[NSFileManager defaultManager]fileExistsAtPath:newPath]){
        [[NSFileManager defaultManager]createDirectoryAtPath:newPath withIntermediateDirectories:YES attributes:@{} error:&error];
        if(error){
            
        }
    }
    NSString* filePath = [newPath stringByAppendingPathComponent:@"chats.plist"];
    return filePath;
}

/*+(NSString*)filePath
{
    NSString* path = [Constants createDirectory];
    NSString* filePath = [path stringByAppendingPathComponent:@"chats.plist"];
    return filePath;
}*/

+(void)animateLayer:(CAGradientLayer*)gradient animDelegate:(id)delegate
{
    
    NSArray *fromColors = gradient.colors;
    NSArray *toColors = @[(id)[UIColor redColor].CGColor,
                          (id)[UIColor orangeColor].CGColor];
    
    [gradient setColors:toColors];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"colors"];
    
    animation.fromValue             = fromColors;
    animation.toValue               = toColors;
    animation.duration              = 3.00;
    animation.removedOnCompletion   = YES;
    animation.fillMode              = kCAFillModeForwards;
    animation.timingFunction        = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.delegate             = delegate;
    
    // Add the animation to our layer
    
    [gradient addAnimation:animation forKey:@"animateGradient"];
}

@end
