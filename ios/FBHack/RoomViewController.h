//
//  RoomViewController.h
//  FBHack
//
//  Created by Brandon Millman on 10/5/12.
//  Copyright (c) 2012 Brandon Millman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BButton;

@interface RoomViewController : UIViewController

- (IBAction)photoPressed:(id)sender;
- (IBAction)youtubePressed:(id)sender;
- (IBAction)cameraPressed:(id)sender;

@property (nonatomic, weak) IBOutlet BButton *photoButton;
@property (nonatomic, weak) IBOutlet BButton *youtubeButton;
@property (nonatomic, weak) IBOutlet BButton *cameraButton;

@property (nonatomic, weak) IBOutlet UIView *helperView;



@property (nonatomic, copy) NSString *roomID;

@end
