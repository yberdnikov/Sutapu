//
//  STPSignUpViewController.m
//  Sutapu
//
//  Created by Yuriy Berdnikov on 7/24/13.
//  Copyright (c) 2013 Yuriy Berdnikov. All rights reserved.
//

#import "STPSignUpViewController.h"
#import "NSString+Utilities.h"
#import <RestKit/RestKit.h>
#import "STPDataProxy.h"

@interface STPSignUpViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIButton *termsOfServiceButton;
@property (weak, nonatomic) IBOutlet UIButton *privacyPolicyButton;

@end

@implementation STPSignUpViewController

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
    
    [self.backButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    UIView *usernamePaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    self.usernameTextField.leftView = usernamePaddingView;
    self.usernameTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *emailPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    self.emailTextField.leftView = emailPaddingView;
    self.emailTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *passwordPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    self.passwordTextField.leftView = passwordPaddingView;
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITapGestureRecognizer methods

- (IBAction)viewWasTapped:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
}

#pragma mark - UIButtons selectors

- (IBAction)backButtonPressed:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)signUpButtonPressed:(UIButton *)sender
{
    [self signupUser];
}

- (IBAction)termsOfServiceButtonPressed:(UIButton *)sender
{
    
}

- (IBAction)privacyPolicyButtonPressed:(UIButton *)sender
{
    
}

#pragma mark - UITextField delegate methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return ![string isEqualToString:@" "];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.usernameTextField)
        [self.emailTextField becomeFirstResponder];
    else if (textField == self.emailTextField)
        [self.passwordTextField becomeFirstResponder];
    else
    {
        [self.view endEditing:YES];
        [self signupUser];
    }
    
    return YES;
}

#pragma mark - Sign up request

- (void)signupUser
{
    if (!self.usernameTextField.text.length || !self.emailTextField.text.length ||
        !self.passwordTextField.text.length)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"All fields must be filled!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    if (![self.emailTextField.text isValidEmailFormat])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Please enter a valid E-mail address"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        [self.emailTextField becomeFirstResponder];
        
        return;
    }
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:self.usernameTextField.text, @"displayName",
                            self.emailTextField.text, @"email",
                            self.passwordTextField.text, @"password", nil];
    
    [[RKObjectManager sharedManager] postObject:nil path:@"/user/create" parameters:params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {

        [self.delegate userWasLogged:YES];
        [[STPDataProxy sharedDataProxy] setLoggedUserInfo:[mappingResult firstObject]];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:error.localizedDescription
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }];
}

@end
