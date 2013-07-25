//
//  STPAppDelegate.m
//  Sutapu
//
//  Created by Yuriy Berdnikov on 7/24/13.
//  Copyright (c) 2013 Yuriy Berdnikov. All rights reserved.
//

#import "STPAppDelegate.h"
#import <RestKit/RestKit.h>
#import "Constants.h"
#import "STPErrorInfo.h"
#import "STPUserInfo.h"
#import "STPPostInfo.h"
#import "STPTopicInfo.h"
#import "STPSubscriptionInfo.h"

@implementation STPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"tabbar_bg.png"]];
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"tabbar_selection.png"]];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{ UITextAttributeTextColor : [UIColor colorWithWhite:220.0f / 255.0f alpha:1.0f] }
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ UITextAttributeTextColor : [UIColor whiteColor] }
                                             forState:UIControlStateHighlighted];
    
    [self setupRestKit];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - RestKit setup

- (void)setupRestKit
{
    // Initialize RestKit
    NSURL *baseURL = [[NSURL alloc] initWithString:kSutapuServerAddress];
    
    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:baseURL];
    
    [objectManager.HTTPClient setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No network connection", @"No network connection")
                                                            message:NSLocalizedString(@"You must be connected to the internet to use this app.",
                                                                                      @"You must be connected to the internet to use this app.")
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK",  @"OK")
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }];
    
    // Enable Activity Indicator Spinner
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    // Initialize managed object store
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    objectManager.managedObjectStore = managedObjectStore;
    
    //error mapping
    [objectManager addResponseDescriptorsFromArray:[self errorMappingDescriptors]];
    
    //user login
    [objectManager addResponseDescriptor:[self userLoginMapping:objectManager.managedObjectStore]];
    
    //user signup
    [objectManager addResponseDescriptor:[self userSignUpMapping:objectManager.managedObjectStore]];
    
    //user info update
    [objectManager addResponseDescriptor:[self userInfoUpdateMapping]];
    
    //post
    [objectManager addResponseDescriptor:[self postsMapping:objectManager.managedObjectStore]];
    
    //subscriptions
    [objectManager addResponseDescriptor:[self subscriptionsMapping:objectManager.managedObjectStore]];
    
    //topic mapping
    [objectManager addResponseDescriptor:[self topicsMapping:objectManager.managedObjectStore]];
    
    //new topic
    [objectManager addResponseDescriptor:[self createNewTopicMapping:objectManager.managedObjectStore]];
    
    //new post
    [objectManager addResponseDescriptor:[self createNewPostMapping]];
    
    /**
     Complete Core Data stack initialization
     */
    [managedObjectStore createPersistentStoreCoordinator];
    NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"STPSutapuDataModel.sqlite"];
    NSError *error;
    [managedObjectStore addSQLitePersistentStoreAtPath:storePath fromSeedDatabaseAtPath:nil withConfiguration:nil options:nil error:&error];
    
    // Create the managed object contexts
    [managedObjectStore createManagedObjectContexts];
    
    // Configure a managed object cache to ensure we do not create duplicate objects
    managedObjectStore.managedObjectCache = [[RKInMemoryManagedObjectCache alloc] initWithManagedObjectContext:managedObjectStore.persistentStoreManagedObjectContext];
}

- (NSArray *)errorMappingDescriptors
{
    RKObjectMapping *errorMapping = [RKObjectMapping mappingForClass:[STPErrorInfo class]];
    // The entire value at the source key path containing the errors maps to the message
    [errorMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:@"description" toKeyPath:@"errorDescription"]];
    [errorMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:@"code" toKeyPath:@"errorCode"]];
    
    RKResponseDescriptor *errorGetDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:errorMapping
                                                                                            method:RKRequestMethodGET
                                                                                       pathPattern:nil
                                                                                           keyPath:nil
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassClientError)];
    RKResponseDescriptor *errorPostDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:errorMapping
                                                                                             method:RKRequestMethodPOST
                                                                                        pathPattern:nil
                                                                                            keyPath:nil
                                                                                        statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassClientError)];
    return @[errorGetDescriptor, errorPostDescriptor];
}

- (RKEntityMapping *)userInfoMapping:(RKManagedObjectStore *)managedObjectStore
{
    RKEntityMapping *userInfoMapping = [RKEntityMapping mappingForEntityForName:@"STPUserInfo" inManagedObjectStore:managedObjectStore];
    
    userInfoMapping.identificationAttributes = @[ @"userID" ];
    [userInfoMapping addAttributeMappingsFromDictionary:@{
     @"id" : @"userID",
     @"displayName" : @"name",
     @"email" : @"email",
     @"avatar" : @"avatar",
     @"bio" : @"bio"
     }];
    
    return userInfoMapping;
}

- (RKResponseDescriptor *)userLoginMapping:(RKManagedObjectStore *)managedObjectStore
{
    RKResponseDescriptor *userLoginResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[self userInfoMapping:managedObjectStore]
                                                                                                     method:RKRequestMethodGET
                                                                                                pathPattern:@"/auth/local"
                                                                                                    keyPath:nil
                                                                                                statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    return userLoginResponseDescriptor;
}

