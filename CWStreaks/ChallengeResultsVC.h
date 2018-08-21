//
//  ChallengeResultsVC.h
//  CWStreaks
//
//  Created by Mensah Shadrach on 1/25/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CW-Predef_Header.h"
#import "ViewController.h"

@interface ChallengeResultsVC : UIViewController
@property (strong, nonatomic)Challenge* challenge;
@property (nonatomic)NSUInteger sectionType;
@end
