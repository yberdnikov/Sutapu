//
//  STPAuthDelegate.h
//  Sutapu
//
//  Created by Yuriy Berdnikov on 7/24/13.
//  Copyright (c) 2013 Yuriy Berdnikov. All rights reserved.
//

@protocol STPAuthDelegate <NSObject>

- (void)userWasLogged:(BOOL)isNewUser;

@end
