//
//  ReportUser.m
//  CWStreaks
//
//  Created by Mensah Shadrach on 4/11/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import "ReportUser.h"

@interface ReportUser ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *usernamelabel;
@property (weak, nonatomic) IBOutlet UITextView *detailsText;
@property (weak, nonatomic, nullable)IBOutlet MaterialButtons* button;
@property(strong,nonatomic)UIColor* color;
@end

@implementation ReportUser

- (void)viewDidLoad {
    [super viewDidLoad];
    self.usernamelabel.text = self.user.username.capitalizedString;
    [self.detailsText.layer setCornerRadius:4.0];
    [self.button setEnabled:NO];
    _color = self.button.backgroundColor;
    [self.button setBackgroundColor:[UIColor lightGrayColor]];
    self.detailsText.delegate = self;
    // Do any additional setup after loading the view.
}

- (IBAction)sendReport:(id)sender {
    [[DatabaseService main]LogUserReport:self.user with:_detailsText.text on:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

-(void)textViewDidChange:(UITextView *)textView
{
    if(textView.text.length > 10){
        [self.button setEnabled:YES];
        self.button.backgroundColor = _color;
    }else{
        [self.button setEnabled:NO];
        [self.button setBackgroundColor:[UIColor lightGrayColor]];
    }

}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
