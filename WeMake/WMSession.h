//
//  WMSession.h
//  WeMake
//
//  Created by Michael Scaria on 7/4/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMSession : NSObject

@property (nonatomic, strong) NSString *user;
+ (WMSession *)sharedInstance;
- (void)loginWithUserInfo:(NSDictionary *)userInfo;
- (void)logout;
@end
