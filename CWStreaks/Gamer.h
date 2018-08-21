//
//  Gamer.h
//  CWStreaks
//
//  Created by Mensah Shadrach on 11/19/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface Gamer : NSObject

@property (strong, nonatomic, nonnull)NSString* uid;
@property (strong, nonatomic,nonnull) NSString* username;
@property (strong, nonatomic,nullable) NSString* avatar;
@property (strong, nonatomic,nullable) NSMutableDictionary* scoreData;
@property(nonatomic)double userPercentage;
@property(nullable,nonatomic,strong) NSString* location;

-(instancetype _Nonnull)initWithname:(nonnull NSString*)username uid:(NSString* _Nonnull)userUID withAvatar:(nullable NSString*)avatarName and:( NSMutableDictionary* _Nullable )scoreData locality:(nullable NSDictionary*)location;

-(instancetype _Nonnull)initWithProfile:(nonnull NSString*)uid profile:(NSDictionary* _Nonnull)profile scoreData:(nullable NSMutableDictionary*)scoreData locality:(NSString* _Nullable)locality;

//-(NSString* _Nonnull)getUsername;
//-(NSString* _Nullable)getProfileImageUrl;
//-(NSMutableDictionary* _Nonnull)getScoreData;
@end
