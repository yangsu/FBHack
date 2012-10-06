//
//  ConnectViewController.h
//  FBHack
//
//  Created by Brandon Millman on 10/5/12.
//  Copyright (c) 2012 Brandon Millman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BButton;

@interface ConnectViewController : UIViewController

- (IBAction)connectPressed:(UIButton *)sender;

- (IBAction)nextPressed:(UIButton *)sender;

- (IBAction)albumPressed:(UIButton *)sender;


@property (nonatomic, weak) IBOutlet BButton *connectButton;




@end
