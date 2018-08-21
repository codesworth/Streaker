//
//  DatabaseService.m
//  CWStreaks
//
//  Created by Mensah Shadrach on 11/24/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

#import "DatabaseService.h"



@implementation DatabaseService

+(id)main

{
    static DatabaseService* main = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        main = [[DatabaseService alloc] init];
        
    });
    return main;
}

-(BOOL)check_fb_connection
{
    Reachability* connection = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [connection currentReachabilityStatus];
    //NSLog(@"Network status:: %ld", (long)status);
    if (status == ReachableViaWWAN || status == ReachableViaWiFi){
        return YES;
    }
    else{
        return NO;
    }
}

-(BOOL)arrayContains:(NSMutableArray<Gamer*>*)gamers and:(Gamer*)gamer
{
    BOOL value = NO;
    for (Gamer* g in gamers) {
        if ([g.uid isEqualToString:gamer.uid]){
            value = YES;
            break;
        }
    }
    return value;
}

-(FIRDatabaseReference*)mainReference{
    return [[FIRDatabase database] reference];
}

-(FIRDatabaseReference*)tokenRef
{
    return [[self mainReference]child:@"NotificationTokens"];
}

-(FIRDatabaseReference*)tokensRef
{
    return [[self mainReference]child:@"Tokens"];
}

-(FIRDatabaseReference*)userReference
{
    return [[self mainReference]child:FIR_BASE_CHILD_USERS];
}

-(FIRDatabaseReference*)scoreRef
{
 return [[self mainReference] child:DB_REF_SCORES];
}

-(FIRDatabaseReference*)challengeRef{
    return [self.mainReference child:FIR_BASE_CHILD_CHLLNG];
}

-(FIRDatabaseReference *)messageRef
{
    return [self.mainReference child:FIR_DB_CH_CHT_];
}

-(FIRStorageReference *)storageRef
{
    return [[FIRStorage storage] referenceForURL:@"gs://cwstreaks.appspot.com"];
}

-(FIRDatabaseReference *)notificationRef
{
    return [self.mainReference child:FIR_DB_NOTIF_];
}

-(FIRDatabaseReference*)reportRef
{
    return [self.mainReference child:@"ReportedUsers"];
}

-(FIRDatabaseReference*)chRequestTokenRef;
{
    return [self.tokenRef child:@"ChallengeRequests"];
    
}

-(FIRDatabaseReference*)chAcceptedTokenRef
{
    return [self.tokenRef child:@"ChallengeAccepted"];
}

-(FIRDatabaseReference*)finishesGamesTRef
{
    return [self.tokenRef child:@"FinishedGames"];
}

-(FIRDatabaseReference*)messageTRef
{
    return [self.tokenRef child:@"Messages"];
}

-(void)awakeFromFBDatabase:(NSString *)uid exec:(ExecuteAfterFinish)onComplete
{
    ScoreData* manager = [ScoreData mainData];
    [[self.scoreRef child:uid]observeSingleEventOfType:(FIRDataEventTypeValue) withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if ([snapshot exists]) {
            NSDictionary* scoreDictionary = snapshot.value;
            [manager initfb_Userdata:scoreDictionary];
            onComplete();
        }
    }];
}

-(void)updateUserLocation:(NSDictionary*)city e:(ExecuteAfterFinish)done
{
    NSString* uid = [[NSUserDefaults standardUserDefaults]stringForKey:USER_UID__];
    [[self.userReference child:uid]updateChildValues:city];
    done();
}

-(void)saveFIRGamer:(NSString *)uid userInfo:(NSDictionary *)info
{
    //[[[_userReference child:uid] child:FIR_BASE_CHILD_PROFILE] setValue:info];
    //[[[[[[FIRDatabase database]reference] child:FIR_BASE_CHILD_USERS] child:uid] child:FIR_BASE_CHILD_PROFILE] setValue:info];
    [[[self userReference] child:uid]updateChildValues:info];
}

-(void)deleteUserAccount:(NSString *)uid
{
    [[self.userReference child:uid] removeValue];
    [[self.scoreRef child:uid]removeValue];
}



-(void)fb_Request_setChallenge:(NSString*)senderUID receipient:(NSString*)uid andDate:(NSString*)date withChID:(NSString*)challengeID and:(NSDictionary*)usernames;
{
    NSString* challengeKey = [[[FIRDatabase database] reference] childByAutoId].key;
    NSDictionary* dict = @{challengeKey : senderUID};
    [[[[self.userReference child:senderUID] child:FIR_BASE_CHILD_CHLLNG] child:FIR_BASE_CHILD_CHLLNG_PND_RQ] updateChildValues:dict];
    [[[[self.userReference child:uid] child:FIR_BASE_CHILD_CHLLNG] child:FIR_BASE_CHILD_CHLLNG_RQST] updateChildValues:dict];
    NSMutableDictionary* challengeDict = [@{@"Sender":senderUID,@"Receipient":uid,@"Usernames":usernames,@"ChallengeID":challengeID,@"Date":date, @"Status":[NSNumber numberWithUnsignedInteger:0], @"Results":@{GAME1:@{}} } mutableCopy];
    [[self.challengeRef child:challengeKey] updateChildValues:challengeDict];
    [[self chRequestTokenRef]updateChildValues:@{uid:senderUID}];

}
/* For response, the challenge request is downloaded and initialized. User responds by accepting or rejecting the competition*/

