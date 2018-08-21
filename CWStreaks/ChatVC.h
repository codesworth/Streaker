//
//  ChatVC.h
//  CWStreaks
//
//  Created by Mensah Shadrach on 2/7/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import <JSQMessagesViewController/JSQMessages.h>
#import "CW-Predef_Header.h"
#import "ImageViewsVC.h"


@import UserNotifications;
@import UserNotificationsUI;
@import Photos;
@interface ChatVC : JSQMessagesViewController

@property(strong,nonnull,nonatomic)NSString* challengeKey;
@property(strong,nullable,nonatomic)NSString* opponent;
@property(strong,nullable,nonatomic)NSArray<NSString*>* avatarArray;

@end
