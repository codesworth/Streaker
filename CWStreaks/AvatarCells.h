//
//  avatarCells.h
//  CWStreaks
//
//  Created by Mensah Shadrach on 2/8/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface avatarCells : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView * _Nullable avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel * _Nullable avatarName;
@property (weak, nonatomic) IBOutlet UIView * _Nullable overView;


-(void)configureCell:(NSString* _Nonnull)name;
@end
