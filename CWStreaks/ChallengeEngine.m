//
//  ChallengeEngine.m
//  CWStreaks
//
//  Created by Mensah Shadrach on 1/16/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import "ChallengeEngine.h"


@implementation ChallengeEngine

+(id _Nonnull)mainEngine
{
    static ChallengeEngine* mainEngine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mainEngine = [[ChallengeEngine alloc] init];
        //mainEngine.challengeEngineDictionary = [[NSDictionary alloc]init];
    });
    
    return mainEngine;
}

-(void)initChallengeOTDict
{
    self.challengeEngineDictionary = [[NSUserDefaults standardUserDefaults]dictionaryForKey:CHLLNG_OVERTIME__];
}

-(void)engine_createAndSendChallenge:(NSString* _Nonnull)sender toRecipient:(NSString* _Nonnull)recepient and:(NSDictionary*)usernames withDate:(NSString*)date withChID:(NSString*)challengeID
{
    [[DatabaseService main] fb_Request_setChallenge:sender receipient:recepient andDate:date withChID:challengeID and:usernames];
    
}

-(NSUInteger)engine_prepareChallenge:(NSMutableArray*)challengeArray
{
    //[[DatabaseService main] fb_fetch_ActiveCH:challengeArray didFinish:^{
        
    //}];
    return 5;
}

-(void)engine_UpdateChallengeScore:(NSUInteger)score c:(Challenge*)challenge withNo:(NSString*)gameNumber didfinish:(ExecuteAfterFinish)execute
{
    NSString* uid = [[NSUserDefaults standardUserDefaults] stringForKey:USER_UID__];
    NSDictionary* results = @{@"Date": [Constants stringFromDate:[NSDate date]], uid: [NSNumber numberWithUnsignedInteger:score]};
    [[DatabaseService main] fb_updateScore:results fromChallenge:challenge withNo:gameNumber  didFinish:^{
        execute();
    }];
    [[DatabaseService main] notifyNextPlay:challenge];
    
}

//-(void)engine_CreateChallenge:

@end
