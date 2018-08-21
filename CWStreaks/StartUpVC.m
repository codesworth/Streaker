//
//  StartUpVC.m
//  CWStreaks
//
//  Created by Mensah Shadrach on 11/2/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

#import "StartUpVC.h"



@interface StartUpVC ()<CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *streakImageView;
@property (weak, nonatomic) IBOutlet Designables *regularButton;
@property (weak, nonatomic) IBOutlet Designables *classicButton;
@property (weak, nonatomic) IBOutlet Designables *playNow;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraitImage;
@property (strong, nonatomic) NSMutableArray* gamers;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgheight;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userprofpic;
@property (weak, nonatomic) IBOutlet UIView *overlayBG;
@property(nonatomic)BOOL isInView;
@property(nonatomic, strong)CLGeocoder* geocoder;
@property(nonatomic)BOOL uploaded;
@property(strong, nonatomic, nullable)CLLocationManager* locationManager;
@property(nonatomic,nullable,strong)NSString* city;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *regHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *clssHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *challHeightt;
@property(strong, nonatomic, nullable)NSArray* colors;


@end

/*CGColorRef a;
CGColorRef b;
CGColorRef c;
CGColorRef d;
CGColorRef e;
CGColorRef f;
CGColorRef g;*/



NSMutableArray* arrray;

@implementation StartUpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initColors];
    if(IS_IPHONE_5){
        [self.regHeight setConstant:30];
        [self.clssHeight setConstant:30];
        [self.challHeightt setConstant:30];
    }else if (IS_IPAD){
        if (IS_iPadPro) {
            [self.imgheight setConstant:500];
            [self.topConstraitImage setConstant:120];

        }else{
            [self.imgheight setConstant:400];
            [self configIpads];
        }
    }
    //[self.navigationController setNavigationBarHidden:YES];
    [self.overlayBG.layer setCornerRadius:self.overlayBG.layer.frame.size.width / 2];
    
    //[Constants dynamicOverlay:self.view.layer with:index];
    [self.userprofpic.layer setCornerRadius:20];
    _gamers = [[NSMutableArray alloc] init];

    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    
    [self getCurrenLocation];
    [self animate:0];
    if ([AppDelegate mainDelegate].shouldRemind){
        [self alertForNotif];
    }
}

-(void)initColors
{
    /*a = [[UIColor colorWithRed:0.247 green:0 blue:0.761 alpha:1]CGColor];
    b = [[UIColor colorWithRed:0.306 green:0 blue:0.761 alpha:1]CGColor];
    c = [[UIColor colorWithRed:0.361 green:0 blue:0.761 alpha:1]CGColor];
    d = [[UIColor colorWithRed:0.420 green:0 blue:0.761 alpha:1]CGColor];
    e = [[UIColor colorWithRed:0.475 green:0 blue:0.761 alpha:1]CGColor];
    f = [[UIColor colorWithRed:0.533 green:0 blue:0.761 alpha:1]CGColor];
    g = [[UIColor colorWithRed:0.588 green:0 blue:0.761 alpha:1]CGColor];
    
    colors = @[(__bridge id)a,(__bridge id)b,(__bridge id)c,(__bridge id)d,(__bridge id)e, (__bridge id)f, (__bridge id)g];
    [self animate:0];
    a1= [[UIColor colorWithRed:0.420 green:0 blue:0.765 alpha:1]CGColor];
    b1 = [[UIColor colorWithRed:0.443 green:0 blue:0.714 alpha:1]CGColor];
    c1 = [[UIColor colorWithRed:0.467 green:0 blue:0.663 alpha:1]CGColor];
    d1 = [[UIColor colorWithRed:0.490 green:0 blue:0.616 alpha:1]CGColor];
    e1 = [[UIColor colorWithRed:0.514 green:0 blue:0.565 alpha:1]CGColor];
    f1 = [[UIColor colorWithRed:0.541 green:0 blue:0.518 alpha:1]CGColor];
    g1 = [[UIColor colorWithRed:0.565 green:0 blue:0.467 alpha:1]CGColor];
    h1 = [[UIColor colorWithRed:0.588 green:0 blue:0.420 alpha:1]CGColor];
    i1 = [[UIColor colorWithRed:0.612 green:0 blue:0.369 alpha:1]CGColor];
    j = [[UIColor colorWithRed:0.635 green:0 blue:0.318 alpha:1]CGColor];
    
    _colors = @[(__bridge id)a1,(__bridge id)b1,(__bridge id)c1,(__bridge id)d1,(__bridge id)e1, (__bridge id)f1, (__bridge id)g1, (__bridge id)h1, (__bridge id)i1, (__bridge id)j];*/
}

