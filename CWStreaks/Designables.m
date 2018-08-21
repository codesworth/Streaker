//
//  Designables.m
//  CWStreaks
//
//  Created by Mensah Shadrach on 10/31/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

#import "Designables.h"

@implementation Designables

-(void)awakeFromNib{
    [super awakeFromNib];
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowRadius = 3.0;
    self.layer.shadowOffset = CGSizeMake(2.0, 2.0);
    self.layer.shadowOpacity = 0.9;
    self.layer.cornerRadius = 3.0;
}

@end
