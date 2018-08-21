//
//  MaterialView.m
//  CWStreaks
//
//  Created by Mensah Shadrach on 10/31/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

#import "MaterialView.h"

#define IS_IPHONE_5_2 (fabs ((double)[[UIScreen mainScreen] bounds].size.height - (double)568 ) < DBL_EPSILON )

@implementation MaterialView

-(void) awakeFromNib{
    [super awakeFromNib];
    if (IS_IPHONE_5_2){
        
        //NSLog(@"%f", [[UIScreen mainScreen] bounds].size.height);
    }
    
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowRadius = 3.0;
    self.layer.shadowOffset = CGSizeMake(0, 2.0);
    self.layer.shadowOpacity = 0.9;
    self.layer.cornerRadius = 5.0;
    self.layer.masksToBounds = YES;
    //self.backgroundColor = [UIColor blueColor];
}

-(void)animateByShaking{

}






@end