-(void)fb_getPendingRequests:(Completed)didFinish
{
    NSString* uid = [[NSUserDefaults standardUserDefaults] stringForKey:USER_UID__];
    [[[[self.userReference child:uid] child:FIR_BASE_CHILD_CHLLNG] child:FIR_BASE_CHILD_CHLLNG_PND_RQ] observeSingleEventOfType:(FIRDataEventTypeValue) withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if([snapshot exists]){        NSDictionary* requests = snapshot.value;
            NSUInteger rCount = 0;
            NSMutableArray* array;
            for (NSString* key in requests) {
                rCount++;
                if (rCount == 0){[array removeAllObjects];}
                [[self.challengeRef child: key] observeSingleEventOfType:(FIRDataEventTypeValue) withBlock:^(FIRDataSnapshot * _Nonnull newsnapshot) {
                    if ([newsnapshot exists]) {
                        NSDictionary* challengeDict = newsnapshot.value;
                        NSString* date = [challengeDict objectForKey:@"Date"];
                        NSDictionary* usernames = [challengeDict objectForKey:@"Usernames"];
                        NSNumber* status = [challengeDict objectForKey:@"Status"];
                        NSString* challengeID = [challengeDict objectForKey:@"ChallengeID"];
                        NSString* recipient = [challengeDict objectForKey:@"Receipient"];
                        __block Challenge* challenge = [(Challenge*)[Challenge alloc] initWith:key aGamerUID:[requests objectForKey:key] to:recipient and:usernames with:challengeID and:nil onDate:date withStatus:status];
                        [array addObject:challenge];
                        //NSLog(@"what a challengeeeee%@", challenge);
                        
                        if (rCount == snapshot.childrenCount){
                            dispatch_async(dispatch_get_main_queue(), ^{
                                didFinish(array,nil);
                            });
                            
                        }
                    }
                }];
            }
        }
    }];

}
-(void)fb_getCHRequests:(Completed)didFinish
{
    
    NSString* uid = [[NSUserDefaults standardUserDefaults] stringForKey:USER_UID__];
    [[[[self.userReference child:uid] child:FIR_BASE_CHILD_CHLLNG] child:FIR_BASE_CHILD_CHLLNG_RQST] observeSingleEventOfType:(FIRDataEventTypeValue) withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if ([snapshot exists]){        NSDictionary* requests = snapshot.value;
            NSUInteger rCounts = 0;
            NSMutableArray* array = [NSMutableArray new];
            for (NSString* key in requests) {
                if(rCounts == 0){}
                rCounts++;
                [[self.challengeRef child: key] observeSingleEventOfType:(FIRDataEventTypeValue) withBlock:^(FIRDataSnapshot * _Nonnull newsnapshot) {
                    NSDictionary* challengeDict = newsnapshot.value;
                    NSString* date = [challengeDict objectForKey:@"Date"];
                    NSDictionary* usernames = [challengeDict objectForKey:@"Usernames"];
                    NSNumber* status = [challengeDict objectForKey:@"Status"];
                    NSString* challengeID = [challengeDict objectForKey:@"ChallengeID"];
                    NSString* recipient = [challengeDict objectForKey:@"Receipient"];
                    __block Challenge* challenge = [(Challenge*)[Challenge alloc] initWith:key aGamerUID:[requests objectForKey:key] to:recipient and:usernames with:challengeID and:nil onDate:date withStatus:status];
                    [array addObject:challenge];
                    if (rCounts == snapshot.childrenCount){
                       dispatch_async(dispatch_get_main_queue(), ^{
                           didFinish(array,nil);
                       });
                    }
                    
                }];
            }
        }else{didFinish(nil,[[NSError alloc]initWithDomain:@"FIR_NO_FETCH_DOMAIN" code:0 userInfo:@{@"Error":@"No Items available"}]);}
    }];
}
//Reject the competition
-(void)fb_RejectCH_Request:(Challenge*)challenge
{
    NSString* uid = [[NSUserDefaults standardUserDefaults] stringForKey:USER_UID__];
    [[[[[self.userReference child:uid] child:FIR_BASE_CHILD_CHLLNG] child:FIR_BASE_CHILD_CHLLNG_RQST] child:challenge.key] removeValueWithCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        [[[[self.userReference child:challenge.sender] child:FIR_BASE_CHILD_CHLLNG_PND_RQ] child:challenge.key] removeValue];
        [[self.challengeRef child:challenge.key]removeValue];
    }];
}
//Accept Action
-(void)fb_AcceptCH_Request:(Challenge*)challenge didFinish:(ExecuteAfterFinish)oncomplete
{
    NSString* uid = [[NSUserDefaults standardUserDefaults] stringForKey:USER_UID__];
    [[[[[self.userReference child:uid] child:FIR_BASE_CHILD_CHLLNG] child:FIR_BASE_CHILD_CHLLNG_RQST] child:challenge.key]removeValueWithCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        if (error == nil){
            [[[[[self.userReference child:challenge.sender] child:FIR_BASE_CHILD_CHLLNG] child:FIR_BASE_CHILD_CHLLNG_PND_RQ] child:challenge.key] removeValue];
            NSDictionary* active = @{challenge.key: challenge.sender};
            [[[[self.userReference child:uid]child:FIR_BASE_CHILD_CHLLNG] child:FIR_BASE_CHILD_ACTV_CHLLNG_] updateChildValues:active];
            [[[[self.userReference child:challenge.sender]child:FIR_BASE_CHILD_CHLLNG] child:FIR_BASE_CHILD_ACTV_CHLLNG_] updateChildValues:active];
            [[self.challengeRef child:challenge.key] updateChildValues:@{@"Status": [NSNumber numberWithInteger:1]}];
            [[self chAcceptedTokenRef]updateChildValues:@{challenge.sender:uid}];
            oncomplete();
        }
    }];
}

//Fetching Active
/* For all active, a sort by status to seperate into unfinished and finished*/

-(void)fb_fetch_ActiveCH:(Completed)onComplete
{
    NSString* uid = [Constants uid];

    [[[[self.userReference child:uid] child:FIR_BASE_CHILD_CHLLNG] child:FIR_BASE_CHILD_ACTV_CHLLNG_] observeSingleEventOfType:(FIRDataEventTypeValue) withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary* requests = snapshot.value;
        if ([snapshot exists]){
            NSMutableArray* holder = [NSMutableArray new];
            __block NSUInteger rCount = 0;
            for (NSString* key in requests){
                if (rCount == 0){
                    //[activeArray removeAllObjects];
                    //[array removeAllObjects];
                }
                
                [[self.challengeRef child: key] observeSingleEventOfType:(FIRDataEventTypeValue) withBlock:^(FIRDataSnapshot * _Nonnull newsnapshot) {
                    if ([newsnapshot exists]) {
                        rCount++;
                        NSDictionary* challengeDict = newsnapshot.value;
                        NSString* date = [challengeDict objectForKey:@"Date"];
                        NSDictionary* usernames = [challengeDict objectForKey:@"Usernames"];
                        NSString* challengeID = [challengeDict objectForKey:@"ChallengeID"];
                        __block Results* results = [(Results*)[Results alloc] initWith:[challengeDict objectForKey:FIR_BASE_CHILD_RESULTS]];
                        NSString* recipient = [challengeDict objectForKey:@"Receipient"];
                        NSNumber* status = [challengeDict objectForKey:@"Status"];
                        __block Challenge* challenge = [(Challenge*)[Challenge alloc] initWith:key aGamerUID:[requests objectForKey:key] to:recipient and:usernames with:challengeID and:results onDate:date withStatus:status];
                        if(challenge.status > [NSNumber numberWithInteger:1]){
                            //[array addObject:challenge];
                            NSString* p = [NSString stringWithFormat:@"%@.plist",challenge.key];
                            NSString* dir = [[Constants create_return_Directory:FILE_DIR_COMPLETED] stringByAppendingPathComponent:p];
                            [NSKeyedArchiver archiveRootObject:challenge toFile:dir];
                            [[[[[self.userReference child:uid]child:FIR_BASE_CHILD_CHLLNG]child:FIR_BASE_CHILD_ACTV_CHLLNG_]child:challenge.key]removeValue];
                            [[self.challengeRef child:challenge.key]removeValue];
                            [self removeChallengeNotif:challenge.key];
                        }else{
                            [holder addObject:challenge];
                            
                        }
                        if(rCount == snapshot.childrenCount){
                            dispatch_async(dispatch_get_main_queue(), ^{
                                onComplete(holder, nil);
                            });
                        }
                    }

                }];
                
            }
            //NSLog(@"This is run last agter ");
        }
    }];
}



-(void)availableActiveCH:(NSMutableArray*)activeArray didFinish:(ExecuteAfterFinish)onComplete
{
    
    [[[[self.userReference child:[Constants uid]]child:FIR_BASE_CHILD_CHLLNG]child:FIR_BASE_CHILD_ACTV_CHLLNG_]observeSingleEventOfType:(FIRDataEventTypeValue) withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        if ([snapshot exists]){
       NSDictionary* snp = (NSDictionary*)snapshot.value;
       NSArray* keys = snp.allKeys;
        NSUInteger ccount = 0;
       for (NSString* aKey in keys){
           ccount++;
           [activeArray removeAllObjects];
          [[self.challengeRef child:aKey]observeSingleEventOfType:(FIRDataEventTypeValue) withBlock:^(FIRDataSnapshot * _Nonnull challengesnapshot) {
              NSDictionary* challengeDict = challengesnapshot.value;
              NSUInteger status = [(NSNumber*)[challengeDict objectForKey:@"Status"]unsignedIntegerValue];
              if (status == 1){
                  Results* results = [(Results*)[Results alloc] initWith:[challengeDict objectForKey:FIR_BASE_CHILD_RESULTS]];
                  NSMutableDictionary* last = results.allResults.lastObject;
                  NSString* uid = [Constants uid];
                  //NSLog(@"the last objecccctctctctc, %@",last);
                  if (results.allResults.count == 0 || last.count == 3 || [last objectForKey:uid] == nil){
                      Challenge* c = [[Challenge alloc]initWith:aKey aGamerUID:[challengeDict objectForKey:@"Sender"] to:[challengeDict objectForKey:@"Receipient"] and:[challengeDict objectForKey:@"Usernames"] with:[challengeDict objectForKey:@"ChallengeID"] and:results onDate:[challengeDict objectForKey:@"Date"] withStatus:[NSNumber numberWithUnsignedInteger:status]];
                      [activeArray addObject:c];

                  }
                  if (ccount == keys.count){
                      onComplete();
                      
                  }
              }
              
          }];
       }
    }
    }];
   
}

