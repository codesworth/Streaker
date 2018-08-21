//
//  ChallengeVCViewController.m
//  CWStreaks
//
//  Created by Mensah Shadrach on 1/19/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import "ChallengeVC.h"

@interface ChallengeVC () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong, nonatomic)UIRefreshControl* refresh;
@property(strong, nonatomic,nullable)NSString* username;
@property(strong, nonatomic,nullable)NSString* receipient;
@property(strong, nonatomic,nullable)UIImage* sAvatar;
@property(strong, nonatomic,nullable)UIImage* rAvatar;
@property (weak, nonatomic) IBOutlet UICollectionView *challengeCollection;
@property(strong,nonatomic)NSMutableArray* availableChallenges;
@property(nonatomic) NSUInteger index;
@property(nonatomic,strong)NSArray* colors;
@property(nonatomic)FIRDatabaseHandle handle;
@property(strong, nonatomic,nullable)IBOutlet UIView* reloadView;
@property(strong, nonatomic,nullable)NSMutableArray* challenges;
@property(strong, nonatomic,nullable)NSMutableArray* challengeRequests;
@property(strong, nonatomic,nullable)NSMutableArray* completedChallenges;
@property(strong, nonatomic,nullable)NSMutableArray* sectionTitles;
@property(strong, nonatomic,nullable)NSMutableDictionary* challengeDict;
@property (weak, nonatomic) IBOutlet UICollectionView *starredCollection;
@property (strong, nonatomic) IBOutlet UIView *starredView;
@property(strong,nonatomic,nonnull)NSMutableArray* starredChallenges;
@property(strong,nonatomic,nonnull)NSMutableDictionary* starredDict;
@property (weak, nonatomic) IBOutlet UIView *emptybackview;
@property (weak, nonatomic) IBOutlet UIView *tutView;
@property (weak, nonatomic) IBOutlet UIImageView *tutImageView;
@property(nonatomic)BOOL alreadyRun;
@property (weak, nonatomic) IBOutlet UIPageControl *pg_controller;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tutImgW;
@property(nonatomic)NSUInteger pageindex;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tutImgH;
@property(nonatomic)NSArray<NSString*>* images;
@end

CGColorRef a11;
CGColorRef b11;
CGColorRef c11;
CGColorRef d11;
CGColorRef e11;
CGColorRef f11;
CGColorRef g11;
CGColorRef h11;
CGColorRef i11;
CGColorRef j11;



UIView* blurView;
NSUInteger sectionType;
@implementation ChallengeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _index = 0;
    [self initColors];
    [self tutsetup];
    self.images = @[@"firstCHTut",@"secCHTut",@"thirdCCTut"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.challengeCollection.delegate = self;
    self.challengeCollection.dataSource = self;
    self.starredCollection.delegate = self;
    self.starredCollection.dataSource = self;
    [self.tableView.layer setCornerRadius:5.0];
    [self.reloadView.layer setCornerRadius:3];
    [self.navigationController.navigationItem setTitle:@"Challenge Series"];
    [self.navigationItem setTitle:@"Challenge Series"];
    _challengeDict = [[NSMutableDictionary alloc]init];
    _challenges = [[NSMutableArray alloc] init];
    _challengeRequests = [[NSMutableArray alloc]init];
    _completedChallenges = [[NSMutableArray alloc]init];
    self.availableChallenges = [[NSMutableArray alloc]init];
    self.starredChallenges = [[NSMutableArray alloc]init];
    [self setrefreshControl];
    [self fetchChallengeData];
    _sectionTitles = [[NSMutableArray alloc]init];
    [_sectionTitles addObject:CHLLNG_SCTN_RQST];
    [_sectionTitles addObject:CHLLNG_SCTN_ACTV];
    [_sectionTitles addObject:CHLLNG_SCTN_CMPLTD];
    //[_challengeDict setObject:_challengeRequests forKey:CHLLNG_SCTN_RQST];
    //[_challengeDict setObject:_challenges forKey:CHLLNG_SCTN_ACTV];
    [_challengeDict setObject:_completedChallenges forKey:CHLLNG_SCTN_CMPLTD];
    if(self.navigationController.navigationItem.backBarButtonItem == nil){
        UIBarButtonItem* leftItem = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:(UIBarButtonItemStylePlain) target:self action:@selector(dismiss)];
        [self.navigationController.navigationItem setBackBarButtonItem:leftItem];
    }
    [self animate:0];
    [self listenForReload];
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    self.alreadyRun = [[NSUserDefaults standardUserDefaults]boolForKey:NSStringFromSelector(@selector(alreadyRun))];
    if (!_alreadyRun){
        [self tutAnimation];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:NSStringFromSelector(@selector(alreadyRun))];
    }
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self initStarredView];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [DatabaseService removeAllobservers:nil];
}

