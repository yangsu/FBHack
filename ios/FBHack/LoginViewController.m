//
//  LoginViewController.m
//  FBHack
//
//  Created by Brandon Millman on 10/6/12.
//  Copyright (c) 2012 Brandon Millman. All rights reserved.
//

#import "LoginViewController.h"

#import "AppDelegate.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Instance methods

- (IBAction)loginPressed:(id)sender
{
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate openSession];
}

- (void)loginFailed
{
    
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

@end
