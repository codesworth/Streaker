//
//  LeaderBoardCells.h
//  CWStreaks
//
//  Created by Mensah Shadrach on 1/10/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Gamer.h"
#import "Constants.h"

@interface LeaderBoardCells : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView * _Nullable profileImageView;
@property (weak, nonatomic) IBOutlet UILabel * _Nullable username;
@property (weak, nonatomic) IBOutlet UILabel * _Nullable userInfo;
@property (weak, nonatomic) IBOutlet UILabel * _Nullable percentage;
@property (weak, nonatomic) IBOutlet UILabel * _Nullable userinfo2;

-(void)configureCells:(Gamer* _Nonnull)gamer selectedSegment:(NSInteger)index atIndexPath:(NSIndexPath* _Nullable)indexPath;

-(void)configEx_cells:(nonnull Gamer*)gamer;

@end
