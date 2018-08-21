//
//  FloatingViews.m
//  CWStreaks
//
//  Created by Mensah Shadrach on 1/15/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import "FloatingViews.h"

@implementation FloatingViews

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.layer.cornerRadius = self.frame.size.width /2;
    self.layer.shadowColor = [[UIColor clearColor] CGColor];
    [self.layer setShadowOpacity:0.8];
    self.layer.shadowRadius = 5.0;
    self.layer.shadowOffset = CGSizeMake(0, 2);
    self.layer.shadowOpacity = 1.0;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:100.0].CGPath;
    
}

@end
