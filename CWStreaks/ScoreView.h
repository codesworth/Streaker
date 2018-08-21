//
//  ScoreView.h
//  CWStreaks
//
//  Created by Mensah Shadrach on 11/6/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreView : UIView

@property (weak, nonatomic) IBOutlet UILabel *scoretype;

@property (weak, nonatomic) IBOutlet UILabel *gamescore;
@property (weak, nonatomic) IBOutlet UILabel *scorePercent;
@property (weak, nonatomic) IBOutlet UILabel *bestscore;
@property (weak, nonatomic) IBOutlet UILabel *bestscorepercent;
@property (weak, nonatomic) IBOutlet UILabel *longeststreak;
@property (weak, nonatomic) IBOutlet UILabel *alltimepercent;

@end
