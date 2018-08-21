//
//  LeaderBoardConfig.h
//  CWStreaks
//
//  Created by Mensah Shadrach on 1/13/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Gamer.h"
#import "Constants.h"


@import CoreLocation;
@interface LeaderBoardConfig : NSObject

+(id _Nonnull)mainConfig;

-(NSMutableArray* _Nullable)sortTopChallengers:(NSMutableArray* _Nonnull)Challengers;

-(NSMutableArray* _Nullable)sort_Percentage_withSortDescriptors:(NSMutableArray* _Nonnull)array;
-(NSMutableArray* _Nullable)sortwithSortDescriptors:(NSString* _Nonnull)keyString source:(NSMutableArray* _Nonnull)array;

-(NSMutableArray* _Nullable)sort_RGL_withSortDescriptors:(NSMutableArray* _Nonnull)array;

//-(NSMutableArray* _Nullable)sort_RGL_HSK_withSortDescriptors:(NSMutableArray* _Nonnull)array;

-(NSMutableArray* _Nullable)sort_CLSS_SC_withSortDescriptors:(NSMutableArray* _Nonnull)array;

-(NSMutableArray* _Nullable)sort_HSK_withSortDescriptors:(NSMutableArray* _Nonnull)array;
-(NSArray* _Nullable)sortLocalitynearbyUser:(NSMutableArray* _Nonnull)array baseLocality:(NSString* _Nullable)myLocale;
-(NSMutableArray* _Nullable)returnSearchResultsFrom:(NSMutableArray<Gamer*>* _Nonnull)list keyString:(NSString* _Nonnull)string;

-(NSMutableArray* _Nullable)sortLoosingStreak:(NSMutableArray* _Nonnull)array;
-(NSMutableArray* _Nullable)sort_ChallengeWins:(NSMutableArray* _Nonnull)array;
-(NSMutableArray* _Nullable)sort_Challenge_sweeps:(NSMutableArray* _Nonnull)array;
@end