-(void)listenForReload
{

}

-(void)loadCompleted
{
    [_completedChallenges removeAllObjects];
    NSError* error;
    NSString* dir = [Constants create_return_Directory:FILE_DIR_COMPLETED];
    NSArray *paths = [[NSFileManager defaultManager]contentsOfDirectoryAtPath:dir error:&error];
    if(error){
        
    }else{
    for (NSString* path in paths) {
        NSString* p = [self enumeratorForPath:path from:dir];
        NSData* data = [NSData dataWithContentsOfFile:p];
        Challenge* ch = (Challenge*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        [_completedChallenges addObject:ch];
        }
    }
}

-(NSString*)enumeratorForPath:(NSString*)directory from:(NSString*)parentPath
{
    NSString* dir = [parentPath stringByAppendingPathComponent:directory];
    return dir;
}

-(void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)reloadData
{
    
    if (self.refresh) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refresh.attributedTitle = attributedTitle;
        
    }
    [self.reloadView setHidden:YES];
    [self.tableView setBackgroundView:nil];
    [self.refresh endRefreshing];
    [self.tableView reloadData];
}

-(void)setrefreshControl
{
    self.refresh = [[UIRefreshControl alloc ]init];
    self.refresh.backgroundColor = [UIColor clearColor];
    [self.refresh setTintColor:[UIColor whiteColor]];
    [self.refresh addTarget:self action:@selector(fetchChallengeData) forControlEvents:(UIControlEventValueChanged)];
    [self.tableView setRefreshControl:self.refresh];
}

-(void)deleteFromLocal:(Challenge*)challenge
{
    NSError* error;
    NSString* filePath = [Constants createDirectoryForChat:challenge.key];
    [[NSFileManager defaultManager]removeItemAtPath:filePath error:&error];
    if (error) {
        //NSLog(@"Unable to delete chat data %@",error.description);
    }
    NSString* p = [NSString stringWithFormat:@"%@.plist",challenge.key];
    NSString* dir = [[Constants create_return_Directory:FILE_DIR_COMPLETED] stringByAppendingPathComponent:p];
    [[NSFileManager defaultManager]removeItemAtPath:dir error:&error];
    if (error) {

    }
}

-(void)fetchAvailable
{
    [self.availableChallenges removeAllObjects];
    for (Challenge* challenge in _challenges) {
        Results* results = challenge.results;
        NSDictionary* last = [results.allResults lastObject];
        if (results.allResults.count == 0 || last.count == 3 || [last objectForKey:[Constants uid]] == nil){
            [self.availableChallenges addObject:challenge];
        }
    }
    [self.challengeCollection reloadData];

}

