//
//  LogInVC.h
//  CWStreaks
//
//  Created by Mensah Shadrach on 11/2/16.
//  Copyright © 2016 Mensah Shadrach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Gamer.h"
#import "MaterialView.h"
#import "MaterialTextfield.h"
#import "MaterialButtons.h"
#import "DatabaseService.h"
#import "DataService.h"
#import "Constants.h"

@import CoreLocation;

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

@interface LogInVC : UIViewController <CLLocationManagerDelegate, AvatarVCDelegate>

@property(strong,nullable,nonatomic)NSString* avatar;
@end
