//
//  ExploreVC.h
//  CWStreaks
//
//  Created by Mensah Shadrach on 2/3/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "DatabaseService.h"
#import "LeaderBoardCells.h"
#import "AppDelegate.h"
#import "UserResultsVC.h"


@interface ExploreVC : UIViewController <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UIView *activityView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;



@end
