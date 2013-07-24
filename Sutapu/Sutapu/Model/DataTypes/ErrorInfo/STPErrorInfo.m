//
//  STPErrorInfo.m
//  Sutapu
//
//  Created by Yuriy Berdnikov on 7/24/13.
//  Copyright (c) 2013 Yuriy Berdnikov. All rights reserved.
//

#import "STPErrorInfo.h"

@implementation STPErrorInfo

- (NSString *)localizedDescription
{
    return self.errorDescription;
}

- (NSString *)description
{
    return self.errorDescription;
}

- (void)dealloc
{
    self.errorDescription = nil;
}

@end
