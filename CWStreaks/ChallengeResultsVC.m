//
//  ChallengeResultsVC.m
//  CWStreaks
//
//  Created by Mensah Shadrach on 1/25/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import "ChallengeResultsVC.h"
#import "CRGradientLabel.h"
#import "AvatarImage.h"

NSMutableArray* winsArray;

@interface ChallengeResultsVC () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *game5lbl;
@property (weak, nonatomic) IBOutlet UILabel *game6lbl;
@property (weak, nonatomic) IBOutlet UILabel *game7lbl;
@property (weak, nonatomic) IBOutlet UILabel *game1winner;
@property (weak, nonatomic) IBOutlet UILabel *game2winnwer;
@property (weak, nonatomic) IBOutlet UILabel *g3winner;
@property (weak, nonatomic) IBOutlet UILabel *g4winner;
@property (weak, nonatomic) IBOutlet UILabel *g5winner;
@property (weak, nonatomic) IBOutlet UILabel *g6winner;
@property (weak, nonatomic) IBOutlet UILabel *g7winer;

@property (weak, nonatomic) IBOutlet CRGradientLabel* points;
@property (weak, nonatomic) IBOutlet UILabel *serieswinpt;
@property(weak, nonatomic)IBOutlet UITableView* tableView;
@property (weak, nonatomic) IBOutlet UIButton *nextGameButton;
@property (weak, nonatomic) IBOutlet UILabel *gmWinPt;
@property(strong, nonatomic)NSArray* results;
@property(nonatomic)NSUInteger instanceOT;
@property(nonatomic)BOOL isOvertime;
@property (weak, nonatomic) IBOutlet UILabel *winLabel;
@property (strong, nonatomic) IBOutlet UIView *chOverview;
@property (weak, nonatomic) IBOutlet UILabel *sweeppts;
@property (weak, nonatomic) IBOutlet UILabel *challengePoints;
@property (weak, nonatomic) IBOutlet UILabel *challengeRecord;
@property(strong,nonatomic,nullable)NSMutableArray* gamewinsarray;
@property(nonatomic)BOOL rematchable;
@property (weak, nonatomic) IBOutlet UILabel *requestSentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *requestConstraint;
@property (weak, nonatomic) IBOutlet MaterialButtons *chatButton;
@property (strong, nonatomic)NSString* username;
@property (strong, nonatomic)NSString* receipient;
@property (strong, nonatomic)NSString* senderAvatar;
@property (strong, nonatomic)NSString* receipientAvatar;
@property(strong,nonatomic)Reachability* internet;
//@property(strong,nonatomic)NSArray* colors;

@end
NSUInteger handle;
NSMutableDictionary* dictionary;
CustomBadge* badge;




@implementation ChallengeResultsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.internet = [Reachability reachabilityForInternetConnection];
    //[self initColors];
    [self.navigationController.navigationBar.topItem setTitle:@""];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setRowHeight:90];
    self.username = [self configUsername:[Constants uid]];
    self.receipient = [self configUsername:[self opponent]];
    self.receipientAvatar = [self.challenge.usernames objectForKey:@"RecipientAvatar"];
    self.senderAvatar = [self.challenge.usernames objectForKey:@"SenderAvatar"];
    _isOvertime = NO;
    _rematchable = NO;
      [self.requestSentLabel.layer setCornerRadius:10];
    dictionary = [[NSMutableDictionary alloc]init];
    winsArray = [[NSMutableArray alloc]init];
    self.gamewinsarray = [[NSMutableArray alloc]init];
    [self setNextplayButton];
    //[[DatabaseService main] fb_fetchGameWins:self.challenge intoArray:winsArray exec:^{

    //}];
    NSMutableArray *dict = [self.challenge.results.rawData objectForKey:@"WINS"];if(dict){[winsArray addObject:dict];}
    [self updateWinnerStatus];
    [self configurePointsView];
    [[DatabaseService main]notifyMessageReceived:_challenge h:handle e:^{}];

    [self.game5lbl setHidden:YES];
    [self.game6lbl setHidden:YES];
    [self.game7lbl setHidden:YES];
    [self.g5winner setHidden:YES];
    [self.g6winner setHidden:YES];
    [self.g7winer setHidden:YES];
     badge = [CustomBadge customBadgeWithString:@"1"];

}