-(void)fetchChallengeData
{
    [self.reloadView setHidden:NO];
    [_challengeRequests removeAllObjects];
    [_challenges removeAllObjects];
    [_completedChallenges removeAllObjects];
    [_tableView reloadData];
    [[DatabaseService main] fb_getCHRequests:^(id  _Nullable collection, NSError * _Nullable error) {
        if (error == nil) {
            NSArray* q = (NSArray*)collection;
            [_challengeRequests addObjectsFromArray:q];
            [_challengeDict setObject:_challengeRequests forKey:CHLLNG_SCTN_RQST];
            [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }
    }];
    [[DatabaseService main] fb_getPendingRequests:^(id  _Nullable collection, NSError * _Nullable error) {
        if (error == nil) {
            NSArray* a = (NSArray*)collection;
            [_challengeRequests addObjectsFromArray:a];
            [_challengeDict setObject:_challengeRequests forKey:CHLLNG_SCTN_RQST];
            
            [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }
    }];

    [[DatabaseService main] fb_fetch_ActiveCH:^(id  _Nullable collection, NSError * _Nullable error) {
        if (error == nil) {
            self.challenges = [(NSArray*)collection mutableCopy];
            [self.challengeDict setObject:self.challenges forKey:CHLLNG_SCTN_ACTV];
            [self loadCompleted];
            [self.refresh endRefreshing];
            [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            [self fetchAvailable];
            [self initStarredData];
        }
    }];


}

-(void)move:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{}];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationItem.title = @"Challenge Series";
    [self.tableView reloadData];
    if(_challenges.count == 0 && _completedChallenges.count == 0 && _challengeRequests.count == 0){
        
    }

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sectionTitles.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString* key = _sectionTitles[section];
    NSMutableArray* values = _challengeDict[key];
    if (values.count == 0 ){
        
        UILabel* emptyLabel = [[UILabel alloc]initWithFrame:self.emptybackview.frame];
        self.emptybackview.backgroundColor = [UIColor clearColor ];
        emptyLabel.tag = 50;
        emptyLabel.text = @"No Challenges Here";
        emptyLabel.textColor = [UIColor whiteColor];
        emptyLabel.font = [UIFont fontWithName:@"SFMono-Bold" size:16];
        [emptyLabel setNumberOfLines:1];
        [emptyLabel setTextAlignment:(NSTextAlignmentCenter)];
        [emptyLabel sizeToFit];
        self.emptybackview = emptyLabel;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        return 0;
    }else{self.tableView.backgroundView = nil;}

    return values.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChallengeCells* cell = (ChallengeCells*)[tableView dequeueReusableCellWithIdentifier:REUSE_ID_CHLLNG_CLL];
    NSString* key = _sectionTitles[indexPath.section];
    NSArray* arrays = [_challengeDict objectForKey:key];
    
    Challenge* challenge = [arrays objectAtIndex:indexPath.row];
    
    [cell configureCell:challenge];
    
    return cell;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_sectionTitles objectAtIndex:section];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* key = _sectionTitles[indexPath.section];
    NSArray* arrays = [_challengeDict objectForKey:key];
    Challenge* challenge = [arrays objectAtIndex:indexPath.row];
    if (indexPath.section == 0){
        
//        NSLog(@"Senderrrrr:::: %@", challenge.sender);
//        NSLog(@"Senderrrrr::::selfff  %@", selff.uid);
        if([challenge.sender isEqualToString:[Constants uid]]){}else{[self challengeResponse:challenge table:tableView at:indexPath];}
        
    }else if (indexPath.section == 1 || indexPath.section == 2){
        //ChallengeCells* cell = (ChallengeCells*)[tableView cellForRowAtIndexPath:indexPath];
        sectionType = indexPath.section;
        [self performSegueWithIdentifier:SEGUE_CHALL_RESULTS sender:challenge];
    }else{
        
    }

}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return YES;
    }
    return YES;
}

-(NSArray<UITableViewRowAction*>*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* key = _sectionTitles[indexPath.section];
    NSArray* arrays = [_challengeDict objectForKey:key];
    Challenge* challenge = [arrays objectAtIndex:indexPath.row];
    UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleDestructive) title:@"      " handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        if (indexPath.section == 2){
            [_completedChallenges removeObject:challenge];
            //[[DatabaseService main]removeFinished:challenge exec:^{}];
            [self deleteFromLocal:challenge];
            [tableView reloadData];
        }else if(indexPath.section == 0){
            NSString* uid = [[NSUserDefaults standardUserDefaults]stringForKey:USER_UID__];
            [_challengeRequests removeObject:challenge];
            if([challenge.sender isEqualToString:uid]){
               [[DatabaseService main]removePending:challenge exec:^{}];
            }else{
                [[DatabaseService main]removeRequest:challenge exec:^{}];
            }
            
            [tableView reloadData];
        }else if (indexPath.section == 1){

            [self presentForfeitAlert:challenge at:indexPath];
            [tableView reloadData];
        }
    }];
    UITableViewRowAction* star = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleNormal) title:@"       " handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        if (indexPath.section == 1){
            [self configureStarredDict:challenge.key];
            

        }
        [self.tableView reloadData];
    }];
    UIImage* image = [UIImage imageNamed:@"trash"];
    UIImage* image1 = [UIImage imageNamed:@"star"];
    [star setBackgroundColor:[UIColor colorWithPatternImage:image1]];
    [delete setBackgroundColor:[UIColor colorWithPatternImage:image]];
    return @[delete,star];
}

