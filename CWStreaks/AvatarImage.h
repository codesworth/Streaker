//
//  AvatarImage.h
//  CWStreaks
//
//  Created by Mensah Shadrach on 3/24/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CW-Predef_Header.h"

@interface AvatarImage : NSObject<JSQMessageAvatarImageDataSource>

@property(nonatomic,nullable,strong)NSArray<NSString*>* avatars;

+(id _Nullable)avatarImageProducer;
-(void)getAvatarsFromSegue:(NSArray* _Nonnull)avatars;
@end
