//
//  STPPostInfo.h
//  Sutapu
//
//  Created by Yuriy Berdnikov on 7/24/13.
//  Copyright (c) 2013 Yuriy Berdnikov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class STPUserInfo;

@interface STPPostInfo : NSManagedObject

@property (nonatomic, retain) NSNumber * postID;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * createdAt;
@property (nonatomic, retain) STPUserInfo *author;

@end
