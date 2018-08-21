//
//  ExploreVC.m
//  CWStreaks
//
//  Created by Mensah Shadrach on 2/3/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import "ExploreVC.h"

@import CoreLocation;
@interface ExploreVC ()<CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *segConBot;
@property (weak, nonatomic) IBOutlet UISegmentedControl *searchSegment;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchBarHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *segmentHeight;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong,nonatomic, nonnull)NSMutableArray* nearUsers;
@property(strong, nonatomic,nonnull)NSMutableArray* allUsers;
@property(strong,nonatomic, nonnull)NSMutableArray* globalChallengers;
@property(strong, nonatomic, nullable)NSMutableArray* searchResults;
@property(strong,nullable,nonatomic)CLLocation* myLocale;
@property(nonatomic)CLLocationDistance baseRadius;
@property(strong, nonatomic, nullable)CLLocationManager* locationManager;
@property(nonatomic)BOOL isNearby;
@property(nonatomic)BOOL isTop;
@property(nonatomic)BOOL isSearching;
@property(nonatomic, strong)CLGeocoder* geocoder;
@property(nonatomic,nullable,strong)NSString* city;
@property(nonatomic)BOOL uploaded;
@property(nonatomic)NSUInteger queryLimit;
@property(nonatomic)CGFloat loadMoreHeight;
@property (strong, nonatomic) IBOutlet UIView *locationPermissionView;
@property(nonatomic)BOOL unlocationd;
@end

@implementation ExploreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar.topItem setTitle:@"Series"];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.searchBar setDelegate:self];
    [self.activityIndicator startAnimating];
    [self.activityView.layer setCornerRadius:5.0];
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    self.allUsers = [[NSMutableArray alloc]init];
    self.nearUsers = [[NSMutableArray alloc]init];
    self.globalChallengers = [[NSMutableArray alloc]init];
    self.searchResults = [[NSMutableArray alloc]init];
    self.searchSegment.selectedSegmentIndex = 0;
    //[self segmentedChanged:self];
    [self setIsNearby:NO];
    [self setIsTop:YES];
    [self setIsSearching:NO];
    [self getCurrenLocation];
    [self setQueryLimit:50];
    [[DatabaseService main]fetchallUsers:self.allUsers queryLimit:self.queryLimit exec:^{
        
        self.globalChallengers = [[LeaderBoardConfig mainConfig] sortTopChallengers:self.allUsers];
        [self.activityIndicator stopAnimating];[self.activityView setHidden:YES];
        [self.tableView reloadData];
        [self configureLoadmore];
//        if (self.city) {
//            self.nearUsers = [[LeaderBoardConfig mainConfig]sortLocalitynearbyUser:self.allUsers baseLocality:self.city];
//        }
    }];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    [self.locationManager stopUpdatingLocation];
    [self.locationManager setDelegate:nil];
    [DatabaseService removeAllobservers:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationItem setTitle:@"Explore"];
    [self.locationManager setDelegate:self];
}

#pragma mark - DELEGATES

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0){
        if (_isSearching) {
            return self.searchResults.count;
        }else{
            if(_isNearby){
                return self.nearUsers.count;
            }else if (_isTop){
                return self.globalChallengers.count;
            }else{
                return self.allUsers.count;
            }
        }
    }else if (section == 1){
        return 1;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0){
        Gamer* gamer = [self gamer:indexPath.row];
        LeaderBoardCells* cell = (LeaderBoardCells*)[tableView dequeueReusableCellWithIdentifier:REUSE_ID_LEADERBOARD_CELLS forIndexPath:indexPath];
        [cell configEx_cells:gamer];
        return cell;
    }else{
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"LoadMore" forIndexPath:indexPath];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0){
        Gamer* gamer = [self gamer:indexPath.row];
        [self performSegueWithIdentifier:_SEGUE_EXPLORE_USR sender:gamer];
    }else{
        
        [tableView setUserInteractionEnabled:NO];
        [self.activityIndicator startAnimating];[self.activityView setHidden:NO];
        [self fetchmoreUsers:^{
            [self.activityIndicator stopAnimating];[self.activityView setHidden:YES];
            [tableView reloadData];
            [tableView setUserInteractionEnabled:YES];
            [self configureLoadmore];

        }];
    }
}


-(void)configureLoadmore
{
    
    if(_queryLimit > [self.tableView numberOfRowsInSection:0]){
        self.loadMoreHeight = 0;
    }else{
        self.loadMoreHeight = 60;
    }
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:(UITableViewRowAnimationBottom)];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 60;
    }else{
        return self.loadMoreHeight;
    }
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.searchResults = [[LeaderBoardConfig mainConfig]returnSearchResultsFrom:self.allUsers keyString:searchText];
    [self.tableView reloadData];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    self.queryLimit = 50;
    [self.searchResults removeAllObjects];
    [self.tableView setUserInteractionEnabled:NO];
    [self.activityIndicator startAnimating];[self.activityView setHidden:NO];
    [[DatabaseService main]searchUserwith:searchBar.text.lowercaseString queryLimited:self.queryLimit into:self.searchResults on:^{
        [self.activityIndicator stopAnimating];[self.activityView setHidden:YES];
        [self.tableView setUserInteractionEnabled:YES];
        [self.tableView reloadData];
        [self configureLoadmore];
    }];
}