-(void)fb_updateChallenge:(Challenge*)challenge results:(NSDictionary*)resultDict
{
    //NSString* uid = [[NSUserDefaults standardUserDefaults] stringForKey:USER_UID__];
    [[[self.challengeRef child:challenge.key] child:FIR_BASE_CHILD_RESULTS] updateChildValues:resultDict];
}

-(void)fb_initScoreData:(NSString *)userUID exec:(ExecuteAfterFinish)onComplete
{
    NSMutableDictionary* playerData = [[NSMutableDictionary alloc] init];
    [playerData setObject:[NSNumber numberWithUnsignedInteger:0] forKey:FIR_DB_REF_ALLTIME_GAMESCORE];
    [playerData setObject:[NSNumber numberWithUnsignedInteger:0] forKey:FIR_DB_REF_ALLTIME_GAMECOUNT];
    [playerData setObject:[NSNumber numberWithUnsignedInteger:0] forKey:FIR_DB_REF_SC_REGL_GAMEHIGHSCORE];
    [playerData setObject:[NSNumber numberWithUnsignedInteger:0] forKey:FIR_DB_REF_SC_REGL_HIGHSTREAK];
    [playerData setObject:[NSNumber numberWithUnsignedInteger:0] forKey:FIR_DB_REF_CLSSC_GAMEHIGHSCORE];
    [playerData setObject:[NSNumber numberWithUnsignedInteger:0] forKey:FIR_DB_REF_HIGHSTREAK];
    [playerData setObject:[NSNumber numberWithUnsignedInteger:0] forKey:CHLL_PNTS_GMWN_PNTS];
    [playerData setObject:[NSNumber numberWithUnsignedInteger:0] forKey:CHLL_PNTS_WN_RCRD];
    [playerData setObject:[NSNumber numberWithUnsignedInteger:0] forKey:CHLL_PNTS_LSE_RCRD];
    [playerData setObject:[NSNumber numberWithUnsignedInteger:0] forKey:CHLL_PNTS_SRSSWP_PTS];
    [[[self scoreRef] child:userUID] updateChildValues:playerData];
    onComplete();
}

#pragma mark Saving Support

-(void)fb_SaveRegGameScore:(ScoreData*)manager execute:(ExecuteAfterFinish _Nullable)onCompletion;
{
    NSString* uid = [[NSUserDefaults standardUserDefaults] stringForKey:USER_UID__];
    [[[self scoreRef] child:uid] updateChildValues:@{FIR_DB_REF_SC_REGL_GAMEHIGHSCORE: [NSNumber numberWithUnsignedInteger:manager.regularhighscore]}];
    onCompletion();
}



-(void)fb_saveClassicGameScore:(ScoreData*)manager execute:(ExecuteAfterFinish _Nullable)onCompletion;
{
    NSString* uid = [[NSUserDefaults standardUserDefaults] stringForKey:USER_UID__];
    [[[self scoreRef] child:uid] updateChildValues:@{FIR_DB_REF_CLSSC_GAMEHIGHSCORE: [NSNumber numberWithUnsignedInteger:manager.classicHighscore]}];
    onCompletion();
    
}

-(void)fb_saveLoosingStreak:(ScoreData*)manager execute:(ExecuteAfterFinish _Nullable)onCompletion;
{
    NSString* uid = [[NSUserDefaults standardUserDefaults] stringForKey:USER_UID__];
    [[[self scoreRef] child:uid] updateChildValues:@{FIR_DB_LSSN_STRK: [NSNumber numberWithUnsignedInteger:manager.loosingStreak]}];
    onCompletion();
    
}


-(void)fb_saveHighStreak:(ScoreData*)manager execute:(ExecuteAfterFinish _Nullable)onCompletion;
{
    NSString* uid = [[NSUserDefaults standardUserDefaults] stringForKey:USER_UID__];
    [[[self scoreRef] child:uid] updateChildValues:@{FIR_DB_REF_HIGHSTREAK: [NSNumber numberWithUnsignedInteger:manager.highstreak]}];
    onCompletion();
}



-(void)fb_saveAllTimeStats:(ScoreData*)manager execute:(ExecuteAfterFinish _Nullable)onCompletion
{
    NSString* uid = [[NSUserDefaults standardUserDefaults] stringForKey:USER_UID__];
    [[[self scoreRef] child:uid] updateChildValues:@{FIR_DB_REF_ALLTIME_GAMESCORE: [NSNumber numberWithUnsignedInteger:manager.alltotalgameScore],FIR_DB_RGL_GM_COUNT:[NSNumber numberWithUnsignedInteger:manager.regularGameCount], ALL_REGL_GAME_SCORE:[NSNumber numberWithUnsignedInteger:manager.regualarGamescore]}];
    [[[self scoreRef] child:uid] updateChildValues:@{FIR_DB_REF_ALLTIME_GAMECOUNT:[NSNumber numberWithUnsignedInteger:manager.lifetimegameCount]}];
    [self fb_saveLoosingStreak:manager execute:^{}];
    onCompletion();
}

-(void)fb_saveUnsavedGamedata:(ExecuteAfterFinish _Nullable)onCompletion
{
    ScoreData* manager = [ScoreData mainData];
    [manager initGamedata];
    [self fb_saveAllTimeStats:manager execute:^{}];
    [self fb_saveClassicGameScore:manager execute:^{}];
    [self fb_saveHighStreak:manager execute:^{}];
    [self fb_SaveRegGameScore:manager execute:^{}];
    [self fb_saveLoosingStreak:manager execute:^{}];
    onCompletion();
}

/*-(void)fb_fetchSelf:(NSMutableArray*)selff exec:(ExecuteAfterFinish)finished
{
    NSString* uid = [[NSUserDefaults standardUserDefaults] stringForKey:USER_UID__];
    NSLog(@"uidddddd %@", uid);
    [[[_userReference child:@"JtZjO0gkaAORjUqhbMiwBA9GTAL2"] child:FIR_BASE_CHILD_PROFILE] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSLog(@"Show mwwww::: %@", snapshot.value);
        NSMutableDictionary* profile = snapshot.value;
        NSString* username = [profile objectForKey:FIR_BASE_CHILD_USERNAME];
        NSString* profileUrl = [profile objectForKey:FIR_BASE_CHILD_PROFILE_IMG_URL];
        [[self.scoreRef child:uid] observeSingleEventOfType:(FIRDataEventTypeValue) withBlock:^(FIRDataSnapshot * _Nonnull newsnapshot) {
            NSDictionary* scoreData = newsnapshot.value;
            NSLog(@"Datsssssssaaaaaa %@", scoreData);
            Gamer* gamer = [[Gamer alloc] initWithname:username uid:uid withProfile:profileUrl and:[scoreData mutableCopy] locality:];
            [selff addObject:gamer];
            finished();
        }];
    }];
}*/


-(void)fb_fetchTop_ScoreData:(NSMutableArray<Gamer*>*)gamers child:(NSString*)child endValue:(NSUInteger)value exec:(ExecuteAfterFinish)onComplete
{
    [[[[self.scoreRef queryOrderedByChild:child]queryEndingAtValue:[NSNumber numberWithUnsignedInteger:value]]queryLimitedToLast:50]observeSingleEventOfType:(FIRDataEventTypeValue) withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if ([snapshot exists]){
            __block NSUInteger cc = 0;
            //NSLog(@"What a dedly snpshot %@",snapshot.value);
            NSDictionary* regDict = snapshot.value;
            for (NSString* key in regDict){
                [[[self userReference] child:key] observeSingleEventOfType:(FIRDataEventTypeValue) withBlock:^(FIRDataSnapshot * _Nonnull resnapshot) {
                    cc++;
                    if ([resnapshot exists]) {
                        NSMutableDictionary* userdict = resnapshot.value;
                        NSDictionary* location = [userdict objectForKey:FIR_DB_LOCALITY_];
                        NSString* username = [userdict objectForKey:FIR_BASE_CHILD_USERNAME];
                        NSString* profileurl = [userdict objectForKey:FIR_BASE_CHILD_PROFILE_IMG_URL];
                        Gamer* gamer = [[Gamer alloc]initWithname:username uid:key withAvatar:profileurl and:[regDict objectForKey:key] locality:location];;
                        if (![self arrayContains:gamers and:gamer]) {
                            [gamers addObject:gamer];
                        }
                        
                        //NSLog(@"the gamrs , %@", gamer.scoreData);
                        if(cc == snapshot.childrenCount){
                            dispatch_async(dispatch_get_main_queue(), ^{
                                onComplete();
                            });
                        }
                    }
                }];
            }
        }
    }];
}

