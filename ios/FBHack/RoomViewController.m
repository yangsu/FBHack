//
//  RoomViewController.m
//  FBHack
//
//  Created by Brandon Millman on 10/5/12.
//  Copyright (c) 2012 Brandon Millman. All rights reserved.
//

#import "RoomViewController.h"

#import "SocketCenter.h"
#import "ImgurUploader.h"
#import "ContentPusher.h"
#import <QuartzCore/QuartzCore.h>
#import "BButton+FontAwesome.h"
#import "DACircularProgressView.h"
#import "FacebookSDK.h"
#import "JPImagePickerController.h"
#import "UIImageView+AFNetworking.h"
#import "UIImageResizing.h"

#define kEventNewContent @"NEW_CONTENT"
#define kEventSetLike @"SET_LIKES"
#define kEventSetDislike @"SET_DISLIKES"

@interface RoomViewController ()<SocketCenterDelegate, ImgurUploaderDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) SocketCenter *socketCenter;
@property (nonatomic, strong) ImgurUploader *imgurUploader;
@property (nonatomic, strong) UIImageView *selectedImageView;
@property (nonatomic, copy) NSString *selectedImageURL;
@property (nonatomic, strong) ContentPusher *contentPusher;
@property (nonatomic, strong) UIActivityIndicatorView *progressView;
@property (nonatomic, strong) UIImageView *checkView;
//@property (nonatomic, strong) NSMutableArray *facebookPhotos;
//@property (nonatomic, strong) NSMutableArray *completeHack;
@end

@implementation RoomViewController

@synthesize photoButton = _photoButton;
@synthesize youtubeButton = _youtubeButton;
@synthesize cameraButton = _cameraButton;
@synthesize helperView = _helperView;
@synthesize roomID = _roomID;
@synthesize socketCenter = _socketCenter;
@synthesize imgurUploader = _imgurUploader;
@synthesize selectedImageView = selectedImageView;
@synthesize selectedImageURL = _selectedImageURL;
@synthesize contentPusher = _contentPusher;
@synthesize progressView = _progressView;
@synthesize checkView = _checkView;
//@synthesize facebookPhotos = _facebookPhotos;
//@synthesize completeHack = _completeHack;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _imgurUploader = [[ImgurUploader alloc] init];
        _imgurUploader.delegate = self;
        
//        _facebookPhotos = [[NSMutableArray alloc] init];
//        
//        _completeHack = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - SocketCenterDelegate

- (void)eventOccurred:(NSString *)event withPayload:(NSDictionary *)payload
{
    
}

#pragma mark - ImgurUploaderDelegate

-(void)imageUploadedWithURLString:(NSString*)urlString
{
    NSLog(urlString);
    self.selectedImageURL = urlString;
    [self.progressView stopAnimating];

    [UIView animateWithDuration:1
                          delay:0
                        options: UIViewAnimationCurveLinear
                     animations:^{
                         self.checkView.alpha = 1;
                         self.progressView.alpha = 0;
                     }
                     completion:^(BOOL finished){
                     }];

}

-(void)uploadProgressedToPercentage:(CGFloat)percentage
{
//    self.progressView.hidden = !( percentage > 0.0 && percentage < 1.0 );
//    self.progres
//    [self.progressView setProgress:percentage animated:YES];
//    self.progressView.alpha = 1;
}

-(void)uploadFailedWithError:(NSError*)error
{
    NSLog(@"%@", error);

}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    CGSize scaled = CGSizeMake(selectedImage.size.width/4, selectedImage.size.height/4);
   	[self.imgurUploader uploadImage:[UIImage image:selectedImage scaleToSize:scaled]];
    [self.selectedImageView setImage:selectedImage];
    self.selectedImageView.center = CGPointMake(self.view.center.x, self.view.center.y - 30);
    self.selectedImageView.alpha = 1;
    self.helperView.alpha = 0;
    self.progressView.alpha = 1;
    [self.progressView startAnimating];
}


#pragma mark - Instance methods

- (IBAction)photoPressed:(UIButton *)sender
{
    UIImagePickerControllerSourceType sourceType = sender.tag == 1 ? UIImagePickerControllerSourceTypePhotoLibrary : UIImagePickerControllerSourceTypeCamera;
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
	imagePicker.sourceType = sourceType;
    imagePicker.delegate = self;
	[self presentViewController:imagePicker animated:YES completion:nil];
}

- (IBAction)facebookPressed:(id)sender
{
//    JPImagePickerController *picker = [[JPImagePickerController alloc] initWithNibName:nil bundle:nil];
//    picker.delegate = self;
//    picker.dataSource = self;
//    [self presentViewController:picker animated:YES completion:nil];

}

