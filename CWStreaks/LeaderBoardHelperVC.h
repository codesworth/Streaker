//
//  LeaderBoardHelperVC.h
//  CWStreaks
//
//  Created by Mensah Shadrach on 3/11/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LeaderBoardCategoriesDelegate <NSObject>

-(void)LeaderBoardCategoryDidFinishSelectingCategoryAt:(NSUInteger)index;

@end

@interface LeaderBoardHelperVC : UITableViewController

@property(nonatomic,weak)id<LeaderBoardCategoriesDelegate> delegate;
@end