#pragma mark Fetching
-(void)fb_fetchScoreData:(NSMutableArray*)gamers exec:(ExecuteAfterFinish)onComplete
{

    [[self scoreRef] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSMutableDictionary* regDict = snapshot.value;
        if (regDict){
            NSArray* keys = [regDict allKeys];
            NSUInteger cc = 0;
            for (NSString* key in keys) {
                cc++;
                [[[self userReference] child:key] observeSingleEventOfType:(FIRDataEventTypeValue) withBlock:^(FIRDataSnapshot * _Nonnull resnapshot) {
                    if ([resnapshot exists]) {
                        NSMutableDictionary* userdict = resnapshot.value;
                        NSDictionary* location = [userdict objectForKey:FIR_DB_LOCALITY_];
                        NSDictionary* profileDict = [userdict objectForKey:FIR_BASE_CHILD_PROFILE];
                        NSString* username = [profileDict objectForKey:FIR_BASE_CHILD_USERNAME];
                        NSString* profileurl = [profileDict objectForKey:FIR_BASE_CHILD_PROFILE_IMG_URL];
                        Gamer* gamer = [[Gamer alloc]initWithname:username uid:key withAvatar:profileurl and:[regDict objectForKey:key] locality:location];;
                        [gamers addObject:gamer];
                        //NSLog(@"the gamrs , %@", gamer.scoreData);
                        if(cc == snapshot.childrenCount){
                            dispatch_async(dispatch_get_main_queue(), ^{
                                onComplete();
                            });
                        }
                    }
                }];
            }
        }
    }];
}

-(void)fb_fetchListed:(NSMutableArray*)gamers exec:(ExecuteAfterFinish)onComplete
{
    NSUInteger cc = 0;
    if ([AppDelegate mainDelegate].myList.count != 0){
        for (NSString* key  in [AppDelegate mainDelegate].myList) {
                cc++;
            [[[self userReference] child:key] observeSingleEventOfType:(FIRDataEventTypeValue) withBlock:^(FIRDataSnapshot * _Nonnull resnapshot) {
                if ([resnapshot exists]) {
                    NSMutableDictionary* userdict = resnapshot.value;
                    NSDictionary* location = [userdict objectForKey:FIR_DB_LOCALITY_];
                    NSDictionary* profileDict = [userdict objectForKey:FIR_BASE_CHILD_PROFILE];
                    NSString* username = [profileDict objectForKey:FIR_BASE_CHILD_USERNAME];
                    NSString* profileurl = [profileDict objectForKey:FIR_BASE_CHILD_PROFILE_IMG_URL];
                    Gamer* gamer = [[Gamer alloc]initWithname:username uid:key withAvatar:profileurl and:nil locality:location];;
                                [gamers addObject:gamer];
                                //NSLog(@"the gamrs , %@", gamer.scoreData);
                    if(cc == [AppDelegate mainDelegate].myList.count){
                            dispatch_async(dispatch_get_main_queue(), ^{
                                        onComplete();
                        });
                    }
                }
            }];

        }
    }
}

-(void)fb_Add_User:(NSString*)uid
{
    NSDictionary* block = @{uid:@"A"};
    [[[self.userReference child:[Constants uid]]child:FIR_DB_LISTED]updateChildValues:block];
}

-(void)fb_fetch_Listed
{
    [[[self.userReference child:[Constants uid]]child:FIR_DB_LISTED]observeSingleEventOfType:(FIRDataEventTypeValue) withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if([snapshot exists]){
            NSDictionary* listDict = snapshot.value;
            NSMutableArray* listed = [[listDict allKeys] mutableCopy];
            [AppDelegate mainDelegate].myList = listed;
            //NSLog(@"My Listed is %@",[AppDelegate mainDelegate].myList);
        }
    }];
}

-(void)fb_fetch_ScoreData:(Gamer*)user exec:(ExecuteAfterFinish)onComplete
{
    [[self.scoreRef child:user.uid]observeSingleEventOfType:(FIRDataEventTypeValue) withBlock:^(FIRDataSnapshot * _Nonnull scoresnapshot) {
        NSMutableDictionary* scoreData = [[NSMutableDictionary alloc]init];
        if ([scoresnapshot exists]) {
            scoreData = (NSMutableDictionary*)scoresnapshot.value;
            user.scoreData = scoreData;
            onComplete();
        }
    }];
}


-(void)fb_fetchUserDetails:(NSString*)uid intoArray:(NSMutableArray*)array exec:(ExecuteAfterFinish)onComplete
{
    [array removeAllObjects];
    [[self.userReference child:uid] observeSingleEventOfType:(FIRDataEventTypeValue) withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if ([snapshot exists]) {
            [array removeAllObjects];
            
            NSDictionary* userDict = snapshot.value;
            NSDictionary* location = [userDict objectForKey:FIR_DB_LOCALITY_];
            NSString* username = [userDict objectForKey:FIR_BASE_CHILD_USERNAME];
            NSString* avatar = [userDict objectForKey:FIR_BASE_CHILD_PROFILE_IMG_URL];
            if (uid == [Constants uid]){[[NSUserDefaults standardUserDefaults]setObject:@{FIR_BASE_CHILD_USERNAME:username, FIR_BASE_CHILD_PROFILE_IMG_URL:avatar} forKey:USER_INFO];}
            [[self.scoreRef child:uid]observeSingleEventOfType:(FIRDataEventTypeValue) withBlock:^(FIRDataSnapshot * _Nonnull scoresnapshot) {
                NSMutableDictionary* scoreData = [[NSMutableDictionary alloc]init];
                if ([scoresnapshot exists]) {
                    scoreData = (NSMutableDictionary*)scoresnapshot.value;
                    Gamer* gamer = [(Gamer*)[Gamer alloc]initWithname:username uid:uid withAvatar:avatar and:scoreData locality:location];
                    [array addObject:gamer];
                     onComplete();
                }
            }];

        }
    }];
}

-(void)fb_fetchScorelessUserDetails:(NSString*)uid intoArray:(NSMutableArray*)array exec:(ExecuteAfterFinish)onComplete
{
    [array removeAllObjects];
    [[self.userReference child:uid] observeSingleEventOfType:(FIRDataEventTypeValue) withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if ([snapshot exists]) {
            [array removeAllObjects];
            
            NSDictionary* userDict = snapshot.value;
            NSDictionary* location = [userDict objectForKey:FIR_DB_LOCALITY_];
            NSDictionary* profile = [userDict objectForKey:FIR_BASE_CHILD_PROFILE];
            NSString* username = [profile objectForKey:FIR_BASE_CHILD_USERNAME];
            NSString* avatar = [profile objectForKey:FIR_BASE_CHILD_PROFILE_IMG_URL];
            Gamer* gamer = [(Gamer*)[Gamer alloc]initWithname:username uid:uid withAvatar:avatar and:nil locality:location];
            [array addObject:gamer];
            onComplete();
        }
    }];
}

