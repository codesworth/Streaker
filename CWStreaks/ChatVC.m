//
//  ChatVC.m
//  CWStreaks
//
//  Created by Mensah Shadrach on 2/7/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import "ChatVC.h"
#import "AvatarImage.h"
@import Photos;


@interface ChatVC ()<GADInterstitialDelegate,JSQMessageAvatarImageDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(strong,nonatomic,nullable)NSMutableArray<JSQMessage*>* messages;
@property(strong,nonatomic)JSQMessagesBubbleImage* outv;
@property(strong,nonatomic)JSQMessagesBubbleImage* inv;
@property(nonatomic)BOOL canShowAd;
@property(nonatomic,strong)GADInterstitial* interstitial;
@property(nonatomic)FIRDatabaseHandle handle;
@property(nonatomic,strong)NSMutableDictionary* mediaItems;
@property(nonatomic) FIRDatabaseHandle updateHandle;
@property(nonatomic)BOOL shouldSave;
@property(nonatomic)BOOL IsInView;
@property(nonatomic,strong)NSURL* chats;
@property(nonatomic,strong)Reachability* in_netReachability;
@property(nonatomic)dispatch_queue_t executeBackground;
@property(nonatomic)BOOL shouldSetsent;

@end

@implementation ChatVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.executeBackground = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    
    NSString* path = [NSString stringWithFormat:@"%@/chats.plist",_challengeKey];
    [self setChats:[Constants createdocumentsUrlFor:path]];
    [self setOutv:[self setOugoingBubImg]];
    [self setInv:[self setIncomingBubImg]];
    [self setMessages:[[NSMutableArray alloc]init]];
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar.topItem setTitle:@""];
    self.navigationItem.title = self.opponent;
    [self setIn_netReachability:[Reachability reachabilityForInternetConnection]];
    //self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
    //self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
    //[self.inputToolbar.contentView setLeftBarButtonItem:nil];
    //[self setMessages:[NSMutableArray arrayWithContentsOfURL:_chats]];
    [self setCanShowAd:NO];
    self.interstitial.delegate = self;
    [self setbackGroundImage];
    self.mediaItems = [NSMutableDictionary new];
    _shouldSave = [[NSUserDefaults standardUserDefaults]boolForKey:AUTO_SAVEPHOTO];
    

}

-(void)reachabilityDidChangeNotif:(NSNotification*)notification
{
    Reachability* netReachability = [notification object];
    NSParameterAssert([netReachability isKindOfClass:[Reachability class]]);
    if([netReachability currentReachabilityStatus] == NotReachable){
        [self.inputToolbar.contentView.rightBarButtonItem setEnabled:NO];
    }else{
        [self.inputToolbar.contentView.rightBarButtonItem setEnabled:YES];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];

}

-(void)addPhotoMessage:(NSString*)url localized:(NSString*)local andMedia:(JSQPhotoMediaItem*)item
{
    
    JSQMessage* message = [[JSQMessage alloc]initWithSenderId:url senderDisplayName:local date:([NSDate date]) media:item];
    if([self isInview:message.senderDisplayName]){}else{
        [self.messages addObject:message];
        /*if(item.image == nil){
            [self.mediaItems setObject:item forKey:key];
        }*/
    }
    
    [self.collectionView reloadData];
}

-(BOOL)isInview:(NSString*)identifier
{
    BOOL isInView = false;
    for (JSQMessage* m in self.messages) {
        if([m.senderDisplayName isEqualToString:identifier]){
            isInView = YES;
            break;
        }
    }

    return isInView;
}



-(void)setbackGroundImage
{

    //NSLog(@"The document directory,%@", [Constants doeumentsUrl]);
    NSString* chBg = [Constants create_return_Directory:@"Background"];
    NSString* bgpath = [chBg stringByAppendingPathComponent:@"chatBackground.jpg"];
    NSData* imageData = [NSData dataWithContentsOfFile:bgpath];
    UIImage* image = [UIImage imageWithData:imageData];
    UIImageView* backImageView = [[UIImageView alloc]initWithFrame:self.collectionView.backgroundView.frame];
    backImageView.image = image;
    backImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.collectionView setBackgroundView:backImageView];
}


-(void)createAndSetAd{
    self.interstitial = [[GADInterstitial alloc] initWithAdUnitID:GAD_AD_UNIT_ID__];
    GADRequest* request = [GADRequest request];
    request.testDevices = @[ @"c5b6e83d0313789be541c4dd0fb00771" ];
    [self.interstitial loadRequest:request];
}

-(void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSLog(@"Failed with Error %@", error.localizedDescription);
}

