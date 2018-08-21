//
//  ChallengeVCViewController.h
//  CWStreaks
//
//  Created by Mensah Shadrach on 1/19/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseService.h"
#import "ChallengeEngine.h"
#import "Constants.h"
#import "ChallengeCells.h"
#import "ChallengeResultsVC.h"
@interface ChallengeVC: UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,nullable,strong)NSString* sender;


@end
