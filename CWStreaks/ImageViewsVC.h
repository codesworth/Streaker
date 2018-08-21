//
//  ImageViewsVC.h
//  CWStreaks
//
//  Created by Mensah Shadrach on 3/24/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import "CW-Predef_Header.h"
@import Photos;
@interface ImageViewsVC : UIViewController<UIScrollViewDelegate>

@property(nonatomic,strong,nullable)UIImage* image;
@property (strong, nonatomic) IBOutlet UIScrollView * _Nullable mainScrollView;

@end
