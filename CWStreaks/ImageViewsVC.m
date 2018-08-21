//
//  ImageViewsVC.m
//  CWStreaks
//
//  Created by Mensah Shadrach on 3/24/17.
//  Copyright © 2017 Mensah Shadrach. All rights reserved.
//

#import "ImageViewsVC.h"

@interface ImageViewsVC ()
@property (strong, nonatomic) UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UIView *tabView;
@property (weak, nonatomic) IBOutlet UIView *saveButton;
@property(nonatomic)CGFloat width;
@property(nonatomic)CGFloat height;
@property(nonatomic)BOOL tapped;
@end

@implementation ImageViewsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    //[self.imageView setAutoresizingMask:(UIViewAutoresizingFlexibleBottomMargin  | UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin)];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped:)];
    [tap setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tap];
    if (self.image){
        
        /*if([self.imagePath hasPrefix:@"file"]){
            data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.imagePath]];
        }else{
            NSString* tp = [self.imagePath stringByReplacingOccurrencesOfString:@"/" withString:@""];
            NSURL* filePath = [Constants createdocumentsUrlFor:tp];
             data = [NSData dataWithContentsOfURL:filePath];
        }*/
        
        //UIImage* img = [UIImage imageWithData:data];
        //NSLog(@"the size of image is %f and %f",img.size.height, img.size.width);
        [self.mainImageView setImage:_image];
        self.width = _image.size.width;
        self.height = _image.size.height;
    }
    //CGFloat scale = self.width/_height;
    //CGFloat scaleHeight = self.imageView.frame.size.height * scale;
    //CGFloat y = self.view.frame.size.height - scaleHeight;
    

    // Creates a view Dictionary to be used in constraints
    NSDictionary *viewsDictionary;
    
    // Creates an image view with a test image
    self.mainImageView = [[UIImageView alloc] init];
    [self.mainImageView setClipsToBounds:YES];
    UIImage *turnImage = self.image;
    [self.mainImageView setImage:turnImage];
    
    // Add the imageview to the scrollview
    [self.mainScrollView addSubview:self.mainImageView];
    
    // Sets the following flag so that auto layout is used correctly
    self.mainScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.mainImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Sets the scrollview delegate as self
    self.mainScrollView.delegate = self;
    
    // Creates references to the views
    UIScrollView *scrollView = self.mainScrollView;
    
    // Sets the image frame as the image size
    self.mainImageView.frame = CGRectMake(0,(self.view.frame.size.height - turnImage.size.height)/2, turnImage.size.width, turnImage.size.height);
    
    // Tell the scroll view the size of the contents
    self.mainScrollView.contentSize = turnImage.size;
    
    // Set the constraints for the scroll view
    viewsDictionary = NSDictionaryOfVariableBindings(scrollView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|" options:0 metrics:0 views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]-(50)-|" options:0 metrics: 0 views:viewsDictionary]];
    
    // Add doubleTap recognizer to the scrollView
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [self.mainScrollView addGestureRecognizer:doubleTapRecognizer];
    
    // Add two finger recognizer to the scrollView
    UITapGestureRecognizer *twoFingerTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTwoFingerTapped:)];
    twoFingerTapRecognizer.numberOfTapsRequired = 1;
    twoFingerTapRecognizer.numberOfTouchesRequired = 2;
    [self.mainScrollView addGestureRecognizer:twoFingerTapRecognizer];
    

    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self setupScales];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)saveImage:(id)sender {
    UIAlertController* camLert = [UIAlertController alertControllerWithTitle:@"Save To Photos" message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction* camera = [UIAlertAction actionWithTitle:@"Save To Photos" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self SaveToPhotos];
    }];
    UIAlertAction* photo = [UIAlertAction actionWithTitle:@"Cancel" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {}];\
    [camLert addAction:camera]; [camLert addAction:photo];
    [self presentViewController:camLert animated:YES completion:nil];
}

-(void)SaveToPhotos
{
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized){
                UIImageWriteToSavedPhotosAlbum(self.mainImageView.image, self, @selector(imageSaved:didFinishSavingWithError:contextInfo:), nil);
            }else{
                UIAlertController* camLert = [UIAlertController alertControllerWithTitle:@"Streaker has been denied access to your Photo Library. Grant Streaker access via Settings" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction* camera = [UIAlertAction actionWithTitle:@"Save To Photos" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
                }];
                UIAlertAction* photo = [UIAlertAction actionWithTitle:@"Cancel" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {}];\
                [camLert addAction:photo]; [camLert addAction:camera];
                [self presentViewController:camLert animated:YES completion:nil];
            }
        }];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.mainImageView.center = self.view.center;
    self.tabView.layer.shadowColor = [[UIColor grayColor]CGColor];
    self.tabView.layer.shadowRadius = 2.0;
    self.tabView.layer.shadowOffset = CGSizeMake(4, 2);
    self.tabView.backgroundColor = [[UIColor alloc]initWithRed:0.6112 green:0.4 blue:1 alpha:1];
    //self.mainImageView.frame = CGRectMake(0,(self.view.frame.size.height - self.image.size.height)/2, self.image.size.width, self.image.size.height);
    /*CGFloat scale = self.width/_height;
    CGFloat scaleHeight = self.imageView.frame.size.height * scale;
    CGFloat y = self.view.frame.size.height - scaleHeight;
    
    CGRect frame = CGRectMake(0, y / 2, self.view.frame.size.width, scaleHeight);
    [self.imageView setFrame:frame];*/

}

