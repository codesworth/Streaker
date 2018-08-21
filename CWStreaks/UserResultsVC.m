//
//  UserResultsVC.m
//  CWStreaks
//
//  Created by Mensah Shadrach on 1/15/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import "UserResultsVC.h"
#import "ChallengeVC.h"
#import "ReportUser.h"

@interface UserResultsVC ()
@property (weak, nonatomic) IBOutlet UIImageView *profileimageview;
@property (weak, nonatomic) IBOutlet UILabel *usernamelabel;
@property (weak, nonatomic) IBOutlet UILabel *positionlabel;
@property (weak, nonatomic) IBOutlet UILabel *averagePercentageLabel;
@property (weak, nonatomic) IBOutlet UIView *resultsView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *classicHS;
@property (weak, nonatomic) IBOutlet UILabel *regularHS;
@property (weak, nonatomic) IBOutlet UILabel *highStreak;
@property (weak, nonatomic) IBOutlet UILabel *alltimeScore;
@property (weak, nonatomic) IBOutlet UILabel *bestRegScore;
@property (weak, nonatomic) IBOutlet UILabel *bestClassicscore;
@property (weak, nonatomic) IBOutlet UILabel *oSE;
@property (weak, nonatomic) IBOutlet UILabel *totalGamesPlayed;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *highscoreheadcnt;
@property (strong, nonatomic) IBOutlet UIView *medalView;
@property (weak, nonatomic) IBOutlet MBCircularProgressBarView *progressStats;
@property (weak, nonatomic) IBOutlet UIButton* medalButton;
@property (weak, nonatomic) IBOutlet UILabel *challPoins;
@property (weak, nonatomic) IBOutlet UILabel *challloses;
@property (weak, nonatomic) IBOutlet UILabel *chsweeps;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stackexcited;
@property(strong,nonatomic)UIVisualEffectView* blurView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *usernameToDp;
//70
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *indextotop;
//95
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *perctotop;
//95
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *prgv;
//180
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *prgw;
//180
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *profImagetop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *flViewtop;
@property (weak, nonatomic) IBOutlet FloatingViews *imageboundary;
@property (weak, nonatomic) IBOutlet MaterialButtons *firstAction;
@property (weak, nonatomic) IBOutlet MaterialButtons *secondAction;
@property (weak, nonatomic) IBOutlet MaterialButtons *thirdAction;
@property(nonatomic)BOOL userActions;
@property (strong, nonatomic) IBOutlet MaterialView *actionSheetView;
@property(nonatomic)BOOL isTopView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statbottomcnt;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recordleading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *challengeTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *percenttrail;

@end

dispatch_queue_t ___execute_ASAP;
UIView* overlayView;

@implementation UserResultsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    ___execute_ASAP = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    [self setIsTopView:YES];
    
    [Constants imageBoundSetup:self.imageboundary.layer delay:5 isInView:_isTopView];
    self.navigationItem.title = self.user.username;
    self.navigationController.navigationBar.topItem.title = @"";
    [self.navigationController setNavigationBarHidden:NO];
    _usernamelabel.text = self.user.username.capitalizedString;
    _positionlabel.text = [NSString stringWithFormat:@"%lu", (long)self.userPosition];
   
    
    CALayer* imageLayer = [CALayer layer];
    imageLayer.shadowRadius = 10.f;
    imageLayer.shadowOffset = CGSizeMake(0.f, 5.f);
    imageLayer.shadowColor = [[UIColor grayColor]CGColor];
    [self initializeScoreData];
    if (self.user == nil) {}else{[self.profileimageview setImage:[UIImage imageNamed:self.user.avatar]];}
    [self.stackexcited setConstant:108];
    [self.highscoreheadcnt setConstant:((self.medalView.frame.size.width/2) + 50)];
    if(IS_IPHONE_5){

    }else if (IS_IPAD){
        //[self.challengeTrailing setConstant:100];
       // [self.recordleading setConstant:100];
        //[self.percenttrail setConstant:104];

        //[self landscapeOrient];
    }
    if(_user.scoreData == nil){
        [[DatabaseService main]fb_fetch_ScoreData:self.user exec:^{
            [self setProgress];
        }];
    }
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationItem.title = self.user.username;
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication]statusBarOrientation] == UIInterfaceOrientationLandscapeRight) {
        [self landscapeOrient];
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [self setIsTopView:NO];
}