-(void)animate:(NSUInteger)index
{
    id color = [_colors objectAtIndex:index];
    [Constants dynamicOverlay:self.view.layer color:color did:^{
        [Constants delayWithSeconds:3 exec:^{
            if (index < _colors.count -1){
                [self reanimateLayer:index];
            }else{[self reverseLayerAnimation:index];}
        }];
    }];
}

-(void)reverseLayerAnimation:(NSUInteger)index
{
    index = index -1;
    id color = [_colors objectAtIndex:index];
    [Constants dynamicOverlay:self.view.layer color:color did:^{
        [Constants delayWithSeconds:3 exec:^{
            if (index == 0){
                [self animate:index];
            }else{[self reverseLayerAnimation:index];}
        }];
    }];
}

-(void)reanimateLayer:(NSUInteger)index
{   NSUInteger newIndex = index + 1;
    [self animate:newIndex];
}

-(void)updateUserUI
{
    NSDictionary* user = [[NSUserDefaults standardUserDefaults]objectForKey:USER_INFO];
    if(user.allValues.count > 0){
        [self.overlayBG setHidden:NO];
        [self.usernameLabel setText: [user objectForKey:FIR_BASE_CHILD_USERNAME]];
        self.userprofpic.image = [UIImage imageNamed:[user objectForKey:FIR_BASE_CHILD_PROFILE_IMG_URL]];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.isInView = YES;
    [self updateUserUI];
    [Constants imageBoundSetup:self.overlayBG.layer delay:4 isInView:_isInView];
    _isRegularSession = NO;
    _isClassicSession = NO;
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    self.isInView = NO;
    [self updateUserUI];
    //CWAlertController* alert = [CWAlertController createAlertWithMessage:@"Hello World"];
    //[alert present:self animation:YES exec:^{
        //NSLog(@"Yayyyy I was Called");
    //}];
    //[alert present]
    
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    self.isInView = NO;
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (IS_IPHONE_6P) {
        UIImageView* imageView = (UIImageView*)[self.view viewWithTag:1000];
        //        [imageView setFrame:(CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, imageView.frame.size.width, imageView.frame.size.height + 70))];
        [self.imgheight setConstant:250];
        
        [imageView setContentMode:(UIViewContentModeScaleAspectFill)];
    }
}

- (IBAction)regularButtonPressed:(id)sender {
    _isRegularSession = YES;
    [self performSegueWithIdentifier:SEGUE_STARTUPVC_MAINVC sender:nil];
}

- (IBAction)classicButtonPressed:(id)sender {
    _isClassicSession = YES;
    [self performSegueWithIdentifier:SEGUE_STARTUPVC_MAINVC sender:nil];
}
- (IBAction)playNowButtonpressed:(id)sender {
    //arrray = [[LeaderBoardConfig mainConfig] initwithSorted:_gamers];
    //NSLog(@"Gameeeeee id %@", arrray);
    [self performSegueWithIdentifier:SEGUE_STARTUPVC_MAINVC sender:nil];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:SEGUE_STARTUPVC_MAINVC]){
        ViewController *vc = [segue destinationViewController];
        if (_isRegularSession) {
            vc.isRegularSession = YES;
        }
        if(_isClassicSession){
            vc.isClassicSession = YES;
        }
    }else if ([segue.identifier isEqualToString:@"STartUpProf"]){
        UserResultsVC* destination = [segue destinationViewController];
        if (sender != nil) {
            Gamer* user = (Gamer*)sender;
            destination.user = user;
        }
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (IBAction)profilebutton:(id)sender {
    Gamer* localGamer = [[Gamer alloc]initWithProfile:[Constants uid] profile:[[NSUserDefaults standardUserDefaults]objectForKey:USER_INFO] scoreData:nil locality:nil];
    localGamer.userPercentage = [[ScoreData mainData] lifeTimePercentage];
    [self performSegueWithIdentifier:@"STartUpProf" sender:localGamer];
    
}

-(void)getCurrenLocation
{
    CLAuthorizationStatus authstatus = [CLLocationManager authorizationStatus];
    if(authstatus == kCLAuthorizationStatusNotDetermined){
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [self.locationManager setDesiredAccuracy:(kCLLocationAccuracyKilometer)];
    [self.locationManager startUpdatingLocation];
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //NSLog(@"Error occurred%@", error.description);
    UIAlertController* c = [Constants createDefaultAlert:@"GPS Error" title:@"Please enable location services for streaker in order to find nearby streakers" message:@"Dismiss"];
    UIAlertAction* action = [UIAlertAction actionWithTitle:@"Settings" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
    }];
    [c addAction:action];
    //[self presentViewController:c animated:YES completion:nil];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    
    //NSLog(@"The locations are %@", locations);
    CLLocation* lastLocation = [locations lastObject];
    self.geocoder = [[CLGeocoder alloc]init];
    [_geocoder reverseGeocodeLocation:lastLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error){
            //NSLog(@"Error occurred");
            [manager stopUpdatingLocation];
        }else{
            if (placemarks.count > 0){
                CLPlacemark* placeMark = [placemarks objectAtIndex:0];
                [self locationFomPlacemark:placeMark];
                return;
            }
        }
    }];
    
    [self.locationManager stopUpdatingLocation];
    
}

