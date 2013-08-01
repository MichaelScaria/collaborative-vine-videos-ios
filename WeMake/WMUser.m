//
//  WMUser.m
//  WeMake
//
//  Created by Michael Scaria on 8/1/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import "WMUser.h"

@implementation WMUser

+ (id)userWithDictionary:(NSDictionary *)userDictionary {
    WMUser *user = [[self alloc] initWithDictionary:userDictionary];
    return user;
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if ((self = [super init])) {
        for (NSString *key in dictionary) {
            id value = [dictionary objectForKey:key];
            if (!value) continue; //if value is null, skip
            
            if ([key isEqualToString:@"id"]) {
                _theID = [value intValue];
            }
            else if ([key isEqualToString:@"name"]) {
                _name = value;
            }
            else if ([key isEqualToString:@"username"]) {
                _username = value;
            }
            else if ([key isEqualToString:@"photo_url"]) {
                _photoURL = value;
            }
        }
    }
    return self;
    
}
@end
