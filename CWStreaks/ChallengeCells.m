//
//  ChallengeCells.m
//  CWStreaks
//
//  Created by Mensah Shadrach on 1/19/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import "ChallengeCells.h"

@implementation ChallengeCells

- (void)awakeFromNib {
    [super awakeFromNib];
    [_senderProfileImage.layer setCornerRadius:_senderProfileImage.frame.size.width /2];
    [_recipientProfileImage.layer setCornerRadius:_recipientProfileImage.frame.size.width / 2];
    [_backView setClipsToBounds:YES];
    
    [self.backView.layer setCornerRadius:self.backView.frame.size.width / 2];
    
    [_backView2 setClipsToBounds:YES];
    [self.backView2.layer setCornerRadius:self.backView2.frame.size.width / 2];
    [_rBackView2 setClipsToBounds:YES];
    
    [self.rBackview.layer setCornerRadius:self.rBackview.frame.size.width / 2];
    
    [_rBackView2 setClipsToBounds:YES];
    [self.rBackView2.layer setCornerRadius:self.rBackView2.frame.size.width / 2];
    //[self.senderUsername setFont:[UIFont fontWithName:@"SFMono-Reular" size:14]];
    //[self.recipientUsername setFont:[UIFont fontWithName:@"SFMono-Regular" size:14]];
    [self.scorelabel setFont:[UIFont fontWithName:@"SFMono-Semibold" size:22]];
    [_scorelabel setTextColor:[UIColor whiteColor ]];
    [_senderUsername setTextColor:[UIColor whiteColor ]];
    [_recipientUsername setTextColor:[UIColor whiteColor ]];
    [_gameNumberLabel setTextColor:[UIColor whiteColor ]];
    [_dateGameplayedlabel setTextColor:[UIColor whiteColor ]];
    
    
}

-(void)prepareForReuse{
    [super prepareForReuse];
    [self.senderUsername setFont:[UIFont fontWithName:@"SFMono-Regular" size:14]];
    [self.recipientUsername setFont:[UIFont fontWithName:@"SFMono-Regular" size:14]];
    [self.scorelabel setFont:[UIFont fontWithName:@"SFMono-Semibold" size:22]];
    [self.gameNumberLabel setHidden:NO];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)configureCell:(Challenge*)challenge
{
    self.rBackview.layer.backgroundColor = (__bridge CGColorRef _Nullable)([Constants createGradientColors:[NSNumber numberWithUnsignedInteger:2]]);
    self.rBackView2.layer.backgroundColor = (__bridge CGColorRef _Nullable)([Constants createGradientColors:[NSNumber numberWithUnsignedInteger:2]]);
    NSDictionary* usernames = challenge.usernames;
    self.senderUsername.text = [(NSString*)[usernames objectForKey:@"Sender"]uppercaseString];
    self.recipientUsername.text = [(NSString*)[usernames objectForKey:@"Recipient"] uppercaseString];
    self.recipientProfileImage.image = [UIImage imageNamed:[usernames objectForKey:@"RecipientAvatar"]];
    self.senderProfileImage.image = [UIImage imageNamed:[usernames objectForKey:@"SenderAvatar"]];

    [self resolveScoreData:challenge];
}

