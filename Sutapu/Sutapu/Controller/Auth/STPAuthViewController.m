//
//  STPAuthViewController.m
//  Sutapu
//
//  Created by Yuriy Berdnikov on 7/24/13.
//  Copyright (c) 2013 Yuriy Berdnikov. All rights reserved.
//

#import "STPAuthViewController.h"
#import "NSString+Utilities.h"
#import <RestKit/RestKit.h>
#import "STPSignUpViewController.h"
#import "STPDataProxy.h"
#import "Constants.h"

@interface STPAuthViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordButton;

@end

@implementation STPAuthViewController

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

#pragma mark - UIGesture recognizer methods

- (IBAction)viewWasTapped:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
}

#pragma mark - UITextField delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.emailTextField)
        [self.passwordTextField becomeFirstResponder];
    else
    {
        [self.passwordTextField resignFirstResponder];
        [self loginUser];
    }
    
    return YES;
}

#pragma mark - UIButton Selector

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    STPSignUpViewController *signupViewController = (STPSignUpViewController *)segue.destinationViewController;
    signupViewController.delegate = self.delegate;
}

- (IBAction)signInButtonPressed:(UIButton *)sender
{
    [self loginUser];
}

#pragma mark - Login user request

- (void)loginUser
{
    if (!self.emailTextField.text.length || ![self.emailTextField.text isValidEmailFormat])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Please enter valid email"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        [self.emailTextField becomeFirstResponder];
        
        return;
    }
    
    if (!self.passwordTextField.text.length)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Password cannot be empty"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        [self.passwordTextField becomeFirstResponder];
        
        return;
    }
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:self.emailTextField.text, @"email",
                            self.passwordTextField.text, @"password", nil];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/auth/local" parameters:params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {

        NSURL *serverURL = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@", kSutapuServerAddress]];
        NSHTTPCookieStorage *cookiesStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        
        [cookiesStorage.cookies enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSHTTPCookie *cookie = (NSHTTPCookie *)obj;
            
            if ([cookie.domain containsString:serverURL.host] && [cookie.name containsString:kSTPSailsIDCookieName])
                [STPDataProxy sharedDataProxy].sailsID = cookie.value;
        }];
        
        [STPDataProxy sharedDataProxy].loggedUserInfo = [mappingResult firstObject];
        [self.delegate userWasLogged:NO];
        
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