-(void)configureStarredDict:(NSString*)key
{
    self.starredDict = [[[NSUserDefaults standardUserDefaults]objectForKey:@"Starred"] mutableCopy];
    if (self.starredDict == NULL) {
        _starredDict = [NSMutableDictionary new];
    }
    [self.starredDict setObject:key forKey:key];
    [[NSUserDefaults standardUserDefaults]setObject:_starredDict forKey:@"Starred"];
    [self.starredChallenges removeAllObjects];
    for (NSString* c_key in [self.starredDict allKeys]) {
        Challenge* challenge = [self returnChallenge:c_key];
        if (challenge != NULL) {
            [self.starredChallenges addObject:challenge];
            
        }
    }
}

-(Challenge*)returnChallenge:(NSString*)key
{
    for (Challenge* challenge in self.challenges) {
        if ([key isEqualToString:challenge.key]) {
            return challenge;
        }
    }
    return nil;
}

-(void)initStarredData
{
    self.starredDict = [[[NSUserDefaults standardUserDefaults]objectForKey:@"Starred"] mutableCopy];
    for (NSString* c_key in [self.starredDict allKeys]) {
        Challenge* challenge = [self returnChallenge:c_key];
        if (challenge != NULL) {
            [self.starredChallenges addObject:challenge];
            
        }
    }

    
}

-(void)presentForfeitAlert:(Challenge*)challenge at:(NSIndexPath*)indexPath
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Forfeit" message:@"You are about to forfeit and choke away this challenge series. This will result in automatic loss of this series which will be added to your total number of losses" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction* play = [UIAlertAction actionWithTitle:@"Play On" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {}];
    UIAlertAction* forfeit = [UIAlertAction actionWithTitle:@"Forfeit" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
        [[DatabaseService main]forfeitGame:challenge e:^{
            //[self fetchChallengeData];
            [_challenges removeObjectAtIndex:indexPath.row];
            [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop | UITableViewRowAnimationLeft];
        }];
    }];
    [alert addAction:play];
    [alert addAction:forfeit];

    [self presentViewController:alert animated:YES completion:nil];
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    
    UITableViewHeaderFooterView* header = (UITableViewHeaderFooterView*)view;
    [header.textLabel setFont:[UIFont fontWithName:@"SFMono-Regular" size:15]];
    [header.contentView setBackgroundColor:[UIColor whiteColor]];

}

-(void)challengeResponse:(Challenge*)challenge table:(UITableView*)tableView at:(NSIndexPath*)indexpath
{
    UIAlertController* response = [UIAlertController alertControllerWithTitle:@"Challenge Request" message:@"" preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction* accept = [UIAlertAction actionWithTitle:@"Accept" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [[DatabaseService main] fb_AcceptCH_Request:challenge didFinish:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_challengeRequests removeObject:challenge];
                    [tableView deleteRowsAtIndexPaths:@[indexpath] withRowAnimation:(UITableViewRowAnimationTop)];
                    [self.tableView reloadData];
                });
            }];
    }];
    UIAlertAction* deny = [UIAlertAction actionWithTitle:@"Deny" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        [[DatabaseService main] fb_RejectCH_Request:challenge];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_challengeRequests removeObject:challenge];
            [tableView deleteRowsAtIndexPaths:@[indexpath] withRowAnimation:(UITableViewRowAnimationTop)];
            [self.tableView reloadData];
        });
        
    }];
    
    /*UIAlertAction* block = [UIAlertAction actionWithTitle:@"Block" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
        //
    }];*/
    
    [response addAction:accept];
    [response addAction:deny];
    //[response addAction:block];
    [self presentViewController:response animated:YES completion:^{}];
}