-(void)fetchmoreUsers:(Execute)onFinish
{
    if (self.queryLimit == [self.tableView numberOfRowsInSection:0]){
        if (_isSearching){
            [self.searchResults removeAllObjects];
            self.queryLimit = _queryLimit + 25;
            [[DatabaseService main]searchUserwith:self.searchBar.text queryLimited:_queryLimit into:self.searchResults on:^{
                onFinish();
            }];
        }else if (_isNearby){
            [self.nearUsers removeAllObjects];
           self.queryLimit = _queryLimit + 25;
            [[DatabaseService main]fetchNearbyUsers:self.city queryLimited:_queryLimit into:self.nearUsers onFinish:^{
                onFinish();
            }];
        }else{
            [self.allUsers removeAllObjects];
            self.queryLimit = _queryLimit + 25;
            [[DatabaseService main]fetchallUsers:self.allUsers queryLimit:self.queryLimit exec:^{
                self.globalChallengers = [[LeaderBoardConfig mainConfig] sortTopChallengers:self.allUsers];
                onFinish();
            }];
        }
    }
}

-(Gamer*)gamer:(NSUInteger)index
{
    if (_isSearching) {
        return (Gamer*)[self.searchResults objectAtIndex:index];
    }else{
        if (_isTop) {
            return (Gamer*)[_globalChallengers objectAtIndex:index];
        }else if (_isNearby){
            return (Gamer*)[_nearUsers objectAtIndex:index];
        }
    }
    return (Gamer*)[_allUsers objectAtIndex:index];
}

-(void)prepareUnLocationdView{
    if (_unlocationd) {
        [self.locationPermissionView setFrame:self.view.frame];
        [self.view addSubview:self.locationPermissionView];
        [self.view bringSubviewToFront:self.searchSegment];
    }else{
        [self.locationPermissionView removeFromSuperview];
    }
}

-(void)segmentConfig
{
    NSInteger index = self.searchSegment.selectedSegmentIndex;
    switch (index) {
        case 0:
            [self.locationPermissionView removeFromSuperview];
            self.queryLimit = 50;
            [self setIsNearby:NO];
            [self setIsTop:YES];
            [self.tableView reloadData];
            break;
        case 1:
        {
            self.queryLimit = 50;
            [self setIsTop:NO];
            [self setIsNearby:YES];
            [self prepareUnLocationdView];
            [self.nearUsers removeAllObjects];
            [[DatabaseService main]fetchNearbyUsers:self.city queryLimited:self.queryLimit into:self.nearUsers onFinish:^{
                [self.activityIndicator stopAnimating];[self.activityView setHidden:YES];
                [self.tableView reloadData];
            }];
            [self.tableView reloadData];
            break;
        }
        default:
            
            break;
    }
}

#pragma mark - IBACTIONS


- (IBAction)globalSelected:(id)sender {
    if (_isSearching) {
        [self setIsSearching:NO];
        self.isNearby = NO;self.isTop=NO;
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:0.4 options:(UIViewAnimationOptionCurveEaseIn) animations:^{
            [self.searchSegment setHidden:NO];
            [self.searchBarHeight setConstant:0];
            [self.segmentHeight setConstant:30];
            [self.segConBot setConstant:12];
        } completion:^(BOOL finished){[_tableView reloadData];}];
    }else{
        [self setIsSearching:YES];
        [self.locationPermissionView removeFromSuperview];
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:0.4 options:(UIViewAnimationOptionCurveEaseIn) animations:^{
            [self.segmentHeight setConstant:0];
            [self.searchSegment setHidden:YES];
            [self.segConBot setConstant:42];
            [self.searchBarHeight setConstant:40];

        } completion:^(BOOL finished){[_tableView reloadData];}];
    }
}
- (IBAction)segmentedChanged:(id)sender {
    [self segmentConfig];
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:_SEGUE_EXPLORE_USR]){
        UserResultsVC* destination = (UserResultsVC*)[segue destinationViewController];
        if (sender != nil) {
            Gamer* user = (Gamer*)sender;
            destination.user = user;
        }
    }
}


#pragma mark - Location

-(void)getCurrenLocation
{
    CLAuthorizationStatus authstatus = [CLLocationManager authorizationStatus];
    if(authstatus == kCLAuthorizationStatusNotDetermined){
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [self.locationManager setDesiredAccuracy:(kCLLocationAccuracyKilometer)];
    [self.locationManager startUpdatingLocation];
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //NSLog(@"Error occurred%@", error.description);
    UIAlertController* c = [Constants createDefaultAlert:@"GPS Error" title:@"Please enable location services for streaker inorder to find nearby streakers" message:@"Dismiss"];
    UIAlertAction* action = [UIAlertAction actionWithTitle:@"Settings" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
    }];
    [c addAction:action];
    self.unlocationd = YES;
    [self presentViewController:c animated:YES completion:nil];
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    
    //NSLog(@"The locations are %@", locations);
    self.unlocationd = NO;
    [self prepareUnLocationdView];
    CLLocation* lastLocation = [locations lastObject];
    self.geocoder = [[CLGeocoder alloc]init];
    [_geocoder reverseGeocodeLocation:lastLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error){
            //NSLog(@"Error occurred");
            [manager stopUpdatingLocation];
        }else{
            if (placemarks.count > 0){
                CLPlacemark* placeMark = [placemarks objectAtIndex:0];
                [self locationFomPlacemark:placeMark];
                return;
            }
        }
    }];
    
    [self.locationManager stopUpdatingLocation];
    
}

-(void)locationFomPlacemark:(CLPlacemark*)placeMark
{
    if (placeMark){
        [_locationManager stopUpdatingLocation];
        self.city = placeMark.locality;
        //NSLog(@"The city is %@", self.city);
        if (self.city != NULL && !_uploaded){
            NSDictionary* cityDict = @{FIR_DB_CITY:self.city.lowercaseString};
            [[DatabaseService main]updateUserLocation:cityDict e:^{
                _uploaded = YES;
                //[[DatabaseService main]fetchNearbyUsers:self.city.lowercaseString into:self.nearUsers onFinish:^{
                    //
                //}];
            }];
        }
        
    }
}
- (IBAction)locationServicePPressed:(id)sender {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
}

@end
