//
//  UserAvatarVC.m
//  CWStreaks
//
//  Created by Mensah Shadrach on 2/15/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import "UserAvatarVC.h"

@interface UserAvatarVC ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation UserAvatarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.username;
    [self.imageView setImage:[UIImage imageNamed:self.avatar]];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGRect frame = CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.width);
    [self.imageView setFrame:frame];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