-(void)interstitialDidFailToPresentScreen:(GADInterstitial *)ad{
    NSLog(@"Ahaaaaa failure");
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    dispatch_async(_executeBackground, ^{
        [self loadMessages];
    });
    self.IsInView = YES;
    [[AppDelegate mainDelegate]setIsChatVC:YES];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reachabilityDidChangeNotif:) name:kReachabilityChangedNotification object:nil];
    //[[DatabaseService main] readMessageReceipt:self.challengeKey h:_handle e:^{}];
    [self observe_MessagePosted];
    [self createAndSetAd];
    NSTimeInterval duration = 240;
    [Constants delayWithSeconds:duration exec:^{
        [self setCanShowAd:YES];
        if ([self.interstitial isReady] && self.canShowAd) {
            [self.interstitial presentFromRootViewController:self];
        }else{
            //NSLog(@"failed to load");
        }
    }];

    [self.in_netReachability startNotifier];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self saveMessages];
    [[AppDelegate mainDelegate]setIsChatVC:NO];
    [[[[DatabaseService main]messageRef] child:_challengeKey] removeObserverWithHandle:_updateHandle];
    self.IsInView = NO;
    [self.in_netReachability stopNotifier];
}

-(void)saveMessages
{
    NSError* error;
    
    [NSKeyedArchiver archiveRootObject:self.messages toFile:[Constants createDirectoryForChat:self.challengeKey]];
    /*NSMutableData* savedChats = [NSMutableData new];
    NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:savedChats];
    [archiver encodeObject:self.messages forKey:_challengeKey];
    [savedChats writeToFile:[self filePath] options:NSDataWritingAtomic error:&error];*/
    if(error){
        //NSLog(@"What the fuck happened %@",error.debugDescription);
    }
    //[archiver finishEncoding];
    //[self loadMessages];
}

-(void)loadMessages
{
    //NSLog(@"The url is %@",[Constants createDirectoryForChat:self.challengeKey]);
    
        NSData* chatData = [NSData dataWithContentsOfFile:[Constants createDirectoryForChat:self.challengeKey]];
    //NSLog(@"contemts 0f file is %@",chatData);
    self.messages = [[NSKeyedUnarchiver unarchiveObjectWithData:chatData]mutableCopy];
    if (self.messages == NULL){
        self.messages = [[NSMutableArray alloc]init];
    }
    [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    
}

-(void)reloadData
{
    [self.collectionView reloadData];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    if(self.messages == NULL){
        self.messages = [NSMutableArray new];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage* image = (UIImage*)[info objectForKey:UIImagePickerControllerOriginalImage];
    JSQPhotoMediaItem* medItem = [[JSQPhotoMediaItem alloc]initWithImage:image];
    NSURL* savedpath = [Constants createdocumentsUrlFor:[NSString stringWithFormat:@"%@.jpg",[NSUUID UUID].UUIDString]];
    //NSData* daten = UIImageJPEGRepresentation(image, 1.0);
    //[daten writeToURL:savedpath atomically:YES];
    //NSLog(@"The url is %@",savedpath);
        JSQMessage* message = [[JSQMessage alloc]initWithSenderId:self.senderId senderDisplayName:savedpath.absoluteString date:([NSDate date]) media:medItem];
    [self.messages addObject:message];
    [self saveMessages];
    if ([info objectForKey:UIImagePickerControllerReferenceURL]){
        NSURL* refUrl = (NSURL*)[info objectForKey:UIImagePickerControllerReferenceURL];
        
        NSData* imgData = UIImageJPEGRepresentation(image, 0.0);
        NSString* key = [self sendPhotoImg];
        if (key){
                NSString* path = [NSString stringWithFormat:@"%@/%lu/.%@", [Constants uid],(unsigned long)([NSDate timeIntervalSinceReferenceDate] * 10000),[refUrl lastPathComponent]];
                
                [[[[DatabaseService main] storageRef]child:path] putData:imgData metadata:nil completion:^(FIRStorageMetadata * _Nullable metadata, NSError * _Nullable error) {
                    if (error){
                        NSLog(@"Error uploading file");
                        return;
                    }else{
                        [self setShouldSetsent:YES];
                        [self setPhotImageURL:metadata.downloadURL.absoluteString forMessage:key atIndex:savedpath.absoluteString];
                    }
                }];

        }

    }else{
        UIImage* image = (UIImage*)[info objectForKey:UIImagePickerControllerOriginalImage];
        NSString* key = [self sendPhotoImg];
        NSData* imgData = UIImageJPEGRepresentation(image, 0.0);
        NSString* path = [NSString stringWithFormat:@"%@/%lu.jpg", [Constants uid],(unsigned long)([NSDate timeIntervalSinceReferenceDate] * 10000)];
        FIRStorageMetadata* metadata = [FIRStorageMetadata new];
        metadata.contentType = @"image/jpeg";
        [[[[DatabaseService main]storageRef]child:path]putData:imgData metadata:metadata completion:^(FIRStorageMetadata * _Nullable metadata, NSError * _Nullable error) {
            if (error){
                //NSLog(@"Error uploading Photo");
                return;
            }
            //NSLog(@"the download url %@",metadata.downloadURL);
            
            [self setPhotImageURL:metadata.downloadURL.absoluteString forMessage:key atIndex:savedpath.absoluteString];
        }];
    }
    [self.collectionView reloadData];
    
    
}

-(void)didPressAccessoryButton:(UIButton *)sender
{
    UIImagePickerController* picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    UIAlertController* camLert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction* camera = [UIAlertAction actionWithTitle:@"Take Photo" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        if([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)]){
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:nil];
        }
    }];
    UIAlertAction* photo = [UIAlertAction actionWithTitle:@"Choose From Photos" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
    }];

    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {}];
    [camLert addAction:camera];[camLert addAction:photo];[camLert addAction:cancel];
    if(IS_IPAD){
        [camLert setModalPresentationStyle:(UIModalPresentationPopover)];
        UIPopoverPresentationController* popLert = [camLert popoverPresentationController];
        popLert.sourceView = sender;
        popLert.sourceRect = sender.bounds;
    }
    [self presentViewController:camLert animated:YES completion:nil];
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.messages.count;
}

