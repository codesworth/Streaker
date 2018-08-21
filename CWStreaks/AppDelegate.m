//
//  AppDelegate.m
//  CWStreaks
//
//  Created by Mensah Shadrach on 10/31/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//


/*
 
 
 */
#import "AppDelegate.h"

@interface AppDelegate ()
@property(nonnull, strong,nonatomic)NSString* token;
@end

@implementation AppDelegate

+(AppDelegate*)mainDelegate
{
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [FIRApp configure];
    [GADMobileAds configureWithApplicationID:GAD_APP_ID];
    _window.rootViewController = [self isRootViewController];
    [Appirater setAppId:@"1222312862"];
    [Appirater setDaysUntilPrompt:1];
    [Appirater setUsesUntilPrompt:10];
    [Appirater setSignificantEventsUntilPrompt:60];
    [Appirater setTimeBeforeReminding:60];
    _unSavedContent = NO;
    _didsignout = NO;
    _firstRun = YES;
    _onStart = YES;
    _onStart2 = YES;
    _isChatVC = NO;
    _shouldRemind = NO;
    [self appearances];
    //NSLog(@"Big integer, %lu",(unsigned long)NSUIntegerMax);
    [self notify_for_covenient_save];
    [self notif_configure];
    [self nsmama];
    _selff = [[NSMutableArray alloc] init];
    _myLocale = [[CLLocation alloc]init];
    if ([Constants uid] != NULL && [[NSUserDefaults standardUserDefaults] boolForKey:DID_LOG_IN_] ) {
        self.myList = [[NSMutableArray alloc]init];
        //[self fetchself];
        [[DatabaseService main] fb_fetch_Listed];
        [[DatabaseService main] observeRequestAccepted:^{}];
        [[DatabaseService main]observeRequestSent:^{}];
    }
    else{

        
    }
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fcm_refreshToken:) name:kFIRInstanceIDTokenRefreshNotification object:nil];
        UIUserNotificationSettings* settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];

    //[[DatabaseService main] fb_saveUnsavedGamedata:^{}];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setNotification:) name:@"Accepted" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setSentNotification:) name:@"SentRequest" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setSentNotification:) name:@"Ended" object:nil];
    [Appirater appLaunched:YES];

    return YES;
}

-(void)nsmama
{

}

- (void)applicationWillResignActive:(UIApplication *)application {
    _firstRun = NO;
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[FIRMessaging messaging] disconnect];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [Appirater appEnteredForeground:YES];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self fbCM_Connect:nil];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //NSLog(@"This is the message, %@", userInfo);
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    
    // Print message ID.

    
    // Print full message.
    //NSLog(@"This is message %@", userInfo);
    
    completionHandler(UIBackgroundFetchResultNewData);
}

-(UIViewController*)isRootViewController{
    NSString* storyboardName = @"Main";
    BOOL firstRun = YES;
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    BOOL isLoggedIn = [[NSUserDefaults standardUserDefaults]boolForKey:DID_LOG_IN_];
    if (isLoggedIn){
        if (!firstRun) {
            return [storyboard instantiateViewControllerWithIdentifier:@"Tuts"];
        }
        UINavigationController* controller = [storyboard instantiateViewControllerWithIdentifier:@"startUpNavC"];
        return controller;
    }else{
        return [storyboard instantiateViewControllerWithIdentifier:ID_LOG_IN_VC];
    }
}

-(void)notify_for_covenient_save{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(save) name:kReachabilityChangedNotification object:nil];

}

-(void)save
{   if ([[DatabaseService main] check_fb_connection] && [[NSUserDefaults standardUserDefaults] boolForKey:DID_LOG_IN_])
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [[DatabaseService main] fb_saveUnsavedGamedata:^{ _unSavedContent = NO; [[Reachability reachabilityForInternetConnection] stopNotifier];}];
        });
    }

}



-(void)fcm_refreshToken:(NSNotification*)notification
{
    NSString* token = [[FIRInstanceID instanceID] token];
    NSLog(@"Instance token is %@", token);
    //[self fbCM_Connect:nil];
}

-(void)fbCM_Connect:(ExecuteAfterFinish)onComplete
{
    [[FIRMessaging messaging] connectWithCompletion:^(NSError * _Nullable error) {
        if(error){
            //NSLog(@"Error occurred in connecting to cloud messaging with signature %@",error.debugDescription);
        }else{
            //NSLog(@"Success in connecting to fcm");
            NSString* token = [[FIRInstanceID instanceID] token];
            if (token) {
                [[DatabaseService main]postToken:token];
                //NSLog(@"Instance token is %@", token);
            }

        }
    }];
}


-(void)notif_configure
{
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
        UIUserNotificationType allNotificationTypes =
        (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        // iOS 10 or later
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
        UNAuthorizationOptions authOptions =
        UNAuthorizationOptionAlert
        | UNAuthorizationOptionSound
        | UNAuthorizationOptionBadge;
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if(granted){
                
            }else{
                [self setShouldRemind:YES];
                //[[NSNotificationCenter defaultCenter] postNotificationName:@"DeniedNotif" object:nil];
            }
        }];
        
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
        // For iOS 10 data message (sent via FCM)
        [FIRMessaging messaging].remoteMessageDelegate = self;