-(void)fb_getCompleted:(Challenge*)challenge winner:(NSString*)winner
{
   [[self.challengeRef child:challenge.key]observeEventType:(FIRDataEventTypeValue) withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
       if ([snapshot exists]) {
           NSDictionary* challengeDict = snapshot.value;
           NSString* date = [challengeDict objectForKey:@"Date"];
           NSDictionary* usernames = [challengeDict objectForKey:@"Usernames"];
           NSString* challengeID = [challengeDict objectForKey:@"ChallengeID"];
           __block Results* results = [(Results*)[Results alloc] initWith:[challengeDict objectForKey:FIR_BASE_CHILD_RESULTS]];
           NSString* recipient = [challengeDict objectForKey:@"Receipient"];
           NSString* sender = [challengeDict objectForKey:@"Sender"];
           NSNumber* status = [challengeDict objectForKey:@"Status"];
           __block Challenge* nchallenge = [(Challenge*)[Challenge alloc] initWith:challenge.key aGamerUID:sender to:recipient and:usernames with:challengeID and:results onDate:date withStatus:status];
           NSDictionary* winnerD = (NSDictionary*)@{@"Winner":winner, @"Status": @2};
           [[self.challengeRef child:challenge.key]updateChildValues:winnerD];
           [[[[[self.userReference child:[Constants uid]]child:FIR_BASE_CHILD_CHLLNG]child:FIR_BASE_CHILD_ACTV_CHLLNG_]child:challenge.key]removeValue];
           NSString* path = [Constants create_return_Directory:@"Completed"];
           NSString* comp = [NSString stringWithFormat:@"%@.plist",challenge.key];
           NSString* dir = [path stringByAppendingPathComponent:comp];
           [NSKeyedArchiver archiveRootObject:nchallenge toFile:dir];
       }
   }];
}


-(void)fb_observeGameWinner:(Challenge*)challenge
{
    //NSString* uid = [Constants uid];
    [[[[self.challengeRef child:challenge.key]child:FIR_BASE_CHILD_RESULTS] child:@"WINS"] observeEventType:(FIRDataEventTypeValue) withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if ([snapshot exists]){
            NSUInteger sendrW = 0;
            NSUInteger rcpntW = 0;
            NSDictionary* winDict = snapshot.value;
            for (NSString* key in winDict) {
                __block NSString* aWin = (NSString*)[winDict objectForKey:key];
                if ([aWin isEqualToString:challenge.sender]){
                    sendrW++;
                }else if ([aWin isEqualToString:challenge.receipient] ){rcpntW++;}
            }
            if (sendrW == 4 || rcpntW == 4){
                __block NSString* winner;
                if(sendrW  == 4){winner = challenge.sender;}else{winner = challenge.receipient;}
                
                [self fb_getCompleted:challenge winner:winner];
                    [[self.scoreRef child:challenge.sender] observeSingleEventOfType:(FIRDataEventTypeValue) withBlock:^(FIRDataSnapshot * _Nonnull sendersnapshot) {
                        if ([sendersnapshot exists]) {
                            //NSMutableDictionary* scoredata = snapshot.value;
                            NSMutableDictionary* challPoints = (NSMutableDictionary*)sendersnapshot.value;
                            //NSLog(@"The ")
                            NSNumber* n =(NSNumber*)[challPoints objectForKey:CHLL_PNTS_GMWN_PNTS];
                            NSUInteger gwinP = [ n unsignedIntegerValue];
                            NSUInteger srWR = [(NSNumber*)[challPoints objectForKey:CHLL_PNTS_WN_RCRD]unsignedIntegerValue];
                            NSUInteger serSweepP = [(NSNumber*)[challPoints objectForKey:CHLL_PNTS_SRSSWP_PTS]unsignedIntegerValue];
                            NSUInteger srLsR = [(NSNumber*)[challPoints objectForKey:CHLL_PNTS_LSE_RCRD]unsignedIntegerValue];
                            gwinP = gwinP + (sendrW * 2);
                            if (sendrW == 4) {
                                gwinP = gwinP + 5;
                                srWR = srWR + 1;
                                if (rcpntW == 0) {
                                    serSweepP++;
                                    gwinP = gwinP + 5;
                                }
                            }else{
                                srLsR++;
                            }
                            NSDictionary* update = @{CHLL_PNTS_GMWN_PNTS:[NSNumber numberWithUnsignedInteger:gwinP],CHLL_PNTS_SRSSWP_PTS:[NSNumber numberWithUnsignedInteger:serSweepP],CHLL_PNTS_WN_RCRD:[NSNumber numberWithUnsignedInteger:srWR],CHLL_PNTS_LSE_RCRD:[NSNumber numberWithUnsignedInteger:srLsR]};
                            /*if ([uid isEqualToString:challenge.sender]) {
                                [[NSUserDefaults standardUserDefaults] setObject:update forKey:USER_CHALLENGE_SCORE_INFO];
                            }*/
                            [[self.scoreRef child:challenge.sender]updateChildValues:update];
                            
                        }
                    }];

                    [[self.scoreRef child:challenge.receipient] observeSingleEventOfType:(FIRDataEventTypeValue) withBlock:^(FIRDataSnapshot * _Nonnull sendersnapshot) {
                        if ([sendersnapshot exists]) {
                            //NSMutableDictionary* scoredata = snapshot.value;
                            NSMutableDictionary* challPoints = (NSMutableDictionary*)sendersnapshot.value;
                            NSUInteger gwinP = [(NSNumber*)[challPoints objectForKey:CHLL_PNTS_GMWN_PNTS]unsignedIntegerValue];
                            NSUInteger srWR = [(NSNumber*)[challPoints objectForKey:CHLL_PNTS_WN_RCRD]unsignedIntegerValue];
                            NSUInteger serSweepP = [(NSNumber*)[challPoints objectForKey:CHLL_PNTS_SRSSWP_PTS]unsignedIntegerValue];
                            NSUInteger srLsR = [(NSNumber*)[challPoints objectForKey:CHLL_PNTS_LSE_RCRD]unsignedIntegerValue];
                            gwinP = gwinP + (rcpntW * 2);
                            if (rcpntW == 4) {
                                gwinP = gwinP + 5;
                                srWR = srWR + 1;
                                if (sendrW == 0) {
                                    serSweepP++;
                                    gwinP = gwinP + 5;
                                }
                            }else{

                                srLsR++;
                            }
                            NSDictionary* update = @{CHLL_PNTS_GMWN_PNTS:[NSNumber numberWithUnsignedInteger:gwinP], CHLL_PNTS_SRSSWP_PTS:[NSNumber numberWithUnsignedInteger:serSweepP],CHLL_PNTS_WN_RCRD:[NSNumber numberWithUnsignedInteger:srWR],CHLL_PNTS_LSE_RCRD:[NSNumber numberWithUnsignedInteger:srLsR]};
                            [[self.scoreRef child:challenge.receipient]updateChildValues:update];
                        }
                    }];
                }


        }
    }];
}




-(NSString*)opponent:(Challenge*)challenge{
    NSString* uid = [[NSUserDefaults standardUserDefaults]stringForKey:USER_UID__];
    if ([uid isEqualToString:challenge.sender]){
        return challenge.receipient;
    }else{
        return challenge.sender;
    }
    

}
-(void)fb_InstanceOfOT:(NSUInteger)score fromChallenge:(Challenge*)challenge withNo:(NSString*)gameNumber
{

    [[[[self.challengeRef child:challenge.key]child:FIR_BASE_CHILD_RESULTS]child:gameNumber]observeSingleEventOfType:(FIRDataEventTypeValue) withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if([snapshot exists]){
            NSDictionary* dict = snapshot.value;
            if ([dict objectForKey:[self opponent:challenge]] != nil){
                NSUInteger opponentscr = [(NSNumber*)[dict objectForKey:[self opponent:challenge]]unsignedIntegerValue];
                if (score == opponentscr){
                    NSDictionary* dictnew = @{challenge.sender: [dict objectForKey:challenge.sender], challenge.receipient: [dict objectForKey:challenge.receipient]};
                    [[[[[self.challengeRef child:challenge.key]child:FIR_BASE_CHILD_RESULTS]child:gameNumber]child:@"OTScores"]updateChildValues:dictnew];
                    [[[[[self.challengeRef child:challenge.key]child:FIR_BASE_CHILD_RESULTS]child:gameNumber]child:challenge.sender]removeValue];
                    [[[[[self.challengeRef child:challenge.key]child:FIR_BASE_CHILD_RESULTS]child:gameNumber]child:challenge.receipient]removeValue];
                    NSNumber* ot = [dict objectForKey:@"OT"];
                    if (ot != nil){
                        NSNumber* newn = [NSNumber numberWithUnsignedInteger:[ot unsignedIntegerValue] + 1];
                        [[[[self.challengeRef child:challenge.key]child:FIR_BASE_CHILD_RESULTS]child:gameNumber]updateChildValues:@{@"OT":newn}];
                    }else{
                        [[[[self.challengeRef child:challenge.key]child:FIR_BASE_CHILD_RESULTS]child:gameNumber]updateChildValues:@{@"OT":[NSNumber numberWithUnsignedInteger:1]}];
                    }
                }
            }
        }
    }];
}

