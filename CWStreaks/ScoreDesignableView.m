//
//  ScoreDesignableView.m
//  CWStreaks
//
//  Created by Mensah Shadrach on 1/8/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import "ScoreDesignableView.h"

@implementation ScoreDesignableView

-(void)awakeFromNib
{
    [super awakeFromNib];
    [[self layer] setCornerRadius:10];
    [[self layer] masksToBounds];
    [[self layer] setShadowColor:[[UIColor blackColor] CGColor]];
    [self.layer setShadowOffset:(CGSizeMake(0.0, 2.0))];
    [self.layer setShadowRadius:3.0];
}

@end
