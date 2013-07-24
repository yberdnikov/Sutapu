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

@property (nonatomic, strong) UITextField *activeTextField;

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
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
    
    [[RKObjectManager sharedManager] postObject:nil path:@"/auth/logout" parameters:nil success:nil failure:nil];
    
    self.tabBarController.selectedIndex = 0;
}

- (IBAction)saveButtonPressed:(UIButton *)sender
{
    NSDictionary *parameters = @{@"displayName" : self.usernameTextField.text, @"bio" : self.bioTextField.text};
    
    NSString *request = [[NSString alloc] initWithFormat:@"%@%@", @"/user/update/", [STPDataProxy sharedDataProxy].loggedUserInfo.userID];
    
    [[RKObjectManager sharedManager] postObject:nil path:request parameters:parameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        [STPDataProxy sharedDataProxy].loggedUserInfo.name = self.usernameTextField.text;
        [STPDataProxy sharedDataProxy].loggedUserInfo.bio = self.bioTextField.text;
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:error.localizedDescription
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }];
}

#pragma mark - UITapGesture recognizer selector

- (IBAction)scrollViewWasTapped:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
}

#pragma mark - Keyboard handling

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (self.bioTextField.text.length >= 100 && text.length)
        return NO;
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.activeTextField = nil;
    
    if (textField == self.usernameTextField && !self.usernameTextField.text.length)
        self.usernameTextField.text = [STPDataProxy sharedDataProxy].loggedUserInfo.name;
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary *info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height - CGRectGetHeight(self.tabBarController.tabBar.frame), 0.0);
    self.contentScrollView.contentInset = contentInsets;
    self.contentScrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.activeTextField.frame.origin))
    {
        CGPoint scrollPoint = CGPointMake(0.0, self.activeTextField.frame.origin.y - kbSize.height);
        [self.contentScrollView setContentOffset:scrollPoint animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.contentScrollView.contentInset = contentInsets;
    self.contentScrollView.scrollIndicatorInsets = contentInsets;
}
@end
