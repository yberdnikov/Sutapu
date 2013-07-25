//
//  STPSubscriptionInfo.h
//  Sutapu
//
//  Created by Yuriy Berdnikov on 7/25/13.
//  Copyright (c) 2013 Yuriy Berdnikov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class STPTopicInfo, STPUserInfo;

@interface STPSubscriptionInfo : NSManagedObject

@property (nonatomic, retain) NSString * subscriptionID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) STPUserInfo *user;
@property (nonatomic, retain) NSSet *topics;
@end

@interface STPSubscriptionInfo (CoreDataGeneratedAccessors)

- (void)addTopicsObject:(STPTopicInfo *)value;
- (void)removeTopicsObject:(STPTopicInfo *)value;
- (void)addTopics:(NSSet *)values;
- (void)removeTopics:(NSSet *)values;

@end
