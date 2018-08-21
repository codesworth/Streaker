//
//  ViewController.m
//  CWStreaks
//
//  Created by Mensah Shadrach on 10/31/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

#import "ViewController.h"
#import "CWStreaks-Swift.h"

#define FRAME ([[UIScreen mainScreen] bounds])


@interface ViewController ()<CAAnimationDelegate>

@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button4;
@property (weak, nonatomic) IBOutlet UILabel *firstNumber;
@property (weak, nonatomic) IBOutlet UIImageView *spiral;
@property (weak, nonatomic) IBOutlet UILabel *secondNumber;
@property (weak, nonatomic) IBOutlet UILabel *thirdNumber;
@property (weak, nonatomic) IBOutlet UILabel *fourthNumber;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *streakLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *highScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *bestStreakLabel;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet MaterialView *view1;
@property (weak, nonatomic) IBOutlet MaterialView *view2;
@property (weak, nonatomic) IBOutlet MaterialView *view3;
@property (weak, nonatomic) IBOutlet MaterialView *view4;
@property (strong, nonatomic) IBOutlet UIView *normalscoreView;
@property (weak, nonatomic) IBOutlet UILabel *mgamtypelabel;
@property (weak, nonatomic) IBOutlet UILabel *mgameScore;
@property (weak, nonatomic) IBOutlet UILabel *mgamePercentage;
@property (weak, nonatomic) IBOutlet UILabel *mscoreViewgamestreaklabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *b1topconstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *b1leadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *b2topcnt;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *b2trailingcnt;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *b3bottomcnt;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *b3leadincnt;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *b4botcnt;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *b4trailingcnt;
@property (weak, nonatomic) IBOutlet UILabel *nGameType;
@property (weak, nonatomic) IBOutlet UILabel *ngameScore;
@property (weak, nonatomic) IBOutlet UILabel *ngamestreak;
@property (weak, nonatomic) IBOutlet UILabel *npercent;

@property (weak, nonatomic) IBOutlet UIImageView *img130;
@property (weak, nonatomic) IBOutlet UIImageView *img100;
@property (weak, nonatomic) IBOutlet UIImageView *img80;
@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UIImageView *img2;
@property (weak, nonatomic) IBOutlet UIImageView *img3;
@property (weak, nonatomic) IBOutlet UIImageView *img4;
@property (weak, nonatomic) IBOutlet UIButton *playAgnbttnnorm;

@property(strong,nonatomic,nullable)AVAudioPlayer* player;
@property(strong,nonatomic,nullable)AVAudioPlayer* buzzplayer;
@property(strong,nonatomic,nullable)AVAudioPlayer* missplayer;
@property(strong,nonatomic)UIView* scoreView;
@property (strong, nonatomic) NSNumber *correctNumber;
@property (strong, nonatomic) NSNumber *chosenNumber;
@property (nonatomic) NSInteger gameCount;
@property (nonatomic) BOOL isSessionRunning;
@property (nonatomic, strong) NSUserDefaults *defaults;
@property (strong, nonatomic) NSTimer *gameTimer;
@property (nonatomic) double timecount;
@property (nonatomic) int milisecondsCount;
@property (nonatomic) int secondsCount;
@property (nonatomic) BOOL timerEnded;
@property (nonatomic, strong) NSMutableArray* colors;
@property (nonatomic) NSUInteger currentGameStreak;
@property (nonatomic) BOOL scoreHasChanges;
@property (nonatomic) BOOL streakHasChanges;
@property (nonatomic, strong) Reachability* internetReachablity;
@property (nonatomic)NSUInteger loosingStreak;
@property (nonatomic)BOOL regularChallenging;
@property (nonatomic)BOOL classicChallenging;
@property (nonatomic)BOOL loosingStreakChallenging;
@property(nonatomic)BOOL sfx;
@property (nonatomic, strong)UILabel *gamtypelabel;
@property (nonatomic, strong)UILabel *gameScore;
@property (nonatomic, strong)UILabel *gamePercentage;
@property (nonatomic, strong)UILabel *scoreViewgamestreaklabel;
@property (nonatomic, strong)UIButton* playagn;
@end

dispatch_queue_t executeInBackground;

NSURL* buzzer;
NSURL* miss;
NSURL* swish;


@implementation ViewController

#pragma mark - Controller Implementations

