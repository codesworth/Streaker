//
//  LeaderboardVC.h
//  CWStreaks
//
//  Created by Mensah Shadrach on 1/10/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Gamer.h"
#import "Constants.h"
#import "DatabaseService.h"
#import "LeaderBoardCells.h"
#import "LeaderBoardConfig.h"
#import "UserResultsVC.h"
#import "LeaderBoardHelperVC.h"

@interface LeaderboardVC : UIViewController<UITableViewDelegate, UITableViewDataSource,LeaderBoardCategoriesDelegate>

@property(strong, nonatomic, nullable)NSMutableArray* gamers;

@end