-(id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.messages[indexPath.item];
}

-(id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage* m = self.messages[indexPath.item];
    if ([m.senderId isEqualToString:[Constants uid]]) {
        return self.outv;
    }
    return self.inv;
}

-(void)setSent:(JSQMessagesCollectionViewCell*)cell
{
    NSUInteger index = self.messages.count;
    JSQMessagesCollectionViewCell* prevcell = (JSQMessagesCollectionViewCell*)[super.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index - 2 inSection:1]];
    prevcell.cellBottomLabel.text = nil;
    cell.cellBottomLabel.text = @"Sent";
    
}

-(NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    NSAttributedString* at_s = [[NSAttributedString alloc]initWithString:@"Sent"];
    JSQMessage* message = [self.messages lastObject];
    if([message.senderId isEqualToString:[Constants uid]]){
        if ([message isMediaMessage] && !_shouldSetsent) {
            
            return [[NSAttributedString alloc]initWithString:@"Sending..."];
            
        }
        if ([message isMediaMessage]) {[self setShouldSetsent:NO];}
        return at_s;
        
    }else{
        
        return nil;
    }

}

-(id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage* m  = self.messages[indexPath.item];
    if ([m.senderId isEqualToString:[Constants uid]]){
        return self;
    }
    return [AvatarImage avatarImageProducer];
}


-(CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.messages.count - 1 && [[self.messages lastObject].senderId isEqualToString:[Constants uid]]){
        return 20;
    }else{
        return 0;
    }
}

-(void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage* message = self.messages[indexPath.item];
    if (message.isMediaMessage){
        
        [self performSegueWithIdentifier:@"ImageViews" sender:message];
    }

}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessagesCollectionViewCell* cell = (JSQMessagesCollectionViewCell*)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    JSQMessage* m = self.messages[indexPath.item];
    if ([m.senderId isEqualToString:self.senderId]) {
        [cell.textView setTextColor:[UIColor whiteColor]];

    }else{
        [cell.textView setTextColor:[UIColor blackColor]];
        
    }
    return cell;
}

-(void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text senderId:(NSString *)senderId senderDisplayName:(NSString *)senderDisplayName date:(NSDate *)date
{
    [self createMessageFromID:senderId username:@"me" withText:text];
    //[JSQSystemSoundPlayer jsq_playMessageSentSound];
    [self finishSendingMessage];
    NSDictionary* d = @{@"Sender":senderId, @"Text":text, @"Date":[Constants stringFromDate:date],@"Read":[NSNumber numberWithUnsignedInteger:0]};
    [[DatabaseService main]sendMessage:d withID:self.challengeKey e:^{
        [JSQSystemSoundPlayer jsq_playMessageSentSound];
        [self finishSendingMessage];

        [self.collectionView reloadData];
    }];
    //NSLog(@"The messages %@",self.messages);
    [self saveMessages];
}


-(JSQMessagesBubbleImage*)setOugoingBubImg
{
    JSQMessagesBubbleImageFactory* bf = [[JSQMessagesBubbleImageFactory alloc]init];
    return [bf outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleBlueColor]];
}

