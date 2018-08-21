//
//  AvatarVC.m
//  CWStreaks
//
//  Created by Mensah Shadrach on 2/8/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import "AvatarVC.h"

@interface AvatarVC ()
@property(strong,nonatomic,nonnull)NSArray<NSString*>* avatars;

@property(weak,nonatomic)IBOutlet UICollectionView* collectionView;

@end

@implementation AvatarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView setDelegate:self];
    [self.collectionView setDataSource:self];
    NSArray* array = [Constants avatar];
    self.avatars = [array sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(void)viewDidDisappear:(BOOL)animated
{
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.avatars.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* avatar = self.avatars[indexPath.row];
    avatarCells* cell = (avatarCells*)[collectionView dequeueReusableCellWithReuseIdentifier:@"AvatarCells" forIndexPath:indexPath];
    [cell configureCell:avatar];
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* avatar = [self.avatars objectAtIndex:indexPath.row];
    
    BOOL isLoggedIn = [[NSUserDefaults standardUserDefaults]boolForKey:DID_LOG_IN_];
    if (isLoggedIn) {
        NSString* uid = [[NSUserDefaults standardUserDefaults]stringForKey:USER_UID__];
        [[[[DatabaseService main] userReference]child:uid]updateChildValues:@{FIR_BASE_CHILD_PROFILE_IMG_URL:avatar }];
        NSDictionary* d = (NSDictionary*)[[NSUserDefaults standardUserDefaults]objectForKey:USER_INFO];
        NSDictionary* newD = @{FIR_BASE_CHILD_USERNAME:[d objectForKey:FIR_BASE_CHILD_USERNAME], FIR_BASE_CHILD_PROFILE_IMG_URL:avatar};
        [[NSUserDefaults standardUserDefaults]setObject:newD forKey:USER_INFO];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.delegate DidFinishPickingAvatar:avatar];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


@end
