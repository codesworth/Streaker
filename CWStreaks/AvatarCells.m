//
//  avatarCells.m
//  CWStreaks
//
//  Created by Mensah Shadrach on 2/8/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import "AvatarCells.h"


@implementation avatarCells

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self.avatarImageView.layer setCornerRadius:5.0];
    [self.avatarImageView setClipsToBounds:YES];
    [self.avatarImageView setContentMode:(UIViewContentModeScaleAspectFill)];
    [self.overView.layer setCornerRadius:5.0];
    [self.overView.layer setMasksToBounds:YES];
}

-(void)configureCell:(NSString*)name
{
    [self.avatarName setText:name];
    [self.avatarImageView setImage:[UIImage imageNamed:name]];
}

@end
