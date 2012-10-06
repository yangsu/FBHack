//
//  ConnectViewController.m
//  FBHack
//
//  Created by Brandon Millman on 10/5/12.
//  Copyright (c) 2012 Brandon Millman. All rights reserved.
//

#import "ConnectViewController.h"

#import "ZBarReaderViewController.h"
#import "RoomViewController.h"
#import "BButton+FontAwesome.h"
#import <QuartzCore/QuartzCore.h>



@interface ConnectViewController ()<ZBarReaderDelegate>

@end

@implementation ConnectViewController

@synthesize connectButton = _connectButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Connect";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"noisy_grid"]];
    
    self.connectButton.color = [UIColor purpleColor];
    [self.connectButton makeAwesomeWithIcon:FAIconSignin];
    self.connectButton.clipsToBounds = YES;
    self.connectButton.layer.cornerRadius = 80;//half of the width
    
    [self.connectButton.layer setShadowOffset:CGSizeMake(0.0, 5.0)];
    [self.connectButton.layer setShadowOpacity:0.8];
    [self.connectButton.layer setShadowRadius:2.0];
    [self.connectButton.layer setShadowColor:[UIColor blackColor].CGColor];

    
}

#pragma mark - Instance Methods

- (IBAction)nextPressed:(UIButton *)sender
{
    RoomViewController *roomViewController = [[RoomViewController alloc] initWithNibName:@"RoomViewController" bundle:nil];
    roomViewController.roomID = @"a_ee9pUu0Jr";
    roomViewController.title = @"Push Dis";
    [self.navigationController pushViewController:roomViewController animated:YES];
}

- (IBAction)connectPressed:(UIButton *)sender
{
    
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = reader.scanner;
    // TODO: (optional) additional reader configuration here
    
    // EXAMPLE: disable rarely used I2/5 to improve performance
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    
    
    CGFloat cameraTransformX = 1.0;
    CGFloat cameraTransformY = 1.12412;
    
    reader.cameraViewTransform = CGAffineTransformScale(reader.cameraViewTransform, cameraTransformX, cameraTransformY);
    
    // present and release the controller
    [self presentViewController:reader animated:NO completion:nil];
}

#pragma mark - ZBarReaderDelegate

- (void)imagePickerController:(UIImagePickerController*)reader didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    NSString *roomID;
    NSString *roomName;
    
    ZBarSymbolSet *symbols = [info objectForKey: ZBarReaderControllerResults];
    for (ZBarSymbol *symbol in symbols) {
        NSLog(symbol.data);
        NSArray* result = [symbol.data componentsSeparatedByString: @":"];
        roomID = [result objectAtIndex: 0];
        roomName = [result objectAtIndex: 1];
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        RoomViewController *roomViewController = [[RoomViewController alloc] initWithNibName:@"RoomViewController" bundle:nil];
        roomViewController.roomID = roomID;
        roomViewController.title = roomName;
        [self.navigationController pushViewController:roomViewController animated:YES];
    }];
   

    
}


@end