- (void)viewDidLoad {
    [super viewDidLoad];

    executeInBackground = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    if (IS_IPHONE_5){
        self.scoreView = self.normalscoreView;
        self.gamtypelabel = self.nGameType;
        self.gameScore = self.ngameScore;
        self.scoreViewgamestreaklabel = self.ngamestreak;
        self.gamePercentage = self.npercent;
        self.playagn = self.playAgnbttnnorm;
    }else{
        self.scoreView = self.megScoreView;
        self.gamtypelabel = self.mgamtypelabel;
        self.gameScore = self.mgameScore;
        self.scoreViewgamestreaklabel = self.mscoreViewgamestreaklabel;
        self.gamePercentage = self.mgamePercentage;
        self.playagn = self.playAgainBttn;
    }
    _sfx = [[NSUserDefaults standardUserDefaults]boolForKey:game_SFX];
    if (_sfx) {
        swish = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"swisher" ofType:@"aiff"]];
        buzzer = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"buzzer" ofType:@"aiff"]];
        miss = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"miss" ofType:@"wav"]];
        self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:swish error:nil];
        self.missplayer = [[AVAudioPlayer alloc]initWithContentsOfURL:miss error:nil];
        self.buzzplayer = [[AVAudioPlayer alloc]initWithContentsOfURL:buzzer error:nil];
    }
    [self.challengeScoreView setFrame:self.view.frame];
    CGRect frame = CGRectMake(-(self.view.frame.size.width), 0, self.view.frame.size.width, self.view.frame.size.height);
    [_scoreView setFrame:frame];
    
    self.colors = [[NSMutableArray alloc]init];
    self.colors = [@[[UIColor redColor], [UIColor greenColor], [UIColor blueColor], [UIColor brownColor], [UIColor yellowColor], [UIColor orangeColor], [UIColor lightGrayColor], [UIColor magentaColor], [UIColor purpleColor], [UIColor cyanColor], [UIColor grayColor]]mutableCopy];
    [self.navigationController setNavigationBarHidden:YES];
    _manager = [ScoreData mainData];
    _service = [DatabaseService main];
    [_manager initGamedata];
    [self prepareForSession];
    [self setUpSession];
    [self createAndLoadInterStitialAdForTesting];
    [self.interstitialAdView setDelegate:self];


    _isPaused = NO;
    _scoreHasChanges = NO;
    _streakHasChanges = NO;
    [self configIpad];
    if(IS_iPadPro){
        
    }
    
}

-(void)playSwish
{
    if(_sfx){
       [self.player play];
    }
    
}

-(void)playMiss
{
    if (_sfx){
        [self.missplayer play];
    }
    
}

-(void)buzzPlayer
{
    if(_sfx){
       [self.buzzplayer play]; 
    }
    
}

-(void)animate360Degrees:(UIView*)view withDuration:(CFTimeInterval)duration withDelegate:(id)delegate completion:(ExecuteAfterFinish)handler
{
    CABasicAnimation* anim = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    [anim setFromValue:0];
    NSNumber* n = [NSNumber numberWithDouble:M_PI * 2];
    [anim setToValue:n];
    [anim setDuration:duration];
    if (delegate != nil){
        anim.delegate = delegate;
        handler();
    }
    [view.layer addAnimation:anim forKey:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    //[self setLayout];
    _gamescore = 0;
    _streakScore = 0;
    _gameCount = 0;
    if(!_isClassicSession){[self.timerLabel setHidden:YES];}
    if (_isChallenging){
        if ([_challenge.challengeID isEqualToString:STRKR_CHLLNG_ID_REGL_]){
            _regularChallenging = YES;
        }else if ([_challenge.challengeID isEqualToString:STRKR_CHLLNG_ID_CLSSC_]){
            _classicChallenging = YES;
            [_timerLabel setHidden:NO];
        }else{
            _loosingStreakChallenging = YES;
        }
    }
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self setLayout];

    //[self.view addSubview:self.scoreView];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    

    //[self.view addSubview:_scoreView];
    if (_isPaused){
        [self.playAgainBttn setTitle:@"Resume" forState:(UIControlStateNormal)];
        [self continueTimer:_secondsCount milli:_milisecondsCount];
        _isPaused = NO;
    }
    if (_timerEnded){
        [self.playAgainBttn setTitle:@"Play Again" forState:(UIControlStateNormal)];
        [self prepareForClassicSession];
        _timerEnded = NO;
    }
    if (_classicChallenging && !_isOvertiming){
        [self setTimer:23];
    }else if (_classicChallenging && _isOvertiming){
        [self setTimer:10];
    }
    
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self saveData];
    
    //[self.scoreView removeFromSuperview];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    
    if ([_service check_fb_connection]){
        if (_isClassicSession){
            if (_scoreHasChanges){
                dispatch_async(executeInBackground, ^{
                    [_service fb_saveClassicGameScore:_manager execute:^{}];
                });
            }
            if (_streakHasChanges){
                dispatch_async(executeInBackground, ^{
                    [_service fb_saveHighStreak:_manager execute:^{}];
                });
            }
        }else if (_isRegularSession){
            if (_scoreHasChanges){
                dispatch_async(executeInBackground, ^{
                    [_service fb_SaveRegGameScore:_manager execute:^{}];
                });
            }
            if (_streakHasChanges) {
                dispatch_async(executeInBackground, ^{
                    [_service fb_saveHighStreak:_manager execute:^{}];
                });
            }
        }
    }else{
        if (_scoreHasChanges){
            [[AppDelegate mainDelegate] setUnSavedContent:YES];
            [AppDelegate mainDelegate].internetReachability = [Reachability reachabilityForInternetConnection];
            [[AppDelegate mainDelegate].internetReachability startNotifier];
        }
    }
    //_scoreView.frame = CGRectMake(30, -600, self.view.frame.size.width - 60, self.view.frame.size.height - 200);
    [_scoreView removeFromSuperview];
    self.isRegularSession = NO;
    self.isClassicSession = NO;
    self.isChallenging = NO;
    self.isOvertiming = NO;
    self.classicChallenging = NO;
    dispatch_async(executeInBackground, ^{
        [[DatabaseService main] fb_saveAllTimeStats:_manager execute:^{}];
    });

}

#pragma mark - Google Ads


-(void)createAndLoadInterStitialAdForTesting
{
    self.interstitialAdView = [[GADInterstitial alloc]initWithAdUnitID:GAD_AD_UNIT_ID__];
    GADRequest* request = [GADRequest request];
    //request.testDevices = @[ @"c5b6e83d0313789be541c4dd0fb00771" ];
    [self.interstitialAdView loadRequest:request];
}

