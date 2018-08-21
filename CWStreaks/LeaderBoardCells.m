//
//  LeaderBoardCells.m
//  CWStreaks
//
//  Created by Mensah Shadrach on 1/10/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import "LeaderBoardCells.h"

@interface LeaderBoardCells()
@property(nonatomic,weak)IBOutlet UIView* overlay;

@end

@implementation LeaderBoardCells

- (void)awakeFromNib {
    [super awakeFromNib];
    _overlay.layer.cornerRadius = _overlay.frame.size.width / 2;
    _overlay.layer.backgroundColor = (__bridge CGColorRef _Nullable)([Constants createGradientColors:nil]);
    
    _profileImageView.layer.cornerRadius = _profileImageView.frame.size.width /2;
    
}

-(void)configureCells:(Gamer* _Nonnull)gamer selectedSegment:(NSInteger)index atIndexPath:(NSIndexPath*)indexPath
{
    NSMutableDictionary* scoreDict = (NSMutableDictionary*)gamer.scoreData;
    _username.text = gamer.username.capitalizedString;
    [_profileImageView setImage:[UIImage imageNamed:gamer.avatar]];
    _userInfo.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
    NSUInteger gcount = [(NSNumber*)[scoreDict objectForKey:FIR_DB_REF_ALLTIME_GAMECOUNT] unsignedIntegerValue];
    NSUInteger gscore = [(NSNumber*)[scoreDict objectForKey:FIR_DB_REF_ALLTIME_GAMESCORE] unsignedIntegerValue];
    if (index == 0){
        _percentage.text = [NSString stringWithFormat:@"%lu", (unsigned long)[(NSNumber*)[scoreDict objectForKey:FIR_DB_REF_SC_REGL_GAMEHIGHSCORE] unsignedIntegerValue]];
        //NSDictionary* d = [gamer.scoreData objectForKey:gamer.uid];
        _userInfo.text = [NSString stringWithFormat:@"%lu", (unsigned long)[(NSNumber*)[scoreDict objectForKey:FIR_DB_REF_ALLTIME_GAMECOUNT] unsignedIntegerValue]];
        //_userinfo2.text = [NSString stringWithFormat:@"Streak: %lu", (unsigned long)[(NSNumber*)[scoreDict objectForKey:FIR_DB_REF_HIGHSTREAK] unsignedIntegerValue]];
    }else if (index == 1){
        _percentage.text = [NSString stringWithFormat:@"%lu", (unsigned long)[(NSNumber*)[scoreDict objectForKey:FIR_DB_REF_CLSSC_GAMEHIGHSCORE] unsignedIntegerValue]];
        //_userInfo.text = [NSString stringWithFormat:@"%lu", [(NSNumber*)[scoreDict objectForKey:FIR_DB_REF_ALLTIME_GAMECOUNT] unsignedIntegerValue]];
        //_userinfo2.text = [NSString stringWithFormat:@"Streak: %lu", (unsigned long)[(NSNumber*)[scoreDict objectForKey:FIR_DB_REF_HIGHSTREAK] unsignedIntegerValue]];
    }else if (index == 2){
        _percentage.text = [NSString stringWithFormat:@"%.2f%%", gamer.userPercentage * 100];
        //_userInfo.text = [NSString stringWithFormat:@"%lu", [(NSNumber*)[scoreDict objectForKey:FIR_DB_REF_ALLTIME_GAMECOUNT] unsignedIntegerValue]];
        //_userinfo2.text = [NSString stringWithFormat:@"score: %lu", (unsigned long)[(NSNumber*)[scoreDict objectForKey:FIR_DB_REF_ALLTIME_GAMESCORE] unsignedIntegerValue]];
    }else if (index == 3){
        _percentage.text = [NSString stringWithFormat:@"%lu",(unsigned long)[(NSNumber*)[scoreDict objectForKey:FIR_DB_REF_HIGHSTREAK]unsignedIntegerValue]];

    }else if (index == 4){
        _percentage.text = [NSString stringWithFormat:@"%lu",(unsigned long)[(NSNumber*)[scoreDict objectForKey:FIR_DB_LSSN_STRK]unsignedIntegerValue]];

    }else if (index == 5){

        _percentage.text = [NSString stringWithFormat:@"%lu",(unsigned long)[(NSNumber*)[scoreDict objectForKey:CHLL_PNTS_WN_RCRD]unsignedIntegerValue]];
        //self.userInfo.text = [NSString stringWithFormat:@"%lu", [(NSNumber*)[scoreDict objectForKey:FIR_DB_REF_ALLTIME_GAMECOUNT] unsignedIntegerValue]];
        //_userinfo2.text = [NSString stringWithFormat:@"score: %lu", (unsigned long)[(NSNumber*)[scoreDict objectForKey:FIR_DB_REF_ALLTIME_GAMESCORE] unsignedIntegerValue]];
    }else if (index == 6){
        
        _percentage.text = [NSString stringWithFormat:@"%lu",(unsigned long)[(NSNumber*)[scoreDict objectForKey:CHLL_PNTS_GMWN_PNTS]unsignedIntegerValue]];
        //self.userInfo.text = [NSString stringWithFormat:@"%lu", [(NSNumber*)[scoreDict objectForKey:FIR_DB_REF_ALLTIME_GAMECOUNT] unsignedIntegerValue]];
        //_userinfo2.text = [NSString stringWithFormat:@"score: %lu", (unsigned long)[(NSNumber*)[scoreDict objectForKey:FIR_DB_REF_ALLTIME_GAMESCORE] unsignedIntegerValue]];
    }else if (index == 7){
        
        _percentage.text = [NSString stringWithFormat:@"%lu",(unsigned long)[(NSNumber*)[scoreDict objectForKey:CHLL_PNTS_SRSSWP_PTS]unsignedIntegerValue]];
        //self.userInfo.text = [NSString stringWithFormat:@"%lu", [(NSNumber*)[scoreDict objectForKey:FIR_DB_REF_ALLTIME_GAMECOUNT] unsignedIntegerValue]];
        //_userinfo2.text = [NSString stringWithFormat:@"score: %lu", (unsigned long)[(NSNumber*)[scoreDict objectForKey:FIR_DB_REF_ALLTIME_GAMESCORE] unsignedIntegerValue]];
    }
    //_percentage.text = [NSString stringWithFormat:@"%.2f%%",gamer.userPercentage * 100];/*[(NSNumber*)[scoreDict objectForKey:FIR_DB_REF_SC_REGL_GAMEHIGHSCORE] floatValue]]; /[(NSNumber*)[scoreDict objectForKey:FIR_DB_REF_ALLTIME_GAMECOUNT] floatValue] * 100]*/
    self.userInfo.text = [NSString stringWithFormat:@"Score:%@",[Constants countHelper:gscore]];
    self.userinfo2.text = [NSString stringWithFormat:@"Games:%@",[Constants countHelper:gcount]];
}


-(void)configEx_cells:(Gamer*)gamer 
{
    self.username.text = gamer.username.capitalizedString;

    NSUInteger sWins = [(NSNumber*)[gamer.scoreData objectForKey:CHLL_PNTS_GMWN_PNTS]unsignedIntegerValue];
    NSUInteger sLoss = [(NSNumber*)[gamer.scoreData objectForKey:CHLL_PNTS_LSE_RCRD]unsignedIntegerValue];

   double winTotal =  ((double)sWins + (double)sLoss);
    self.percentage.text = [NSString stringWithFormat:@"%lu", (unsigned long)sWins];
    [self.userInfo setText:[NSString stringWithFormat:@"%lu",(unsigned long)winTotal]];
    [self.userinfo2 setHidden:YES];
    [self.userInfo setHidden:YES];
    [self.profileImageView setImage:[UIImage imageNamed:gamer.avatar]];
}


@end