-(void)resolveScoreData:(Challenge*)challenge
{
    
    if (challenge.results != nil && challenge.results.allResults.count != 0){
        //NSDictionary* game1 = [challenge.results.allResults objectAtIndex:0];
        NSMutableDictionary* lastscoreResults = [challenge.results.allResults lastObject];
        //NSMutableDictionary* senderScoreDict = [lastscoreResults objectForKey:GAME1];
        //NSLog(@"last score resultssssss, %@", challenge.results.allResults);
        NSNumber* sndrscr = [lastscoreResults objectForKey:challenge.sender];
        //NSLog(@"Sender score == %@", sndrscr);
        NSNumber* rcscr = [lastscoreResults objectForKey:challenge.receipient];
        NSMutableDictionary* otScores = [lastscoreResults objectForKey:CHLLNG_OT_SCORES];
        if (sndrscr != nil && rcscr != nil){ _scorelabel.text = [NSString stringWithFormat:@"%lu-%lu", (unsigned long)[rcscr unsignedIntegerValue], (unsigned long)[sndrscr unsignedIntegerValue]];
            NSString* date = [lastscoreResults objectForKey:@"Date"];
            NSUInteger gameNo = [challenge.results.allResults indexOfObject:lastscoreResults] + 1;
            _dateGameplayedlabel.text = [NSString stringWithFormat:@"%@", date];
            _gameNumberLabel.text = [NSString stringWithFormat:@"GAME %lu", (unsigned long)gameNo ];
        }else if (sndrscr != nil && rcscr == nil && otScores == nil ){
            _scorelabel.text = [NSString stringWithFormat:@"*-%lu", (unsigned long)[sndrscr unsignedIntegerValue]];
            NSString* date = [lastscoreResults objectForKey:@"Date"];
            NSUInteger gameNo = [challenge.results.allResults indexOfObject:lastscoreResults] + 1;
            _dateGameplayedlabel.text = [NSString stringWithFormat:@"%@", date];
            _gameNumberLabel.text = [NSString stringWithFormat:@"GAME %lu", (unsigned long)gameNo ];
        }else if (sndrscr == nil && rcscr != nil && otScores == nil){
            _scorelabel.text = [NSString stringWithFormat:@"%lu-*",(unsigned long)[rcscr unsignedIntegerValue]];
            NSString* date = [lastscoreResults objectForKey:@"Date"];
            NSUInteger gameNo = [challenge.results.allResults indexOfObject:lastscoreResults] + 1;
            _dateGameplayedlabel.text = [NSString stringWithFormat:@"%@", date];
            _gameNumberLabel.text = [NSString stringWithFormat:@"GAME %lu", (unsigned long)gameNo ];
        }else if (otScores != nil && sndrscr == nil && rcscr != nil){
            NSUInteger score = [(NSNumber*)[otScores objectForKey:challenge.sender]unsignedIntegerValue];
            _scorelabel.text = [NSString stringWithFormat:@"%lu-%lu", (unsigned long)[rcscr unsignedIntegerValue], (unsigned long)score];
            NSString* date = [lastscoreResults objectForKey:@"Date"];
            NSUInteger gameNo = [challenge.results.allResults indexOfObject:lastscoreResults] + 1;
            _dateGameplayedlabel.text = [NSString stringWithFormat:@"%@", date];
            _gameNumberLabel.text = [NSString stringWithFormat:@"GAME %lu/OT%lu", (unsigned long)gameNo, (unsigned long)[(NSNumber*)[lastscoreResults objectForKey:@"OT"]unsignedIntegerValue]];
        }else if (otScores != nil && sndrscr != nil && rcscr == nil){
            NSUInteger score = [(NSNumber*)[otScores objectForKey:challenge.receipient]unsignedIntegerValue];
            _scorelabel.text = [NSString stringWithFormat:@"%lu-%lu", (unsigned long)score,(unsigned long)[sndrscr unsignedIntegerValue]];
            NSString* date = [lastscoreResults objectForKey:@"Date"];
            NSUInteger gameNo = [challenge.results.allResults indexOfObject:lastscoreResults] + 1;
            _dateGameplayedlabel.text = [NSString stringWithFormat:@"%@", date];
            _gameNumberLabel.text = [NSString stringWithFormat:@"GAME %lu/%luOT", (unsigned long)gameNo, (unsigned long)[(NSNumber*)[lastscoreResults objectForKey:@"OT"]unsignedIntegerValue]];
        }else if (sndrscr == nil && rcscr == nil && otScores != nil){
            NSUInteger score = [(NSNumber*)[otScores objectForKey:challenge.receipient]unsignedIntegerValue];
            NSUInteger score2 = [(NSNumber*)[otScores objectForKey:challenge.sender]unsignedIntegerValue];
            _scorelabel.text = [NSString stringWithFormat:@"%lu-%lu", (unsigned long)score,(unsigned long)score2];
            NSString* date = [lastscoreResults objectForKey:@"Date"];
            NSUInteger gameNo = [challenge.results.allResults indexOfObject:lastscoreResults] + 1;
            _dateGameplayedlabel.text = [NSString stringWithFormat:@"%@", date];
            _gameNumberLabel.text = [NSString stringWithFormat:@"GAME %lu/%luOT", (unsigned long)gameNo, (unsigned long)[(NSNumber*)[lastscoreResults objectForKey:@"OT"]unsignedIntegerValue]];
        }
        
    }else if (challenge.results.allResults.count == 0 && challenge.status == [NSNumber numberWithUnsignedInteger:1]){
        _scorelabel.text = @"--";
        _dateGameplayedlabel.text = [NSString stringWithFormat:@"%@", challenge.date];
        [self.gameNumberLabel setHidden:YES];
    }else{
            NSString* date = challenge.date;
            _dateGameplayedlabel.text = [NSString stringWithFormat:@"%@", date];
            [_gameNumberLabel setHidden:YES];
            NSString* uid = [[NSUserDefaults standardUserDefaults] stringForKey:USER_UID__];
            //Gamer* selff = (Gamer*)[[AppDelegate mainDelegate].selff objectAtIndex:0];
        if([challenge.sender isEqualToString:uid]){_scorelabel.text = @"PENDING";_scorelabel.font = [UIFont fontWithName:@"SFMono-Regular" size:14];}else{_scorelabel.text = @"ACCEPT";_scorelabel.font = [UIFont fontWithName:@"SFMono-Regular" size:14];}

    }
}




