//
//  UserResultsVC.h
//  CWStreaks
//
//  Created by Mensah Shadrach on 1/15/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import "CW-Predef_Header.h"


@interface UserResultsVC : UIViewController

@property(strong, nonatomic, nullable)Gamer* user;
@property(nonatomic)NSInteger userPosition;
@property (weak, nonatomic,nullable) IBOutlet MaterialView *userOptions;
@property (nonnull, nonatomic, strong)ScoreData* manager;
@property(nonatomic, strong,nullable)NSString* uid;
@end
