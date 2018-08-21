//
//  ChallengeCells.h
//  CWStreaks
//
//  Created by Mensah Shadrach on 1/19/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Challenge.h"
#import "Gamer.h"
#import "Constants.h"
//#import "AppDelegate.h"

@interface ChallengeCells : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel * _Nullable scorelabel;
@property (weak, nonatomic) IBOutlet UIImageView * _Nullable senderProfileImage;
@property (weak, nonatomic) IBOutlet UILabel * _Nullable senderUsername;
@property (weak, nonatomic) IBOutlet UILabel * _Nullable recipientUsername;
@property (weak, nonatomic) IBOutlet UIImageView * _Nullable recipientProfileImage;
@property (weak, nonatomic) IBOutlet UILabel * _Nullable dateGameplayedlabel;
@property (weak, nonatomic) IBOutlet UILabel * _Nullable gameNumberLabel;
@property(weak,nonatomic)IBOutlet UIView* _Nullable backView;
@property (weak, nonatomic) IBOutlet UIView * _Nullable backView2;
@property (weak, nonatomic) IBOutlet UIView * _Nullable rBackview;
@property (weak, nonatomic) IBOutlet UIView * _Nullable rBackView2;

-(void)configureCell:(nonnull Challenge*)challenge;
-(void)configureGameCell:(Challenge* _Nonnull)challenge atIndexPath:(NSUInteger)index; 
@end