-(NSArray*)avatarImageSet
{
    if ([_challenge.sender isEqualToString:[Constants uid]]){
        NSArray* set = @[self.senderAvatar, self.receipientAvatar];
        return set;
    }else{
        NSArray* set = @[self.receipientAvatar,self.senderAvatar];
        return set;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
        self.navigationItem.title = [NSString stringWithFormat:@"Game with %@",[self configUsername:[self opponent]]];
    if (_internet.currentReachabilityStatus == NotReachable && _sectionType < 2){
        [self.nextGameButton setEnabled:NO];
        UIView* warnView = [[UIView alloc]initWithFrame:self.view.frame];
        [warnView setBackgroundColor:[UIColor darkGrayColor]];
        [warnView setAlpha:0.34];
        UIButton* warnButton = [[UIButton alloc]initWithFrame:CGRectMake(warnView.center.x - 100, warnView.center.y - 30, 200, 60)];
        [warnButton setTitle:@"No Internet Connection" forState:(UIControlStateNormal)];
        [warnButton addTarget:self action:@selector(dismiss) forControlEvents:(UIControlEventTouchUpInside)];
        [warnView addSubview:warnButton];
        [self.view addSubview:warnView];
    }
    if (self.sectionType == 1){
        //NSDictionary* last = [_challenge.results.allResults lastObject];
        [[DatabaseService main]returnInstanceOfOT:self.challenge with:dictionary exec:^{
            _instanceOT = dictionary.count;
            if (_instanceOT == 0){
                [self.nextGameButton setTitle:@"Play Next Game" forState:(UIControlStateNormal)];
            }else{
                NSMutableDictionary* lastGame = [self.challenge.results.allResults lastObject];
                NSUInteger i = [[lastGame objectForKey:@"OT"] unsignedIntegerValue];
                if( i > 0 && [lastGame objectForKey:[self opponent]] == NULL && lastGame.count > 3){        [self.nextGameButton setTitle:@"Awaiting...." forState:(UIControlStateNormal)];
                    [self.nextGameButton setEnabled:NO];}else if (i > 0 && [lastGame objectForKey:[Constants uid]] == NULL ){
                        [self.nextGameButton setTitle:@"Play Overtime" forState:(UIControlStateNormal)];
                        _isOvertime = YES;
                        [self.nextGameButton setEnabled:YES];
                    }

            }
        }];
    }else if (self.sectionType == 2){
        if (_internet.currentReachabilityStatus == NotReachable){
            [self.nextGameButton setEnabled:NO];
        }
        self.rematchable = YES;
        [self.nextGameButton setTitle:@"Rematch" forState:UIControlStateNormal];
        
    }
    self.results = [[NSArray alloc] initWithArray:_challenge.results.allResults];
    //NSLog(@"The result count issssss %ld", (unsigned long)_results.count);
    [self setNextplayButton];
    [[DatabaseService main]queryForChatMessages:self.challenge e:^{
        [badge setHidden:NO];
    }];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];

}

-(void)dismiss
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGRect frame = CGRectMake(self.view.frame.size.width + 200, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.chOverview setFrame:frame];
    [self.chOverview setBackgroundColor:[UIColor colorWithRed:0.161 green:0.7451 blue:1 alpha:1]];
    [self.view addSubview:_chOverview];
    //CGRect frame1 = CGRectMake((self.chatButton.frame.origin.x + self.chatButton.frame.size.width) - 12, (self.chatButton.frame.origin.y - self.chatButton.frame.size.height) - 10, badge.frame.size.width, badge.frame.size.height);
    CGRect frame1 = CGRectMake(50, -12, badge.frame.size.width, badge.frame.size.height);
    [badge setFrame:frame1];
    [self.chatButton addSubview:badge];
    [badge setHidden:YES];
  
}

-(NSString*)opponent
{
    if ([self.challenge.sender isEqualToString:[self uid]]){
        return self.challenge.receipient;
    }else{
        return self.challenge.sender;
    }
}
-(NSString*)uid{
    return [[NSUserDefaults standardUserDefaults]stringForKey:USER_UID__];
}

