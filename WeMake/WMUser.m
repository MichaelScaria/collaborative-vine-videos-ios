//
//  WMUser.m
//  WeMake
//
//  Created by Michael Scaria on 8/1/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import "WMUser.h"

@implementation WMUser

+ (NSArray *)usersWithArray:(NSArray *)usersArray {
    NSMutableArray *users = [NSMutableArray arrayWithCapacity:usersArray.count];
    for (NSDictionary *dictionary in usersArray) {
        WMUser *user = [[self alloc] initWithDictionary:dictionary];
        [users addObject:user];
    }
    return [users copy];
}

+ (id)userWithDictionary:(NSDictionary *)userDictionary {
    WMUser *user = [[self alloc] initWithDictionary:userDictionary];
    return user;
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if ((self = [super init])) {
        [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
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
        }];
    }
    return self;
    
}
@end