-(GADInterstitial*)createAndLoadInsterstialAd
{
    GADInterstitial* interstitialAd = [[GADInterstitial alloc]initWithAdUnitID:GAD_AD_UNIT_ID__];
    [interstitialAd setDelegate:self];
    [interstitialAd loadRequest:[GADRequest request]];
    return interstitialAd;
}

-(void)presentInterstitialAd
{
    if ([self.interstitialAdView isReady]){
        [self.interstitialAdView presentFromRootViewController:self];
    }else{
        NSLog(@"Failed to load Interstitial Ad");
        
    }
}

-(void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
   
}

-(void)interstitialWillPresentScreen:(GADInterstitial *)ad
{
    
}

-(void)interstitialDidFailToPresentScreen:(GADInterstitial *)ad
{
    NSLog(@"Failed to present Screen");

}

-(void)interstitialDidDismissScreen:(GADInterstitial *)ad
{
    self.interstitialAdView = [self createAndLoadInsterstialAd];
}

-(void)interstitialWillLeaveApplication:(GADInterstitial *)ad
{
    
}

-(void)interstitialWillDismissScreen:(GADInterstitial *)ad
{
    
}

-(void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error
{
    if ([[DatabaseService main]check_fb_connection]) {
        [self createAndLoadInsterstialAd];
    }
}


#pragma mark - Game Logic

-(NSString*)gameNo
{
    NSMutableDictionary* lastResult = [_challenge.results.allResults lastObject];
    if (lastResult != nil){
        if (([lastResult objectForKey:[[DatabaseService main] opponent:self.challenge]] == NULL && !_isOvertiming) || ([lastResult objectForKey:[[NSUserDefaults standardUserDefaults] stringForKey:USER_UID__]] ==NULL && !_isOvertiming)){
            return [NSString stringWithFormat:@"GAME%lu",(unsigned long)self.challenge.results.allResults.count];
        }else if (([lastResult objectForKey:[[DatabaseService main] opponent:self.challenge]] != NULL && !_isOvertiming) || ([lastResult objectForKey:[[NSUserDefaults standardUserDefaults] stringForKey:USER_UID__]] !=NULL && !_isOvertiming)){
            return [NSString stringWithFormat:@"GAME%lu", (unsigned long)self.challenge.results.allResults.count + 1];
        }else{
            return [NSString stringWithFormat:@"GAME%lu", (unsigned long)self.challenge.results.allResults.count];
        }
    }else{
        return @"GAME1";
    }
}





- (IBAction)firstNumberSelected:(id)sender {
    //[self.img1 setImage:[UIImage imageNamed:@"gp"]];
    [self choiceSelected:_button1];
}

- (IBAction)secondNumberSelected:(id)sender {
    //[self.img2 setImage:[UIImage imageNamed:@"op" ]];
    [self choiceSelected:_button2];
}

- (IBAction)thirdNumberSelected:(id)sender {
    //[self.img3 setImage:[UIImage imageNamed:@"bp" ]];
    [self choiceSelected:_button3];

}
- (IBAction)fourthNumberSelected:(id)sender {
    //[self.img4 setImage:[UIImage imageNamed:@"pp" ]];
    [self choiceSelected:_button4];
}

-(void)choiceSelected:(UIButton*)button
{
    self.chosenNumber = [[[NSNumberFormatter alloc] init] numberFromString:button.currentTitle];
    if ([self.chosenNumber intValue] == [self.correctNumber intValue]){
        [self playSwish];
        _gamescore++;
        if(_isRegularSession){_manager.regualarGamescore++;}
        if(_isClassicSession || _isRegularSession){ _manager.alltotalgameScore++;}
        _streakScore++;
        [self updateScore];
        [self configureHighscoreUpdate];
        [self setUpSession];
    }else{
        [self playMiss];
        _streakScore = 0;
        _streakLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long) _streakScore];
        _gameScoreLabel.text = [NSString stringWithFormat:@"%lu / %lu", (unsigned long) _gamescore, (signed long) _gameCount];
        [self setUpSession];
        
    }
}
-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    UIInterfaceOrientation orient = [[UIApplication sharedApplication]statusBarOrientation];
    switch (orient) {
        case UIInterfaceOrientationLandscapeLeft:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self potraitOrient];
            });
            break;
        }
        case UIInterfaceOrientationLandscapeRight:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self potraitOrient];
            });
            break;
        }
            case UIInterfaceOrientationPortrait:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self landscapeOrient];
            });
            break;
        }
        default:
            [self landscapeOrient];
            break;
    }
    
}

