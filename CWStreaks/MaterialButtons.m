//
//  MaterialButtons.m
//  CWStreaks
//
//  Created by Mensah Shadrach on 11/21/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

#import "MaterialButtons.h"

@implementation MaterialButtons

-(void)awakeFromNib{
    [super awakeFromNib];
    self.layer.cornerRadius = 3.0;
    self.layer.shadowColor = [UIColor grayColor].CGColor;
    self.layer.shadowOpacity = 0.8;
    self.layer.shadowRadius = 5.0;
    self.layer.shadowOffset = CGSizeMake(0.0, 2);
    
}


@end