//===================================================================================
//MARK:- RESULTS TABLE CONFIG
-(void)configureGameCell:(Challenge* _Nonnull)challenge atIndexPath:(NSUInteger)index
{
    self.backView.layer.backgroundColor = (__bridge CGColorRef _Nullable)([Constants createGradientColors:[NSNumber numberWithUnsignedInteger:2]]);
    self.backView2.layer.backgroundColor = (__bridge CGColorRef _Nullable)([Constants createGradientColors:[NSNumber numberWithUnsignedInteger:2]]);
    
    self.senderUsername.text = [(NSString*)[challenge.usernames objectForKey:@"Sender"]uppercaseString];
    self.recipientUsername.text = [(NSString*)[challenge.usernames objectForKey:@"Recipient"] uppercaseString];
    UIImage* r = [UIImage imageNamed:[challenge.usernames objectForKey:@"RecipientAvatar"]];
    UIImage* s = [UIImage imageNamed:[challenge.usernames objectForKey:@"SenderAvatar"]];
    [self.recipientProfileImage setImage:r];
    [self.senderProfileImage setImage:s];
    NSArray* gameResults = challenge.results.allResults;
    NSMutableDictionary* scores = [gameResults objectAtIndex:index];
    NSNumber* sndrscr = [scores objectForKey:challenge.sender];
    NSNumber* rcpntscr = [scores objectForKey:challenge.receipient];
    NSMutableDictionary* otScores = [scores objectForKey:CHLLNG_OT_SCORES];
    if (sndrscr != nil && rcpntscr != nil ){ _scorelabel.text = [NSString stringWithFormat:@"%lu-%lu", (unsigned long)[rcpntscr unsignedIntegerValue], (unsigned long)[sndrscr unsignedIntegerValue]];
        NSString* date = [scores objectForKey:@"Date"];
        NSUInteger gameNo = [challenge.results.allResults indexOfObject:scores] + 1;
        _dateGameplayedlabel.text = [NSString stringWithFormat:@"%@", date];
        _gameNumberLabel.text = [NSString stringWithFormat:@"GAME %lu", (unsigned long)gameNo ];
    }else if (sndrscr != nil && rcpntscr == nil && otScores == nil){
        _scorelabel.text = [NSString stringWithFormat:@"*-%lu", (unsigned long)[sndrscr unsignedIntegerValue]];
        NSString* date = [scores objectForKey:@"Date"];
        NSUInteger gameNo = [challenge.results.allResults indexOfObject:scores] + 1;
        _dateGameplayedlabel.text = [NSString stringWithFormat:@"%@", date];
        _gameNumberLabel.text = [NSString stringWithFormat:@"GAME %lu", (unsigned long)gameNo ];
    }else if (sndrscr == nil && rcpntscr == nil && otScores != nil){
        NSUInteger score = [(NSNumber*)[otScores objectForKey:challenge.receipient]unsignedIntegerValue];
        NSUInteger score2 = [(NSNumber*)[otScores objectForKey:challenge.sender]unsignedIntegerValue];
        _scorelabel.text = [NSString stringWithFormat:@"%lu-%lu", (unsigned long)score,(unsigned long)score2];
        NSString* date = [scores objectForKey:@"Date"];
        NSUInteger gameNo = [challenge.results.allResults indexOfObject:scores] + 1;
        _dateGameplayedlabel.text = [NSString stringWithFormat:@"%@", date];
        _gameNumberLabel.text = [NSString stringWithFormat:@"GAME %lu/%luOT", (unsigned long)gameNo, (unsigned long)[(NSNumber*)[scores objectForKey:@"OT"]unsignedIntegerValue]];
    }else if (otScores != nil && sndrscr == nil && rcpntscr != nil){
        NSUInteger score = [(NSNumber*)[otScores objectForKey:challenge.sender]unsignedIntegerValue];
        _scorelabel.text = [NSString stringWithFormat:@"%lu-%lu", (unsigned long)[rcpntscr unsignedIntegerValue], (unsigned long)score];
        NSString* date = [scores objectForKey:@"Date"];
        NSUInteger gameNo = [challenge.results.allResults indexOfObject:scores] + 1;
        _dateGameplayedlabel.text = [NSString stringWithFormat:@"%@", date];
        _gameNumberLabel.text = [NSString stringWithFormat:@"GAME %lu/OT%lu", (unsigned long)gameNo, (unsigned long)[(NSNumber*)[scores objectForKey:@"OT"]unsignedIntegerValue]];
    }else if (otScores != nil && sndrscr != nil && rcpntscr == nil){
        NSUInteger score = [(NSNumber*)[otScores objectForKey:challenge.receipient]unsignedIntegerValue];
        _scorelabel.text = [NSString stringWithFormat:@"%lu-%lu", (unsigned long)score,(unsigned long)[sndrscr unsignedIntegerValue]];
        NSString* date = [scores objectForKey:@"Date"];
        NSUInteger gameNo = [challenge.results.allResults indexOfObject:scores] + 1;
        _dateGameplayedlabel.text = [NSString stringWithFormat:@"%@", date];
        _gameNumberLabel.text = [NSString stringWithFormat:@"GAME %lu/%luOT", (unsigned long)gameNo, (unsigned long)[(NSNumber*)[scores objectForKey:@"OT"]unsignedIntegerValue]];
    }else{
        _scorelabel.text = [NSString stringWithFormat:@"%lu-*",(unsigned long)[rcpntscr unsignedIntegerValue]];
        NSString* date = [scores objectForKey:@"Date"];
        NSUInteger gameNo = [challenge.results.allResults indexOfObject:scores] + 1;
        _dateGameplayedlabel.text = [NSString stringWithFormat:@"%@", date];
        _gameNumberLabel.text = [NSString stringWithFormat:@"GAME %lu", (unsigned long)gameNo ];
    }
}
@end

/*
 
 
 @property (weak, nonatomic) IBOutlet UILabel *scorelabel;
 @property (weak, nonatomic) IBOutlet UIImageView *senderProfileImage;
 @property (weak, nonatomic) IBOutlet UILabel *senderUsername;
 @property (weak, nonatomic) IBOutlet UILabel *recipientUsername;
 @property (weak, nonatomic) IBOutlet UIImageView *recipientProfileImage;
 @property (weak, nonatomic) IBOutlet UILabel *dateGameplayedlabel;
 @property (weak, nonatomic) IBOutlet UILabel *gameNumberLabel;
 */