-(void)setNextplayButton
{
    NSMutableDictionary* lastGame = [self.challenge.results.allResults lastObject];
    if ([lastGame objectForKey:[self opponent]] == NULL && self.challenge.results.allResults.count != 0  && !_isOvertime){
        [self.nextGameButton setTitle:@"Awaiting...." forState:(UIControlStateNormal)];
         [self.nextGameButton setEnabled:NO];
    }
    /*if([lastGame objectForKey:@"OT"] == nil && [lastGame objectForKey:[self opponent]] == NULL && self.challenge.results.allResults.count != 0){
        //if (self.challenge.results.allResults.count == 0){}
        [self.nextGameButton setTitle:@"Awaiting...." forState:(UIControlStateNormal)];
        [self.nextGameButton setEnabled:NO];
    }*/
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.challenge.results.allResults.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChallengeCells* cell = (ChallengeCells*)[tableView dequeueReusableCellWithIdentifier:REUSE_ID_CHLLNG_CLL forIndexPath:indexPath];
    [cell configureGameCell:self.challenge atIndexPath:indexPath.row];
    return cell;
}

- (IBAction)playNextGame:(id)sender {
    if (_rematchable) {
        NSDictionary* usernames = [[NSDictionary alloc]init];
        NSString* date = [Constants stringFromDate:([NSDate date])];
        if ([[Constants uid] isEqualToString:_challenge.sender]){
             usernames = @{@"Sender":_username, @"Recipient":self.receipient,@"SenderAvatar":[self.challenge.usernames objectForKey:@"SenderAvatar"], @"RecipientAvatar":[self.challenge.usernames objectForKey:@"RecipientAvatar"]};
        }else{
            usernames = @{@"Sender":_username, @"Recipient":self.receipient,@"RecipientAvatar":[self.challenge.usernames objectForKey:@"SenderAvatar"], @"SenderAvatar":[self.challenge.usernames objectForKey:@"RecipientAvatar"]};
        }
        
    

        [[ChallengeEngine mainEngine]engine_createAndSendChallenge:[self uid] toRecipient:[self opponent] and:usernames withDate:date withChID:self.challenge.challengeID];
        [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.6 options:(UIViewAnimationOptionCurveEaseIn) animations:^{
            CGRect frame = CGRectMake((self.view.frame.size.width-300)/2, 80, 300, 50);
            [self.requestSentLabel setAlpha:1];
            [self.requestSentLabel setFrame:frame];
        } completion:^(BOOL finished){
            [Constants delayWithSeconds:2 exec:^{
                [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.6 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
                    [self.requestConstraint setConstant:-120];
                    [self.requestSentLabel setAlpha:0];
                } completion:nil];
            }];
        }];
    }else{
        [self performSegueWithIdentifier:SEGUE_CHALL_NXTCHLL_ sender:self.challenge];
    }
}

