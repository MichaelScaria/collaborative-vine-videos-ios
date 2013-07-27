//
//  WMSession.m
//  WeMake
//
//  Created by Michael Scaria on 7/4/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import "WMSession.h"

@implementation WMSession
@synthesize user;
+ (WMSession *)sharedInstance
{
    static WMSession *sharedInstance = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        sharedInstance = [[WMSession alloc] init];
        sharedInstance.user = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
    });
    
    return sharedInstance;
}

- (void)loginWithUser:(NSDictionary *)userInfo {
    [[NSUserDefaults standardUserDefaults] setObject:userInfo[@"token"] forKey:@"CSRFToken"];
    [[NSUserDefaults standardUserDefaults] setObject:userInfo[@"user"][@"token"] forKey:@"UserToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.user = userInfo[@"user"][@"_id"];
}

- (void)logout {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CSRFToken"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
