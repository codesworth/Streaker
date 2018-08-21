//
//  ChallengeCollectionCell.m
//  CWStreaks
//
//  Created by Mensah Shadrach on 3/8/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import "ChallengeCollectionCell.h"


@implementation ChallengeCollectionCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self.username setTextColor:[UIColor whiteColor]];
    [self.imageView.layer setCornerRadius:self.imageView.frame.size.width /2];

    self.backView.layer.backgroundColor = (__bridge CGColorRef _Nullable)([Constants createGradientColors:[NSNumber numberWithUnsignedInteger:5]]);
    [_backView setClipsToBounds:YES];
    [self.backView.layer setCornerRadius:self.backView.frame.size.width / 2];
    
}





-(void)configureCollectionCell:(Challenge*)challenge
{
    NSString* name = [self opponentName:challenge];
    NSString* avatar = [self opponentAvatar:challenge];
    self.username.text = name.uppercaseString;
    self.imageView.image = [UIImage imageNamed:avatar];
}

-(NSString*)opponentAvatar:(Challenge*)challenge
{
    if ([challenge.sender isEqualToString:[Constants uid]]){
        return [challenge.usernames objectForKey:@"RecipientAvatar"];
    }else{
        return [challenge.usernames objectForKey:@"SenderAvatar"];
    }
}

-(NSString*)opponentName:(Challenge*)challenge
{
    if ([challenge.sender isEqualToString:[Constants uid]]){
        return [challenge.usernames objectForKey:@"Recipient"];
    }else{
        return [challenge.usernames objectForKey:@"Sender"];
    }
}

-(void)config_StarredCell
{
  self.username.text = @"STARRED";
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.image = [UIImage imageNamed:@"starred"];
}



@end
