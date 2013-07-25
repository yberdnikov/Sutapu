//
//  STPPostComposerViewController.m
//  Sutapu
//
//  Created by Yuriy Berdnikov on 7/25/13.
//  Copyright (c) 2013 Yuriy Berdnikov. All rights reserved.
//

#import "STPPostComposerViewController.h"
#import "XCDFormInputAccessoryView.h"
#import "ActionSheetPicker.h"
#import "HTProgressHUD.h"
#import <RestKit/RestKit.h>
#import "STPTopicInfo.h"

@interface STPPostComposerViewController () <UITextFieldDelegate>
@property (nonatomic, strong) XCDFormInputAccessoryView *inputAccessoryView;

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UITextField *topicTextField;
@property (weak, nonatomic) IBOutlet UITextView *postTextView;

@property (weak, nonatomic) IBOutlet UIButton *createPostButton;
@property (nonatomic, strong) UIButton *expandButton;

@property (nonatomic, strong) NSArray *topicsDataSource;
@property (nonatomic, strong) HTProgressHUD *loadingHUD;
@property (nonatomic, copy) NSArray *pickerDataSource;
@end

@implementation STPPostComposerViewController

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
    
    self.inputAccessoryView = [[XCDFormInputAccessoryView alloc] init];
    
    self.loadingHUD = [[HTProgressHUD alloc] init];
    [self.loadingHUD showInView:self.view];
    
    [self loadTopicsData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIButton selector

- (IBAction)backButtonPressed:(UIButton *)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)createPostButtonPressed:(UIButton *)sender
{
    if (!self.topicTextField.text.length)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:NSLocalizedString(@"You should set Topic for post", @"You should set Topic for post")
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [self.loadingHUD showInView:self.view];
    
    if ([self.pickerDataSource indexOfObject:self.topicTextField.text] == NSNotFound)
    {
        //need create topic
        
        [[RKObjectManager sharedManager] postObject:nil path:@"/topic/create" parameters:@{@"name" : self.topicTextField.text} success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            
            STPTopicInfo *topicInfo = [mappingResult.array lastObject];
            NSDictionary *params = @{@"text" : self.postTextView.text, @"topic" : topicInfo.topicID};
            [[RKObjectManager sharedManager] postObject:nil path:@"/post/create" parameters:params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                [self.loadingHUD hideWithAnimation:YES];
            } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                
                [self.loadingHUD hideWithAnimation:YES];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:NSLocalizedString(@"You should set Topic for post", @"You should set Topic for post")
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }];
            
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            
            [self.loadingHUD hideWithAnimation:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:NSLocalizedString(@"You should set Topic for post", @"You should set Topic for post")
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }];
    }
    else
    {
        STPTopicInfo *topicInfo = [self.topicsDataSource objectAtIndex:[self.pickerDataSource indexOfObject:self.topicTextField.text]];
        NSDictionary *params = @{@"text" : self.postTextView.text, @"topic" : topicInfo.topicID};
        
        [[RKObjectManager sharedManager] postObject:nil path:@"/post/create" parameters:params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            [self.loadingHUD hideWithAnimation:YES];
            
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        } failure:^(RKObjectRequestOperation *operation, NSError *error) {
            
            [self.loadingHUD hideWithAnimation:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:NSLocalizedString(@"You should set Topic for post", @"You should set Topic for post")
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }];
    }
}

- (void)expandButtonPressed:(UIButton *)sender
{
    ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        self.topicTextField.text = selectedValue;
    };
    
    ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker) {
        NSLog(@"Block Picker Canceled");
    };
    
    [ActionSheetStringPicker showPickerWithTitle:@"Select a Topic" rows:self.pickerDataSource initialSelection:0 doneBlock:done cancelBlock:cancel origin:sender];
}

#pragma mark - Load data

- (void)loadTopicsData
{
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/topic/mine" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        
        self.topicsDataSource = mappingResult.array;
        
        if (self.topicsDataSource.count)
        {
            self.pickerDataSource = [self.topicsDataSource valueForKeyPath:@"@unionOfObjects.name"];
            self.expandButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetHeight(self.topicTextField.frame), CGRectGetHeight(self.topicTextField.frame))];
            self.expandButton.backgroundColor = [UIColor colorWithRed:72.0f / 255.0f green:184.0f / 255.0f blue:85.0f / 255.0f alpha:1.0f];
            [self.expandButton setTitle:@"..." forState:UIControlStateNormal];
            [self.expandButton addTarget:self action:@selector(expandButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self.expandButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.topicTextField.rightView = self.expandButton;
            self.topicTextField.rightViewMode = UITextFieldViewModeAlways;
        }
        
        [self.loadingHUD hideWithAnimation:YES];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        [self.loadingHUD hideWithAnimation:YES];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:error.localizedDescription
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }];
}

@end
