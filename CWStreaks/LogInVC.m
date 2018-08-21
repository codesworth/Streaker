//
//  LogInVC.m
//  CWStreaks
//
//  Created by Mensah Shadrach on 11/2/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

#import "LogInVC.h"


@interface LogInVC () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *signUplabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signInButtonbottom;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet MaterialTextfield *usernameField;
@property (weak, nonatomic) IBOutlet MaterialTextfield *emailTextfield;
@property (weak, nonatomic) IBOutlet MaterialTextfield *passwordTextfield;
@property (weak, nonatomic) IBOutlet UIButton *imageSelectButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signINbottom;
@property (weak, nonatomic) IBOutlet MaterialButtons *signUpButton;
@property (strong, nonatomic) UIImagePickerController* imagePicker;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stackHeight;
@property (weak, nonatomic) IBOutlet UILabel *accntStatusTexxt;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (nonatomic)BOOL canSignIn;
@property (weak, nonatomic) IBOutlet UIView *activityView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activitystatus;
@property (weak, nonatomic) IBOutlet UIStackView *detailStack;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailStacktop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *proimgheight;
//@property(strong, nonatomic, nullable)CLLocationManager* locationManger;
@property(nonatomic)BOOL alreadyRun;
@property (weak, nonatomic) IBOutlet UIButton *imgSelectButton;
@property (weak, nonatomic) IBOutlet UIButton *forgotPassBtn;
@property (weak, nonatomic) IBOutlet UIView *overlayBG;
@property(nonatomic)BOOL isInView;
@property(strong,nonatomic)NSArray* colors;

@end

CGColorRef a2;

CGColorRef b2;

CGColorRef c2;


CGColorRef d2;


CGColorRef e2;


CGColorRef f2;


CGColorRef g2;

CGColorRef h2;

CGColorRef i2;

CGColorRef j2;


CGColorRef k2;

CGColorRef l2;

CGColorRef m2;

CGColorRef n2;

CGColorRef o2;

CGColorRef p2;

CGColorRef q2;

CGColorRef r2;

CGColorRef s2;

CGColorRef t2;

CGColorRef u2;

CGColorRef v2;

CGColorRef w2;
CGColorRef a1;

CGColorRef b1;

CGColorRef c1;


CGColorRef d1;


CGColorRef e1;


CGColorRef f1;


CGColorRef g1;

CGColorRef h1;

CGColorRef i1;

CGColorRef j;

@implementation LogInVC


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAlreadyRun:[[NSUserDefaults standardUserDefaults]boolForKey:@"Already"]];
    [self setavatar];
    [self initColors2];
    _imagePicker = [[UIImagePickerController alloc]init];
    self.imagePicker.delegate = self;
    [self.overlayBG.layer setCornerRadius:self.overlayBG.frame.size.width / 2];
    _profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2;
    [self.activityView.layer setCornerRadius:10];
    [self.activityView setHidden:YES];
    [self.activitystatus setHidesWhenStopped:YES];
    [self.activitystatus stopAnimating];
    _usernameField.delegate = self;
    _emailTextfield.delegate = self;
    _passwordTextfield.delegate = self;
    self.canSignIn = NO;
    


    [self animate:0];
}

-(void)setavatar
{
    NSUInteger n = arc4random_uniform((u_int32_t)[Constants avatar].count);
    [self setAvatar:[[Constants avatar] objectAtIndex:n]];
}


- (IBAction)signUpButtonPressed:(id)sender
{
    if(self.canSignIn){
        [self performSignIn];
    }else{
        [self performSignup];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.isInView = YES;
    [self.activityView.layer setCornerRadius:10];
    [self.activityView setHidden:YES];
    [self.activitystatus setHidesWhenStopped:YES];
    [self.activitystatus stopAnimating];
    [self.navigationController setNavigationBarHidden:YES];
    [Constants imageBoundSetup:self.overlayBG.layer delay:5 isInView:_isInView];
    if(IS_IPAD){
       // [self.signInButtonbottom setConstant:400];
        //[self.signINbottom setConstant:360];
    }else if (IS_IPHONE_5){
        [self.detailStack setSpacing:15];
    }
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.overlayBG.layer setCornerRadius:self.overlayBG.frame.size.width / 2];
    _profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2;
    //NSLog(@"The height is %f", self.view.frame.size.height);
    //NSLog(@"The width is %f", self.view.frame.size.width);
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    self.isInView = NO;
}

