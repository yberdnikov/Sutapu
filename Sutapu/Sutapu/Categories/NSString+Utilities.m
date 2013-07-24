//
//  NSString+Utilities.m
//  WineAndBeer
//
//  Created by Yuriy Berdnikov on 01.04.13.
//  Copyright (c) 2013 Yuriy Berdnikov. All rights reserved.
//

#import "NSString+Utilities.h"

@implementation NSString (Utilities)

- (BOOL)isValidEmailFormat
{
	//Test valid email format
	NSString *emailRegEx =
	@"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
	@"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
	@"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
	@"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
	@"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
	@"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
	@"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    
	NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    
	return [regExPredicate evaluateWithObject:self];
}

- (BOOL)isEmptyString
{
    if([self length] == 0)
    {
        //string is empty or nil
        return YES;
    }
    else if([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0)
    {
        //string is all whitespace
        return YES;
    }
    
    return NO;
}

- (BOOL)containsString:(NSString *)string options:(NSStringCompareOptions)options
{
    NSRange rng = [self rangeOfString:string options:options];
    return rng.location != NSNotFound;
}

- (BOOL)containsString:(NSString *)string
{
    return [self containsString:string options:0];
}

// f - 1, 21, 31, ...
// s - 2-4, 22-24, 32-34 ...
// t - 5-20, 25-30, ...
+ (NSString *)numpf:(NSInteger)n f:(NSString *)f s:(NSString *)s t:(NSString *)t
{
    NSInteger n10 = n % 10;
    
    if ((n10 == 1) && ((n == 1) || (n > 20)))
        return f;
    else if ((n10 > 1) && (n10 < 5) && ((n > 20) || (n < 10) ))
        return s;
    else
        return t;
}

+ (NSString *)timeStringFromUnixTime:(NSTimeInterval)timestamp
{
    NSDate *postedDate = [[NSDate alloc] initWithTimeIntervalSince1970:timestamp];
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:postedDate];
    
    if (!interval)
        return nil;
    
    NSInteger minute = 60;
    NSInteger hour = 60 * minute;
    NSInteger day = 24 * hour;
    NSInteger month = 30 * day;
    
    if (interval < 2 * minute)
        return NSLocalizedString(@"a minute ago", @"a minute ago");
    if (interval < hour)
    {
        return [NSString stringWithFormat:@"%d %@", (int)interval / minute,
                [NSString numpf:(int)interval / minute
                              f:NSLocalizedString(@"one min ago", @"Text for minute (1, 21, 31)")
                              s:NSLocalizedString(@"2-4 min ago", @"Text for minute in range 2-4")
                              t:NSLocalizedString(@"5-10 min ago", @"Text for minute in range 2-4")]];
    }
    if (interval < 2 * hour)
        return [NSString stringWithFormat:@"%d %@", (int)interval / hour, NSLocalizedString(@"hour ago", @"hour ago")];
    if (interval < day)
    {
        return [NSString stringWithFormat:@"%d %@", (int)interval / hour,
                [NSString numpf:(int)interval / hour
                              f:NSLocalizedString(@"one hour ago", @"Text for hour (1, 21, 31)")
                              s:NSLocalizedString(@"2-4 hour ago", @"Text for hour in range 2-4")
                              t:NSLocalizedString(@"5-10 hour ago", @"Text for hour in range 2-4")]];
    }
    if (interval < 48 * hour)
        return NSLocalizedString(@"yesterday", @"yesterday");
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:[[NSLocale preferredLanguages] objectAtIndex:0]]];
    
    if (interval < 12 * month)
        [dateFormat setDateFormat:@"dd MMMM"];
    else
        [dateFormat setDateFormat:@"dd MMMM YYYY"];
    
    NSString *dateString = [[dateFormat stringFromDate:postedDate] capitalizedString];
    
    return dateString;
}

@end