- (void)handlePanFrom:(UIPanGestureRecognizer*)recognizer
{
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        if (self.selectedImageURL) {
            [self.contentPusher pushPhoto:self.selectedImageURL withWidth:self.selectedImageView.image.size.width withHeight:self.selectedImageView.image.size.height];
            [UIView animateWithDuration:0.7
                                  delay:0
                                options: UIViewAnimationCurveLinear
                             animations:^{
                                 self.selectedImageView.center = CGPointMake(self.view.center.x, -200);
                                 
                             }
                             completion:^(BOOL finished){
                                 NSLog(@"Done!");
                                 self.selectedImageURL = nil;
                                 
                                 [UIView animateWithDuration:1
                                                       delay:0
                                                     options: UIViewAnimationCurveLinear
                                                  animations:^{
                                                      self.helperView.alpha = 1;
                                                      self.checkView.alpha = 0;
                                                  }
                                                  completion:^(BOOL finished){
                                                      self.selectedImageView.image = nil;
                                                  }];
                             }];
        }
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
    }
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"noisy_grid"]];
    
    self.selectedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 220, 220)];
    self.selectedImageView.layer.cornerRadius = 5.0;
    self.selectedImageView.layer.masksToBounds = YES;
    self.selectedImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.selectedImageView.layer.borderWidth = 1.0;
    self.selectedImageView.alpha = 0;
    self.selectedImageView.contentMode  = UIViewContentModeScaleAspectFill;
    self.selectedImageView.clipsToBounds = YES;
    [self.view addSubview:self.selectedImageView];
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"NewTitle" style: UIBarButtonItemStyleBordered target: nil action: nil];
    
    [[self navigationItem] setBackBarButtonItem: newBackButton];
    
    
    UIPanGestureRecognizer* panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
    
    self.cameraButton.color = [UIColor purpleColor];
    [self.cameraButton makeAwesomeWithIcon:FAIconCamera];
    self.photoButton.color = [UIColor purpleColor];
    [self.photoButton makeAwesomeWithIcon:FAIconPicture];
    self.youtubeButton.color = [UIColor purpleColor];
    [self.youtubeButton makeAwesomeWithIcon:FAIconFacebook];


    self.progressView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.progressView.frame = CGRectMake(280, 12, 20, 20);
    [self.navigationController.navigationBar addSubview:self.progressView];
    
    self.checkView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check"]];
    self.checkView.frame = CGRectMake(280, 12, 20, 20);
    self.checkView.alpha = 0;
    [self.navigationController.navigationBar addSubview:self.checkView];
    
//    [[FBRequest requestForGraphPath:@"me/photos"] startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
//        
//        NSArray *infoList = [result objectForKey:@"data"];
//        for (id item in infoList) {
//            [self.facebookPhotos addObject:[item objectForKey:@"images"]];
//        }
//
//    }];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Accessors

- (void)setRoomID:(NSString *)roomID
{
    _roomID = [roomID copy];
    self.socketCenter = [SocketCenter centerWithRoomID:roomID andDelegate:self];
    self.contentPusher = [ContentPusher pusherWithRoomID:roomID];

}

//#pragma mark - JPImageDataSource
//
//- (NSInteger)numberOfImagesInImagePicker:(JPImagePickerController *)picker
//{
//    return [self.facebookPhotos count];
//}
//
//
//- (UIImage *)imagePicker:(JPImagePickerController *)picker thumbnailForImageNumber:(NSInteger)imageNumber
//{
//    NSDictionary *photoData = [self.facebookPhotos objectAtIndex:imageNumber];
//    NSString *url = [photoData objectForKey:@"source"];
//    UIImageView *temp = [[UIImageView alloc] init];
//    [temp setImageWithURL:[NSURL URLWithString:url]];
//    [self.completeHack addObject:temp];
//    return temp.image;
//    
//}
//
//
//- (UIImage *)imagePicker:(JPImagePickerController *)picker imageForImageNumber:(NSInteger)imageNumber
//{
//    NSDictionary *photoData = [self.facebookPhotos objectAtIndex:imageNumber];
//    NSString *url = [photoData objectForKey:@"source"];
//    UIImageView *temp = [[UIImageView alloc] init];
//    [temp setImageWithURL:[NSURL URLWithString:url]];
//    [self.completeHack addObject:temp];
//    return temp.image;
//}
//
//#pragma mark - JPImageDelegate
//
//
//- (void)imagePickerDidCancel:(JPImagePickerController *)picker
//{
//    [self dismissModalViewControllerAnimated:YES];
//}
//
//
//- (void)imagePicker:(JPImagePickerController *)picker didFinishPickingWithImageNumber:(NSInteger)imageNumber
//{
//    NSDictionary *photoData = [self.facebookPhotos objectAtIndex:imageNumber];
//    NSString *url = [photoData objectForKey:@"source"];
//    self.selectedImageURL = url;
//}


@end
