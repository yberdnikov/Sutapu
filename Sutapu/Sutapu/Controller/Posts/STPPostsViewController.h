//
//  STPPostsViewController.h
//  Sutapu
//
//  Created by Yuriy Berdnikov on 7/25/13.
//  Copyright (c) 2013 Yuriy Berdnikov. All rights reserved.
//

#import "STPSubscriptionInfo.h"

@interface STPPostsViewController : UIViewController

@property (nonatomic, assign) BOOL showRecentsPosts;
@property (nonatomic, strong) STPSubscriptionInfo *subscriptionInfo;

@end
