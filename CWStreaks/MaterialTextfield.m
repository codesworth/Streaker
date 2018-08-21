//
//  MaterialTextfield.m
//  CWStreaks
//
//  Created by Mensah Shadrach on 11/21/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

#import "MaterialTextfield.h"

@implementation MaterialTextfield

-(void)awakeFromNib{
    [super awakeFromNib];
    self.layer.cornerRadius = 2.0;
    self.layer.borderColor = [UIColor grayColor].CGColor;
    self.layer.borderWidth = 1.0;
}

-(CGRect)textRectForBounds:(CGRect)bounds{
    return CGRectInset(bounds, 10, 0);
}

-(CGRect)editingRectForBounds:(CGRect)bounds{
    return CGRectInset(bounds, 10, 0);
}
@end
