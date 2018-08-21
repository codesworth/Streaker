//
//  Results.m
//  CWStreaks
//
//  Created by Mensah Shadrach on 1/20/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import "Results.h"

@implementation Results

-(id)init{
    self = [super init];
    return self;
}

-(id)initWith:(NSString *)gamedate gameOneResult:(NSMutableDictionary *)g1R gameTwoResult:(NSMutableDictionary *)g2R gameThreeResult:(NSMutableDictionary *)g3R gameFourResult:(NSMutableDictionary *)g4R gameFiveResult:(NSMutableDictionary *)g5R gameSixResult:(NSMutableDictionary *)g6R gameSevenresult:(NSMutableDictionary *)g7R
{
    self = [super init];
    if (self){
        self.gameDate = gamedate;
        self.gameOneResults = g1R;
        if (g1R != nil){[self.allResults addObject:g1R];}
        self.gameTwoResults = g2R;
        if (g2R != nil){[self.allResults addObject:g2R];}
        self.gameThreeResults = g3R;
        if (g3R != nil){[self.allResults addObject:g3R];}
        self.gameFourResults = g4R;
        if (g4R != nil){[self.allResults addObject:g4R];}
        self.gameFiveResults = g5R;
        if (g5R != nil){[self.allResults addObject:g5R];}
        self.gameSixResults = g6R;
        if (g6R != nil){[self.allResults addObject:g6R];}
        self.gameSevenResults = g7R;
        if(g7R != nil){[self.allResults addObject:g7R];}
    }
    return self;
}

-(id _Nullable)initWith:(NSMutableDictionary* _Nullable)dictionary
{
    self = [super init];
    if (self){
        if (dictionary) {
            self.rawData = dictionary;
            
        }
        self.allResults = [[NSMutableArray alloc] init];
        if ([dictionary objectForKey:GAME1] != nil){
            [self.allResults addObject:[dictionary objectForKey:GAME1]];
            self.gameOneResults = [dictionary objectForKey:GAME1];
            //NSLog(@"the score isssss %@", [_gameOneResults objectForKey:@"icSxe57gdoYJf3Bh6LVB2dGp8jM2"]);
             //NSLog(@"the score isssss %@", [[dictionary objectForKey:GAME1] objectForKey:@"icSxe57gdoYJf3Bh6LVB2dGp8jM2"]);
            //[self.allResults addObject:_gameOneResults];
             //NSLog(@"The all result dict is hahhaha %@", self.allResults);
        }
        
        if ([dictionary objectForKey:GAME2] != nil){[self.allResults addObject:[dictionary objectForKey:GAME2]]; self.gameTwoResults = [dictionary objectForKey:GAME2];}
        
        if ([dictionary objectForKey:GAME3] != nil){[self.allResults addObject:[dictionary objectForKey:GAME3]]; self.gameThreeResults = [dictionary objectForKey:GAME3];}
        
        if ([dictionary objectForKey:GAME4] != nil){[self.allResults addObject:[dictionary objectForKey:GAME4]]; self.gameFourResults = [dictionary objectForKey:GAME4];}
        
        if ([dictionary objectForKey:GAME5] != nil){[self.allResults addObject:[dictionary objectForKey:GAME5]]; self.gameFiveResults = [dictionary objectForKey:GAME5];}
        
        if ([dictionary objectForKey:GAME6] != nil){[self.allResults addObject:[dictionary objectForKey:GAME6]]; self.gameSixResults = [dictionary objectForKey:GAME6];}
        
        if ([dictionary objectForKey:GAME7] != nil){[self.allResults addObject:[dictionary objectForKey:GAME7]]; self.gameSevenResults = [dictionary objectForKey:GAME7];}
    }
   
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self){
    _gameDate = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(gameDate))];
    _gameOneResults = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(gameOneResults))];
    _gameTwoResults = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(gameTwoResults))];
    _gameThreeResults = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(gameThreeResults))];
    _gameFourResults = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(gameFourResults))];
    _gameFiveResults = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(gameFiveResults))];
    _gameSixResults = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(gameSixResults))];
    _gameSevenResults = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(gameSevenResults))];
    _allResults = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(allResults))];
    _rawData = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(rawData))];
    }
    return self;
}


-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.gameDate forKey:NSStringFromSelector(@selector(gameDate))];
    [aCoder encodeObject:self.gameOneResults forKey:NSStringFromSelector(@selector(gameOneResults))];
    [aCoder encodeObject:self.gameTwoResults forKey:NSStringFromSelector(@selector(gameTwoResults))];
    [aCoder encodeObject:self.gameThreeResults forKey:NSStringFromSelector(@selector(gameThreeResults))];
    [aCoder encodeObject:self.gameFourResults forKey:NSStringFromSelector(@selector(gameFourResults))];
    [aCoder encodeObject:self.gameFiveResults forKey:NSStringFromSelector(@selector(gameFiveResults))];
    [aCoder encodeObject:self.gameSixResults forKey:NSStringFromSelector(@selector(gameSixResults))];
    [aCoder encodeObject:self.gameSevenResults forKey:NSStringFromSelector(@selector(gameSevenResults))];
    [aCoder encodeObject:self.allResults forKey:NSStringFromSelector(@selector(allResults))];
    [aCoder encodeObject:self.rawData forKey:NSStringFromSelector(@selector(rawData))];
    
    
}

#pragma NSCOPYING




@end