-(void)setUpSession{
    //NSLog(@"Loosing Streakkkk:: %lu", (unsigned long)_manager.loosingStreak);
    
    if (_regularChallenging && _gameCount == 82 && !_isOvertiming) {
        self.challengeScore.text = [NSString stringWithFormat:@"%lu", (unsigned long)_gamescore];
        [self.challengeoverView setBackgroundColor:[self.colors objectAtIndex:0]];
        [UIView animateWithDuration:0.5 animations:^{
            
            [self.view addSubview:_challengeScoreView];
            [Constants delayWithSeconds:0.9 exec:^{
                [self presentInterstitialAd];
            }];
        }];
        [[ChallengeEngine mainEngine] engine_UpdateChallengeScore:_gamescore c:_challenge withNo:[self gameNo] didfinish:^{[[DatabaseService main]fb_observeGameWinner:self.challenge];}];
        
    }else if(_loosingStreakChallenging && _gameCount == 82 && !_isOvertiming){
        self.challengeScore.text = [NSString stringWithFormat:@"%lu", (unsigned long)_gamescore];
        [self.challengeoverView setBackgroundColor:[self.colors objectAtIndex:0]];
        [UIView animateWithDuration:0.5 animations:^{
            
            [self.view addSubview:_challengeScoreView];
        }];
        [[ChallengeEngine mainEngine] engine_UpdateChallengeScore:_loosingStreak c:self.challenge withNo:[self gameNo] didfinish:^{[[DatabaseService main]fb_observeGameWinner:self.challenge];}];
    }else if(_regularChallenging && _isOvertiming && _gameCount == 24){
        NSNumber* score = [_overtimeDict objectForKey:[[NSUserDefaults standardUserDefaults] stringForKey:USER_UID__]];
        self.challengeScore.text = [NSString stringWithFormat:@"%lu", (unsigned long)_gamescore + [score unsignedIntegerValue]];
        [self.challengeoverView setBackgroundColor:[self.colors objectAtIndex:0]];
        [UIView animateWithDuration:0.5 animations:^{
            
            [self.view addSubview:_challengeScoreView];
            [Constants delayWithSeconds:1 exec:^{
                [self presentInterstitialAd];
            }];
        }];
        NSUInteger s = [score unsignedIntegerValue] + _gamescore;
        [[ChallengeEngine mainEngine] engine_UpdateChallengeScore:s c:_challenge withNo:[self gameNo] didfinish:^{[[DatabaseService main]fb_observeGameWinner:self.challenge];}];
    }else if(_loosingStreakChallenging && _isOvertiming && _gameCount == 24){
        NSNumber* score = [_overtimeDict objectForKey:[[NSUserDefaults standardUserDefaults] stringForKey:USER_UID__]];
        self.challengeScore.text = [NSString stringWithFormat:@"%lu", (unsigned long)_gamescore + [score unsignedIntegerValue]];
        [self.challengeoverView setBackgroundColor:[self.colors objectAtIndex:0]];
        [UIView animateWithDuration:0.5 animations:^{
            
            [self.view addSubview:_challengeScoreView];
        }];
        NSUInteger s = [score unsignedIntegerValue] + _gamescore;
        [[ChallengeEngine mainEngine] engine_UpdateChallengeScore:s c:_challenge withNo:[self gameNo] didfinish:^{[[DatabaseService main]fb_observeGameWinner:self.challenge];}];
    }
    
    if (_gameCount == 82 && _isRegularSession){
        
        [self initScoreView];
        CGRect frame = self.view.frame;
        [self animate360Degrees:self.spiral withDuration:2 withDelegate:self completion:^{}];
        [UIView animateWithDuration:1.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.3 options:(UIViewAnimationOptionTransitionCrossDissolve) animations:^{
            [self.view addSubview:_scoreView];
            [self.scoreView setHidden:NO];
            self.scoreView.frame = frame;
        } completion:^(BOOL finished) {}];
        self.gameCount = 0;
        self.gamescore = 0;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.gameScoreLabel.text = [NSString stringWithFormat:@"%lu / %lu", (unsigned long) self.gamescore, (signed long) self.gameCount];
            _currentGameStreak = 0;
            
        });

    }
    else if (_timerEnded && _isClassicSession){
        [self initScoreView];
        [self presentScoreView];

    }
    else{
        if (_isClassicSession || _isRegularSession){_manager.lifetimegameCount++;}
        _winPercentage = ((double)_gamescore / (double)_gameCount ) * 100;
        if (_isRegularSession){_manager.regularGameCount++;}
        //if (_isClassicSession){_manager.classicGameCount++;}
        
        if (!_isSessionRunning){
            //_manager.alltotalgameScore = _manager.alltotalgameScore + _gameCount;
            _gamescore = 0;
            _gameCount = 0;
            _streakScore = 0;
            _streakLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long )_streakScore];
            _gameScoreLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)_gamescore];
            _isSessionRunning = YES;
        }
        
        _gameCount++;
        NSMutableArray *sessionArray = [[NSMutableArray alloc] init];
        for ( int x = 1; x < 5; x++) {
            int number = arc4random_uniform(99);
            NSNumber * nsnumber = [[NSNumber alloc] initWithInt:number];
            [sessionArray addObject:nsnumber];
            
        }
        [self shuffleColors];
        NSNumber *first = [sessionArray objectAtIndex:0];
        [self.button1 setTitle:[first stringValue] forState:(UIControlStateNormal)];
       // self.firstNumber.text = [first stringValue];
        self.firstNumber.backgroundColor = [self.colors objectAtIndex:0];
        //_view1.backgroundColor = [_colors objectAtIndex:0];
        NSNumber * second = [sessionArray objectAtIndex:1];
        [self.button2 setTitle:[second stringValue] forState:(UIControlStateNormal)];
        //self.secondNumber.text = [second stringValue];
        self.secondNumber.backgroundColor = [_colors objectAtIndex:4];
        //self.view2.backgroundColor = [_colors objectAtIndex:4];
        NSNumber * third = [sessionArray objectAtIndex:2];
        [self.button3 setTitle:[third stringValue] forState:(UIControlStateNormal)];
        //self.thirdNumber.text = [third stringValue];
        self.thirdNumber.backgroundColor = [_colors objectAtIndex:7];
        //_view3.backgroundColor = [_colors objectAtIndex:7];
        NSNumber * fourth = [sessionArray objectAtIndex:3];
       // self.fourthNumber.text = [fourth stringValue];
        [self.button4 setTitle:[fourth stringValue] forState:(UIControlStateNormal)];
        self.fourthNumber.backgroundColor = [_colors objectAtIndex:10];
        //self.view4.backgroundColor = [_colors objectAtIndex:10];
        int choice = arc4random_uniform(4);
        self.correctNumber = [sessionArray objectAtIndex:choice];
