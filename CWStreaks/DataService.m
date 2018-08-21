//
//  DataService.m
//  CWStreaks
//
//  Created by Mensah Shadrach on 11/1/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

#import "DataService.h"

//typedef void(^Completed)(  NSString* _Nullable  errorMessage,  NSObject* _Nullable userData);


@implementation DataService


+(id)authService

{
    static DataService *authService = nil;
    static dispatch_once_t oncetoken;
    dispatch_once(&oncetoken, ^{
        authService = [[self alloc] init];
    });
    return authService;
}

-(void)logIn:(NSString*)email password:(NSString*)password view:(UIViewController* _Nullable)controller onComplete:(ExecuteAfterFinish _Nullable)onComplete stop:(Execute)animationBlock
{
    [[FIRAuth auth]signInWithEmail:email password:password completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
        if (error != nil){
            animationBlock();
            [controller presentViewController:[self fireBaseErrorHandling:error] animated:YES completion:nil];
            //NSLog(@"An Error occurred with signature: %@", error.debugDescription);
            
        }else{
            [[NSUserDefaults standardUserDefaults]setObject:user.uid forKey:USER_UID__];
            [[DatabaseService main] awakeFromFBDatabase:user.uid exec:^{
                onComplete();
            }];
            
        }
    }];
}
-(void)signUp:(NSString* _Nonnull)email password:(NSString* _Nonnull)passsword onComplete:(ExecuteAfterFinish _Nullable)onComplete view:(UIViewController* _Nullable)controller stop:(Execute)animationBlock
{
    [[FIRAuth auth] createUserWithEmail:email password:passsword completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
        if (error != nil){
            //handle error
            animationBlock();
            [controller presentViewController:[self fireBaseErrorHandling:error ] animated:YES completion:nil];
            //NSLog(@"Error occured with Signature: %@", error);
            
        }else{
            if (user.uid != nil){
                [[NSUserDefaults standardUserDefaults] setObject:user.uid forKey:USER_UID__];
                [[DatabaseService main] fb_initScoreData:user.uid exec:^{}];
                onComplete();
            
                //optional sign in
            }
        }//
    }];
}

-(void)fb_signOut:(Execute)onComplete
{
    [[FIRAuth auth] signOut:nil];
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:USER_UID__];
    [[AppDelegate mainDelegate] setDidsignout:YES];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:DID_LOG_IN_];
    NSDictionary* info = @{};
    [[NSUserDefaults standardUserDefaults]setObject:info forKey:USER_INFO];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"alreadyRun"];
    onComplete();
}


-(void)fb_Auth_Password_Reset:(NSString *)email c:(UIViewController*)controller e:(Execute)onComplete
{
    [[FIRAuth auth] sendPasswordResetWithEmail:email completion:^(NSError * _Nullable error) {
        if (error){
             UIAlertController* alert = [Constants createDefaultAlert:@"Error" title:@"Please enter the email used to create the account" message:@"Dismiss"];
            [controller presentViewController:alert animated:YES completion:^{}];
        }else{
            UIAlertController* alert = [Constants createDefaultAlert:@"Password Reset" title:@"Please check your mail for password reset link." message:@"Dismiss"];
            [controller presentViewController:alert animated:YES completion:^{}];
            onComplete();
        }
    }];
}

-(void)fb_Auth_DeleteUserAccount:(NSString*)email p:(NSString*)password c:(UIViewController*)controller e:(Execute)onComplete
{
    FIRUser* user = [FIRAuth auth].currentUser;
    FIRAuthCredential* credentials = [FIREmailPasswordAuthProvider credentialWithEmail:email password:password];
    [user reauthenticateWithCredential:credentials completion:^(NSError * _Nullable error) {
        if (error){
            UIAlertController* alert = [Constants createDefaultAlert:@"Authentication Error" title:@"There was an error authenticating credentials, please enter correct email/password or check your internet connection" message:@"Dismiss"];
            [controller presentViewController:alert animated:YES completion:^{}];
        }else{
            [[DatabaseService main] deleteUserAccount:user.uid];
            [user deleteWithCompletion:^(NSError * _Nullable error) {
                if (error){
                    UIAlertController* alert = [Constants createDefaultAlert:@"Error" title:@"Unable to delete user account. Please check internet connection" message:@"Dismiss"];
                    [controller presentViewController:alert animated:YES completion:^{}];
                }else{
                    
                    onComplete();
                }
            }];
        }
    }];
}

-(void)fb_Auth_Change_Email:(NSString *)email p:(NSString *)password new:(NSString*)newEmail c:(UIViewController*)controller e:(Execute)onComplete
{
    FIRUser* user = [FIRAuth auth].currentUser;
    FIRAuthCredential* credentials = [FIREmailPasswordAuthProvider credentialWithEmail:email password:password];
    [user reauthenticateWithCredential:credentials completion:^(NSError * _Nullable error) {
        if(error){
            UIAlertController* alert = [Constants createDefaultAlert:@"Authentication Error" title:@"There was an error authenticating credentials, please enter correct email/password or check your internet connection" message:@"Dismiss"];
            [controller presentViewController:alert animated:YES completion:^{}];
        }else{
            [user updateEmail:newEmail completion:^(NSError * _Nullable updateerror) {
                if(updateerror){
                    UIAlertController* alert = [Constants createDefaultAlert:@"Error" title:@"Unable to update Email. Email is already registered to an account or unavailable. Please check internet connection" message:@"Dismiss"];
                    [controller presentViewController:alert animated:YES completion:^{}];
                }else{
                    [self fb_signOut:^{}];
                    onComplete();
                }
            }];
        }
    }];
}

-(UIAlertController*)fireBaseErrorHandling:(NSError*)error
{
    switch (error.code) {
        case FIRAuthErrorCodeInvalidEmail:
            return [Constants createDefaultAlert:@"Invalid Email" title:@"Please enter a valid email address" message:@"OK" ];
            break;
        case FIRAuthErrorCodeEmailAlreadyInUse:
            return [Constants createDefaultAlert:@"Email Already In Use" title:@"Please enter another valid email address" message:@"OK"];
            break;
        case FIRAuthErrorCodeNetworkError:
            return [Constants createDefaultAlert:@"Network Error" title:@"Network error interrupted authentication" message:@"OK" ];
            break;
        case FIRAuthErrorCodeWrongPassword:
            return [Constants createDefaultAlert:@"Wrong Password" title:@"Please enter the correct pasword" message:@"OK" ];
            break;
        case FIRAuthErrorCodeUserNotFound:
            return [Constants createDefaultAlert:@"User Not Found" title:@"Thsi account could not be found" message:@"OK"];
            break;
        default:
            return [Constants createDefaultAlert:@"Problem Signing In" title:@"A problem was encontered whiles signing in" message:@"OK"];
            break;
    }
}
@end
