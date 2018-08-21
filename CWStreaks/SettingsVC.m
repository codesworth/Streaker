//
//  SettingsVC.m
//  CWStreaks
//
//  Created by Mensah Shadrach on 2/10/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import "SettingsVC.h"

@interface SettingsVC ()<UITextFieldDelegate,AvatarVCDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UITextField *usernamelbl;
@property (weak, nonatomic) IBOutlet UISwitch *gameSfxEnabled;
@property(strong,nonatomic,nullable)NSDictionary* userInfo;
@property(strong,nullable,nonatomic)SFSafariViewController* webView;
@property (weak, nonatomic) IBOutlet UIView *overlayBG;
@property(nonatomic)BOOL isTopView;
@property(strong,nonatomic,nullable)UIImagePickerController* picker;
@property (weak, nonatomic) IBOutlet UISwitch *savePhoto;

@end

@implementation SettingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setIsTopView:YES];
    [Constants imageBoundSetup:self.overlayBG.layer delay:5 isInView:_isTopView];
    self.usernamelbl.delegate = self;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.avatarImgView.layer setCornerRadius:self.avatarImgView.frame.size.width/2];
    [self.overlayBG.layer setCornerRadius:self.overlayBG.frame.size.width/2];

    
    [self.gameSfxEnabled setOn:[[NSUserDefaults standardUserDefaults] boolForKey:game_SFX] animated:YES];
    [self.savePhoto setOn:[[NSUserDefaults standardUserDefaults] boolForKey:AUTO_SAVEPHOTO] animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.userInfo = (NSDictionary*)[[NSUserDefaults standardUserDefaults]objectForKey:USER_INFO];
    self.usernamelbl.text = [self.userInfo objectForKey:FIR_BASE_CHILD_USERNAME];
    [self.avatarImgView setImage:([UIImage imageNamed:[_userInfo objectForKey:FIR_BASE_CHILD_PROFILE_IMG_URL]])];

}


-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [self setIsTopView:NO];
}
#pragma mark - IBACTIONS

- (IBAction)avatarEditButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"avatarVC" sender:nil];
}
- (IBAction)sfxToggled:(id)sender {
    if (self.gameSfxEnabled.isOn){
        [self.gameSfxEnabled setOn:NO animated:YES];
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:game_SFX];
        //stop sfx
    }else{
        [self.gameSfxEnabled setOn:YES animated:YES];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:game_SFX];
        //resume sfx
    }
}

- (IBAction)savePhotoToggled:(id)sender {
    if (self.gameSfxEnabled.isOn){
        [self.savePhoto setOn:NO animated:YES];
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:AUTO_SAVEPHOTO];
        //stop sfx
    }else{
        [self.savePhoto setOn:YES animated:YES];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:AUTO_SAVEPHOTO];
        //resume sfx
    }
}



- (IBAction)dismissView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage* image = (UIImage*)[info objectForKey:UIImagePickerControllerOriginalImage];
    NSData* pickData = UIImagePNGRepresentation(image);
    NSString* chBg = [Constants create_return_Directory:@"Background"];
    NSString* bgpath = [chBg stringByAppendingPathComponent:@"chatBackground.jpg"];
    [pickData writeToFile:bgpath atomically:NO];
    //NSLog(@"The document directory,%@", [Constants doeumentsUrl]);
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 3;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0){
        if (indexPath.row == 2){
            if ([[DatabaseService main] check_fb_connection]) {
                
                [[DatabaseService main] fb_saveUnsavedGamedata:^{
                    UIAlertController* alert = [Constants createDefaultAlert:@"Update" title:@"User scores succesfully syncronized" message:@"OK"];
                    [self presentViewController:alert animated:YES completion:^{}];
                }];
            }else{
                [self presentViewController:[Constants createDefaultAlert:@"No Internet Connection" title:@"An internet connection is required to synchronize scores" message:@"Dismiss"] animated:YES completion:^{}];
            }
        }else if(indexPath.row == 4){
            UIViewController* c = (UIViewController*)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Tuts"];
            [self presentViewController:c animated:YES completion:nil];
            skip = YES;
            
        }else if (indexPath.row == 5){
            self.picker = [[UIImagePickerController alloc]init];
            _picker.delegate = self;
            [self presentViewController:_picker animated:YES completion:nil];
        }
        
    }else if (indexPath.section == 1){
        if (indexPath.row == 0){
            /*[[DataService authService] fb_signOut:^{
                [self presentViewController:[Constants initLogInVC] animated:YES completion:nil];
            }];*/
            [self signOut];
        }else if (indexPath.row == 1){
            NSNumber* number = [NSNumber numberWithUnsignedInteger:1];
            [self performSegueWithIdentifier:SEGUE_SETTINGS_ACC_HELP sender:number];
        }else if (indexPath.row == 2){
           NSNumber* number = [NSNumber numberWithUnsignedInteger:2];
            [self performSegueWithIdentifier:SEGUE_SETTINGS_ACC_HELP sender:number];
        }else{
            [self performSegueWithIdentifier:@"Blocked" sender:nil];
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0){
            [self performSegueWithIdentifier:@"About" sender:nil];
        }else if (indexPath.row == 1){
            NSURL* url = [NSURL URLWithString:@"http://www.codesworth.net/streaker"];
            self.webView = [[SFSafariViewController alloc]initWithURL:url];
            _webView.title = @"Privacy Policy";
            _webView.preferredBarTintColor = [UIColor colorWithRed:0.73 green:0.467 blue:1 alpha:1 ];
            [self presentViewController:self.webView animated:YES completion:^{}];

        }else if (indexPath.row == 2){
            [self sendMail];
        }else if(indexPath.row == 3){
            [self performSegueWithIdentifier:@"Privacy" sender:nil];
        }else if (indexPath.row == 4){
            [self performSegueWithIdentifier:@"OPNSLVC" sender:nil];
        }
        
    }
    
