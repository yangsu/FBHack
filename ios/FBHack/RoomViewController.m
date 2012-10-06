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

#define kEventNewContent @"NEW_CONTENT"
#define kEventSetLike @"SET_LIKES"
#define kEventSetDislike @"SET_DISLIKES"

@interface RoomViewController ()<SocketCenterDelegate, ImgurUploaderDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) SocketCenter *socketCenter;
@property (nonatomic, strong) ImgurUploader *imgurUploader;
@end

@implementation RoomViewController

@synthesize roomID = _roomID;
@synthesize socketCenter = _socketCenter;
@synthesize imgurUploader = _imgurUploader;


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
    
}

-(void)uploadProgressedToPercentage:(CGFloat)percentage
{
    
}

-(void)uploadFailedWithError:(NSError*)error
{
    
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
}

#pragma mark - Instance methods

- (IBAction)photoPressed:(id)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
	imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	[self presentViewController:imagePicker animated:YES completion:nil];
}

- (IBAction)youtubePressed:(id)sender
{
    
}

- (IBAction)cameraPressed:(id)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
	[self presentViewController:imagePicker animated:YES completion:nil];
}



#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
}

@end
