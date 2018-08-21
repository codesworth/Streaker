//
//  LeaderBoardHelperVC.m
//  CWStreaks
//
//  Created by Mensah Shadrach on 3/11/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import "LeaderBoardHelperVC.h"


@interface LeaderBoardHelperVC ()
@property(nonatomic,strong)NSArray<NSString*>* categories;

@end

@implementation LeaderBoardHelperVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Categories";
    self.categories = @[@"Streaks",@"Loosing Streak",@"Challenge Wins",@"Challenge Points",@"Challenge Series Sweeps"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return self.categories.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBH" forIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"SFMono-Regular" size:16];
    cell.textLabel.text = [self.categories objectAtIndex:indexPath.row];
    
    return cell;
}

-(void)configCell:(UITableViewCell*)cell atIndex:(NSIndexPath*)indexPath
{
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate LeaderBoardCategoryDidFinishSelectingCategoryAt:indexPath.row];
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)UserDidCancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{}];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
