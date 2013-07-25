//
//  STPPostViewCell.h
//  Sutapu
//
//  Created by Yuriy Berdnikov on 7/25/13.
//  Copyright (c) 2013 Yuriy Berdnikov. All rights reserved.
//

#import "STPPostInfo.h"

#define kSTPMinPostCellHeight 50.0f
#define kSTPPostTextFont [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f]
#define kSTPPostTextMaxWidth 310.0f
#define kSTPPostImageHeight 50.0f
#define kSTPPostElementsPadding 5.0f

@interface STPPostViewCell : UITableViewCell

@property (nonatomic, strong) STPPostInfo *postInfo;

@end