-(BOOL)isListable{
    BOOL listable = YES;
    for (NSString* person in [AppDelegate mainDelegate].myList) {
        if ([person isEqualToString:self.user.uid]){
            listable = NO;
            break;
        }
    }
    //NSLog(@"Is it listed %d",(int)listable);
    return listable;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self setProgress];
    if (self.user){
        NSString* uid = [Constants uid];
        if ([self.user.uid isEqualToString:uid]){
            [self.secondAction setTitle:@"Edit Profile" forState:UIControlStateNormal];
            [self.thirdAction setTitle:@"Sign Out" forState:(UIControlStateNormal)];
        }else{
            [self.secondAction setTitle:@"Report User" forState:UIControlStateNormal];
            if ([self isListable]){
                [self.thirdAction setTitle:@"Add To List" forState:(UIControlStateNormal)];
            }else{
                [self.thirdAction setTitle:@"Added To List" forState:(UIControlStateNormal)];
                [self.thirdAction setEnabled:NO];
                
            }
        }
    }

}

-(void)setProgress
{

    NSUInteger sWins = [(NSNumber*)[self.user.scoreData objectForKey:CHLL_PNTS_WN_RCRD]unsignedIntegerValue];
    NSUInteger sLoss = [(NSNumber*)[self.user.scoreData objectForKey:CHLL_PNTS_LSE_RCRD]unsignedIntegerValue];
    NSUInteger sSweeps = [(NSNumber*)[self.user.scoreData objectForKey:CHLL_PNTS_SRSSWP_PTS]unsignedIntegerValue];
    NSUInteger gameP = [(NSNumber*)[self.user.scoreData objectForKey:CHLL_PNTS_GMWN_PNTS]unsignedIntegerValue];
    [self.progressStats setMaxValue:(CGFloat)(sWins+sLoss)];
    
    CGFloat val = sWins;
    [UIView animateWithDuration:2.f animations:^{
        [self.progressStats setValue:val];
    }];
    [self.chsweeps setText:[NSString stringWithFormat:@"%lu",(unsigned long)sSweeps]];
    [self.challloses setText:[Constants countHelper:sLoss]];
    [self.challPoins setText:[Constants countHelper:gameP]];
    self.bestRegScore.text = [NSString stringWithFormat:@"%lu",(unsigned long)[(NSNumber*)[self.user.scoreData objectForKey:FIR_DB_REF_SC_REGL_GAMEHIGHSCORE]unsignedIntegerValue]];
    self.bestClassicscore.text = [NSString stringWithFormat:@"%lu",(unsigned long)[(NSNumber*)[self.user.scoreData objectForKey:FIR_DB_REF_CLSSC_GAMEHIGHSCORE]unsignedIntegerValue]];
    self.regularHS.text = [NSString stringWithFormat:@"%lu",(unsigned long)[(NSNumber*)[self.user.scoreData objectForKey:FIR_DB_LSSN_STRK]unsignedIntegerValue]];
    self.classicHS.text = [NSString stringWithFormat:@"%lu",(unsigned long)[(NSNumber*)[self.user.scoreData objectForKey:FIR_DB_REF_HIGHSTREAK]unsignedIntegerValue]];
    NSUInteger s = [(NSNumber*)[self.user.scoreData objectForKey:FIR_DB_REF_ALLTIME_GAMESCORE]unsignedIntegerValue];
    NSUInteger a = [(NSNumber*)[self.user.scoreData objectForKey:FIR_DB_REF_ALLTIME_GAMECOUNT]unsignedIntegerValue];
    double percent = (double)s / (double)a;
    self.alltimeScore.text = [Constants countHelper:s];
    self.totalGamesPlayed.text = [Constants countHelper:a];
    self.oSE.text = [NSString stringWithFormat:@"%.2f%%",  percent * 100];
     _averagePercentageLabel.text = [NSString stringWithFormat:@"%.2f%%",  percent * 100];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self.medalView removeFromSuperview];
    
}