/*-(void)initColors
{
    a2= [[UIColor colorWithRed:0.133 green:0 blue:0.240 alpha:1]CGColor];
    b2 = [[UIColor colorWithRed:0.043 green:0 blue:0.078 alpha:1]CGColor];
    c2 = [[UIColor colorWithRed:0.086 green:0 blue:0.161 alpha:1]CGColor];
    d2 = [[UIColor colorWithRed:0.176 green:0 blue:0.322 alpha:1]CGColor];
    e2 = [[UIColor colorWithRed:0.220 green:0 blue:0.4 alpha:1]CGColor];
    f2 = [[UIColor colorWithRed:0.263 green:0 blue:0.490 alpha:1]CGColor];
    g2 = [[UIColor colorWithRed:0.310 green:0 blue:0.522 alpha:1]CGColor];
    h2 = [[UIColor colorWithRed:0.353 green:0 blue:0.639 alpha:1]CGColor];
    i2 = [[UIColor colorWithRed:0.396 green:0 blue:0.726 alpha:1]CGColor];
    j2 = [[UIColor colorWithRed:0.482 green:0 blue:0.996 alpha:1]CGColor];
    k2 = [[UIColor colorWithRed:0.529 green:0.039 blue: 0.961 alpha:1]CGColor];
    l2 = [[UIColor colorWithRed:0.569 green:0.122 blue:1 alpha:1]CGColor];
    m2 = [[UIColor colorWithRed:0.604 green:0.2 blue:1  alpha:1]CGColor];
    n2 = [[UIColor colorWithRed:0.675 green:0.278 blue:1 alpha:1]CGColor];
    o2 = [[UIColor colorWithRed:0.714 green:0.361 blue:1 alpha:1]CGColor];
    p2 = [[UIColor colorWithRed:0.749 green:0.439 blue:1 alpha:1]CGColor];
    q2 = [[UIColor colorWithRed:0.784 green:0.313 blue:1 alpha:1]CGColor];
    r2 = [[UIColor colorWithRed:0.820 green:0.6 blue:1 alpha:1]CGColor];
    s2 = [[UIColor colorWithRed:0.855 green:0.678 blue:1 alpha:1]CGColor];
    t2 = [[UIColor colorWithRed:0.890 green:0.761 blue:1 alpha:1]CGColor];
    u2 = [[UIColor colorWithRed:0.929 green:0.839 blue:1 alpha:1]CGColor];
    v2 = [[UIColor colorWithRed:0.965 green:0.922 blue:1 alpha:1]CGColor];
    w2 = [[UIColor colorWithRed:1 green:1 blue:1 alpha:1]CGColor];
    
    _colors = @[(__bridge id)a2,(__bridge id)b2,(__bridge id)c2,(__bridge id)d2,(__bridge id)e2, (__bridge id)f2, (__bridge id)g2, (__bridge id)h2, (__bridge id)i2, (__bridge id)j2,(__bridge id)k2, (__bridge id)l2, (__bridge id)m2, (__bridge id)n2,(__bridge id)o2, (__bridge id)p2, (__bridge id)q2, (__bridge id)r2,(__bridge id)s2, (__bridge id)t2, (__bridge id)u2, (__bridge id)v2,(__bridge id)w2];
}*/

