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
#import "DAPagesContainer.h"
#import "Constants.h"
#import "NSString+Utilities.h"

@interface STPHomeViewController () <STPAuthDelegate>

@property (strong, nonatomic) DAPagesContainer *pagesContainer;

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
    
    self.pagesContainer = [[DAPagesContainer alloc] init];
    [self.pagesContainer willMoveToParentViewController:self];
    self.pagesContainer.view.frame = self.view.bounds;
    self.pagesContainer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.pagesContainer.view];
    [self.pagesContainer didMoveToParentViewController:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([STPDataProxy sharedDataProxy].loggedUserInfo && [STPDataProxy sharedDataProxy].sailsID.length)
    {
        [self loadData];
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

#pragma mark - Data loading

- (void)loadData
{
    UIViewController *beaverViewController = [[UIViewController alloc] init];
    UIImageView *beaverImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"beaver.jpg"]];
    beaverImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [beaverViewController.view addSubview:beaverImageView];
    beaverViewController.title = @"BEAVER";
    
    UIViewController *buckDeerViewController = [[UIViewController alloc] init];
    UIImageView *buckDeerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"buckDeer.jpg"]];
    buckDeerImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [buckDeerViewController.view addSubview:buckDeerImageView];
    buckDeerViewController.title = @"BUCK DEER";
    
    UIViewController *catViewController = [[UIViewController alloc] init];
    UIImageView *catImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cat.jpg"]];
    catImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [catViewController.view addSubview:catImageView];
    catViewController.title = @"CAT";
    
    UIViewController *lionViewController = [[UIViewController alloc] init];
    UIImageView *lionImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lion.jpg"]];
    lionImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [lionViewController.view addSubview:lionImageView];
    lionViewController.title = @"REALLY CUTE LION";
    
    self.pagesContainer.viewControllers = @[beaverViewController, buckDeerViewController, catViewController, lionViewController];
}

@end
