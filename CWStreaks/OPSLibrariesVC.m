//
//  ReportVC.m
//  CWStreaks
//
//  Created by Mensah Shadrach on 3/20/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import "OPSLibrariesVC.h"

@interface OPSLibrariesVC ()
@property(strong,nonatomic)NSArray* openSL;

@end

@implementation OPSLibrariesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationItem.title = @"Open Source Libraries";
    self.openSL = [Constants openSLs];
    // Do any additional setup after loading the view.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.openSL.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* opsl = [self.openSL objectAtIndex:indexPath.row];
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"OPENSL" forIndexPath:indexPath];
    UILabel* label = (UILabel*)[cell viewWithTag:10];
    label.text = opsl;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSNumber* index = [NSNumber numberWithUnsignedInteger:indexPath.row];
    //[self performSegueWithIdentifier:@"OPENSLD" sender:index];
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView* hv = (UITableViewHeaderFooterView*)view;
    //UILabel* label = [[UILabel alloc]init];
    hv.textLabel.font = [UIFont fontWithName:@"SFMono-Regular" size:15];
    hv.textLabel.textColor = [UIColor whiteColor ];
    //hv.backgroundColor = [UIColor clearColor];

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 80;;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Third Party Open Source Libraries used in the development of Streaker";
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"OPENSLD"]){
        OPENSLDVC* destination = [segue destinationViewController];
        if (sender){
            destination.openSLIndex = (NSNumber*)sender;
        }
    }
}

@end