-(void)updateWinnerStatus
{
    NSString* uid = [[NSUserDefaults standardUserDefaults]stringForKey:USER_UID__];
    NSUInteger me = 0;
    NSUInteger opponent = 0;
    NSMutableDictionary* winDict = [winsArray firstObject];
    for (NSString* key in winDict) {
        [self.gamewinsarray addObject:[winDict objectForKey:key]];
        NSString* winner = [winDict objectForKey:key];
        if ([winner isEqualToString:uid]){
            me++;
        }else{
            opponent++;
        }
        
    }
    NSMutableArray* leads = [[NSMutableArray alloc]initWithCapacity:4];
    NSUInteger lead = 0;
    if (winDict.count >3) {
        [leads addObject:[winDict objectForKey:GAME1]];
        [leads addObject:[winDict objectForKey:GAME2]];
        [leads addObject:[winDict objectForKey:GAME3]];
        [leads addObject:[winDict objectForKey:GAME4]];
        
        for (NSString* l in leads) {
            if ([l isEqualToString:uid]) {
                lead++;
            }
        }
    }
    
    if (lead == 3 && winDict.count == 7 && !([[winDict objectForKey:GAME7] isEqualToString:uid])) {
        [self setRematchable:YES];
        self.winLabel.text = @"You blew a 3-1 lead 😝😝😝";
        [self.nextGameButton setEnabled:YES];
        [self.nextGameButton setTitle:@"Rematch" forState:(UIControlStateNormal)];
        self.gmWinPt.text = [NSString stringWithFormat:@"%f",3.0 * 2];
    }else{
        if (me > opponent && me > 3 && opponent != 0){
            self.winLabel.text = [NSString stringWithFormat:@"You won %lu-%lu", (unsigned long)me,(unsigned long)opponent];
            [self setRematchable:YES];
            [self.nextGameButton setEnabled:YES];
            [self.nextGameButton setTitle:@"Rematch" forState:(UIControlStateNormal)];
            self.gmWinPt.text = [NSString stringWithFormat:@"%lu",(unsigned long)me];
        }else if (me > opponent && me < 4){
            self.winLabel.text = [NSString stringWithFormat:@"You lead %lu-%lu", (unsigned long)me,(unsigned long)opponent];
            self.gmWinPt.text = [NSString stringWithFormat:@"%lu",(unsigned long)me * 2];
        }else if (me > opponent && me > 3 && opponent == 0){
            [self setRematchable:YES];
            self.winLabel.text = [NSString stringWithFormat:@"You swept the series"];
            self.sweeppts.text = @"10";
            [self.nextGameButton setEnabled:YES];
            self.gmWinPt.text = [NSString stringWithFormat:@"%lu",(unsigned long)me*2];
        }else if (me < opponent && opponent > 3 && me != 0){
            self.winLabel.text = [NSString stringWithFormat:@"You lost %lu-%lu", (unsigned long)me,(unsigned long)opponent];
            self.gmWinPt.text = [NSString stringWithFormat:@"%lu",(unsigned long)me*2];
            [self setRematchable:YES];
            [self.nextGameButton setEnabled:YES];
            [self.nextGameButton setTitle:@"Rematch" forState:(UIControlStateNormal)];
        }else if (me < opponent && opponent < 4){
            self.winLabel.text = [NSString stringWithFormat:@"You trail %lu-%lu", (unsigned long)me,(unsigned long)opponent];
            self.gmWinPt.text = [NSString stringWithFormat:@"%lu",(unsigned long)me*2];
        }else if (me < opponent && opponent > 3 && me == 0){
            [self setRematchable:YES];
            self.winLabel.text = [NSString stringWithFormat:@"You were swept in this series"];
            self.gmWinPt.text = [NSString stringWithFormat:@"%lu",(unsigned long)me*2];
            self.serieswinpt.text = @"0";
            [self.nextGameButton setEnabled:YES];
                    [self.nextGameButton setTitle:@"Rematch" forState:(UIControlStateNormal)];
        }else if (me == opponent){
            self.winLabel.text = [NSString stringWithFormat:@"You are tied at %lu-%lu",(unsigned long)me,(unsigned long)opponent];
            self.gmWinPt.text = [NSString stringWithFormat:@"%lu",(unsigned long)me*2];
        }
    }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:SEGUE_CHALL_NXTCHLL_]){
        ViewController* destination = (ViewController*)[segue destinationViewController];
        if(sender != nil){
            destination.challenge = (Challenge*)sender;
            destination.isChallenging = YES;
            destination.isOvertiming = _isOvertime;
            if(_isOvertime){
                destination.overtimeDict = dictionary;
            }
        }
    }else if ([segue.identifier isEqualToString:SEGUE_CHAT_VIEW]){
        ChatVC* destination = (ChatVC*)[segue destinationViewController];
        [destination setSenderDisplayName:_username];
        [destination setSenderId:[self uid]];
        [destination setChallengeKey: self.challenge.key];
        destination.avatarArray = [self avatarImageSet];
        [[AvatarImage avatarImageProducer]getAvatarsFromSegue:[self avatarImageSet]];
        [destination setOpponent:[self configUsername:[self opponent]]];
        [badge setHidden:YES];
        
    }
}



- (IBAction)challengeOverview:(id)sender {
    /*CGRect frame = CGRectMake(0, 0, self.view.frame.size.width + 100, self.view.frame.size.height);
    [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.6 options:(UIViewAnimationOptionCurveEaseIn) animations:^{
        [self.chOverview setFrame:frame];
    } completion:^(BOOL finish){}];*/
    if (self.username){
        [self performSegueWithIdentifier:SEGUE_CHAT_VIEW sender:nil];
    }
}

-(NSString* _Nullable)configUsername:(NSString*)uid{
   
        if ([_challenge.sender isEqualToString:uid]){
            return [self.challenge.usernames objectForKey:@"Sender"];
        }else{
            return [self.challenge.usernames objectForKey:@"Recipient"];
        }

}

