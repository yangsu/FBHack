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

#define kEventNewContent @"NEW_CONTENT"
#define kEventSetLike @"SET_LIKES"
#define kEventSetDislike @"SET_DISLIKES"

@interface RoomViewController ()<SocketCenterDelegate, ImgurUploaderDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) SocketCenter *socketCenter;
@property (nonatomic, strong) ImgurUploader *imgurUploader;
@property (nonatomic, strong) UIButton *selectedImageButton;
@property (nonatomic, strong) ContentPusher *contentPusher;
@end

@implementation RoomViewController

@synthesize roomID = _roomID;
@synthesize socketCenter = _socketCenter;
@synthesize imgurUploader = _imgurUploader;
@synthesize selectedImageButton = selectedImageButton;
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
   [self.contentPusher pushContent:urlString];
    NSLog(urlString);
}

-(void)uploadProgressedToPercentage:(CGFloat)percentage
{
    
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
    
    [self.selectedImageButton setImage:selectedImage forState:UIControlStateNormal];
    self.selectedImageButton.center = self.view.center;

    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Image animation handling

- (IBAction)imageMoved:(id)sender withEvent:(UIEvent *)event
{
    CGPoint point = [[[event allTouches] anyObject] locationInView:self.view];
    UIControl *control = sender;
    
    CGPoint delta = CGPointMake(point.x - control.center.x, point.y - control.center.y);

    control.center = point;


}

- (IBAction)imageReleased:(id)sender withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.7
                          delay:0
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         self.selectedImageButton.center = self.view.center;
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Done!");
                     }];
}


#pragma mark - Instance methods

- (IBAction)photoPressed:(UIButton *)sender
{
    UIImagePickerControllerSourceType sourceType = [sender.currentTitle isEqualToString:@"Photo"] ? UIImagePickerControllerSourceTypePhotoLibrary : UIImagePickerControllerSourceTypeCamera;
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
	imagePicker.sourceType = sourceType;
    imagePicker.delegate = self;
	[self presentViewController:imagePicker animated:YES completion:nil];
}

- (IBAction)youtubePressed:(id)sender
{
    
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.selectedImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //[button addTarget:self action:@selector(imageTouch:withEvent:) forControlEvents:UIControlEventTouchDown];
    [self.selectedImageButton addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [self.selectedImageButton addTarget:self action:@selector(imageReleased:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    self.selectedImageButton.frame = CGRectMake(0, 0, 160, 160);
    [self.view addSubview:self.selectedImageButton];
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
