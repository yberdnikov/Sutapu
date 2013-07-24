//
//  STPProfileViewController.m
//  Sutapu
//
//  Created by Yuriy Berdnikov on 7/24/13.
//  Copyright (c) 2013 Yuriy Berdnikov. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "STPProfileViewController.h"
#import "STPDataProxy.h"
#import <RestKit/RestKit.h>

@interface STPProfileViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;

@property (weak, nonatomic) IBOutlet UIImageView *userAvataImageView;

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIImageView *emailImageView;

@property (weak, nonatomic) IBOutlet UIImageView *passwordImageView;

@property (weak, nonatomic) IBOutlet UIImageView *bioImageView;
@property (weak, nonatomic) IBOutlet UITextView *bioTextField;

@property (weak, nonatomic) IBOutlet UIButton *changePasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

@end

@implementation STPProfileViewController

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
    
    self.userAvataImageView.layer.cornerRadius = 50.0f;
    self.userAvataImageView.layer.masksToBounds = YES;
    
    UIView *emailPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 10)];
    self.emailTextField.rightView = emailPaddingView;
    self.emailTextField.rightViewMode = UITextFieldViewModeAlways;
    
    UIView *usernamePaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 10)];
    self.usernameTextField.rightView = usernamePaddingView;
    self.usernameTextField.rightViewMode = UITextFieldViewModeAlways;
    
    self.usernameTextField.text = [[[STPDataProxy sharedDataProxy] loggedUserInfo] name];
    self.emailTextField.text = [[[STPDataProxy sharedDataProxy] loggedUserInfo] email];
    self.bioTextField.text = [[[STPDataProxy sharedDataProxy] loggedUserInfo] bio].length ? [[[STPDataProxy sharedDataProxy] loggedUserInfo] bio] : NSLocalizedString(@"Few words about me", @"Few words about me");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIButton selectors

- (IBAction)logoutButtonPressed:(UIButton *)sender
{
    [[STPDataProxy sharedDataProxy] setLoggedUserInfo:nil];
    
    [[RKObjectManager sharedManager] postObject:nil path:@"/auth/logout" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {

    }];
    
    self.tabBarController.selectedIndex = 0;
}


@end
