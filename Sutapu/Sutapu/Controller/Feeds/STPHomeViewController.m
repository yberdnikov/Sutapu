//
//  STPHomeViewController.m
//  Sutapu
//
//  Created by Yuriy Berdnikov on 7/24/13.
//  Copyright (c) 2013 Yuriy Berdnikov. All rights reserved.
//

#import "STPHomeViewController.h"
#import "STPAuthDelegate.h"
#import "STPAuthViewController.h"
#import "STPDataProxy.h"

@interface STPHomeViewController () <STPAuthDelegate>

@end

@implementation STPHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([STPDataProxy sharedDataProxy].loggedUserInfo)
    {
        
    }
    else
    {
        [self performSegueWithIdentifier:@"authControllerSegue" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UINavigationController *navigationController = segue.destinationViewController;
    STPAuthViewController *authViewController = (STPAuthViewController *)navigationController.topViewController;
    authViewController.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - STPAuthDelegate methods

- (void)userWasLogged:(BOOL)isNewUser
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
