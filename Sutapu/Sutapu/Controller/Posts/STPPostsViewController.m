//
//  STPPostsViewController.m
//  Sutapu
//
//  Created by Yuriy Berdnikov on 7/25/13.
//  Copyright (c) 2013 Yuriy Berdnikov. All rights reserved.
//

#import "STPPostsViewController.h"
#import "STPPostViewCell.h"
#import "STPPostInfo+Additions.h"
#import <RestKit/RestKit.h>

@interface STPPostsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *contentTableView;
@property (nonatomic, strong) NSArray *contentDataSource;
@end

@implementation STPPostsViewController

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
    
    [self.contentTableView registerNib:[UINib nibWithNibName:@"STPPostViewCell" bundle:nil] forCellReuseIdentifier:@"postViewCell"];
    self.contentTableView.tableFooterView = [[UIView alloc] init];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data loading

- (void)loadData
{
    NSString *request;
    
    if (self.showRecentsPosts)
    {
        request = @"/post";
    }
    else
    {
        request = @"/post";
    }
    
    __weak STPPostsViewController *weakSelf = self;
    [[RKObjectManager sharedManager] getObjectsAtPath:request parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        weakSelf.contentDataSource = mappingResult.array;
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

#pragma mark - UITableView datasource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    STPPostInfo *post = [self.contentDataSource objectAtIndex:indexPath.row];
    return [post optimalCellSizeForPost];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    STPPostViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"postViewCell"];
    if (!cell)
        cell = [[STPPostViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"postViewCell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    STPPostInfo *post = [self.contentDataSource objectAtIndex:indexPath.row];

    cell.postInfo = post;
    
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

@end