-(void)fb_updateScore:(NSDictionary *)dictionary fromChallenge:(Challenge *)challenge withNo:(NSString*)gameNumber didFinish:(nullable ExecuteAfterFinish)oncomplete
{

    
    [[[[self.challengeRef child:challenge.key] child:FIR_BASE_CHILD_RESULTS] child:gameNumber] updateChildValues:dictionary];
    NSUInteger score = [(NSNumber*)[dictionary objectForKey:[self uid]]unsignedIntegerValue];
    
    [self fb_InstanceOfOT:score fromChallenge:challenge withNo:gameNumber];
    [[[[self.challengeRef child:challenge.key] child:FIR_BASE_CHILD_RESULTS] child:gameNumber]observeSingleEventOfType:(FIRDataEventTypeValue) withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if([snapshot exists]){
            NSDictionary* wins = snapshot.value;
            NSNumber* senderscore = (NSNumber*) [wins objectForKey:challenge.sender];
            NSNumber* receipientscore = (NSNumber*)[wins objectForKey:challenge.receipient];
            //NSNumber* ot = [wins objectForKey:@"OT"];
            
            if (senderscore != nil && receipientscore != nil){
                if ([senderscore unsignedIntegerValue] != [receipientscore unsignedIntegerValue]){
                    __block NSUInteger sndr = [senderscore unsignedIntegerValue];
                    __block NSUInteger rcpnt = [receipientscore unsignedIntegerValue];
                    if (sndr > rcpnt){
                        __block NSDictionary* sndrD = (NSDictionary*) @{gameNumber:challenge.sender};
                        [[[[self.challengeRef child:challenge.key] child:FIR_BASE_CHILD_RESULTS]child:@"WINS"] updateChildValues:sndrD];
                        [[[[[self.challengeRef child:challenge.key] child:FIR_BASE_CHILD_RESULTS]child:gameNumber]child:@"OT"]removeValue];
                        [self fb_observeGameWinner:challenge];
                    }else if (sndr < rcpnt){
                        __block NSDictionary* rcpntD = (NSDictionary*)@{gameNumber: challenge.receipient};
                        [[[[self.challengeRef child:challenge.key] child:FIR_BASE_CHILD_RESULTS] child:@"WINS"]updateChildValues:rcpntD];
                        [[[[[self.challengeRef child:challenge.key] child:FIR_BASE_CHILD_RESULTS]child:gameNumber]child:@"OT"]removeValue];
                        [self fb_observeGameWinner:challenge];
                    }
                }else {
                    /*ChallengeEngine* engine = [ChallengeEngine mainEngine];
                    [engine initChallengeOTDict];
                    if (engine.challengeEngineDictionary != nil && [engine.challengeEngineDictionary objectForKey:challenge.key] == nil){
                        NSMutableDictionary* dict = [engine.challengeEngineDictionary mutableCopy];
                        [dict setObject:[NSNumber numberWithUnsignedInteger:1] forKey:challenge.key];
                        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:CHLLNG_OVERTIME__];
                    }else if (engine.challengeEngineDictionary != nil && [engine.challengeEngineDictionary objectForKey:challenge.key] != nil){
                        NSNumber* otNo = [engine.challengeEngineDictionary objectForKey:challenge.key];
                        NSMutableDictionary* dict = [engine.challengeEngineDictionary mutableCopy];
                        NSUInteger newOT = [otNo unsignedIntegerValue] + 1;
                        [dict setObject:[NSNumber numberWithUnsignedInteger:newOT] forKey:challenge.key];
                        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:CHLLNG_OVERTIME__];
                    }*/
                }
            }
        }
    }];
    
}

-(void)fb_writeOfOT:(nonnull Challenge*)challenge andNo:(NSString* _Nonnull)gameNo
{
    [[[[self.challengeRef child:challenge.key]child:FIR_BASE_CHILD_RESULTS]child:gameNo]updateChildValues:@{[self uid]: @"OTPlayed" }];
}

-(NSString*)uid
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:USER_UID__];
}
-(NSString*)returnGameNo:(Challenge*)challenge
{
    NSMutableDictionary* lastGame = [challenge.results.allResults lastObject];
    if ([lastGame objectForKey:[self opponent:challenge]] == NULL || [lastGame objectForKey:[self uid]] ==NULL){
        return [NSString stringWithFormat:@"GAME%lu", (unsigned long)challenge.results.allResults.count];
    }else{
        return [NSString stringWithFormat:@"GAME%lu", (unsigned long)challenge.results.allResults.count + 1];
    }
}

-(void)returnInstanceOfOT:(Challenge*)challenge with:(NSMutableDictionary*)dictionary exec:(ExecuteAfterFinish)oncomplete
{
    //NSMutableArray* array = [[NSMutableArray alloc]init];
    NSString* gameNo = [NSString stringWithFormat:@"GAME%lu", (unsigned long)challenge.results.allResults.count];
    [[[[self.challengeRef child:challenge.key] child:FIR_BASE_CHILD_RESULTS]child:gameNo]observeSingleEventOfType:(FIRDataEventTypeValue) withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if([snapshot exists]){
            __block NSDictionary* dict = snapshot.value;
            __block NSNumber* ot  = [dict objectForKey:@"OT"];
            if (ot != nil ){
                NSString* uid = [[NSUserDefaults standardUserDefaults]stringForKey:USER_UID__];
                [dictionary setValue:ot forKey:@"OT"];
                NSNumber* myScore = [(NSDictionary*)[dict objectForKey:@"OTScores"]objectForKey:uid];
                [dictionary setValue:myScore forKey:uid];
                //[[[[[self.challengeRef child:challenge.key]child:FIR_BASE_CHILD_RESULTS]child:gameNo]child:@"OT"]removeValue];
                oncomplete();
            }
            
        }
    
    }];
}

-(void)fb_fetchGameWins:(Challenge*)challenge intoArray:(NSMutableArray*)array exec:(ExecuteAfterFinish)onComplete
{
    [[[[self.challengeRef child:challenge.key]child:FIR_BASE_CHILD_RESULTS]child:@"WINS"]observeEventType:(FIRDataEventTypeValue) withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if([snapshot exists]){
            NSMutableDictionary* wins = snapshot.value;
            [array addObject:wins];
            onComplete();
        }
    }];
    
}

#pragma mark CHALLENGE REMOVAL

-(void)removePending:(Challenge *)challenge exec:(ExecuteAfterFinish)finished
{
    NSString* uid = [[NSUserDefaults standardUserDefaults] stringForKey:USER_UID__];
    [[[[[self.userReference child:uid] child:FIR_BASE_CHILD_CHLLNG] child:FIR_BASE_CHILD_CHLLNG_PND_RQ]child:challenge.key]removeValue];
    [[[[[self.userReference child:challenge.receipient] child:FIR_BASE_CHILD_CHLLNG] child:FIR_BASE_CHILD_CHLLNG_RQST]child:challenge.key]removeValue];
    [[self.challengeRef child:challenge.key]removeValue];
    finished();
}

