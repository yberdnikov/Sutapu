//
//  STPDataProxy.h
//  Sutapu
//
//  Created by Yuriy Berdnikov on 7/24/13.
//  Copyright (c) 2013 Yuriy Berdnikov. All rights reserved.
//

#import "STPUserInfo.h"

@interface STPDataProxy : NSObject

@property(nonatomic, strong) STPUserInfo *loggedUserInfo;
@property(nonatomic, copy) NSString *sailsID;

+ (STPDataProxy *)sharedDataProxy;

@end
