//
//  STPPostInfo.h
//  Sutapu
//
//  Created by Yuriy Berdnikov on 7/25/13.
//  Copyright (c) 2013 Yuriy Berdnikov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class STPTopicInfo, STPUserInfo;

@interface STPPostInfo : NSManagedObject

@property (nonatomic, retain) NSString * createdAt;
@property (nonatomic, retain) NSString * postID;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) STPUserInfo *author;
@property (nonatomic, retain) STPTopicInfo *topic;

@end