-(void)forfeitGame:(Challenge*)challenge e:(ExecuteAfterFinish)finished
{
    NSString* uid  = [Constants uid];
    [[[[[self.userReference child:challenge.sender]child:FIR_BASE_CHILD_CHLLNG]child:FIR_BASE_CHILD_ACTV_CHLLNG_]child:challenge.key]removeValue];
    [[[[[self.userReference child:challenge.receipient]child:FIR_BASE_CHILD_CHLLNG]child:FIR_BASE_CHILD_ACTV_CHLLNG_]child:challenge.key]removeValue];
    [[self.challengeRef child:challenge.key] removeValue];
    [[self.messageRef child:challenge.key] removeValue];
    [[self.notificationRef child:challenge.key] removeValue];
    [[self.scoreRef child:uid]observeSingleEventOfType:(FIRDataEventTypeValue) withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if([snapshot exists]){
            NSDictionary* d = snapshot.value;
            NSUInteger loss = [(NSNumber*)[d objectForKey:CHLL_PNTS_LSE_RCRD]unsignedIntegerValue];
            NSDictionary* nd = @{CHLL_PNTS_LSE_RCRD:[NSNumber numberWithUnsignedInteger:loss + 1]};
            [[self.scoreRef child:uid]updateChildValues:nd];
            finished();
            [self removeChallengeNotif:challenge.key];
        }
    }];
}

-(void)removeRequest:(Challenge *)challenge exec:(ExecuteAfterFinish)finished
{
    NSString* uid = [[NSUserDefaults standardUserDefaults] stringForKey:USER_UID__];
    [[[[[self.userReference child:uid] child:FIR_BASE_CHILD_CHLLNG] child:FIR_BASE_CHILD_CHLLNG_RQST]child:challenge.key]removeValue];
    [[[[[self.userReference child:challenge.sender] child:FIR_BASE_CHILD_CHLLNG] child:FIR_BASE_CHILD_CHLLNG_PND_RQ]child:challenge.key]removeValue];
    [[self.challengeRef child:challenge.key]removeValue];
    finished();
}

-(void)removeFinished:(Challenge *)challenge exec:(ExecuteAfterFinish)finished
{
   NSString* uid = [[NSUserDefaults standardUserDefaults] stringForKey:USER_UID__];
    [[[self.challengeRef child:challenge.key]child:@"Status"]observeSingleEventOfType:(FIRDataEventTypeValue) withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if ([snapshot exists]) {
            NSNumber* status = snapshot.value;
            if ([status unsignedIntegerValue] < 3){
                [[[[[self.userReference child:uid] child:FIR_BASE_CHILD_CHLLNG] child:FIR_BASE_CHILD_ACTV_CHLLNG_]child:challenge.key]removeValue];
                [[self.challengeRef child:challenge.key]updateChildValues:@{@"Status":@3}];
                finished();
            }else if ([status unsignedIntegerValue] >2){
                [[[[[self.userReference child:uid] child:FIR_BASE_CHILD_CHLLNG] child:FIR_BASE_CHILD_ACTV_CHLLNG_]child:challenge.key]removeValue];
                [[self.challengeRef child:challenge.key]removeValue];
                finished();
            }
        }
    }];
}
//MARK:- OBSERVE
-(void)fetchallUsers:(NSMutableArray *)allUsers queryLimit:(NSUInteger)limit exec:(ExecuteAfterFinish)finished
{
    [[[self userReference]queryLimitedToLast:limit] observeSingleEventOfType:(FIRDataEventTypeValue) withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if([snapshot exists]){
            NSUInteger ccount = 0;
            NSDictionary* users = snapshot.value;
            for (NSString* key in users) {
                ccount++;
                NSDictionary* user = [users objectForKey:key];
                NSDictionary* profile = @{@"Username":[user objectForKey:FIR_BASE_CHILD_USERNAME], FIR_BASE_CHILD_PROFILE_IMG_URL:[user objectForKey:FIR_BASE_CHILD_PROFILE_IMG_URL]};
                NSString* location = [user objectForKey:FIR_DB_CITY];
                [[self.scoreRef child:key]observeSingleEventOfType:(FIRDataEventTypeValue) withBlock:^(FIRDataSnapshot * _Nonnull newsnapshot) {
                    if ([newsnapshot exists]) {
                        NSMutableDictionary* scoreData = newsnapshot.value;
                        __block Gamer* gamer = [[Gamer alloc]initWithProfile:key profile:profile scoreData:scoreData locality:location];
                        [allUsers addObject:gamer];
                        finished();
                    }
                }];
            }
        }else{
            finished();
        }
    }];
}



-(void)sendMessage:(NSDictionary*)messageDict withID:(NSString*)challengeID e:(ExecuteAfterFinish)exec
{
    [[[[self messageRef] child:challengeID]childByAutoId]updateChildValues:messageDict];
    exec();
}


#pragma mark - Queries

-(void)queryForChatMessages:(Challenge*)challenge e:(ExecuteAfterFinish _Nullable)exec
{
    NSString* uid = [[NSUserDefaults standardUserDefaults] stringForKey:USER_UID__];
    FIRDatabaseQuery* mQ = [[self.messageRef child:challenge.key] queryLimitedToLast:1];
    [mQ observeEventType:(FIRDataEventTypeChildAdded) withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if ([snapshot exists]){
            NSDictionary* meta = (NSDictionary*)snapshot.value;
            
            if (![[meta objectForKey:@"Sender"] isEqualToString:uid]) {
                 exec();
            }else{}
        }
    }];
}
//Unused
-(void)readMessageReceipt:(NSString*)challengeKey h:(FIRDatabaseHandle)handle e:(ExecuteAfterFinish)exec
{
    NSString* uid = [[NSUserDefaults standardUserDefaults] stringForKey:USER_UID__];
    FIRDatabaseQuery* mQ = [[self.messageRef child:challengeKey] queryLimitedToLast:1];
    FIRDatabaseHandle h = [mQ observeEventType:(FIRDataEventTypeChildAdded) withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if ([snapshot exists]){
            NSDictionary* meta = (NSDictionary*)snapshot.value;
            if ([[meta objectForKey:@"Sender"] isEqualToString:uid]){}else{
                [[[self.messageRef child:challengeKey]child:snapshot.key] updateChildValues:@{@"Read":[NSNumber numberWithUnsignedInteger:1]}];
            }
        }
    }];
    handle = h;
    
}

#pragma Notifications

-(void)notifyMessageReceived:(Challenge*)challenge h:(FIRDatabaseHandle)handle e:(ExecuteAfterFinish)exec
{
    NSString* uid = [[NSUserDefaults standardUserDefaults] stringForKey:USER_UID__];
    FIRDatabaseQuery* mQ = [[self.messageRef child:challenge.key] queryLimitedToLast:1];
    FIRDatabaseHandle h = [mQ observeEventType:(FIRDataEventTypeChildAdded) withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if ([snapshot exists]){
            NSDictionary* meta = (NSDictionary*)snapshot.value;
            if ([[meta objectForKey:@"Sender"] isEqualToString:uid]){}else{
                if(![AppDelegate mainDelegate].isChatVC){
                    NSString* name = [DatabaseService configureUsername:challenge id:[meta objectForKey:@"Sender"]];
                    NSString* message = [meta objectForKey:@"Text"];
                    NSUInteger r = [(NSNumber*)[meta objectForKey:@"Read"]unsignedIntegerValue];
                    if(r == 0){
                        [[AppDelegate mainDelegate]createNotificationFor:challenge t:name b:message];
                    }
                }
                
            }
        }
    }];
    handle = h;
    
}

-(void)getKeys:(ExecuteAfterFinish)exec;
{
    NSString* uid = [Constants uid];
    AppDelegate* del = [AppDelegate mainDelegate];

     FIRDatabaseReference* a = [[[self.userReference child:uid] child:FIR_BASE_CHILD_CHLLNG] child:FIR_BASE_CHILD_ACTV_CHLLNG_];

    [a observeEventType:(FIRDataEventTypeValue) withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if ([snapshot exists]){
            [del.activeChKeys removeAllObjects];
            NSDictionary* active = snapshot.value;
            //NSLog(@"The snapp::%@",active);
            del.activeChKeys = [active allKeys].mutableCopy;
            //NSLog(@"The array keys %@",del.activeChKeys);
            exec();
            
        }
    }];
    
}

