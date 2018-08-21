//
//  AppDelegate.h
//  CWStreaks
//
//  Created by Mensah Shadrach on 10/31/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "Reachability.h"
#import "DatabaseService.h"
#import "Appirater.h"

@import Firebase;
@import FirebaseDatabase;
@import FirebaseInstanceID;
@import FirebaseMessaging;
@import UserNotifications;
@import GoogleMobileAds;
@import CoreLocation;
@interface AppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate, FIRMessagingDelegate>
@property(nonatomic)BOOL didsignout;
@property(nonatomic)BOOL firstRun;
@property (strong, nonatomic) UIWindow * _Nullable window;
@property(nonatomic)BOOL unSavedContent;
@property(nonatomic, strong)Reachability* _Nullable internetReachability;
@property(nonnull, strong, nonatomic)NSMutableArray* selff;
@property(strong,nullable,nonatomic)CLLocation* myLocale;
@property(strong,nonatomic,nullable)NSMutableArray* pendingReqKeys;
@property(strong,nonatomic,nullable)NSMutableArray* activeChKeys;
@property(nonatomic)BOOL onStart;
@property(nonatomic)NSUInteger endedCount;
@property(nonatomic)BOOL isChatVC;
@property(nonatomic)BOOL onStart2;
@property(nonatomic,nonnull)NSMutableArray* myList;
@property(nonatomic)BOOL shouldRemind;


+(AppDelegate* _Nullable)mainDelegate;
-(void)createNotificationFor:(Challenge* _Nonnull)challenge t:(NSString* _Nullable)title b:(NSString*_Nullable)body;



@end