//        [self.img1 setImage:[UIImage imageNamed:@"op" ]];
//        [self.img2 setImage:[UIImage imageNamed:@"op" ]];
//        [self.img3 setImage:[UIImage imageNamed:@"op" ]];
//        [self.img4 setImage:[UIImage imageNamed:@"op" ]];
        //NSLog(@"this total %lu",(unsigned long) _manager.alltotalgameScore);
    }


}
- (IBAction)shuffle:(id)sender {
    if (_isClassicSession){
        _isPaused = YES;
        [self initScoreView];
        [self presentScoreView];
    }else if (_isRegularSession){
        [self initScoreView];
        [self presentScoreView];
    }else{
        [self initScoreView];
        [self presentScoreView];
    }


}

- (IBAction)sartOverButtonPressed:(id)sender {
    //self.isClassicSession = NO;
    //self.isRegularSession = NO;
    [self.navigationController popViewControllerAnimated:YES];
}   

- (IBAction)playAgainButtonPressed:(id)sender {
    [self.img130.layer removeAllAnimations];
    
    
    CGRect frame = CGRectMake(0, -(self.view.frame.size.height + 600), _scoreView.frame.size.width, _scoreView.frame.size.height);
    [UIView animateWithDuration:1.4 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.3 options:( UIViewAnimationOptionCurveEaseIn) animations:^{
        _scoreView.frame = frame;
        //[_scoreView removeFromSuperview];
    } completion:^(BOOL finished) {}];
    if (_isPaused){
        [self continueTimer:_secondsCount milli:_milisecondsCount];
        self.isPaused = NO;
    }else if (!_isPaused && _isClassicSession){
        _currentGameStreak = 0;
            _timerEnded = NO;
            //_gameCount = 0;
            //_gameScore = 0;
        _isSessionRunning = NO;
            [self prepareForSession];
            [self setUpSession];
            return;
    }
    
 
    
}

- (IBAction)scoreTablebuttonPrssed:(id)sender {
    [self performSegueWithIdentifier:SCORES_VC sender:nil];
}

- (IBAction)fb_synchronize:(id)sender {
    [[DatabaseService main] fb_saveUnsavedGamedata:^{}];
}


-(void)updateScore{
    _gameScoreLabel.text = [NSString stringWithFormat:@"%lu / %lu", (unsigned long) _gamescore, (signed long) _gameCount];
    _streakLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long) _streakScore];
}

-(void)updateHighScores{
    if (_gamescore > _highscore){
        _highscore = _gamescore;
        _manager.gameHighScore = _highscore;
        _highScoreLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long) _highscore];
    }
    if (_streakScore > _highStreak){
        _highStreak = _streakScore;
        _currentGameStreak = _streakScore;
        _manager.gameHighStreak = _highStreak;
        _bestStreakLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long) _highStreak];
    }else{
        if (_streakScore > _currentGameStreak){
            _currentGameStreak = _streakScore;

        }
    }

}

-(void)updateRegularHighscore{
    
    if (_gamescore > _regularhighscore){
        _regularhighscore = _gamescore;
        _manager.regularhighscore = _regularhighscore;
        _highScoreLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long) _regularhighscore];
        _scoreHasChanges = YES;
    }
    if (_streakScore > _regularStreakRecord){
        _regularStreakRecord = _streakScore;
        _currentGameStreak = _streakScore;
        _manager.highstreak = _regularStreakRecord;
        _bestStreakLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long) _regularStreakRecord];
        _streakHasChanges = YES;
    }else{
        if (_streakScore > _currentGameStreak){
            _currentGameStreak = _streakScore;
            
        }

    }
}

-(void)updateClassichighScore{
    if (_gamescore > _classicHighscore){
        _classicHighscore = _gamescore;
        _manager.classicHighscore = _classicHighscore;
        _highScoreLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long) _classicHighscore];
        _scoreHasChanges = YES;
        
    }
    if (_streakScore > _classicHighstreak){
        _classicHighstreak = _streakScore;
        _currentGameStreak = _streakScore;
        _manager.highstreak = _classicHighstreak;
        _bestStreakLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long) _classicHighstreak];
        _streakHasChanges = YES;
    }
    else{
        if (_streakScore > _currentGameStreak){
            _currentGameStreak = _streakScore;
            //NSLog(@"THe current strak is %lu", _currentGameStreak );
        }

    }
}

-(void)awakeFromScoreData{
    _highscore = _manager.gameHighScore;
    _highStreak = _manager.gameHighStreak;
    _lifeTimeWinPercentage = _manager.lifeTimePercentage;
    _regularStreakRecord = _manager.highstreak;
    _regularhighscore = _manager.regularhighscore;
}

-(void)prepareForRegularSession{
    _currentGameStreak = 0;
    [self.timerLabel setHidden:YES];
    _regularhighscore = _manager.regularhighscore;
    _regularStreakRecord = _manager.highstreak;
    _highScoreLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long) _regularhighscore];
    _bestStreakLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long) _regularStreakRecord];

}

-(void)prepareForPlaySession{
    self.currentGameStreak = 0;
    [self.timerLabel setHidden:YES];
    _highscore = _manager.gameHighScore;
    _highStreak = _manager.gameHighStreak;
    _highScoreLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long) _highscore];
    _bestStreakLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long) _highStreak];
}