-(void)performSignup
{
    if(![_usernameField.text  isEqual: @""] && ![_passwordTextfield.text  isEqual: @""] && ![_emailTextfield.text  isEqual: @""] && (_emailTextfield.text).length > 6 ){
        [self.signInButton setEnabled:NO];
        [UIView animateWithDuration:0.3 animations:^{
            [self.activityView setHidden:NO];
            [self.activitystatus startAnimating];
            
        }];
        NSDictionary* userInfo = @{FIR_BASE_CHILD_USERNAME : _usernameField.text.lowercaseString, FIR_BASE_CHILD_PROFILE_IMG_URL : self.avatar};
        [[DataService authService] signUp:_emailTextfield.text password:_passwordTextfield.text onComplete:^{
            [self.signInButton setEnabled:YES];
            NSString* uid = [[NSUserDefaults standardUserDefaults] objectForKey:USER_UID__];
            [[DatabaseService main] saveFIRGamer:uid userInfo:userInfo];
            if (self.alreadyRun){
                [self performSegueWithIdentifier:SEGUE_LOGGED_IN sender:nil];
            }else{
                UIViewController* v = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Tuts"];
                [self presentViewController:v animated:YES completion:nil];
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"Already"];
            }
            NSDictionary* d = @{FIR_BASE_CHILD_USERNAME:_usernameField.text,FIR_BASE_CHILD_PROFILE_IMG_URL:self.avatar};
            [[NSUserDefaults standardUserDefaults]setObject:d forKey:USER_INFO];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:DID_LOG_IN_];
        } view:self stop:^{
            [self.activityView setHidden:YES];
            [self.activitystatus stopAnimating];
            [self.signInButton setEnabled:YES];
        }];
    }else{
        UIAlertController* alert = [Constants createDefaultAlert:@"Invalid Credentials" title:@"Please enter a valid email and password" message:@"Dismiss"];
        [self presentViewController:alert animated:YES completion:^{}];
    }

}



-(void)performSignIn
{
    if (![_emailTextfield.text isEqualToString:@""] && ![_passwordTextfield.text isEqualToString:@""]){
        [self.signInButton setEnabled:NO];
        [UIView animateWithDuration:0.3 animations:^{
            [self.activityView setHidden:NO];
            [self.activitystatus startAnimating];
        }];
        [[DataService authService] logIn:_emailTextfield.text password:_passwordTextfield.text view:self onComplete:^{[self.signInButton setEnabled:NO];
            if ([Constants uid] != nil) {
                NSMutableArray* array = [NSMutableArray new];
                [[DatabaseService main] fb_fetchUserDetails:[Constants uid] intoArray:array exec:^{
                    Gamer* user = (Gamer*)[array objectAtIndex:0];
                    NSDictionary* d = @{FIR_BASE_CHILD_USERNAME:user.username, FIR_BASE_CHILD_PROFILE_IMG_URL:user.avatar};
                    [[NSUserDefaults standardUserDefaults]setObject:d forKey:USER_INFO];
                }];
            }
                [[AppDelegate mainDelegate] setDidsignout:NO];
            
            if (self.alreadyRun){
                [self performSegueWithIdentifier:SEGUE_LOGGED_IN sender:nil];
            }else{
                UIViewController* v = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Tuts"];
                [self presentViewController:v animated:YES completion:nil];
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"Already"];
            }
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:DID_LOG_IN_];
                
        } stop:^{
            [self.activityView setHidden:YES];
            [self.activitystatus stopAnimating];
            [self.signInButton setEnabled:YES];
        }];
    }else{
        UIAlertController* alert = [Constants createDefaultAlert:@"Invalid Credentials" title:@"Please enter a valid email and password" message:@"Dismiss"];
        [self presentViewController:alert animated:YES completion:^{}];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    if(IS_IPHONE_5){
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.4 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
            //[self.stackViewBottom setConstant:50];
            [self.proimgheight setConstant:100];
            [self.overlayBG setHidden:NO];
        } completion:^(BOOL did){}];
    }

    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(IS_IPHONE_5){
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.4 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
            //[self.stackViewBottom setConstant:150];
            [self.proimgheight setConstant:0];
            [self.overlayBG setHidden:YES];
        } completion:^(BOOL did){}];
    }
    return YES;
}

