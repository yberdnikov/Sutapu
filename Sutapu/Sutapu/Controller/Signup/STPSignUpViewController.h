//
//  STPSignUpViewController.h
//  Sutapu
//
//  Created by Yuriy Berdnikov on 7/24/13.
//  Copyright (c) 2013 Yuriy Berdnikov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STPAuthDelegate.h"

@interface STPSignUpViewController : UIViewController

@property (nonatomic, weak) id <STPAuthDelegate> delegate;

@end