-(void)userUpdated
{
    self.user = [[AppDelegate mainDelegate].selff objectAtIndex:0];
    _usernamelabel.text = self.user.username;
    [self.profileimageview setImage:[UIImage imageNamed:self.user.avatar]];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _imageboundary.layer.cornerRadius = _imageboundary.frame.size.width/2;
    _profileimageview.layer.cornerRadius = _profileimageview.frame.size.width /2;
    if (IS_IPHONE_5){
        [self.firstViewHeight setConstant:300];
        [self.usernameToDp setConstant:50];
        [self.indextotop setConstant:75];
        [self.perctotop setConstant:75];
        [self.prgv setConstant:160];
        [self.prgw setConstant:160];
        [self.profImagetop setConstant:10];
        [self.flViewtop setConstant:10];
    }
    overlayView = [[UIView alloc] initWithFrame:self.view.frame];
    [overlayView setBackgroundColor:[UIColor darkGrayColor]];
    [overlayView.layer setOpacity:0.4];
    [self.view addSubview:overlayView];
    [overlayView setHidden:YES];
    [self initialCHLViewSetUp];
    CGFloat x = self.view.frame.size.width;
    if (IS_IPAD) {
        x = 500;
    }
    CGRect frame = CGRectMake(-((self.view.frame.size.width / 2) +100) , 0,x , self.view.frame.size.height);

    [self.medalView setFrame:frame];
    [self.view addSubview:self.medalView];
    [self.medalView setHidden:YES];

}
- (IBAction)challenges:(id)sender {
    UIBlurEffect* blur = [UIBlurEffect effectWithStyle:(UIBlurEffectStyleLight)];
    self.blurView = [[UIVisualEffectView alloc]initWithEffect:blur];
    [_blurView setFrame:self.view.frame];
    [self.blurView setBackgroundColor:[UIColor clearColor]];
    [self.resultsView addSubview:_blurView];
    [self.resultsView setHidden:NO];
    //[self.view bringSubviewToFront:self.medalView];
    CGRect frame = CGRectMake(-100, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.3 options:(UIViewAnimationOptionCurveEaseIn) animations:^{
        [self.medalView setHidden:NO];
        [self.medalView setFrame:frame];
        
    } completion:^(BOOL finish){}];

}

- (IBAction)sendChallengeRequest:(id)sender {
    NSString* uid = [[NSUserDefaults standardUserDefaults]objectForKey:USER_UID__];
    if (self.user != nil) {
        if ([uid isEqualToString:self.user.uid]) {
            [self performSegueWithIdentifier:@"challenges" sender:uid];
        }else{[self sendChallenge];}
    }
    
    //[self setUserActions:YES];
    


    
}
/**/

- (IBAction)regularSelected:(id)sender {
    NSString* uid = [Constants uid];
    if(self.userActions){
        if([self.user.uid isEqualToString:uid]){
            [self performSegueWithIdentifier:@"Settings" sender:nil];
        }else{
            [self performSegueWithIdentifier:@"Report" sender:self.user];
        }
    }else{
        NSString* gameID = STRKR_CHLLNG_ID_REGL_;
        
        NSString* date = [Constants stringFromDate:[NSDate date]];
        NSDictionary* meDict = [[NSUserDefaults standardUserDefaults]objectForKey:USER_INFO];
        NSDictionary* usernames = @{@"Sender":[meDict objectForKey:FIR_BASE_CHILD_USERNAME],@"Recipient":self.user.username,@"SenderAvatar":[meDict objectForKey:FIR_BASE_CHILD_PROFILE_IMG_URL],@"RecipientAvatar":self.user.avatar};
        [[ChallengeEngine mainEngine] engine_createAndSendChallenge:uid toRecipient:self.user.uid and:usernames withDate:date withChID:gameID];
    }
    [self removeAnimationViewAnimation];

    
}

-(IBAction)dismisMedalView:(id)sender
{

    CGFloat x = self.view.frame.size.width;
    if (IS_IPAD) {
        x = 500;
    }
    CGRect dframe = CGRectMake(-((self.view.frame.size.width / 2) + 200) , 0,x, self.view.frame.size.height);
    CGRect frame = CGRectMake(0, self.view.frame.size.height + 50, self.view.frame.size.width, self.view.frame.size.height);
    [UIView animateWithDuration:1.4 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.3 options:(UIViewAnimationOptionCurveEaseIn) animations:^{
        [self.blurView removeFromSuperview];
        [self.medalView setHidden:NO];
        [self.medalView setFrame:frame];
        [self.resultsView setHidden:YES];
        [self.medalButton setEnabled:NO];
    } completion:^(BOOL finish){
        _medalView.frame = dframe;
        [self.medalButton setEnabled:YES];
    }];

}