//viewTitle,button,title
else if(indexPath.row == 6){
        NSURL* url = [NSURL URLWithString:@"http://www.codesworth.net"];
        self.webView = [[SFSafariViewController alloc]initWithURL:url];
        _webView.title = @"Codesworth Inc.";
        _webView.preferredBarTintColor = [UIColor colorWithRed:0.73 green:0.467 blue:1 alpha:1 ];
        [self presentViewController:self.webView animated:YES completion:^{}];
        //[[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {}];
    
    }else if (indexPath.row == 7){
        
    }
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView* v = (UITableViewHeaderFooterView*)view;
    v.textLabel.font = [UIFont fontWithName:@"SFMono-Semibold" size:16];
    v.textLabel.textColor = [UIColor whiteColor];
}


-(void)sendMail{
    if ([MFMailComposeViewController canSendMail]) {
        NSString* name = [UIDevice currentDevice].name;
        NSString* system = [UIDevice currentDevice].systemName;
        NSString* systemVersion = [UIDevice currentDevice].systemVersion;
        NSString* model = [UIDevice currentDevice].model;
        NSString* body = [NSString stringWithFormat:@"%@\n%@\n%@\n%@", name,system,systemVersion,model];
        MFMailComposeViewController* mailVc  = [[MFMailComposeViewController alloc]init];
        mailVc.mailComposeDelegate = self;
        [mailVc setToRecipients:@[@"cwstreaker@gmail.com"]];
        [mailVc setSubject:@"Support"];
        [mailVc setMessageBody:body isHTML:NO];
        [self presentViewController:mailVc animated:YES completion:nil];
    }else{
        UIAlertController* alert = [Constants createDefaultAlert:@"Mail Error" title:@"Your device is unable to send emails at this time. Please contact us on our website" message:@"Dismiss"];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [controller dismissViewControllerAnimated:YES completion:nil];
}


-(void)DidFinishPickingAvatar:(NSString *)avatar
{
    self.avatarImgView.image = [UIImage imageNamed:avatar];
}

-(void)signOut
{
    UIAlertController* alert = [Constants createDefaultAlert:@"Sign Out" title:@"You are about to sign out from your Streaker account. Signing out will erase all history of completed challenges and chat messages" message:@"Cancel"];
    UIAlertAction* signout = [UIAlertAction actionWithTitle:@"Sign Out" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
        [[DataService authService] fb_signOut:^{
            [self presentViewController:[Constants initLogInVC] animated:YES completion:nil];
        }];
    }];
    [alert addAction:signout];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UITEXTFIELD DELEGATE
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{   [self.view endEditing:YES];
    NSString* uid = [[NSUserDefaults standardUserDefaults ]stringForKey:USER_UID__];
    [[[[DatabaseService main]userReference] child:uid]updateChildValues:@{FIR_BASE_CHILD_USERNAME:textField.text.lowercaseString}];
    NSDictionary* d = @{FIR_BASE_CHILD_USERNAME: textField.text, FIR_BASE_CHILD_PROFILE_IMG_URL:[_userInfo objectForKey:FIR_BASE_CHILD_PROFILE_IMG_URL]};
    [[NSUserDefaults standardUserDefaults]setObject:d forKey:USER_INFO];
    return YES;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"avatarVC"]){
        AvatarVC* destination = [segue destinationViewController];
        destination.fromSettings = YES;
        destination.delegate = self;
    }else if ([segue.identifier isEqualToString:SEGUE_SETTINGS_ACC_HELP]){
        AccountHelperVC* destination = (AccountHelperVC*)[segue destinationViewController];
        if (sender){
            destination.viewNumber = (NSNumber*)sender;
        }
    }
}


@end
