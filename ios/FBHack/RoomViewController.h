//
//  RoomViewController.h
//  FBHack
//
//  Created by Brandon Millman on 10/5/12.
//  Copyright (c) 2012 Brandon Millman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoomViewController : UIViewController

- (IBAction)photoPressed:(id)sender;
- (IBAction)youtubePressed:(id)sender;
- (IBAction)cameraPressed:(id)sender;


@property (nonatomic, copy) NSString *roomID;

@end
