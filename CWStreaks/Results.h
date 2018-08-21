//
//  Results.h
//  CWStreaks
//
//  Created by Mensah Shadrach on 1/20/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface Results : NSObject<NSCoding>
@property(strong, nonatomic,nullable)NSString* gameDate;
@property(strong, nonatomic, nullable)NSMutableDictionary* gameOneResults;
@property(strong, nonatomic, nullable)NSMutableDictionary*gameTwoResults;
@property(strong, nonatomic, nullable)NSMutableDictionary*gameThreeResults;
@property(strong, nonatomic, nullable)NSMutableDictionary*gameFourResults;
@property(strong, nonatomic, nullable)NSMutableDictionary*gameFiveResults;
@property(strong, nonatomic, nullable)NSMutableDictionary*gameSixResults;
@property(strong, nonatomic, nullable)NSMutableDictionary*gameSevenResults;
@property(strong, nonatomic, nullable)NSMutableArray* allResults;
@property(strong,nonatomic,nullable)NSMutableDictionary* rawData;

-(id _Nullable)initWith:(NSString* _Nullable)gamedate gameOneResult:(NSMutableDictionary* _Nullable)g1R gameTwoResult:(NSMutableDictionary* _Nullable)g2R gameThreeResult:(NSMutableDictionary* _Nullable)g3R gameFourResult:(NSMutableDictionary* _Nullable)g4R gameFiveResult:(NSMutableDictionary* _Nullable)g5R gameSixResult:(NSMutableDictionary* _Nullable)g6R gameSevenresult:(NSMutableDictionary* _Nullable)g7R;

-(id _Nullable)initWith:(NSMutableDictionary* _Nullable)dictionary;
@end