-(void)configurePointsView
{
    //NSLog(@"the count is %lu",_gamewinsarray.count);
    NSMutableDictionary* winDict = [winsArray firstObject];
    _game1winner.text = @"**TBD**";
    _game2winnwer.text = @"**TBD**";
    _g3winner.text = @"**TBD**";
    _g4winner.text = @"**TBD**";
    switch (winDict.count) {
            
        case 0:

            break;
        case 1:
            _game1winner.text =[NSString stringWithFormat:@"%@",[self configUsername:[winDict objectForKey:GAME1]]];
            break;
        case 2:
            _game1winner.text =[NSString stringWithFormat:@"%@",[self configUsername:[winDict objectForKey:GAME1]]];
            _game2winnwer.text =[NSString stringWithFormat:@"%@",[self configUsername:[winDict objectForKey:GAME2]]];
            break;
        case 3:
            _game1winner.text =[NSString stringWithFormat:@"%@",[self configUsername:[winDict objectForKey:GAME1]]];
            _game2winnwer.text =[NSString stringWithFormat:@"%@",[self configUsername:[winDict objectForKey:GAME2]]];
            _g3winner.text = [NSString stringWithFormat:@"%@",[self configUsername:[winDict objectForKey:GAME3]]];
            break;
        case 4:
            _game1winner.text =[NSString stringWithFormat:@"%@",[self configUsername:[winDict objectForKey:GAME1]]];
            _game2winnwer.text =[NSString stringWithFormat:@"%@",[self configUsername:[winDict objectForKey:GAME2]]];
            _g3winner.text = [NSString stringWithFormat:@"%@",[self configUsername:[winDict objectForKey:GAME3]]];
            _g4winner.text = [NSString stringWithFormat:@"%@",[self configUsername:[winDict objectForKey:GAME4]]];
            break;
        case 5:
            _game1winner.text =[NSString stringWithFormat:@"%@",[self configUsername:[winDict objectForKey:GAME1]]];
            _game2winnwer.text =[NSString stringWithFormat:@"%@",[self configUsername:[winDict objectForKey:GAME2]]];
            _g3winner.text = [NSString stringWithFormat:@"%@",[self configUsername:[winDict objectForKey:GAME3]]];
            _g4winner.text = [NSString stringWithFormat:@"%@",[self configUsername:[winDict objectForKey:GAME4]]];
            [_game5lbl setHidden:NO];
            [_g5winner setHidden:NO];
            _g5winner.text = [NSString stringWithFormat:@"%@",[self configUsername:[winDict objectForKey:GAME5]]];
            break;
        case 6:
            _game1winner.text =[NSString stringWithFormat:@"%@",[self configUsername:[winDict objectForKey:GAME1]]];
            _game2winnwer.text =[NSString stringWithFormat:@"%@",[self configUsername:[winDict objectForKey:GAME2]]];
            _g3winner.text = [NSString stringWithFormat:@"%@",[self configUsername:[winDict objectForKey:GAME3]]];
            _g4winner.text = [NSString stringWithFormat:@"%@",[self configUsername:[winDict objectForKey:GAME4]]];
            [_game5lbl setHidden:NO];
            [_g5winner setHidden:NO];
            _g5winner.text = [NSString stringWithFormat:@"%@",[self configUsername:[winDict objectForKey:GAME5]]];
            [_game6lbl setHidden:NO];
            [_game6lbl setHidden:NO];
            _g6winner.text = [NSString stringWithFormat:@"%@",[self configUsername:[winDict objectForKey:GAME6]]];
            break;
        case 7:
            _game1winner.text =[NSString stringWithFormat:@"%@",[self configUsername:[winDict objectForKey:GAME1]]];
            _game2winnwer.text =[NSString stringWithFormat:@"%@",[self configUsername:[winDict objectForKey:GAME2]]];
            _g3winner.text = [NSString stringWithFormat:@"%@",[self configUsername:[winDict objectForKey:GAME3]]];
            _g4winner.text = [NSString stringWithFormat:@"%@",[self configUsername:[winDict objectForKey:GAME4]]];
            [_game5lbl setHidden:NO];
            [_g5winner setHidden:NO];
            _g5winner.text = [NSString stringWithFormat:@"%@",[self configUsername:[winDict objectForKey:GAME5]]];
            [_game6lbl setHidden:NO];
            [_game6lbl setHidden:NO];
            _g6winner.text = [NSString stringWithFormat:@"%@",[self configUsername:[winDict objectForKey:GAME6]]];
            [_game7lbl setHidden:NO];
            [_g7winer setHidden:NO];
            _g7winer.text = [NSString stringWithFormat:@"%@",[self configUsername:[winDict objectForKey:GAME7]]];
        default:
            break;
    }
    
    
    
}


/*-(void)animate:(NSUInteger)index
{
    id color = [_colors objectAtIndex:index];
    [Constants dynamicOverlay:self.view.layer color:color did:^{
        [Constants delayWithSeconds:2 exec:^{
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
    [Constants dynamicOverlay:self.view.layer color:color did:^{
        [Constants delayWithSeconds:2 exec:^{
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
*/


@end