#endif
    }
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
}

-(void)fetchself
{
    NSString* uid = [[NSUserDefaults standardUserDefaults]stringForKey:USER_UID__];
    if (uid != nil) {
        [[DatabaseService main] fb_fetchUserDetails:uid intoArray:[AppDelegate mainDelegate].selff exec:^{
            Gamer* user = (Gamer*)[self.selff objectAtIndex:0];
            NSDictionary* d = @{FIR_BASE_CHILD_USERNAME:user.username, FIR_BASE_CHILD_PROFILE_IMG_URL:user.avatar};
            [[NSUserDefaults standardUserDefaults]setObject:d forKey:USER_INFO];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIF_NAME_USER_FETCHED object:nil];
        }];
    }else{
        [self setDidsignout:YES];
    }

}
 -(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    completionHandler(UNNotificationPresentationOptionAlert);
}

-(void)setNotification:(NSNotification*)notification
{
    NSString* uid = [Constants uid];
    NSString* key = [notification.userInfo objectForKey:@"Key"];
    [[[[DatabaseService main] challengeRef] child:key]observeSingleEventOfType:(FIRDataEventTypeValue) withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if ([snapshot exists]){
            //NSLog(@"The snapshot %@",snapshot.value);
            NSString* sender = [(NSDictionary*)snapshot.value objectForKey:@"Sender"];
            if ([uid isEqualToString:sender]){
                NSDictionary* usernames = [(NSDictionary*)snapshot.value objectForKey:@"Usernames"];
                UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc]init];
                content.title = @"Request Accepted";
                NSString* user = [usernames objectForKey:@"Recipient"];
                content.body = [NSString stringWithFormat:@"%@ has accepted your challenge request",user];
                content.sound = [UNNotificationSound defaultSound];
                UNTimeIntervalNotificationTrigger* t = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:2 repeats:NO];
                UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:key content:content trigger:t];
                [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                    //NSLog(@"Notifies");
                }];
            }
        }
    }];
}

-(void)setSentNotification:(NSNotification*)notification
{
    //NSString* uid = [Constants uid];
    NSString* key = [notification.userInfo objectForKey:@"Key"];
    [[[[DatabaseService main] challengeRef] child:key]observeSingleEventOfType:(FIRDataEventTypeValue) withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if ([snapshot exists]){
            
            //NSString* sender = [(NSDictionary*)snapshot.value objectForKey:@"Sender"];
                NSDictionary* usernames = [(NSDictionary*)snapshot.value objectForKey:@"Usernames"];
                UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc]init];
                NSString* user = [usernames objectForKey:@"Sender"];
            if ([notification.name isEqualToString:@"SentRequest"]){
                content.title = @"Challenged!!";
                content.body = [NSString stringWithFormat:@"%@ has sent you a challenge request",user];
            }else{
                content.body = [NSString stringWithFormat:@"A game with %@ has ended",user];
            }
                content.sound = [UNNotificationSound defaultSound];
                UNTimeIntervalNotificationTrigger* t = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:2 repeats:NO];
                UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:key content:content trigger:t];
                [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                    //NSLog(@"Notifies");
                }];
        }
    }];
}

-(void)createNotificationFor:(Challenge*)challenge t:(NSString*)title b:(NSString*)body
{
    UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc]init];
    content.title = title;
    if ([body isEqualToString:@""]){
        content.body = @"📷";
    }
    content.body = body;
    content.sound = [UNNotificationSound defaultSound];
    UNTimeIntervalNotificationTrigger* t = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:2 repeats:NO];
    UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:challenge.key content:content trigger:t];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        //NSLog(@"Notifies");
    }];
 
}

-(void)applicationReceivedRemoteMessage:(FIRMessagingRemoteMessage *)remoteMessage
{
    
}

-(void)appearances
{
    UINavigationBar *apperance = [UINavigationBar appearance];
    apperance.barTintColor = [[UIColor alloc]initWithRed:0.6112 green:0.4 blue:1 alpha:1];
    apperance.tintColor = [UIColor whiteColor];
    NSDictionary *attributes = @{
                                 //NSUnderlineStyleAttributeName: @1,
                                 NSForegroundColorAttributeName : [UIColor whiteColor],
                                 NSFontAttributeName: [UIFont fontWithName:@"SFMono-Bold" size:18]
                                 };
    
    [apperance setTitleTextAttributes:attributes];
    NSDictionary* barAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"SFMono-Bold" size:14]};
    [[UIBarButtonItem appearance]setTitleTextAttributes:barAttributes forState:(UIControlStateNormal)];
    [[UISegmentedControl appearance]setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"SFMono-Bold" size:14]} forState:(UIControlStateNormal)];
}






@end
