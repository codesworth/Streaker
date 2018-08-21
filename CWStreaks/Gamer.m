//
//  Gamer.m
//  CWStreaks
//
//  Created by Mensah Shadrach on 11/19/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

#import "Gamer.h"

@implementation Gamer

-(instancetype _Nonnull)initWithname:(nonnull NSString*)username uid:(NSString* _Nonnull)userUID withAvatar:(nullable NSString*)avatarName and:(nullable NSMutableDictionary*)scoreData locality:(nullable NSString*)location{
    self = [super init];
    if (self){
        self.uid = userUID;
        _username = username;
        _avatar = avatarName;
        _scoreData = scoreData;
        self.location = location;
        if (scoreData != nil){
            self.userPercentage = ([(NSNumber*) [scoreData objectForKey:FIR_DB_REF_ALLTIME_GAMESCORE] doubleValue]) / ([(NSNumber*) [scoreData objectForKey:FIR_DB_REF_ALLTIME_GAMECOUNT] doubleValue]);
        }
    }
    
    return  self;
}

//Light Weight Instance type that excludes scoredaata. Convenient for initailiazing users nearby.

-(instancetype)initWithProfile:(NSString*)uid profile:(NSDictionary*)profile scoreData:(NSMutableDictionary*)scoreData locality:(NSString *)locality
{
    self = [super init];
    if (self){
        self.uid = uid;
        self.username = [profile objectForKey:FIR_BASE_CHILD_USERNAME];
        self.avatar = [profile objectForKey:FIR_BASE_CHILD_PROFILE_IMG_URL];
        self.location = locality;
        self.scoreData = scoreData;
        self.userPercentage = ([(NSNumber*) [scoreData objectForKey:FIR_DB_REF_ALLTIME_GAMESCORE] doubleValue]) / ([(NSNumber*) [scoreData objectForKey:FIR_DB_REF_ALLTIME_GAMECOUNT] doubleValue]);
    }
    return self;
}

@end
