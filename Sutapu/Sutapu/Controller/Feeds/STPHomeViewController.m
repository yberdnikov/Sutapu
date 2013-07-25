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
#import "STPPostsViewController.h"
#import <RestKit/RestKit.h>

@interface STPHomeViewController () <STPAuthDelegate>

@property (weak, nonatomic) IBOutlet UIButton *createPostButton;
@property (nonatomic, strong) NSArray *contentDataSource;

@property (strong, nonatomic) DAPagesContainer *pagesContainer;

@end

@implementation STPHomeViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Home" image:[UIImage imageNamed:@"home_tab.png"] tag:0];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
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
    
    [self.view bringSubviewToFront:self.createPostButton];
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
    if ([segue.identifier isEqualToString:@"authControllerSegue"])
    {
        UINavigationController *navigationController = segue.destinationViewController;
        STPAuthViewController *authViewController = (STPAuthViewController *)navigationController.topViewController;
        authViewController.delegate = self;
    }
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
    __weak STPHomeViewController *weakSelf = self;
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/subscription" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        weakSelf.contentDataSource = mappingResult.array;
        [weakSelf buildSubscriptionsTabs];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:error.localizedDescription
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }];
}

- (void)buildSubscriptionsTabs
{
    __block NSMutableArray *controllers = [[NSMutableArray alloc] init];
    
    //in any case show recents posts
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    STPPostsViewController *postsController = [storyboard instantiateViewControllerWithIdentifier:@"postsViewController"];
    postsController.showRecentsPosts = YES;
    postsController.title = NSLocalizedString(@"Recents", @"Recents");
    
    [controllers addObject:postsController];
    
    if (!self.contentDataSource.count)
    {
        self.pagesContainer.viewControllers = controllers;
        return;
    }
    
    [self.contentDataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        STPPostsViewController *postsController = [storyboard instantiateViewControllerWithIdentifier:@"postsViewController"];
        postsController.subscriptionInfo = obj;
        postsController.title = postsController.subscriptionInfo.name;
        
        [controllers addObject:postsController];
    }];
    
    self.pagesContainer.viewControllers = controllers;
}

@end
