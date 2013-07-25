//
//  STPTopicInfo.h
//  Sutapu
//
//  Created by Yuriy Berdnikov on 7/25/13.
//  Copyright (c) 2013 Yuriy Berdnikov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class STPPostInfo, STPSubscriptionInfo, STPUserInfo;

@interface STPTopicInfo : NSManagedObject

@property (nonatomic, retain) NSString * topicID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSSet *posts;
@property (nonatomic, retain) STPUserInfo *user;
@property (nonatomic, retain) NSSet *subscriptions;
@end

@interface STPTopicInfo (CoreDataGeneratedAccessors)

- (void)addPostsObject:(STPPostInfo *)value;
- (void)removePostsObject:(STPPostInfo *)value;
- (void)addPosts:(NSSet *)values;
- (void)removePosts:(NSSet *)values;

- (void)addSubscriptionsObject:(STPSubscriptionInfo *)value;
- (void)removeSubscriptionsObject:(STPSubscriptionInfo *)value;
- (void)addSubscriptions:(NSSet *)values;
- (void)removeSubscriptions:(NSSet *)values;

@end