- (RKResponseDescriptor *)userSignUpMapping:(RKManagedObjectStore *)managedObjectStore
{
    RKResponseDescriptor *userSignUpResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[self userInfoMapping:managedObjectStore]
                                                                                                      method:RKRequestMethodPOST
                                                                                                 pathPattern:@"/user/create"
                                                                                                     keyPath:nil
                                                                                                 statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    return userSignUpResponseDescriptor;
}

- (RKResponseDescriptor *)userInfoUpdateMapping
{
    RKResponseDescriptor *userInfoUpdateResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[RKObjectMapping mappingForClass:[NSArray class]]
                                                                                                          method:RKRequestMethodPOST
                                                                                                     pathPattern:@"/user/update/:userID"
                                                                                                         keyPath:nil
                                                                                                     statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    return userInfoUpdateResponseDescriptor;
}

- (RKEntityMapping *)topicMapping:(RKManagedObjectStore *)managedObjectStore
{
    RKEntityMapping *userMapping = [RKEntityMapping mappingForEntityForName:@"STPUserInfo" inManagedObjectStore:managedObjectStore];
    userMapping.identificationAttributes = @[ @"userID" ];
    [userMapping addAttributeMappingsFromDictionary:@{@"id" : @"userID"}];
    
    RKEntityMapping *topicMapping = [RKEntityMapping mappingForEntityForName:@"STPTopicInfo" inManagedObjectStore:managedObjectStore];
    topicMapping.identificationAttributes = @[ @"topicID" ];
    [topicMapping addAttributeMappingsFromDictionary:@{@"id" : @"topicID", @"name" : @"name"}];
    [topicMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"user" toKeyPath:@"user" withMapping:userMapping]];
    
    return topicMapping;
}

- (RKResponseDescriptor *)postsMapping:(RKManagedObjectStore *)managedObjectStore
{
    RKEntityMapping *postMapping = [RKEntityMapping mappingForEntityForName:@"STPPostInfo" inManagedObjectStore:managedObjectStore];
    
    postMapping.identificationAttributes = @[ @"postID" ];
    [postMapping addAttributeMappingsFromDictionary:@{
     @"id" : @"postID",
     @"text" : @"text"
     }];
    
    [postMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"user" toKeyPath:@"author" withMapping:[self userInfoMapping:managedObjectStore]]];
    [postMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"topic" toKeyPath:@"topic" withMapping:[self topicMapping:managedObjectStore]]];

    RKResponseDescriptor *postsResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:postMapping
                                                                                                          method:RKRequestMethodGET
                                                                                                     pathPattern:@"/post"
                                                                                                         keyPath:nil
                                                                                                     statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    return postsResponseDescriptor;
}

- (RKResponseDescriptor *)subscriptionsMapping:(RKManagedObjectStore *)managedObjectStore
{
    RKEntityMapping *subscriptionsMapping = [RKEntityMapping mappingForEntityForName:@"STPSubscriptionInfo" inManagedObjectStore:managedObjectStore];
    
    subscriptionsMapping.identificationAttributes = @[ @"subscriptionID" ];
    [subscriptionsMapping addAttributeMappingsFromDictionary:@{
     @"id" : @"subscriptionID",
     @"name" : @"name"
     }];
    
    [subscriptionsMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"user" toKeyPath:@"user" withMapping:[self userInfoMapping:managedObjectStore]]];
    [subscriptionsMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"topic" toKeyPath:@"topic" withMapping:[self topicMapping:managedObjectStore]]];
    
    RKResponseDescriptor *subscriptionsResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:subscriptionsMapping
                                                                                                         method:RKRequestMethodGET
                                                                                                    pathPattern:@"/subscription"
                                                                                                        keyPath:nil
                                                                                                    statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    return subscriptionsResponseDescriptor;
}

- (RKResponseDescriptor *)topicsMapping:(RKManagedObjectStore *)managedObjectStore
{
    RKResponseDescriptor *topicsResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[self topicMapping:managedObjectStore]
                                                                                                         method:RKRequestMethodGET
                                                                                                    pathPattern:@"/topic/mine"
                                                                                                        keyPath:nil
                                                                                                    statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    return topicsResponseDescriptor;
}

- (RKResponseDescriptor *)createNewTopicMapping:(RKManagedObjectStore *)managedObjectStore
{
    RKResponseDescriptor *createNewTopicResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[self topicMapping:managedObjectStore]
                                                                                                          method:RKRequestMethodPOST
                                                                                                     pathPattern:@"/topic/create"
                                                                                                         keyPath:nil
                                                                                                     statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    return createNewTopicResponseDescriptor;
}

- (RKResponseDescriptor *)createNewPostMapping
{
    RKResponseDescriptor *createNewPostResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[RKObjectMapping mappingForClass:[NSArray class]]
                                                                                                         method:RKRequestMethodPOST
                                                                                                    pathPattern:@"/post/create"
                                                                                                        keyPath:nil
                                                                                                    statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    return createNewPostResponseDescriptor;
}

@end
