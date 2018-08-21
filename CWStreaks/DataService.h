//
//  DataService.h
//  CWStreaks
//
//  Created by Mensah Shadrach on 11/1/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Firebase;
@import FirebaseAuth;


#import "Constants.h"
#import "AppDelegate.h"
#import "DatabaseService.h"

typedef void (^ExecuteAfterFinish)(void);
typedef void(^Execute)(void);
@interface DataService : NSObject


+(_Nonnull id)authService;

-(void)logIn:( NSString* _Nonnull )email password:(NSString* _Nonnull)password view:(UIViewController* _Nullable)controller onComplete:(ExecuteAfterFinish _Nullable)onComplete  stop:(nullable Execute)animationBlock ;

-(void)signUp:(NSString* _Nonnull)email password:(NSString* _Nonnull)passsword onComplete:(ExecuteAfterFinish _Nullable)onComplete view:(UIViewController* _Nullable)controller  stop:(nullable Execute)animationBlock;

-(void)fb_signOut:(nullable Execute)onComplete;

-(void)fb_Auth_Password_Reset:(NSString* _Nonnull)email c:(UIViewController* _Nonnull)controller e:(nullable Execute)onComplete;

-(void)fb_Auth_Change_Email:(NSString* _Nonnull)email p:(NSString* _Nonnull)password new:(NSString* _Nonnull)newEmail c:(UIViewController* _Nonnull)controller e:(Execute _Nullable)onComplete;

-(void)fb_Auth_DeleteUserAccount:(NSString* _Nonnull)email p:(NSString* _Nonnull)password c:(UIViewController* _Nonnull)controller e:(nullable Execute)onComplete;


@end
