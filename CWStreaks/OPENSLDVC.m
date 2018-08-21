//
//  OPENSLDVC.m
//  CWStreaks
//
//  Created by Mensah Shadrach on 3/20/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import "OPENSLDVC.h"

@interface OPENSLDVC ()
@property(strong,nonatomic,nonnull)NSArray<NSString*>* openSLDetails;

@property(weak,nonatomic)IBOutlet UITextView* detailTextView;

@end

@implementation OPENSLDVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.detailTextView setText:[_openSLDetails objectAtIndex:[self.openSLIndex unsignedIntegerValue]]];
    // Do any additional setup after loading the view.
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
