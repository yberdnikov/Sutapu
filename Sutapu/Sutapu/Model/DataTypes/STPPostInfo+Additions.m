//
//  STPPostInfo+Additions.m
//  Sutapu
//
//  Created by Yuriy Berdnikov on 7/25/13.
//  Copyright (c) 2013 Yuriy Berdnikov. All rights reserved.
//

#import "STPPostInfo+Additions.h"
#import "STPPostViewCell.h"

@implementation STPPostInfo (Additions)

- (CGFloat)optimalCellSizeForPost
{
    CGFloat postCellHeight = kSTPMinPostCellHeight;
    
    if (self.text.length)
    {
        CGFloat height = [self.text sizeWithFont:kSTPPostTextFont constrainedToSize:CGSizeMake(kSTPPostTextMaxWidth, 9999)].height;
        postCellHeight += (height + kSTPPostElementsPadding);
    }
    
//    if (self.createdAt.length)
//    {
//        CGSize postTimeSize = [self.createdDate sizeWithFont:CELL_TWEET_TIME_TEXT_FONT
//                                            constrainedToSize:CGSizeMake(300, 9999)];
//        tweetCellHeight += tweetTimeSize.height + 8;
//    }
    
    //TODO: add image size
    
    return postCellHeight + kSTPPostElementsPadding * 4;
}

@end