-(JSQMessagesBubbleImage*)setIncomingBubImg
{
    JSQMessagesBubbleImageFactory* bf = [[JSQMessagesBubbleImageFactory alloc]init];
    return [bf incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
}

-(void)createMessageFromID:(NSString*)ID username:(NSString*)user withText:(NSString*)text
{
    JSQMessage* m = [[JSQMessage alloc]initWithSenderId:ID senderDisplayName:user date:([NSDate date]) text:text];
    [self.messages addObject:m];
    
    JSQMessagesCollectionViewCell* cell = (JSQMessagesCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.messages.count - 2 inSection:1]];
    if ([cell isKindOfClass:[JSQMessagesCollectionViewCellOutgoing class]]){
        cell.cellBottomLabel.text = nil;
    }
    
}


#pragma mark - JQAVATARIMAGEDATASOURCE

-(UIImage *)avatarImage
{
    
    UIImage* img = [UIImage imageNamed:[_avatarArray objectAtIndex:0]];
    UIImage* avatar = [JSQMessagesAvatarImageFactory circularAvatarImage:img withDiameter:20];
    return avatar;
}

-(UIImage *)avatarHighlightedImage
{
    return nil;
}

-(UIImage *)avatarPlaceholderImage
{
   UIImage* img = [UIImage imageNamed:[_avatarArray objectAtIndex:0]];
    UIImage* avatar = [JSQMessagesAvatarImageFactory circularAvatarImage:img withDiameter:20];
    return avatar;
}

NSString* image_URL_NOTSET = @"NOTSET";

-(NSString*)sendPhotoImg
{
    //NSDictionary* d = @{@"photourl":image_URL_NOTSET, @"Sender":self.senderId};
    FIRDatabaseReference* ref = [[[[DatabaseService main]messageRef]child:_challengeKey]childByAutoId];
    //[ref setValue:d];

    return ref.key;
}

-(void)setPhotImageURL:(NSString*)url forMessage:(NSString*)key atIndex:(NSString*)index
{
    [[[[[DatabaseService main]messageRef]child:_challengeKey]child:key]updateChildValues:@{@"photourl":url, @"Local":index, @"Sender":self.senderId, @"Date":[Constants stringFromDate:[NSDate date ]]}];
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    [self finishSendingMessage];
    [self.collectionView reloadData];
}

-(void)delivered
{
    JSQMessagesCollectionViewCell* cell = (JSQMessagesCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathWithIndex:self.messages.count - 1]];
    cell.cellBottomLabel.text = @"Delivered";
}

-(void)observe_MessagePosted
{
    FIRDatabaseReference* mRef = [[[DatabaseService main] messageRef] child:_challengeKey];
    self.updateHandle = [mRef observeEventType:(FIRDataEventTypeChildAdded) withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if([snapshot exists]){
            NSDictionary* messageData = snapshot.value;
            //NSLog(@"%@",snapshot.value);
            NSString* senderID = [messageData objectForKey:@"Sender"];
            if(![senderID isEqualToString:self.senderId]){
                NSArray* keys = [messageData allKeys];
                NSString* media = @"photourl";
                if(![keys containsObject:media]){
                    NSString* senderID = [messageData objectForKey:@"Sender"];
                    NSString* text = [messageData objectForKey:@"Text"];
                    [self createMessageFromID:senderID username:@"Me" withText:text];
                    [self finishReceivingMessage];
                    [[mRef child:snapshot.key] removeValue];
                }else{
                    NSString* photoUrl = [messageData objectForKey:media];
                    NSString* local = [messageData objectForKey:@"Local"];
                    //NSString* filePath = [Constants createdocumentsUrlFor:photoUrl].absoluteString;
                   // NSLog(@"The list issss %@",filePath);
                    
                    if([senderID isEqualToString:[Constants uid]]){
                        //[self addPhotoMessage:senderID localized: photoUrl andMedia:media];
                        [self fetchImage:photoUrl forMediaItem:local sender:senderID exists:NO];
                        
                        
                    }else{
                        //[self addPhotoMessage:senderID localized:photoUrl andMedia:media];
                        [self fetchImage:photoUrl forMediaItem:local sender:senderID exists:NO];
                        
                    }
                    [[mRef child:snapshot.key] removeValue];
                }

            }else{[self delivered];}
            
        }
    }];
    
}



