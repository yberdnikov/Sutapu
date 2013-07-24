//
//  STPUserInfo.h
//  Sutapu
//
//  Created by Yuriy Berdnikov on 7/24/13.
//  Copyright (c) 2013 Yuriy Berdnikov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface STPUserInfo : NSManagedObject

@property (nonatomic, retain) NSNumber * userID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * avatar;
@property (nonatomic, retain) NSString * bio;

@end
