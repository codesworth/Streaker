//
//  LeaderboardVC.m
//  CWStreaks
//
//  Created by Mensah Shadrach on 1/10/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import "LeaderboardVC.h"

@interface LeaderboardVC ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameTypeSegment;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UIButton *switchResultsButton;
@property (weak, nonatomic) IBOutlet UIView *activityView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic)NSUInteger index;
@property(nonatomic)NSUInteger endValue;
@property(nonatomic)NSString* child;
@end

NSMutableArray* array;
NSMutableArray<Gamer*>* arrays;
@implementation LeaderboardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _gamers = [[NSMutableArray alloc] init];
    array = [[NSMutableArray alloc] init];
    arrays = [[NSMutableArray alloc] init];
    [self.activityView.layer setCornerRadius:5];
    [self.activityIndicator startAnimating];
    /*[[DatabaseService main] fb_fetchScoreData:_gamers exec:^{
        array = [[LeaderBoardConfig mainConfig] sort_RGL_withSortDescriptors:_gamers];
        [self.tableView reloadData];
        }];*/
    [[DatabaseService main]fb_fetchTop_ScoreData:_gamers child:FIR_DB_REF_SC_REGL_GAMEHIGHSCORE endValue:82 exec:^{

        array = [[LeaderBoardConfig mainConfig]sort_RGL_withSortDescriptors:_gamers];
        [self.activityIndicator stopAnimating];[self.activityView setHidden:YES];
        [self.tableView reloadData];
        Gamer* gamer = (Gamer*)[array lastObject];
        _endValue = [(NSNumber*)[gamer.scoreData objectForKey:FIR_DB_REF_SC_REGL_GAMEHIGHSCORE] unsignedIntegerValue];
        _child = FIR_DB_REF_SC_REGL_GAMEHIGHSCORE;
    }];
    [_tableView reloadData];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self configIndex];
}

-(void)setArray
{
    LeaderBoardConfig* config = [LeaderBoardConfig mainConfig];
    
    switch (self.index) {
        case 0:
            array = [[LeaderBoardConfig mainConfig] sort_RGL_withSortDescriptors:_gamers];
            break;
        case 1:
            array = [[LeaderBoardConfig mainConfig] sort_CLSS_SC_withSortDescriptors:_gamers];
            break;
        case 2:
            array = [[LeaderBoardConfig mainConfig] sort_Percentage_withSortDescriptors:_gamers];
            break;
        case 3:
           array = [config sort_HSK_withSortDescriptors:self.gamers];
            break;
        case 4:
           array = [config sortLoosingStreak:self.gamers];
            break;
        case 5:
            array = [config sort_ChallengeWins:self.gamers];
            break;
        case 6:
            array = [config sortTopChallengers:self.gamers];
            break;
        case 7:
           array = [config sort_Challenge_sweeps:self.gamers];
        default:
            break;
    }
    [_tableView reloadData];
}

-(void)configIndex
{
    [self.activityIndicator startAnimating];[self.activityView setHidden:NO];
    LeaderBoardConfig* config = [LeaderBoardConfig mainConfig];
    if (self.index > 4){
       [self.gamers removeAllObjects];
        [[DatabaseService main]fb_fetchTop_ScoreData:self.gamers child:CHLL_PNTS_GMWN_PNTS endValue:1000000 exec:^{
            if (self.index == 5){
                _child = CHLL_PNTS_GMWN_PNTS;
                array = [config sort_ChallengeWins:self.gamers];
                Gamer* gamer = (Gamer*)[array lastObject];
                _endValue = [(NSNumber*)[gamer.scoreData objectForKey:CHLL_PNTS_WN_RCRD] unsignedIntegerValue];
            }else if (self.index == 6){
                array = [config sortTopChallengers:self.gamers];
               
                Gamer* gamer = (Gamer*)[array lastObject];
                _endValue = [(NSNumber*)[gamer.scoreData objectForKey:CHLL_PNTS_GMWN_PNTS] unsignedIntegerValue];
            }else if (self.index == 7){
                array = [config sort_Challenge_sweeps:self.gamers];
                
                Gamer* gamer = (Gamer*)[array lastObject];
                _endValue = [(NSNumber*)[gamer.scoreData objectForKey:CHLL_PNTS_SRSSWP_PTS] unsignedIntegerValue];
            }
            [_tableView reloadData];
            [self.activityIndicator stopAnimating];[self.activityView setHidden:YES];
        }];
    }
    
    if (self.index == 3) {
        
        array = [config sort_HSK_withSortDescriptors:self.gamers];
        Gamer* gamer = (Gamer*)[array lastObject];
        _endValue = [(NSNumber*)[gamer.scoreData objectForKey:FIR_DB_REF_SC_REGL_GAMEHIGHSCORE] unsignedIntegerValue];
    }else if (self.index == 4){
        
        array = [config sortLoosingStreak:self.gamers];
        
        Gamer* gamer = (Gamer*)[array lastObject];
        _endValue = [(NSNumber*)[gamer.scoreData objectForKey:FIR_DB_REF_SC_REGL_GAMEHIGHSCORE] unsignedIntegerValue];
    }
    
    [self.tableView reloadData];
    [self.activityIndicator stopAnimating];[self.activityView setHidden:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self.navigationItem setTitle:@"Leaderboard"];
    //NSLog(@"the real index is %lu", self.index);
}