-(BOOL)isOutGoing:(NSString*)senderID{
    if([self.senderId isEqualToString:senderID]){
        return YES;
    }
    return NO;
}



-(void)fetchImage:(NSString*)photoUrl forMediaItem:(NSString*)item sender:(NSString*)key exists:(BOOL)locally
{
    
    if(locally){
        NSURL* path = [NSURL URLWithString:item].absoluteURL;
        NSData* data = [NSData dataWithContentsOfURL:path];
        UIImage* img = [UIImage imageWithData:data];
        JSQPhotoMediaItem* media = [[JSQPhotoMediaItem alloc]initWithImage:img];
        [self addPhotoMessage:key localized:item andMedia:media];
    }else{
        //NSString* truePath = [photoUrl stringByReplacingOccurrencesOfString:@"/" withString:@""];
       // NSURL* path = [Constants createdocumentsUrlFor:truePath];
        //NSData* data = [NSData dataWithContentsOfURL:[Constants createdocumentsUrlFor:truePath]];
        //UIImage* img = [UIImage imageWithData:data];
        
            //JSQPhotoMediaItem* media = [[JSQPhotoMediaItem alloc]initWithMaskAsOutgoing:[self isOutGoing:key]];
            /*media.image = img;
            [self addPhotoMessage:key localized:item andMedia:media];
            [self.mediaItems setObject:path forKey:item];*/
            
            FIRStorageReference* ref = [[FIRStorage storage]referenceForURL:photoUrl];
            [ref dataWithMaxSize:(INT64_MAX) completion:^(NSData * _Nullable data, NSError * _Nullable error) {
                if (error){
                    //NSLog(@"Error downloading pic %@",error.debugDescription);
                }
                
                [ref metadataWithCompletion:^(FIRStorageMetadata * _Nullable metadata, NSError * _Nullable meterror) {
                    if (meterror){}
                    if([metadata.contentType isEqualToString:@"image/gif"]){
                        //swifgig
                    }else{
                        UIImage* image = [UIImage imageWithData:data];
                        JSQPhotoMediaItem* media = [[JSQPhotoMediaItem alloc]initWithMaskAsOutgoing:[self isOutGoing:key]];
                        media.image = image;
                        [self saveImageToPhotos:image]; 
                        [self addPhotoMessage:key localized:item andMedia:media];
                        //NSData* imgData = UIImageJPEGRepresentation(image, 1.0);
                        //[imgData writeToURL:path atomically:NO];
                        if(![key isEqualToString:[Constants uid]]){
                            [ref deleteWithCompletion:^(NSError * _Nullable error) {
                                if (error){
                                    //NSLog(@"Error occured whiles deleting files");
                                    return;
                                }
                               // NSLog(@"Succesfully deleted");
                            }];
                        }
                    }
                    [self.collectionView reloadData];
                    
                    if(key){
                        [self.mediaItems removeObjectForKey:key];
                    }
                }];
            }];
        
    }

    [self.collectionView reloadData];
    
}

-(void)cleanUpDB
{
    [[[[DatabaseService main]messageRef]child:_challengeKey]observeSingleEventOfType:(FIRDataEventTypeValue) withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if([snapshot exists]){
            NSArray* keys =[(NSDictionary*)snapshot.value allKeys];
            if(keys.count > 25){
                NSUInteger op = keys.count - 25;
                    [[[[[DatabaseService main]messageRef]child:_challengeKey]queryLimitedToFirst:op]observeSingleEventOfType:(FIRDataEventTypeChildAdded) withBlock:^(FIRDataSnapshot * _Nonnull resnapshot) {
                        if ([resnapshot exists]){
                            [[[[[DatabaseService main]messageRef]child:_challengeKey]child:snapshot.key]removeValue];
                        }
                    }];
                }
            }
    }];
}

-(void)saveImageToPhotos:(UIImage*)image
{
    if(_shouldSave){
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized){
                UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSaved:didFinishSavingWithError:contextInfo:), nil);
            }else{
                [[NSUserDefaults standardUserDefaults]setBool:NO forKey:AUTO_SAVEPHOTO];
            }
        }];
    }
}

-(void)imageSaved:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    if (error == nil){}else{}
    
}

#pragma mark: - NAVIGATION

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"ImageViews"]){
        ImageViewsVC* vc = [segue destinationViewController];
        if(sender){
            JSQMessage* mess = (JSQMessage*)sender;
            UIImageView* imageView = (UIImageView*)[mess.media mediaView];
            UIImage* img = imageView.image;
            vc.image = img;
        }
    }
}

@end