-(void)tapped:(UITapGestureRecognizer*)tap
{
    if (_tapped){
        [UIView animateWithDuration:0.4 animations:^{
            [self.tabView setAlpha:1];
            [self.navigationController setNavigationBarHidden:NO];
            [self.view setBackgroundColor:[UIColor whiteColor]];
        }];
        self.tapped = NO;
    }else{
        [UIView animateWithDuration:0.4 animations:^{
            [self.tabView setAlpha:0];
            [self.navigationController setNavigationBarHidden:YES];
            [self.view setBackgroundColor:[UIColor blackColor]];
        }];
        self.tapped = YES;
    }
}

-(void)imageSaved:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo
{
    if (error == nil){
        UIAlertController* a = [Constants createDefaultAlert:@"Saved" title:@"Photo succesfully saved to Library" message:@"OK"];
        [self presentViewController:a animated:YES completion:nil];
    }else{
        
    UIAlertController* a = [Constants createDefaultAlert:@"Error" title:@"Photo could not be saved" message:@"Dismiss"];
        [self presentViewController:a animated:YES completion:nil];
    }

}


#pragma mark -
#pragma mark - Scroll View scales setup and center

-(void)setupScales {
    // Set up the minimum & maximum zoom scales
    CGRect scrollViewFrame = self.mainScrollView.frame;
    CGFloat scaleWidth = scrollViewFrame.size.width / self.mainScrollView.contentSize.width;
    CGFloat scaleHeight = scrollViewFrame.size.height / self.mainScrollView.contentSize.height;
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    
    self.mainScrollView.minimumZoomScale = minScale;
    self.mainScrollView.maximumZoomScale = 1.0f;
    self.mainScrollView.zoomScale = minScale;
    
    [self centerScrollViewContents];
}

- (void)centerScrollViewContents {
    // This method centers the scroll view contents also used on did zoom
    CGSize boundsSize = self.mainScrollView.bounds.size;
    CGRect contentsFrame = self.mainImageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.mainImageView.frame = contentsFrame;
}

#pragma mark -
#pragma mark - ScrollView Delegate methods
- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    // Return the view that we want to zoom
    self.mainImageView.center = self.view.center;
    return self.mainImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // The scroll view has zoomed, so we need to re-center the contents
    self.mainImageView.center = self.view.center;
    [self centerScrollViewContents];
}

#pragma mark -
#pragma mark - ScrollView gesture methods
- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer {
    // Get the location within the image view where we tapped
    CGPoint pointInView = [recognizer locationInView:self.mainImageView];
    
    // Get a zoom scale that's zoomed in slightly, capped at the maximum zoom scale specified by the scroll view
    CGFloat newZoomScale = self.mainScrollView.zoomScale * 1.5f;
    newZoomScale = MIN(newZoomScale, self.mainScrollView.maximumZoomScale);
    
    // Figure out the rect we want to zoom to, then zoom to it
    CGSize scrollViewSize = self.mainScrollView.bounds.size;
    
    CGFloat w = scrollViewSize.width / newZoomScale;
    CGFloat h = scrollViewSize.height / newZoomScale;
    CGFloat x = pointInView.x - (w / 2.0f);
    CGFloat y = pointInView.y - (h / 2.0f);
    
    CGRect rectToZoomTo = CGRectMake(x, y, w, h);
    
    [self.mainScrollView zoomToRect:rectToZoomTo animated:YES];
}

- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer*)recognizer {
    // Zoom out slightly, capping at the minimum zoom scale specified by the scroll view
    CGFloat newZoomScale = self.mainScrollView.zoomScale / 1.5f;
    newZoomScale = MAX(newZoomScale, self.mainScrollView.minimumZoomScale);
    [self.mainScrollView setZoomScale:newZoomScale animated:YES];
}

#pragma mark -
#pragma mark - Rotation

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    // When the orientation is changed the contentSize is reset when the frame changes. Setting this back to the relevant image size
    self.mainScrollView.contentSize = self.mainImageView.image.size;
    // Reset the scales depending on the change of values
    [self setupScales];
}


//after
- (UIImage *)scaleAndRotateImage:(UIImage *)image
{
    int kMaxResolution = 320; // Or whatever
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
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
