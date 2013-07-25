//
//  STPSubscriptionsViewController.m
//  Sutapu
//
//  Created by Yuriy Berdnikov on 7/25/13.
//  Copyright (c) 2013 Yuriy Berdnikov. All rights reserved.
//

#import "STPSubscriptionsViewController.h"
#import "MOOPullGestureRecognizer.h"
#import "MOOPullGestureRecognizer.h"
#import "MOOCreateView.h"
#import <RestKit/RestKit.h>

@interface STPSubscriptionsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *contentTableView;
@property (nonatomic, strong) NSMutableArray *contentDataSource;
@end

@implementation STPSubscriptionsViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Subscriptions" image:[UIImage imageNamed:@"subscribtions.png"] tag:1];
    }
    return self;
}

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
    
    self.contentTableView.tableFooterView = [[UIView alloc] init];
    
    // Add pull gesture recognizer
    MOOPullGestureRecognizer *recognizer = [[MOOPullGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    
    // Create cell
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.backgroundColor = self.contentTableView.backgroundColor; // UITableViewCell background color is transparent by default
    cell.imageView.image = [UIImage imageNamed:@"Arrow-Bucket.png"];
    
    // Create create view
    MOOCreateView *createView = [[MOOCreateView alloc] initWithCell:cell];
    createView.configurationBlock = ^(MOOCreateView *view, UITableViewCell *cell, MOOPullState state){
        if (![cell isKindOfClass:[UITableViewCell class]])
            return;
        
        switch (state)
        {
            case MOOPullActive:
            case MOOPullTriggered:
                cell.textLabel.text = NSLocalizedStringFromTable(@"Release to create item\u2026", @"MOOPullGesture", @"Release to create item");
                break;
            case MOOPullIdle:
                cell.textLabel.text = NSLocalizedStringFromTable(@"Pull to create item\u2026", @"MOOPullGesture", @"Pull to create item");
                break;
                
        }
    };
    recognizer.triggerView = createView;
    [self.contentTableView addGestureRecognizer:recognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data loading

- (void)loadData
{
    __weak STPSubscriptionsViewController *weakSelf = self;
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/subscription" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        weakSelf.contentDataSource = [[NSMutableArray alloc] initWithArray:mappingResult.array];
        [weakSelf.contentTableView reloadData];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:error.localizedDescription
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }];
}

#pragma mark - UIScrollViewDelegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    if (scrollView.pullGestureRecognizer)
        [scrollView.pullGestureRecognizer scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
{
    if (scrollView.pullGestureRecognizer)
        [scrollView.pullGestureRecognizer resetPullState];
}

#pragma mark - UITableView datasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    STPPostInfo *post = [self.contentDataSource objectAtIndex:indexPath.row];
//    return [post optimalCellSizeForPost];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"subscriptionViewCell"];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"subscriptionViewCell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    STPPostInfo *post = [self.contentDataSource objectAtIndex:indexPath.row];
//    
//    cell.postInfo = post;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contentDataSource.count;
}

#pragma mark - UITableView delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - MOOPullGestureRecognizer targets

- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer;
{
    if (gestureRecognizer.state == UIGestureRecognizerStateRecognized) {
        if ([gestureRecognizer conformsToProtocol:@protocol(MOOPullGestureRecognizer)])
            [self _pulledToCreate:(UIGestureRecognizer<MOOPullGestureRecognizer> *)gestureRecognizer];
    }
}

- (void)_pulledToCreate:(UIGestureRecognizer<MOOPullGestureRecognizer> *)pullGestureRecognizer;
{
    CGPoint contentOffset = self.contentTableView.contentOffset;
    contentOffset.y -= CGRectGetMinY(pullGestureRecognizer.triggerView.frame);
    [self.contentTableView reloadData];
    self.contentTableView.contentOffset = contentOffset;
    
    [self performSegueWithIdentifier:@"subscriptionComposerSegue" sender:self];
}


@end
