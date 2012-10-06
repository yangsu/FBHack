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

#define kEventNewContent @"NEW_CONTENT"
#define kEventSetLike @"SET_LIKES"
#define kEventSetDislike @"SET_DISLIKES"

@interface RoomViewController ()<SocketCenterDelegate, ImgurUploaderDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) SocketCenter *socketCenter;
@property (nonatomic, strong) ImgurUploader *imgurUploader;
@property (nonatomic, strong) UIImageView *selectedImageView;
@property (nonatomic, copy) NSString *selectedImageURL;
@property (nonatomic, strong) ContentPusher *contentPusher;
@end

@implementation RoomViewController

@synthesize photoButton = _photoButton;
@synthesize youtubeButton = _youtubeButton;
@synthesize cameraButton = _cameraButton;
@synthesize roomID = _roomID;
@synthesize socketCenter = _socketCenter;
@synthesize imgurUploader = _imgurUploader;
@synthesize selectedImageView = selectedImageView;
@synthesize selectedImageURL = _selectedImageURL;
@synthesize contentPusher = _contentPusher;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _imgurUploader = [[ImgurUploader alloc] init];
        _imgurUploader.delegate = self;
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
}

-(void)uploadProgressedToPercentage:(CGFloat)percentage
{
    progressView.hidden = !( percentage > 0.0 && percentage < 1.0 );
	progressView.progress = percentage;
}

-(void)uploadFailedWithError:(NSError*)error
{
    NSLog(@"%@", error);

}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
   	[self.imgurUploader uploadImage:selectedImage];
    
    [self.selectedImageView setImage:selectedImage];
    
    self.selectedImageView.center = CGPointMake(self.view.center.x, self.view.center.y - 30);
    
    self.selectedImageView.alpha = 1;
    
    self.helperView.alpha = 0;


    [self dismissViewControllerAnimated:YES completion:nil];
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

- (IBAction)youtubePressed:(id)sender
{
    
}

- (void)handlePanFrom:(UIPanGestureRecognizer*)recognizer
{
    CGPoint translation = [recognizer translationInView:recognizer.view];
    CGPoint velocity = [recognizer velocityInView:recognizer.view];
    
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
                                                  }
                                                  completion:^(BOOL finished){
                                                      NSLog(@"Done!");
                                                      self.selectedImageURL = nil;
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
    
    self.title = @"Push";
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"noisy_grid"]];
    
    self.selectedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 180, 180)];
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
    [self.youtubeButton makeAwesomeWithIcon:FAIconFacetimeVideo];



    
    
    
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


@end