-(void)locationFomPlacemark:(CLPlacemark*)placeMark
{
    if (placeMark){
        [_locationManager stopUpdatingLocation];
        self.city = placeMark.locality;
        //NSLog(@"The city is %@", self.city);
        NSString* savedCity = [[NSUserDefaults standardUserDefaults]objectForKey:FIR_DB_CITY];
        if (self.city != NULL && !_uploaded){
            if (![self.city isEqualToString:savedCity]){
                NSDictionary* cityDict = @{FIR_DB_CITY:self.city.lowercaseString};
                [[DatabaseService main]updateUserLocation:cityDict e:^{
                    _uploaded = YES;
                    [[NSUserDefaults standardUserDefaults]setObject:self.city forKey:FIR_DB_CITY];
                }];
            }
        }

    }
}

-(void)alertForNotif
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Enable User Notifications" message:@"Enable User Notifications for Streaker to receive updates and challenge requests" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction* a1 = [UIAlertAction actionWithTitle:@"Settings" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
    }];
    UIAlertAction* a2 = [UIAlertAction actionWithTitle:@"Cancel" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction* a){}];
    [alert addAction:a1];[alert addAction:a2];
    [self presentViewController:alert animated:YES completion:nil];
}



#pragma mark:- UITRANSITION

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    UIInterfaceOrientation orient = [[UIApplication sharedApplication]statusBarOrientation];
    switch (orient) {
        case UIInterfaceOrientationLandscapeLeft:
        {
            dispatch_async(dispatch_get_main_queue(), ^{

            });
            break;
        }
        case UIInterfaceOrientationLandscapeRight:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
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

-(void)configIpads
{
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
                
            });
            break;
        }
        default:
            
            break;
    }
}

-(void)landscapeOrient
{
    if(IS_IPAD && !IS_iPadPro){
        [self.topConstraitImage setConstant:40];
    }
}
@end