- (IBAction)signInButtonPressed:(id)sender {
    
    if (!self.canSignIn){
        [self signInSelected];
    }else{
        [self signUpSelected];
    }

}

- (IBAction)forgotPassBtnPressed:(UIButton *)sender {
    NSString* email = self.emailTextfield.text;
    if(email){
        UIAlertController* a = [UIAlertController alertControllerWithTitle:@"Password Reset" message:@"You are about to reset your Streaker account password" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction* action = [UIAlertAction actionWithTitle:@"Cancel" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {}];
        UIAlertAction* action2 = [UIAlertAction actionWithTitle:@"Reset" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
            [[DataService authService] fb_Auth_Password_Reset:email c:self e:^{}];
        }];
        [a addAction:action];[a addAction:action2];
        [self presentViewController:a animated:YES completion:^{}];
        
    }else{
        UIAlertController* alert = [Constants createDefaultAlert:@"Error" title:@"Please enter the email used to create the account" message:@"Dismiss"];
        [self presentViewController:alert animated:YES completion:^{}];
    }
}


-(void)signInSelected
{
    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.4 options:(UIViewAnimationOptionCurveEaseIn) animations:^{
        [self.usernameField setHidden:YES];
        [self.forgotPassBtn setHidden:NO];
        if(IS_IPAD){//[self.signInButtonbottom setConstant:470];
            //[self.signINbottom setConstant:430];
        }else if (IS_IPHONE_5){
            [self.stackHeight setConstant:150];
                [self.detailStack setSpacing:40];
                
            }
        else{
            //[self.stackViewBottom setConstant:120];
        }
        [self.signUpButton setTitle:@"Log In" forState:(UIControlStateNormal)];

    } completion:^(BOOL finished) {
        [self setCanSignIn:YES];

    }];
    [self.accntStatusTexxt setText:@"Create New Account"];
    [self.signInButton setTitle:@"Sign Up" forState:(UIControlStateNormal)];
    [self.imgSelectButton setEnabled:NO];
}

-(void)signUpSelected
{
    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.4 options:(UIViewAnimationOptionCurveEaseIn) animations:^{
        [self.usernameField setHidden:NO];
        [self.forgotPassBtn setHidden:YES];
        if(IS_IPAD){
            //[self.signInButtonbottom setConstant:400];[self.signINbottom setConstant:360];
        }else if (IS_IPHONE_5){
            [self.detailStack setSpacing:15];
            [self.stackHeight setConstant:200];
        }else{
            //[self.stackViewBottom setConstant:50];
        }
       

    } completion:^(BOOL finished) {
        [self setCanSignIn:NO];

    }];
     [self.signUpButton setTitle:@"Sign Up" forState:(UIControlStateNormal)];
    [self.accntStatusTexxt setText:@"Have An Account Already?"];
    [self.signInButton setTitle:@"Sign In" forState:(UIControlStateNormal)];
    [self.imgSelectButton setEnabled:YES];
}

- (IBAction)imageSelectpressed:(id)sender {
    [self performSegueWithIdentifier:@"AVatrSegue" sender:nil];
    //[self presentViewController:_imagePicker animated:YES completion:nil];
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info

{
  [self dismissViewControllerAnimated:YES completion:^{
      //
  }];
    UIImage* image = (UIImage* )info[UIImagePickerControllerOriginalImage];
    self.profileImageView.image = image;
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker

{
    [self dismissViewControllerAnimated:YES completion:nil];
}


//Location delegates

/*-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Error occurred%@", error.description);
    UIAlertController* c = [Constants createDefaultAlert:@"GPS Error" title:error.description message:@"Dismiss"];
    [self presentViewController:c animated:YES completion:nil];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    NSLog(@"The locations are %@", locations);
    CLLocation* lastLocation = [locations lastObject];
    [self setLatitude:lastLocation.coordinate.latitude];
    [self setLongitude:lastLocation.coordinate.longitude];
    NSLog(@"The longitude is  %f", _longitude);
    NSLog(@"The latitude is  %f", _latitude);
    
    
}*/

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"AVatrSegue"]){
        AvatarVC* destination = (AvatarVC*)[segue destinationViewController];
        [destination setDelegate:self];
    }
}

