//
//  CustomLabels.m
//  CWStreaks
//
//  Created by Mensah Shadrach on 1/15/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import "CustomLabels.h"

@implementation CustomLabels

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.layer.cornerRadius = 3.0;
    self.layer.shadowColor = [UIColor grayColor].CGColor;
    self.layer.shadowOpacity = 0.8;
    self.layer.shadowRadius = 5.0;
    self.layer.shadowOffset = CGSizeMake(0.0, 2);
}

@end
