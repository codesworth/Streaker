//
//  ChallengeCollectionCell.h
//  CWStreaks
//
//  Created by Mensah Shadrach on 3/8/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import "CW-Predef_Header.h"

@interface ChallengeCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView * _Nullable imageView;

@property (weak, nonatomic) IBOutlet UILabel * _Nullable username;
@property (weak,nonatomic)IBOutlet UIView* _Nullable backView;

-(void)configureCollectionCell:(Challenge* _Nonnull)challenge;
-(void)config_StarredCell;
@end
