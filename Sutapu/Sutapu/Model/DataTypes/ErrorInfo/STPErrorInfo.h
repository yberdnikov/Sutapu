//
//  STPErrorInfo.h
//  Sutapu
//
//  Created by Yuriy Berdnikov on 7/24/13.
//  Copyright (c) 2013 Yuriy Berdnikov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STPErrorInfo : NSObject

@property (nonatomic, assign) NSUInteger errorCode;
@property (nonatomic, copy) NSString *errorDescription;

@end
