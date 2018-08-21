//
//  ChallengeEngine.h
//  CWStreaks
//
//  Created by Mensah Shadrach on 1/16/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Gamer.h"
#import "Constants.h"
#import "DatabaseService.h"

@interface ChallengeEngine : NSObject

typedef void(^ExecuteAfterFinish)(void);
@property (strong, nullable, nonatomic)NSDictionary* challengeEngineDictionary;

+(id _Nonnull)mainEngine;

-(void)initChallengeOTDict;

-(void)engine_createAndSendChallenge:(NSString* _Nonnull)sender toRecipient:(NSString* _Nonnull)recepient and:(NSDictionary* _Nonnull)usernames withDate:(NSString* _Nullable)date withChID:(NSString* _Nonnull)challengeID;
-(void)engine_UpdateChallengeScore:(NSUInteger)score c:(nonnull Challenge*)challenge withNo:(nonnull NSString*)gameNumber didfinish:(ExecuteAfterFinish _Nullable)execute;
@end