-(void)segmentConfig
{
    NSInteger index = self.gameTypeSegment.selectedSegmentIndex;
    switch (index) {
        case 0:{
            self.index = 0;
            array = [[LeaderBoardConfig mainConfig] sort_RGL_withSortDescriptors:_gamers];
            [self.tableView reloadData];
            Gamer* gamer = (Gamer*)[array lastObject];
            _endValue = [(NSNumber*)[gamer.scoreData objectForKey:FIR_DB_REF_SC_REGL_GAMEHIGHSCORE] unsignedIntegerValue];
            break;
        }
        case 1:
        {
            self.index = 1;
            [self.activityView setHidden:NO];[self.activityIndicator startAnimating];
            [self.gamers removeAllObjects];
            [[DatabaseService main]fb_fetchTop_ScoreData:self.gamers child:FIR_DB_REF_CLSSC_GAMEHIGHSCORE endValue:100 exec:^{
                _child = FIR_DB_REF_CLSSC_GAMEHIGHSCORE;
                array = [[LeaderBoardConfig mainConfig] sort_CLSS_SC_withSortDescriptors:_gamers];
                [self.activityIndicator stopAnimating];[self.activityView setHidden:YES];
                [self.tableView reloadData];
                Gamer* gamer = (Gamer*)[array lastObject];
                _endValue = [(NSNumber*)[gamer.scoreData objectForKey:FIR_DB_REF_SC_REGL_GAMEHIGHSCORE] unsignedIntegerValue];
            }];
            break;
        }
        case 2:{
            [self.activityView setHidden:NO];[self.activityIndicator startAnimating];
            self.index = 2;
            array = [[LeaderBoardConfig mainConfig] sort_Percentage_withSortDescriptors:_gamers];
            [self.tableView reloadData];
            [self.activityIndicator stopAnimating];[self.activityView setHidden:YES];
            //Gamer* gamer = (Gamer*)[array lastObject];
            //_endValue = [(NSNumber*)[gamer.scoreData objectForKey:FIR_DB_REF_SC_REGL_GAMEHIGHSCORE] unsignedIntegerValue];
            break;
        }
        default:
            break;
    }
}

- (IBAction)switchResults:(id)sender {

    [self performSegueWithIdentifier:@"Categories" sender:nil];

}

//MARK:-  TABLEVIEW DELEGATE IMPLEMENTATION

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return array.count;
    }else{
        return 1;
    }
}
- (IBAction)segmentedControlSwitchChanged:(id)sender {
    [self segmentConfig];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0){
        Gamer* gamer = [array objectAtIndex:indexPath.row];
        LeaderBoardCells* cells = [tableView dequeueReusableCellWithIdentifier:REUSE_ID_LEADERBOARD_CELLS forIndexPath:indexPath];
        [cells configureCells:gamer selectedSegment:self.index atIndexPath:indexPath];
        return cells;
    }else{
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"LoadMore" forIndexPath:indexPath];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(array.count > 0){
        if (indexPath.section == 0) {
            Gamer* gamer = [array objectAtIndex:indexPath.row];
            [self performSegueWithIdentifier:SEGUE_LEAD_USER sender:gamer];
        }else{
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"LoadMore" forIndexPath:indexPath];
            UIActivityIndicatorView* activity = [cell viewWithTag:49];
            [activity startAnimating];
            [[DatabaseService main]fb_fetchTop_ScoreData:_gamers child:_child endValue:_endValue exec:^{
                NSOrderedSet *set = [NSOrderedSet orderedSetWithArray:_gamers];
                self.gamers = [set.array mutableCopy];
                [self setArray];
                [activity stopAnimating];
            }];
            //[tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
}
- (IBAction)cancelButtontapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];

}

-(void)LeaderBoardCategoryDidFinishSelectingCategoryAt:(NSUInteger)index
{
    self.index = index + 3;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:SEGUE_LEAD_USER ] ){
        UserResultsVC* destination = [segue destinationViewController];
        Gamer* gamer = (Gamer*)sender;
        destination.user = gamer;
        destination.userPosition = [array indexOfObject:gamer] + 1;
        
    }else if ([segue.identifier isEqualToString:@"Categories"]){
        LeaderBoardHelperVC* lh = (LeaderBoardHelperVC*)[segue destinationViewController];
        lh.delegate = self;
    }
}

@end
