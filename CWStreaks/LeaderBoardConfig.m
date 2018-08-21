//
//  LeaderBoardConfig.m
//  CWStreaks
//
//  Created by Mensah Shadrach on 1/13/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import "LeaderBoardConfig.h"

@implementation LeaderBoardConfig


+(id _Nonnull)mainConfig
{
    static LeaderBoardConfig* mainConfig = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mainConfig = [[LeaderBoardConfig alloc] init];
    });
    return mainConfig;
}

-(NSMutableArray* _Nullable)initwithSorted:(NSMutableArray* _Nonnull)array
{
    NSMutableArray* sortedArray = [[NSMutableArray alloc] init];
    [array sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
            Gamer* g1 = obj1;
            Gamer* g2 = obj2;
        double percent1 = [(NSNumber*)[g1.scoreData objectForKey:FIR_DB_REF_SC_REGL_GAMEHIGHSCORE] doubleValue]; /// [(NSNumber*)[g2.scoreData objectForKey:FIR_DB_REF_ALLTIME_GAMECOUNT] doubleValue];
        double percent2 = [(NSNumber*)[g2.scoreData objectForKey:FIR_DB_REF_SC_REGL_HIGHSTREAK] doubleValue]; /// [(NSNumber*)[g2.scoreData objectForKey:FIR_DB_REF_ALLTIME_GAMECOUNT] doubleValue];
            //NSLog(@"Percenatggge 11 = %.3f", percent1);
            //NSLog(@"Percenatggge 22 = %.3f", percent2);
            if (percent1 > percent2){
                return (NSComparisonResult)NSOrderedAscending;
            }else if (percent1 < percent2){
                return (NSComparisonResult)NSOrderedDescending;
            }

        return (NSComparisonResult)NSOrderedSame;
    }];
    sortedArray = array;
    //NSLog(@"Gamerssss: %@", [(Gamer*)[sortedArray objectAtIndex:0] username]);
    return sortedArray;
}

-(NSMutableArray* _Nullable)sortwithSortDescriptors:(NSString* _Nonnull)keyString source:(NSMutableArray* _Nonnull)array
{
    NSSortDescriptor *sortdescriptor = [[NSSortDescriptor alloc] initWithKey:keyString ascending:NO];
    NSArray* sortDescriptors = [NSArray arrayWithObject:sortdescriptor];
    NSArray *sortedArray = [array sortedArrayUsingDescriptors:sortDescriptors];
    NSMutableArray *returnArray = [sortedArray mutableCopy];
    return returnArray;
}

-(NSMutableArray* _Nullable)sort_Percentage_withSortDescriptors:(NSMutableArray* _Nonnull)array
{
    /*NSSortDescriptor* sortdescriptor = [[NSSortDescriptor alloc] initWithKey:@"userPercentage" ascending:NO];
    NSArray* sortDescriptors = [NSArray arrayWithObject:sortdescriptor];
    NSArray *sortedArray = [array sortedArrayUsingDescriptors:sortDescriptors];
    NSMutableArray *returnArray = [sortedArray mutableCopy];
    return returnArray;*/
    NSString* percentageKey = @"userPercentage";
    return [self sortwithSortDescriptors:percentageKey source:array];
}

-(NSMutableArray* _Nullable)sort_RGL_withSortDescriptors:(NSMutableArray* _Nonnull)array
{
    NSString* keypath = @"scoreData.RegularGameHighScore";
    return [self sortwithSortDescriptors:keypath source:array];
}


-(NSMutableArray* _Nullable)sort_CLSS_SC_withSortDescriptors:(NSMutableArray* _Nonnull)array
{
    NSString* keypath = @"scoreData.ClassicGameHighScore";
    return [self sortwithSortDescriptors:keypath source:array];
}
-(NSMutableArray* _Nullable)sort_HSK_withSortDescriptors:(NSMutableArray* _Nonnull)array
{
    NSString* keypath = @"scoreData.HighStreak";
    return [self sortwithSortDescriptors:keypath source:array];
}

-(NSMutableArray*)sortLoosingStreak:(NSMutableArray*)array
{
    NSString* path = @"scoreData.LoosingStreak";
    return [self sortwithSortDescriptors:path source:array];
}

-(NSMutableArray*)sort_ChallengeWins:(NSMutableArray*)array
{
    NSString* path = @"scoreData.ChallWinRecord";
    return [self sortwithSortDescriptors:path source:array];
}

-(NSMutableArray*)sort_Challenge_sweeps:(NSMutableArray*)array
{
    NSString* path = @"scoreData.SeriesSweepPoints";
    return [self sortwithSortDescriptors:path source:array];
}

-(NSArray*)sortLocalitynearbyUser:(NSMutableArray*)array baseLocality:(NSString*)myLocale;
{
    NSMutableArray* holder = [NSMutableArray new];
    for (Gamer* gamer in array) {
        if (gamer.location != nil && myLocale != nil) {
            
            if ([gamer.location isEqualToString:myLocale]) {
                [holder addObject:gamer];
            }
        }
    }
    return holder;
    
}

-(NSMutableArray* _Nullable)sortTopChallengers:(NSMutableArray*)Challengers
{
    NSString* keyPath = @"scoreData.GameWinPoints";
    return [self sortwithSortDescriptors:keyPath source:Challengers];
}

-(NSMutableArray* _Nullable)returnSearchResultsFrom:(NSMutableArray<Gamer*>* _Nonnull)list keyString:(NSString* _Nonnull)string
{
    NSMutableArray* array = [[NSMutableArray alloc]init];
    for (Gamer* gamer in list) {
        if ([gamer.username.lowercaseString containsString:string.lowercaseString]) {
            [array addObject:gamer];
        }
    }
    return array;
}

    




@end
