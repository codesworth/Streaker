//
//  AvatarImage.m
//  CWStreaks
//
//  Created by Mensah Shadrach on 3/24/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import "AvatarImage.h"

@implementation AvatarImage


+(id)avatarImageProducer
{
    static AvatarImage *avatarImageProducer = nil;
    static dispatch_once_t oncetoken;
    dispatch_once(&oncetoken, ^{
        avatarImageProducer = [[self alloc] init];
    });
    return avatarImageProducer;
}
-(void)getAvatarsFromSegue:(NSArray*)avatars{
    self.avatars  = avatars;
}

-(UIImage *)avatarImage
{
    UIImage* img = [UIImage imageNamed:[_avatars objectAtIndex:1]];
    UIImage* avatar = [JSQMessagesAvatarImageFactory circularAvatarImage:img withDiameter:20];
    return avatar;

}

-(UIImage *)avatarHighlightedImage
{
    return nil;
}

-(UIImage *)avatarPlaceholderImage
{
     UIImage* img = [UIImage imageNamed:[_avatars objectAtIndex:1]];
    UIImage* avatar = [JSQMessagesAvatarImageFactory circularAvatarImage:img withDiameter:20];
    return avatar;
}

@end