#pragma CollectionView

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (collectionView == self.challengeCollection){
        return 2;
    }else if (collectionView == _starredCollection){
        return 1;
    }
    return 0;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == _challengeCollection){
        if (section == 1) {
            return self.availableChallenges.count;
        }
        return 1;
    }else if (collectionView == _starredCollection){
        return self.starredChallenges.count;
    }
    return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == _challengeCollection) {
        if(indexPath.section == 0){
            ChallengeCollectionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ChallengeCollection" forIndexPath:indexPath];
            [cell config_StarredCell];
            return cell;
        }
        Challenge* challenge = [self.availableChallenges objectAtIndex:indexPath.row];
        ChallengeCollectionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ChallengeCollection" forIndexPath:indexPath];
        [cell configureCollectionCell:challenge];
        return cell;
    }else if (collectionView == _starredCollection){
        Challenge* challenge = [self.starredChallenges objectAtIndex:indexPath.row];
        ChallengeCollectionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ChallengeCollection" forIndexPath:indexPath];
        [cell configureCollectionCell:challenge];
        return cell;
    }
    return [ChallengeCollectionCell new];
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.challengeCollection) {
        if (indexPath.section == 1){
            Challenge* challenge = self.availableChallenges[indexPath.row];
            sectionType = 1;
            [self performSegueWithIdentifier:SEGUE_CHALL_RESULTS sender:challenge];
        }else{
            [self presentStarredView];
            
        }
    }else if (collectionView == _starredCollection){
        Challenge* challenge = self.starredChallenges[indexPath.row];
        sectionType = 1;
        [self performSegueWithIdentifier:SEGUE_CHALL_RESULTS sender:challenge];
        [self removeAnimation];
    }
    
}

-(void)initColors
{
    a11= [[UIColor colorWithRed:0.420 green:0 blue:0.765 alpha:1]CGColor];
    b11 = [[UIColor whiteColor] CGColor];
    //[[UIColor colorWithRed:0.443 green:0 blue:0.714 alpha:1]CGColor];
    c11 = [[UIColor colorWithRed:0.467 green:0 blue:0.663 alpha:1]CGColor];
    d11 = [[UIColor whiteColor] CGColor];
    //[[UIColor colorWithRed:0.490 green:0 blue:0.616 alpha:1]CGColor];
    e11 = [[UIColor colorWithRed:0.514 green:0 blue:0.565 alpha:1]CGColor];
    f11 = [[UIColor whiteColor] CGColor];//[[UIColor colorWithRed:0.541 green:0 blue:0.518 alpha:1]CGColor];
    g11 = [[UIColor colorWithRed:0.565 green:0 blue:0.467 alpha:1]CGColor];
    h11 = [[UIColor whiteColor] CGColor];//[[UIColor colorWithRed:0.588 green:0 blue:0.420 alpha:1]CGColor];
    i11 = [[UIColor colorWithRed:0.612 green:0 blue:0.369 alpha:1]CGColor];
    j11 = [[UIColor whiteColor] CGColor];//[[UIColor colorWithRed:0.635 green:0 blue:0.318 alpha:1]CGColor];
    
    _colors = @[(__bridge id)a11,(__bridge id)b11,(__bridge id)c11,(__bridge id)d11,(__bridge id)e11, (__bridge id)f11, (__bridge id)g11, (__bridge id)h11, (__bridge id)i11, (__bridge id)j11];
}



-(void)animate:(NSUInteger)index
{
    id color = [_colors objectAtIndex:index];
    [Constants dynamicOverlay:self.reloadView.layer color:color did:^{
        [Constants delayWithSeconds:1 exec:^{
            if (index < _colors.count -1){
                [self reanimateLayer:index];
            }else{[self reverseLayerAnimation:index];}
        }];
    }];
}