-(void)sendChallenge
{
    
    CGRect frame = CGRectMake(0, self.view.frame.size.height - 190, self.view.frame.size.width, 280);
    [UIView animateWithDuration:2 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.4 options:(UIViewAnimationOptionTransitionCrossDissolve) animations:^{
        
        [self.actionSheetView setFrame:frame];
        [overlayView setHidden:NO];
    } completion:^(BOOL finished) {}];
    //NSLog(@"the frame of %f",self.actionSheetView.frame.origin.y);
}



-(IBAction)userAvatarPressed:(id)sender
{
    [self performSegueWithIdentifier:@"USAVC" sender:self.user.avatar];
}

- (IBAction)classicSelected:(id)sender {
    NSString* uid = [Constants uid];
    if (self.userActions){
        if([self.user.uid isEqualToString:uid]){
            UIAlertController* alert = [Constants createDefaultAlert:@"Sign Out" title:@"You are about to sign out from your Streaker account. Signing out will erase all history of completed challenges and chat messages" message:@"Cancel"];
            UIAlertAction* signout = [UIAlertAction actionWithTitle:@"Sign Out" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
                [[DataService authService] fb_signOut:^{
                    [self presentViewController:[Constants initLogInVC] animated:YES completion:nil];
                }];
            }];
            [alert addAction:signout];
            [self presentViewController:alert animated:YES completion:nil];
            //[[DataService authService] fb_signOut:^{
                //[self performSegueWithIdentifier:SIGNED_OUT sender:nil];
                
            //}];
        }else{
            [[DatabaseService main]fb_Add_User:self.user.uid];
            [[AppDelegate mainDelegate].myList addObject:self.user.uid];
            self.thirdAction = (MaterialButtons*)sender;
            self.thirdAction.titleLabel.text = @"Added To List";
            [self.thirdAction setEnabled:NO];

        }
    }else{
        NSString* gameID = STRKR_CHLLNG_ID_CLSSC_;
        
        NSString* date = [Constants stringFromDate:[NSDate date]];
        NSDictionary* meDict = [[NSUserDefaults standardUserDefaults]objectForKey:USER_INFO];
        NSDictionary* usernames = @{@"Sender":[meDict objectForKey:FIR_BASE_CHILD_USERNAME],@"Recipient":self.user.username,@"SenderAvatar":[meDict objectForKey:FIR_BASE_CHILD_PROFILE_IMG_URL],@"RecipientAvatar":self.user.avatar};
        [[ChallengeEngine mainEngine] engine_createAndSendChallenge:uid toRecipient:self.user.uid and:usernames withDate:date withChID:gameID];
    }
    [self removeAnimationViewAnimation];
}
- (IBAction)loosingStreakSelected:(id)sender {
    /*NSString* gameID = STRKR_CHLLNG_ID_LSNSTRKR_;
    NSString* uid = [[NSUserDefaults standardUserDefaults] stringForKey:USER_UID__];
    NSString* date = [Constants stringFromDate:[NSDate date]];
    [[ChallengeEngine mainEngine] engine_createAndSendChallenge:uid toRecipient:self.user.uid withDate:date withChID:gameID];*/
    [self removeAnimationViewAnimation];
}

-(void)initialCHLViewSetUp
{
    CGRect frame = CGRectMake(0, self.view.frame.size.height + 100, [UIScreen mainScreen].bounds.size.width, 280);
    [self.actionSheetView setFrame:frame];
    [self.actionSheetView.layer setCornerRadius:10];
    [self.view addSubview:self.actionSheetView];
    [self.userOptions setFrame:frame];
    [self.userOptions.layer setCornerRadius:10];
    [self.view addSubview:self.userOptions];
}

