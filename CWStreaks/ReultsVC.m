//
//  ReultsVC.m
//  CWStreaks
//
//  Created by Mensah Shadrach on 11/27/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

#import "ReultsVC.h"

@interface ReultsVC ()

@property (weak, nonatomic) IBOutlet UILabel *classicHS;
@property (weak, nonatomic) IBOutlet UILabel *regularHS;
@property (weak, nonatomic) IBOutlet UILabel *highStreak;
@property (weak, nonatomic) IBOutlet UILabel *alltimeHS;
@property (weak, nonatomic) IBOutlet UILabel *bestRegodds;
@property (weak, nonatomic) IBOutlet UILabel *bestClassicOdds;
@property (weak, nonatomic) IBOutlet UILabel *oSE;
@property (weak, nonatomic) IBOutlet UILabel *totalGamesPlayed;

@property (strong,nonatomic) ScoreData* manager;
@end

@implementation ReultsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager = [ScoreData mainData];
    double regOdds = (double)(_manager.regularhighscore)/ 82.00;
    double classOdss = (double)(_manager.classicHighscore) / 24.00;
    double oSE = (double)(_manager.alltotalgameScore) /(double)(_manager.lifetimegameCount) * 100;

    _classicHS.text = [NSString stringWithFormat:@"%lu", (unsigned long)_manager.classicHighscore];
    _regularHS.text = [NSString stringWithFormat:@"%lu", (unsigned long) _manager.regularhighscore];
    
    _highStreak.text = [NSString stringWithFormat:@"%lu", (unsigned long)_manager.highstreak];
    
    _alltimeHS.text = [NSString stringWithFormat:@"%lu", (unsigned long)_manager.alltotalgameScore];
    _bestRegodds.text = [NSString stringWithFormat:@"%.3f",regOdds];
    _bestClassicOdds.text = [NSString stringWithFormat:@"%.2f/sec",classOdss];
    _oSE.text = [NSString stringWithFormat:@"%.2f%%", oSE];
    _totalGamesPlayed.text = [NSString stringWithFormat:@"%lu", (unsigned long) _manager.lifetimegameCount];
}

- (IBAction)cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
