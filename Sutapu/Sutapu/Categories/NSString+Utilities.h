//
//  NSString+Utilities.h
//  WineAndBeer
//
//  Created by Yuriy Berdnikov on 01.04.13.
//  Copyright (c) 2013 Yuriy Berdnikov. All rights reserved.
//

@interface NSString (Utilities)

- (BOOL)isValidEmailFormat;
- (BOOL)isEmptyString;
- (BOOL)containsString:(NSString *)string;
- (BOOL)containsString:(NSString *)string options:(NSStringCompareOptions)options;
+ (NSString *)timeStringFromUnixTime:(NSTimeInterval)timestamp;

@end