-(void)observeRequestSent:(ExecuteAfterFinish)exec
{
    NSString* uid = [Constants uid];
    FIRDatabaseQuery* r = [[[[self.userReference child:uid] child:FIR_BASE_CHILD_CHLLNG] child:FIR_BASE_CHILD_CHLLNG_RQST] queryLimitedToLast:1];
    [r observeEventType:(FIRDataEventTypeChildAdded) withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if([snapshot exists]){
            NSString* key = snapshot.key;
            if ([AppDelegate mainDelegate].onStart){
                [[AppDelegate mainDelegate]setOnStart:NO];
            }else{
                //NSLog(@"this is the key %@", key);
                [[NSNotificationCenter defaultCenter] postNotificationName:@"SentRequest" object:nil userInfo:@{@"Key":key}];
            }
            
            
        }
    }];
    
}

-(void)observeGameEnded:(NSString*)challengeKey count:(NSUInteger)count e:(ExecuteAfterFinish)exec
{
    //NSString* uid = [Constants uid];
    AppDelegate* app = [AppDelegate mainDelegate];
    FIRDatabaseQuery* r = [[[self.challengeRef child:challengeKey] child:FIR_BASE_CHILD_RESULTS] queryLimitedToLast:1];
    [r observeEventType:(FIRDataEventTypeChildAdded) withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if([snapshot exists]){
            //NSString* key = snapshot.key;
            if(app.endedCount > count){
                //NSLog(@"this is the key %@", key);
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Ended" object:nil userInfo:@{@"Key":challengeKey}];
            }else{
                app.endedCount++;}
            
            
        }
    }];
    
}


-(void)observeRequestAccepted:(ExecuteAfterFinish)exec
{
    NSString* uid = [Constants uid];
    FIRDatabaseQuery* r = [[[[self.userReference child:uid] child:FIR_BASE_CHILD_CHLLNG] child:FIR_BASE_CHILD_ACTV_CHLLNG_] queryLimitedToLast:1];
    [r observeEventType:(FIRDataEventTypeChildAdded) withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if([snapshot exists]){
            //NSLog(@"this is the key %@", snapshot.key);
            if (![snapshot.value isEqualToString:[Constants uid]]){
                NSString* key = snapshot.key;
                if ([AppDelegate mainDelegate].onStart2){
                    [[AppDelegate mainDelegate]setOnStart2:NO];
                }else{
                                    //NSLog(@"this is the key %@", key);
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"Accepted" object:nil userInfo:@{@"Key":key}];
                }
            }
        }
    }];

}

-(void)removeChallengeNotif:(NSString*)challengeKey
{
   FIRDatabaseReference* notifRef = [self.notificationRef child:challengeKey];
    [notifRef removeValue];
}

-(void)NotifiedGameFinished:(Challenge*)challenge
{
    FIRDatabaseReference* notifRef = [self.notificationRef child:challenge.key];
    //[notifRef removeAllObservers];
    [notifRef observeEventType:(FIRDataEventTypeChildChanged) withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if ([snapshot exists]){
            NSString* player = snapshot.value;
            if (![player isEqualToString:[Constants uid]]){
                NSString* title = @"Game Ended";
                NSString* user = [DatabaseService configureUsername:challenge id:player];
                NSString* body = [NSString stringWithFormat:@"A game with %@ just finished", user];
                [[AppDelegate mainDelegate]createNotificationFor:challenge t:title b:body];
            }
        }
    }];
 
}


-(void)notifyNextPlay:(Challenge*)challenge
{
        NSDictionary* d = @{@"NextPlayer":[Constants uid]};
    [[self.notificationRef child:challenge.key]updateChildValues:d];
}

-(NSString* _Nullable)uniquetype:(NSString*)key
{
    NSString* s;
    NSArray* array = [AppDelegate mainDelegate].pendingReqKeys;
    for (NSString* element in array) {
        if ([element isEqualToString:key]){
            s = nil;
        }else{
            s = key;
        }
    }
    return s;
}

+(NSString*)configureUsername:(Challenge*)challenge id:(NSString*)uid
{
    NSString* username = [challenge.usernames objectForKey:@"Sender"];
    NSString* receipient = [challenge.usernames objectForKey:@"Recipient"];
    if ([challenge.sender isEqualToString:uid]){
        return username;
     }else{
        return receipient;
    }

}

-(void)LogUserReport:(Gamer*)voilater with:(NSString*)details on:(ExecuteAfterFinish)sent
{
    NSDictionary* report = @{[Constants uid]:details};
    [[self.reportRef child:voilater.uid]updateChildValues:report];
    sent();
}

-(void)searchUserwith:(NSString*)name queryLimited:(NSUInteger)limit into:(NSMutableArray*)array on:(ExecuteAfterFinish)complete
{
    FIRDatabaseQuery* query = [[[[self.userReference queryOrderedByChild:@"Username" ] queryStartingAtValue:name]queryEndingAtValue:[name stringByAppendingString:@"u{f8ff}"]]queryLimitedToFirst:limit];
    
    [query observeSingleEventOfType:(FIRDataEventTypeValue) withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSUInteger ccount = 0;
        //NSLog(@"the Snap of users is %@",snapshot.value);
        if ([snapshot exists]) {
            NSDictionary* users = snapshot.value;
            for (NSString* key in users) {
                ccount++;
                NSString* uid = [Constants uid];
                NSDictionary* user = [users objectForKey:key];
                NSDictionary* profile = @{@"Username":[user objectForKey:FIR_BASE_CHILD_USERNAME], FIR_BASE_CHILD_PROFILE_IMG_URL:[user objectForKey:FIR_BASE_CHILD_PROFILE_IMG_URL]};
                NSString* location = [user objectForKey:FIR_DB_CITY];
                [[self.scoreRef child:key]observeSingleEventOfType:(FIRDataEventTypeValue) withBlock:^(FIRDataSnapshot * _Nonnull newsnapshot) {
                    if ([newsnapshot exists]) {
                        NSMutableDictionary* scoreData = newsnapshot.value;
                        __block Gamer* gamer = [[Gamer alloc]initWithProfile:key profile:profile scoreData:scoreData locality:location];
                        if (![gamer.uid isEqualToString:uid]) {
                            [array addObject:gamer];
                            complete();
                        }

                    }
                }];
            }
            
        }else{
            complete();
        }
    }];
    
}

-(void)fetchNearbyUsers:(NSString*)locality queryLimited:(NSUInteger)limit into:(NSMutableArray*)array onFinish:(ExecuteAfterFinish)completed
{
    if (locality) {
        FIRDatabaseQuery* locquery = [[[self.userReference queryOrderedByChild:FIR_DB_CITY]queryStartingAtValue:locality.lowercaseString]queryLimitedToFirst:limit];
        __block NSUInteger ccount = 0;
        [locquery observeSingleEventOfType:(FIRDataEventTypeValue) withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            if([snapshot exists]){

                NSDictionary* users = snapshot.value;
                for (NSString* key in users) {
                    ccount++;
                    NSDictionary* user = [users objectForKey:key];
                    NSDictionary* profile = @{@"Username":[user objectForKey:FIR_BASE_CHILD_USERNAME], FIR_BASE_CHILD_PROFILE_IMG_URL:[user objectForKey:FIR_BASE_CHILD_PROFILE_IMG_URL]};
                    NSString* location = [user objectForKey:FIR_DB_CITY];
                    [[self.scoreRef child:key]observeSingleEventOfType:(FIRDataEventTypeValue) withBlock:^(FIRDataSnapshot * _Nonnull newsnapshot) {
                        if ([newsnapshot exists]) {
                            NSMutableDictionary* scoreData = newsnapshot.value;
                            __block Gamer* gamer = [[Gamer alloc]initWithProfile:key profile:profile scoreData:scoreData locality:location];
                            [array addObject:gamer];
                            completed();
                        }
                    }];
                }

            }else{
                completed();
                
            }
        }];
    }
}


+(void)removeAllobservers:(FIRDatabaseReference*)ref
{
    if (ref) {
        [ref removeAllObservers];
        return;
    }
    [[[DatabaseService main]mainReference]removeAllObservers];
}



-(void)postToken:(NSString*)token
{
    NSParameterAssert(token != nil);
    if ([Constants uid] != nil){
         [[self tokensRef]updateChildValues:@{[Constants uid]:token}];
    }
   
}




//DK98QHqDOoaRpOBRR1pNOWiW6UU2

@end