-(void)prepareForClassicSession{
    _currentGameStreak = 0;
    _classicHighscore = _manager.classicHighscore;
    _classicHighstreak = _manager.highstreak;
    _highScoreLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long) _classicHighscore];
    _bestStreakLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long) _classicHighstreak];
    _timecount = 60;
    [self setTimer:23];
}

-(void)saveData{
    
    _defaults = [NSUserDefaults standardUserDefaults];
    
    if (_isRegularSession){
        [_defaults setInteger:_manager.regularhighscore forKey:REG_HIGH_SCORE];
        [_defaults setInteger:_manager.highstreak forKey:HIGH_STREAK];
        [_defaults setInteger:_manager.regularGameCount forKey:REGL_GAME_COUNT_];
        [_defaults setInteger:_manager.regualarGamescore forKey:ALL_REGL_GAME_SCORE];

    }
    if (_isClassicSession){
        [_defaults setInteger:_manager.classicHighscore forKey:CLASSIC_HIGH_SCORE];
        [_defaults setInteger:_manager.highstreak forKey:HIGH_STREAK];
        [_defaults setInteger:_manager.classicGameCount forKey:CLSSC_GAME_COUNT_];
    }
    if (!_isRegularSession && !_isClassicSession){
        [_defaults setInteger:_manager.gameHighScore forKey: GAME_HIGH_SCORE];
        [_defaults setInteger:_manager.gameHighStreak forKey:GAME_HIGH_STREAK];
        //[_defaults setInteger:-_manager.highscoreGameCount forKey:GAME_HIGH_SCORE_GAME_COUNT];
        
    }
    [_defaults setInteger:_manager.alltotalgameScore forKey:ALL_TOTAL_GAMESCORE];
    [_defaults setInteger:_manager.lifetimegameCount forKey:GAME_COUNT_LIFETIME];
    [_defaults setDouble:_manager.lifeTimePercentage forKey:PERCENTAGE_LIFETIME];
    //NSLog(@"Lifetimmmmmmmme:@%lu", (unsigned long) _manager.lifeTimePercentage);
    [_defaults setInteger:_manager.loosingStreak forKey:GM_LSSN_STRK];

}

-(void) prepareForSession{
    if (_isRegularSession){
        [self prepareForRegularSession];
    }
    if (_isClassicSession){
        [self prepareForClassicSession];
    }
    if (!_isRegularSession && !_isClassicSession){
        [self prepareForPlaySession];
    }
}

-(void)configureHighscoreUpdate{
    if (_isRegularSession){
        [self updateRegularHighscore];
    }
    if (_isClassicSession){
        [self updateClassichighScore];
    }
    if (!_isRegularSession && !_isClassicSession){
        [self updateHighScores];
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self saveData];
}

//MARK:-  CLASSIC GAME IMPLEMENTATION


-(void) setTimer:(int)secondCount {
     _milisecondsCount = 99;
    _secondsCount = secondCount;
    _gameTimer = [NSTimer scheduledTimerWithTimeInterval:.005 target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
    
    
}

-(void)continueTimer:(int)seconds milli:(int)secs
{
    _gameTimer = [NSTimer scheduledTimerWithTimeInterval:.005 target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
}

-(void) timerRun {
    if (!_isPaused){
        _milisecondsCount = _milisecondsCount - 1;
        
        
        
        if(_milisecondsCount == 0){
            _secondsCount -= 1;
            
            if (_secondsCount == 0){
                
                
                [_gameTimer invalidate];
                self.timerEnded = YES;
                [self timerDidEnd];
                //_gameTimer = nil;
            }
            else{
                
                _milisecondsCount = 99;
            }
        }
    }else{
        
        [_gameTimer invalidate];
        
    }

    
    
    NSString *timerOutput = [NSString stringWithFormat:@"%2d:%2d", _secondsCount, _milisecondsCount];
    
    _timerLabel.text = timerOutput;
}
#pragma mark - Timer

-(void)timerDidEnd{
    //Present view to show the score total || percentage per second
    if (_classicChallenging && !_isOvertiming){
        self.challengeScore.text = [NSString stringWithFormat:@"%lu", (unsigned long)_gamescore];
        [self.challengeoverView setBackgroundColor:[self.colors objectAtIndex:0]];
        [UIView animateWithDuration:0.5 animations:^{
            
            [self.view addSubview:_challengeScoreView];
            [Constants delayWithSeconds:0.8 exec:^{
                [self presentInterstitialAd];
            }];
            
        }];
        [[ChallengeEngine mainEngine] engine_UpdateChallengeScore:_gamescore c:self.challenge withNo:[self gameNo] didfinish:^{[[DatabaseService main] fb_observeGameWinner:self.challenge];}];
    }else if (_classicChallenging && _isOvertiming){
        NSNumber* score = [_overtimeDict objectForKey:[[NSUserDefaults standardUserDefaults] stringForKey:USER_UID__]];
        self.challengeScore.text = [NSString stringWithFormat:@"%lu", (unsigned long)_gamescore + [score unsignedIntegerValue]];
        [self.challengeoverView setBackgroundColor:[self.colors objectAtIndex:0]];
        [UIView animateWithDuration:0.5 animations:^{
            
            [self.view addSubview:_challengeScoreView];
            [Constants delayWithSeconds:0.9 exec:^{
                [self presentInterstitialAd];
            }];
        }];
        NSUInteger s = [score unsignedIntegerValue] + _gamescore;
        //[[DatabaseService main] fb_writeOfOT:self.challenge andNo:[self gameNo]];
        [[ChallengeEngine mainEngine] engine_UpdateChallengeScore:s c:_challenge withNo:[self gameNo] didfinish:^{[[DatabaseService main]fb_observeGameWinner:self.challenge];}];
    }else if (_isClassicSession && !_isChallenging){
        [self initScoreView];
        [self presentScoreView];
    }
    
}

-(void)initScoreView
{
    //Display custom Text
    if (_isPaused) {
        [self.playagn setTitle:@"Resume" forState:(UIControlStateNormal)];
    }else{
        [self.playagn setTitle:@"Play Again" forState:(UIControlStateNormal)];
    }
    _gameScore.text = [NSString stringWithFormat:@"%lu/%lu", (unsigned long)_gamescore, (signed long)_gameCount];
    _scoreViewgamestreaklabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)_currentGameStreak];
    if (_isRegularSession){
        _gamePercentage.text = [NSString stringWithFormat:@"%.2f %%", ((double)_gamescore / (double)_gameCount) *100];
        _gamtypelabel.text = [NSString stringWithFormat:@"Regular"];
    }else if (_isClassicSession){

        _gamtypelabel.text = [NSString stringWithFormat:@"Classic"];
        _gamePercentage.text = [NSString stringWithFormat:@"%.2f %%", ((double)_gamescore / (double)_gameCount) *100];
    }else{
        _gamePercentage.text = [NSString stringWithFormat:@"%.2f %%", ((double)_gamescore / (double)_gameCount) *100];
        _gamtypelabel.text = [NSString stringWithFormat:@"On-The-Go"];
    }
    
    
}

