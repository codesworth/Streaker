//
//  AccountHelperVC.m
//  CWStreaks
//
//  Created by Mensah Shadrach on 3/18/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import "AccountHelperVC.h"

@interface AccountHelperVC ()

@property (weak, nonatomic) IBOutlet MaterialTextfield *emailTextField;
@property (weak, nonatomic) IBOutlet MaterialTextfield *passwordTextfield;
@property (weak, nonatomic) IBOutlet MaterialButtons *actionButtn;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView* activity;

@property (weak, nonatomic) IBOutlet UIView *activityBG;
@property (weak, nonatomic) IBOutlet MaterialTextfield *nAddressField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttnCon;


@end

@implementation AccountHelperVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.activityBG.layer setCornerRadius:10];
    [self.activityBG setHidden:YES];
    if (_viewNumber) {
        if (self.viewNumber.unsignedIntegerValue == 1){
            self.navigationItem.title = @"Change Email";
        }else if (self.viewNumber.unsignedIntegerValue == 2){
            self.navigationItem.title = @"Delete Account";
            [self.nAddressField setHidden:YES];
            [self.buttnCon setConstant:40];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)actionButtonPreesed:(id)sender {
    if (_viewNumber) {
        [self.activityBG setHidden:NO];
        [self.activity startAnimating];
        NSString* email = self.emailTextField.text;
        NSString* password = self.passwordTextfield.text;
        if (self.viewNumber.unsignedIntegerValue == 1){
            NSString* nmail = self.nAddressField.text;
            if (email && password && nmail){
                [[DataService authService] fb_Auth_Change_Email:email p:password new:nmail c:self e:^{
                    [self presentViewController:[Constants initLogInVC] animated:YES completion:^{}];
                    [self.activity stopAnimating];
                }];
            }else{
                [self presentViewController:[Constants createDefaultAlert:@"Error" title:@"Please authenticate with valid email and password" message:@"OK"] animated:YES completion:nil];
                [self.activity stopAnimating];
            }
        }else if (self.viewNumber.unsignedIntegerValue == 2){
            [self.activityBG setHidden:NO];
            [self.activity startAnimating];
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Warning" message:@"You are attemting to delete your Streaker Account. This will delete all data and sign you out of Streaker. Proceed with caution" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction* action = [UIAlertAction actionWithTitle:@"Cancel" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {}];
            UIAlertAction* action2 = [UIAlertAction actionWithTitle:@"Proceed" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
                [[DataService authService] fb_Auth_DeleteUserAccount:email p:password c:self e:^{

                    [self presentViewController:[Constants initLogInVC] animated:YES completion:^{}];
                    [self.activity stopAnimating];
                }];
            }];
            [alert addAction:action];[alert addAction:action2];
            [self presentViewController:alert animated:YES completion:^{}];
            
            
        }
    }
}


@end
