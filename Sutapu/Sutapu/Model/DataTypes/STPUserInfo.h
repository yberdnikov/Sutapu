//
//  STPUserInfo.h
//  Sutapu
//
//  Created by Yuriy Berdnikov on 7/25/13.
//  Copyright (c) 2013 Yuriy Berdnikov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class STPPostInfo, STPSubscriptionInfo, STPTopicInfo;

@interface STPUserInfo : NSManagedObject

@property (nonatomic, retain) NSString * avatar;
@property (nonatomic, retain) NSString * bio;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) NSSet *posts;
@property (nonatomic, retain) NSSet *topics;
@property (nonatomic, retain) NSSet *subscriptions;
@end

@interface STPUserInfo (CoreDataGeneratedAccessors)

- (void)addPostsObject:(STPPostInfo *)value;
- (void)removePostsObject:(STPPostInfo *)value;
- (void)addPosts:(NSSet *)values;
- (void)removePosts:(NSSet *)values;

- (void)addTopicsObject:(STPTopicInfo *)value;
- (void)removeTopicsObject:(STPTopicInfo *)value;
- (void)addTopics:(NSSet *)values;
- (void)removeTopics:(NSSet *)values;

- (void)addSubscriptionsObject:(STPSubscriptionInfo *)value;
- (void)removeSubscriptionsObject:(STPSubscriptionInfo *)value;
- (void)addSubscriptions:(NSSet *)values;
- (void)removeSubscriptions:(NSSet *)values;

@end