-(void)callScoreVC{

    [self performSegueWithIdentifier:SCORES_VC sender:nil];
}

-(void)shuffleColors{
    NSUInteger count = [_colors count];
    
    for (NSUInteger i = 0; i < count; i++){
        NSUInteger remainCount = count - i;
        NSUInteger exhangeIndex = i + arc4random_uniform((u_int32_t)remainCount);
        [_colors exchangeObjectAtIndex:i withObjectAtIndex:exhangeIndex];
    }
}
- (IBAction)cancelView:(id)sender {
    [self saveData];
    
    [self dismissViewControllerAnimated:YES completion:^{
        //
    }];
}

-(void)presentScoreView
{
     [self animate360Degrees:self.spiral withDuration:2 withDelegate:self completion:^{}];
    CGRect frame = self.view.frame;
    [UIView animateWithDuration:3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.3 options:(UIViewAnimationOptionTransitionCrossDissolve) animations:^{
        [self.view addSubview:_scoreView];
        [self.scoreView setHidden:NO];
        self.scoreView.frame = frame;
    } completion:^(BOOL finished) {}];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.gameScoreLabel.text = [NSString stringWithFormat:@"%lu / %lu", (unsigned long) self.gamescore, (signed long) self.gameCount];
        
    });
    if (!_isPaused && _isClassicSession) {
    
    }
    if (self.streakHasChanges || self.scoreHasChanges) {
        
    }
    if (!_isPaused) {
        NSArray* array = @[@1,@2,@3];
        NSUInteger index = arc4random_uniform((UInt32)array.count);
        if (index == 2) {
            [self presentInterstitialAd];
        }
    }

}

- (IBAction)viewResults:(id)sender {
    [self performSegueWithIdentifier:@"ChallengeFinished" sender:nil];
}

-(void)makeFrameForSESize:(UIButton*)button size:(CGFloat)size
{
    CGRect frame = CGRectMake(button.frame.origin.x, button.frame.origin.y, size, size);
    [button setFrame:frame];
}


-(void)setLayout
{
    if (IS_IPHONE_5) {
        [self makeFrameForSESize:self.button1 size:105];
        [self makeFrameForSESize:self.button2 size:105];
        [self makeFrameForSESize:self.button3 size:105];
        [self makeFrameForSESize:self.button4 size:105];
        //CGSize size = CGSizeMake(140, 140);
        [self.b1topconstraint setConstant:144];
        [self.b1leadingConstraint setConstant:24];
        [self.b2topcnt setConstant:150];
        [self.b2trailingcnt setConstant:10];
        [self.b3bottomcnt setConstant:150];
        [self.b3leadincnt setConstant:23];
        [self.b4botcnt setConstant:150];
        [self.b4trailingcnt setConstant:14];
        

    }
    else if (IS_IPHONE_6P){
        [self makeFrameForSESize:self.button1 size:131];
        [self makeFrameForSESize:self.button2 size:131];
        [self makeFrameForSESize:self.button3 size:131];
        [self makeFrameForSESize:self.button4 size:131];
        [self.b1topconstraint setConstant:194];
        [self.b1leadingConstraint setConstant:40];
        [self.b2topcnt setConstant:194];
        [self.b2trailingcnt setConstant:52];
        [self.b3bottomcnt setConstant:223];
        [self.b3leadincnt setConstant:37];
        [self.b4botcnt setConstant:224];
        [self.b4trailingcnt setConstant:47];
        
    }else if (IS_IPAD){
        if (IS_iPadPro) {
            [self makeFrameForSESize:self.button1 size:340];
            [self makeFrameForSESize:self.button2 size:340];
            [self makeFrameForSESize:self.button3 size:340];
            [self makeFrameForSESize:self.button4 size:340];
        }else{
            [self makeFrameForSESize:self.button1 size:260];
            [self makeFrameForSESize:self.button2 size:260];
            [self makeFrameForSESize:self.button3 size:260];
            [self makeFrameForSESize:self.button4 size:260];
        }
    }
}