-(void)reverseLayerAnimation:(NSUInteger)index
{
    index = index -1;
    id color = [_colors objectAtIndex:index];
    [Constants dynamicOverlay:self.reloadView.layer color:color did:^{
        [Constants delayWithSeconds:1 exec:^{
            if (index == 0){
                [self animate:index];
            }else{[self reverseLayerAnimation:index];}
        }];
    }];
}

-(void)reanimateLayer:(NSUInteger)index
{   NSUInteger newIndex = index + 1;
    [self animate:newIndex];
}


//======================================================================
//MARK:- PrepareForSegue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender

{
    if ([segue.identifier isEqualToString:SEGUE_CHALL_RESULTS]) {
        ChallengeResultsVC* destination = (ChallengeResultsVC*)[segue destinationViewController];
        if(sender != nil){
            destination.challenge = (Challenge*)sender;
            destination.sectionType = sectionType;
        }
    }
}
- (IBAction)dismissView:(id)sender {
    if(self.sender){
       [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)explorebutton:(id)sender {
    [self performSegueWithIdentifier:@"Explore" sender:nil];
}

-(void)initStarredView
{
    CGRect frame =  self.view.frame;
    [self.starredView setFrame:frame];
    //self.starredView.center = self.view.center;
    //[self.starredView.layer setCornerRadius:15];
    [self.view addSubview:self.starredView];
    [self.starredView setAlpha:0];
    [self.starredView setHidden:YES];
}


-(void)presentStarredView
{
    
    
        [_starredCollection reloadData];
    [UIView animateWithDuration:3 delay:0.2 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:(UIViewAnimationOptionTransitionCrossDissolve) animations:^{
        
        [self.starredView setAlpha:1];
        [self.starredView setHidden:NO];
        
    } completion:^(BOOL finished) {}];
}
- (IBAction)dismissStarred:(UIButton *)sender {
    [self removeAnimation];
}

-(void)removeAnimation
{
    CGRect frame = CGRectMake(0, -(self.view.frame.size.height + 200), self.view.frame.size.width, self.view.frame.size.height);
    [UIView animateWithDuration:2.5 delay:0.2 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:(UIViewAnimationOptionTransitionCrossDissolve) animations:^{
        
        [self.starredView setFrame:frame];
        
        
    } completion:^(BOOL finished) {
        [self initStarredView];
    }];
}

-(void)tutAnimation
{
    CGAffineTransform transform = CGAffineTransformMakeScale(0.1, 0.1);
    self.tutImageView.transform = transform;
    [UIView transitionWithView:self.tutView duration:1 options:(UIViewAnimationOptionTransitionCrossDissolve) animations:^{
        [self.tutView setHidden:NO];
        [_tutView setAlpha:1];
        _tutImageView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
        [self tutImgAnimation];
    }];
}

-(void)tutImgAnimation
{
    //[self.tutView addSubview:_tutImageView];
    [self.tutImageView setImage:[UIImage imageNamed:[self image]]];
    
}

-(void)changeImgAnim
{
    self.pageindex++;
    _pg_controller.currentPage++;
    if (_pageindex < 3) {
        [self.tutImageView setImage:[UIImage imageNamed:[self image]]];
    }else {
        _pg_controller.currentPage = 0;
        _pageindex = 0;
        [self.tutImageView setImage:[UIImage imageNamed:[self image]]];
    }
    

}

-(NSString*)image
{
    return [_images objectAtIndex:self.pageindex];
    
}
-(void)tutsetup
{
    [self.tutView setHidden:YES];
    //[self.tutImageView removeFromSuperview];
    if (IS_IPHONE_5) {
        [_tutImgW setConstant:240];
        [_tutImgH setConstant:426];
    }
    if(IS_IPAD){
        [_tutImgW setConstant:400];
        [_tutImgH setConstant:712];
    }
    [self.tutView setAlpha:0];
    [_tutImageView.layer setCornerRadius:4.0];
    UISwipeGestureRecognizer* swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(changeImgAnim)];
    swipe.direction = UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeImgAnim)];
    [tap setNumberOfTapsRequired:1];
    [_tutView addGestureRecognizer:tap];
    [_tutView addGestureRecognizer:swipe];
}

- (IBAction)cancelTut:(id)sender {
    [_tutView removeFromSuperview];
 
}

@end

