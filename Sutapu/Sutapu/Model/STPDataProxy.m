//
//  STPDataProxy.m
//  Sutapu
//
//  Created by Yuriy Berdnikov on 7/24/13.
//  Copyright (c) 2013 Yuriy Berdnikov. All rights reserved.
//

#import "STPDataProxy.h"
#import <RestKit/RestKit.h>
#import "Constants.h"

@interface STPDataProxy ()

@property (nonatomic, strong) STPUserInfo *userInfo;

@end

@implementation STPDataProxy

#pragma mark - Singleton mehtods

+ (STPDataProxy *)sharedDataProxy
{
    static STPDataProxy *sharedDataProxy = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedDataProxy = [[self alloc] init];
    });
    
    return sharedDataProxy;
}

- (id)init
{
    if (self = [super init])
    {
        
    }
    return self;
}

#pragma mark - Property

- (void)setLoggedUserInfo:(STPUserInfo *)loggedUserInfo
{
    self.userInfo = loggedUserInfo;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:loggedUserInfo.userID forKey:kSTPLoggedUserID];
    [prefs synchronize];
}

- (STPUserInfo *)loggedUserInfo
{
    if (!self.userInfo)
    {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSNumber *userID = [prefs objectForKey:kSTPLoggedUserID];
        
        if (userID)
        {
            NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"STPUserInfo"];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:[[NSString alloc] initWithFormat:@"userID like '%@'", userID]];
            fetchRequest.predicate = predicate;
            
            NSError *error = nil;
            NSArray *result = [[RKManagedObjectStore defaultStore].mainQueueManagedObjectContext executeFetchRequest:fetchRequest
                                                                                                               error:&error];
            if (error)
            {
                NSAssert(NO, error.localizedDescription);
            }
            
            if (result.count)
                self.userInfo = [result objectAtIndex:0];
        }
    }
    
    return self.userInfo;
}

- (NSString *)sailsID
{
    NSString *sailsID = [[NSUserDefaults standardUserDefaults] objectForKey:kSTPSailsIDCookieName];
    if (sailsID.length)
    {
        NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:@{NSHTTPCookieOriginURL : kSutapuServerAddress,
                                                NSHTTPCookiePath : @"/",
                                                NSHTTPCookieName : kSTPSailsIDCookieName,
                                               NSHTTPCookieValue : sailsID}];
        
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:@[cookie] forURL:[NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@", kSutapuServerAddress]] mainDocumentURL:nil];
    }
    
    return sailsID;
}

- (void)setSailsID:(NSString *)sailsID
{
    [[NSUserDefaults standardUserDefaults] setObject:sailsID forKey:kSTPSailsIDCookieName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
