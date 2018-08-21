 //
//  Challenge.m
//  CWStreaks
//
//  Created by Mensah Shadrach on 1/16/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import "Challenge.h"

@implementation Challenge

-(instancetype)initWith:(NSString*)key aGamerUID:(NSString *)senderUID to:(NSString *)receipientUID and:(NSDictionary*)usernames with:(NSString *)challengeID and:(Results*)results onDate:(NSString* _Nonnull)date withStatus:(NSNumber*)status;
{
    self = [super init];
    if (self){
        self.sender = senderUID;
        self.receipient = receipientUID;
        self.usernames = usernames;
        self.challengeID = challengeID;
        self.results = results;
        self.key = key;
        self.date = date;
        self.status = status;
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self){
        _sender = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(sender))];
        _receipient = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(receipient))];
        _usernames = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(usernames))];
        _challengeID = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(challengeID))];
        _results = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(results))];
        _key = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(key))];
        _status = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(status))];
        _date = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(date))];
    }
    
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.sender forKey:NSStringFromSelector(@selector(sender))];
    [aCoder encodeObject:self.receipient forKey:NSStringFromSelector(@selector(receipient))];
    [aCoder encodeObject:self.usernames forKey:NSStringFromSelector(@selector(usernames))];
    [aCoder encodeObject:self.challengeID forKey:NSStringFromSelector(@selector(challengeID))];
    [aCoder encodeObject:self.results forKey:NSStringFromSelector(@selector(results))];
    [aCoder encodeObject:self.key forKey:NSStringFromSelector(@selector(key))];
    [aCoder encodeObject:self.status forKey:NSStringFromSelector(@selector(status))];
    [aCoder encodeObject:self.date forKey:NSStringFromSelector(@selector(date))];
}



/*
 @param: usernames is a convenient for storing usernames of challenge participants and their respective avatar states
 dictionary contains keys:
 @"Sender"
 @"Recipient"
 @"RecipientAvatar"
 @"SenderAvatar"
 */

@end