-(void)removeAnimationViewAnimation
{
    if (self.userActions){
        [self setUserActions:NO];
        CGRect frame = CGRectMake(0, self.view.frame.size.height + 190, self.view.frame.size.width, 280);
        [UIView animateWithDuration:2 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.4 options:(UIViewAnimationOptionTransitionCrossDissolve) animations:^{
            
            [self.userOptions setFrame:frame];
            [overlayView setHidden:YES];
            
        } completion:^(BOOL finished) {}];
    }else{
        CGRect frame = CGRectMake(0, self.view.frame.size.height + 190, self.view.frame.size.width, 280);
        [UIView animateWithDuration:2 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.4 options:(UIViewAnimationOptionTransitionCrossDissolve) animations:^{
            
            [self.actionSheetView setFrame:frame];
            [overlayView setHidden:YES];
            
        } completion:^(BOOL finished) {}];
    }
    

}

-(void)initializeScoreData{

}
- (IBAction)signOutPressed:(id)sender {
    [self setUserActions:YES];
    
    [self userAction];
    

   
    

}

-(void)userAction
{

    CGRect frame = CGRectMake(0, self.view.frame.size.height - 190, self.view.frame.size.width, 280);
    [UIView animateWithDuration:2 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.4 options:(UIViewAnimationOptionTransitionCrossDissolve) animations:^{
            
            [self.userOptions setFrame:frame];
            [overlayView setHidden:NO];
        } completion:^(BOOL finished) {}];
        //NSLog(@"the frame of %f",self.actionSheetView.frame.origin.y);

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"USAVC"]){
        UserAvatarVC* destination = [segue destinationViewController];
        if (sender){
            destination.avatar = (NSString*)sender;
            destination.username = self.user.username;
        }
    }else if([segue.identifier isEqualToString:@"Report"]){
        if(sender){
            ReportUser* vc = (ReportUser*)[segue destinationViewController];
            vc.user = (Gamer*) sender;
        }
    
    }else if ([segue.identifier isEqualToString:@"challenges"]){
        ChallengeVC* v = (ChallengeVC*)[segue destinationViewController];
        v.sender = (NSString*)sender;
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
                [self removeAnimationViewAnimation];
            });
            break;
        }
        case UIInterfaceOrientationLandscapeRight:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self potraitOrient];
                [self removeAnimationViewAnimation];
            });
            break;
        }
        case UIInterfaceOrientationPortrait:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self landscapeOrient];
                [self removeAnimationViewAnimation];
            });
            break;
        }
        default:
            [self landscapeOrient];
            [self removeAnimationViewAnimation];
            break;
    }
}

-(void)landscapeOrient
{
    if (IS_IPAD && !IS_iPadPro) {
        [self.prgv setConstant:215];
        [self.prgw setConstant:215];
        self.viewHeight.constant = 405;
    }
    //[self.statbottomcnt setConstant:50];
}

-(void)potraitOrient
{

    if (IS_IPAD && !IS_iPadPro) {
        [self.prgv setConstant:260];
        [self.prgw setConstant:260];
        self.viewHeight.constant = 450;
    }
    /*[self.firstViewHeight setConstant:470];
    [self.usernamelabel setCenter:CGPointMake(self.usernamelabel.center.x, self.usernamelabel.center.y + 100)];
    [self.profImagetop setConstant:60];
    [self.indextotop setConstant:150];
    [self.perctotop setConstant:150];
    //[self ipadFrameSetup];*/
    
}

-(void)ipadFrameSetup
{
    self.profileimageview.frame = CGRectMake(self.profileimageview.center.x, self.profileimageview.center.y, 150, 150);
    self.imageboundary.frame = CGRectMake(self.imageboundary.center.x, self.imageboundary.center.y, 155, 155);
    _profileimageview.layer.cornerRadius = _profileimageview.frame.size.width/2;
    _imageboundary.layer.cornerRadius = _imageboundary.frame.size.width/2;
}

-(void)setIpadLayout
{
    UIInterfaceOrientation orient = [[UIApplication sharedApplication]statusBarOrientation];
    switch (orient) {
        case UIInterfaceOrientationLandscapeLeft:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self potraitOrient];
                [self removeAnimationViewAnimation];
            });
            break;
        }
        case UIInterfaceOrientationLandscapeRight:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self potraitOrient];
                [self removeAnimationViewAnimation];
            });
            break;
        }
        case UIInterfaceOrientationPortrait:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self landscapeOrient];
                [self removeAnimationViewAnimation];
            });
            break;
        }
        default:
            [self landscapeOrient];
            [self removeAnimationViewAnimation];
            break;
    }
}

@end
