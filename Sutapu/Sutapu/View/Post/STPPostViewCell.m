//
//  STPPostViewCell.m
//  Sutapu
//
//  Created by Yuriy Berdnikov on 7/25/13.
//  Copyright (c) 2013 Yuriy Berdnikov. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "STPPostViewCell.h"
#import "STPUserInfo.h"

@interface STPPostViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *postTextLabel;

@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation STPPostViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.avatarImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.avatarImageView.layer.borderWidth = 1.0f;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.usernameLabel.text = @"";
    self.postTextLabel.text = @"";
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.postInfo.text.length)
    {
        CGFloat height = [self.postInfo.text sizeWithFont:kSTPPostTextFont constrainedToSize:CGSizeMake(kSTPPostTextMaxWidth, 9999)].height;
        
        CGRect textFrame = self.postTextLabel.frame;
        textFrame.origin.y = CGRectGetMaxY(self.avatarImageView.frame) + kSTPPostElementsPadding;
        textFrame.size.height = height;
        self.postTextLabel.frame = textFrame;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPostInfo:(STPPostInfo *)postInfo
{
    _postInfo = postInfo;
    
    if (postInfo)
    {
        self.usernameLabel.text = postInfo.author.name;
        self.postTextLabel.text = postInfo.text;
        
        [self setNeedsLayout];
    }
}

@end