-(void)DidFinishPickingAvatar:(NSString *)avatar
{
    [self setAvatar:avatar];
    [self.profileImageView setImage:[UIImage imageNamed:avatar]];
}



-(void)animate:(NSUInteger)index
{
    id color = [_colors objectAtIndex:index];
    [Constants dynamicOverlay:self.view.layer color:color did:^{
        [Constants delayWithSeconds:2 exec:^{
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
        [Constants delayWithSeconds:2 exec:^{
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

-(void)initColors
{
    a2= [[UIColor colorWithRed:0.133 green:0 blue:0.240 alpha:1]CGColor];
    b2 = [[UIColor colorWithRed:0.043 green:0 blue:0.078 alpha:1]CGColor];
    c2 = [[UIColor colorWithRed:0.086 green:0 blue:0.161 alpha:1]CGColor];
    d2 = [[UIColor colorWithRed:0.176 green:0 blue:0.322 alpha:1]CGColor];
    e2 = [[UIColor colorWithRed:0.220 green:0 blue:0.4 alpha:1]CGColor];
    f2 = [[UIColor colorWithRed:0.263 green:0 blue:0.490 alpha:1]CGColor];
    g2 = [[UIColor colorWithRed:0.310 green:0 blue:0.522 alpha:1]CGColor];
    h2 = [[UIColor colorWithRed:0.353 green:0 blue:0.639 alpha:1]CGColor];
    i2 = [[UIColor colorWithRed:0.396 green:0 blue:0.726 alpha:1]CGColor];
    j2 = [[UIColor colorWithRed:0.482 green:0 blue:0.996 alpha:1]CGColor];
    k2 = [[UIColor colorWithRed:0.529 green:0.039 blue: 0.961 alpha:1]CGColor];
    l2 = [[UIColor colorWithRed:0.569 green:0.122 blue:1 alpha:1]CGColor];
    m2 = [[UIColor colorWithRed:0.604 green:0.2 blue:1  alpha:1]CGColor];
    n2 = [[UIColor colorWithRed:0.675 green:0.278 blue:1 alpha:1]CGColor];
    o2 = [[UIColor colorWithRed:0.714 green:0.361 blue:1 alpha:1]CGColor];
    /*p2 = [[UIColor colorWithRed:0.749 green:0.439 blue:1 alpha:1]CGColor];
    q2 = [[UIColor colorWithRed:0.784 green:0.313 blue:1 alpha:1]CGColor];
    r2 = [[UIColor colorWithRed:0.820 green:0.6 blue:1 alpha:1]CGColor];
    s2 = [[UIColor colorWithRed:0.855 green:0.678 blue:1 alpha:1]CGColor];
    t2 = [[UIColor colorWithRed:0.890 green:0.761 blue:1 alpha:1]CGColor];
    u2 = [[UIColor colorWithRed:0.929 green:0.839 blue:1 alpha:1]CGColor];
    v2 = [[UIColor colorWithRed:0.965 green:0.922 blue:1 alpha:1]CGColor];
    w2 = [[UIColor colorWithRed:1 green:1 blue:1 alpha:1]CGColor];*/
    
    _colors = @[(__bridge id)a2,(__bridge id)b2,(__bridge id)c2,(__bridge id)d2,(__bridge id)e2, (__bridge id)f2, (__bridge id)g2, (__bridge id)h2, (__bridge id)i2, (__bridge id)j2,(__bridge id)k2, (__bridge id)l2, (__bridge id)m2, (__bridge id)n2,(__bridge id)o2/*, (__bridge id)p2, (__bridge id)q2, (__bridge id)r2,(__bridge id)s2, (__bridge id)t2, (__bridge id)u2, (__bridge id)v2,(__bridge id)w2*/];
}

-(void)initColors2
{
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
    
    _colors = @[(__bridge id)a1,(__bridge id)b1,(__bridge id)c1,(__bridge id)d1,(__bridge id)e1, (__bridge id)f1, (__bridge id)g1, (__bridge id)h1, (__bridge id)i1, (__bridge id)j];
}

@end
