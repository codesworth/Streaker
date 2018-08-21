//
//  Challenge.h
//  CWStreaks
//
//  Created by Mensah Shadrach on 1/16/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Results.h"

@interface Challenge : NSObject<NSCoding>
@property (nonatomic, strong, nonnull)NSString* key;
@property (nonatomic, strong, nonnull) NSString* challengeID;
@property (nonatomic, strong, nonnull) NSString* sender;
@property (nonatomic, strong, nonnull) NSString* receipient;
@property (nonatomic, strong, nonnull) Results* results;
@property(nonatomic, strong,nonnull) NSNumber* status;
@property(nonatomic, nonnull, strong)NSString* date;
@property(nonatomic, nonnull, strong)NSDictionary* usernames;

-(instancetype _Nonnull)initWith:(NSString* _Nonnull)key aGamerUID:(NSString * _Nonnull)senderUID to:(NSString * _Nonnull)receipientUID and:(NSDictionary* _Nonnull)usernames with:(NSString * _Nonnull)challengeID and:(Results* _Nullable)results onDate:(NSString* _Nonnull)date withStatus:(NSNumber* _Nonnull)status;

@end