-(BOOL)shouldAutorotate{
    [super shouldAutorotate];
    return  YES;
}

-(void)configIpad{

    UIInterfaceOrientation orient = [[UIApplication sharedApplication]statusBarOrientation];
    switch (orient) {
        case UIInterfaceOrientationLandscapeLeft:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self landscapeOrient];
            });
            break;
        }
        case UIInterfaceOrientationLandscapeRight:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self landscapeOrient];
            });
            break;
        }
        case UIInterfaceOrientationPortrait:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self potraitOrient];
            });
            break;
        }
        default:
            dispatch_async(dispatch_get_main_queue(), ^{
                [self potraitOrient];
            });
            break;
    }

    /*if(UIDeviceOrientationIsPortrait(UIDeviceOrientationPortrait) || UIDeviceOrientationIsPortrait(UIDeviceOrientationPortraitUpsideDown)){
        [self.backgroundImage setImage:[UIImage imageNamed:@"strkripadP"]];
        [self.b1topconstraint setConstant:180];
        [self.b1leadingConstraint setConstant:74];
        [self.b2topcnt setConstant:180];
        [self.b2trailingcnt setConstant:220];
        [self.b3bottomcnt setConstant:360];
        [self.b3leadincnt setConstant:74];
        [self.b4botcnt setConstant:360];
        [self.b4trailingcnt setConstant:225];
    }else if (UIDeviceOrientationIsLandscape(UIDeviceOrientationLandscapeRight ) || UIDeviceOrientationIsLandscape(UIDeviceOrientationLandscapeLeft)){
        [self.backgroundImage setImage:[UIImage imageNamed:@"ipl2"]];
        [self.b1topconstraint setConstant:77];
        [self.b1leadingConstraint setConstant:182];
        [self.b2topcnt setConstant:77];
        [self.b2trailingcnt setConstant:180];
        [self.b3bottomcnt setConstant:200];
        [self.b3leadincnt setConstant:182];
        [self.b4botcnt setConstant:98];
        [self.b4trailingcnt setConstant:180];
    }*/
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    if(toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown){
        [self.backgroundImage setImage:[UIImage imageNamed:@"strkripadP"]];
        [self.b1topconstraint setConstant:180];
        [self.b1leadingConstraint setConstant:74];
        [self.b2topcnt setConstant:180];
        [self.b2trailingcnt setConstant:220];
        [self.b3bottomcnt setConstant:360];
        [self.b3leadincnt setConstant:74];
        [self.b4botcnt setConstant:360];
        [self.b4trailingcnt setConstant:225];
    }else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight){
        [self.backgroundImage setImage:[UIImage imageNamed:@"ipl2"]];
        [self.b1topconstraint setConstant:77];
        [self.b1leadingConstraint setConstant:182];
        [self.b2topcnt setConstant:77];
        [self.b2trailingcnt setConstant:180];
        [self.b3bottomcnt setConstant:200];
        [self.b3leadincnt setConstant:182];
        [self.b4botcnt setConstant:98];
        [self.b4trailingcnt setConstant:180];
    }
}

-(void)potraitOrient
{
    if(IS_IPAD){
        [self.backgroundImage setImage:[UIImage imageNamed:@"strkripadP"]];
        if (IS_iPadPro) {
            
            [self.b1topconstraint setConstant:238];
            [self.b1leadingConstraint setConstant:110];
            [self.b2topcnt setConstant:242];
            [self.b2trailingcnt setConstant:332];
            [self.b3bottomcnt setConstant:514];
            [self.b3leadincnt setConstant:116];
            [self.b4botcnt setConstant:514];
            [self.b4trailingcnt setConstant:332];
        }else{
            [self.b1topconstraint setConstant:180];
            [self.b1leadingConstraint setConstant:74];
            [self.b2topcnt setConstant:180];
            [self.b2trailingcnt setConstant:220];
            [self.b3bottomcnt setConstant:360];
            [self.b3leadincnt setConstant:74];
            [self.b4botcnt setConstant:360];
            [self.b4trailingcnt setConstant:225];
        }
    }
}

-(void)landscapeOrient
{
    if (IS_IPAD) {
        [self.backgroundImage setImage:[UIImage imageNamed:@"ipl2"]];
        if (IS_iPadPro) {
            [self.b1topconstraint setConstant:137];
            [self.b1leadingConstraint setConstant:238];
            [self.b2topcnt setConstant:137];
            [self.b2trailingcnt setConstant:474];
            [self.b3bottomcnt setConstant:350];
            [self.b3leadincnt setConstant:233];
            [self.b4botcnt setConstant:354];
            [self.b4trailingcnt setConstant:474];
        }else{
            [self.b1topconstraint setConstant:100];
            [self.b1leadingConstraint setConstant:173];
            [self.b2topcnt setConstant:105];
            [self.b2trailingcnt setConstant:320];
            [self.b3bottomcnt setConstant:235];
            [self.b3leadincnt setConstant:173];
            [self.b4botcnt setConstant:235];
            [self.b4trailingcnt setConstant:320];
        }
    }
}

-(IBAction)popToRootView:(id)sender
{
    
    UINavigationController* home = (UINavigationController*)[self.storyboard instantiateViewControllerWithIdentifier:@"startUpNavC" ];
    [self presentViewController:home animated:YES completion:^{}];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    
}

@end
