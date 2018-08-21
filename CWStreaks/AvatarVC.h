//
//  AvatarVC.h
//  CWStreaks
//
//  Created by Mensah Shadrach on 2/8/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CW-Predef_Header.h"

@protocol AvatarVCDelegate <NSObject>

-(void)DidFinishPickingAvatar:(NSString*)avatar;

@end

@interface AvatarVC : UIViewController <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic)BOOL fromSettings;
@property(weak,nonatomic)id<AvatarVCDelegate> delegate;
@end
