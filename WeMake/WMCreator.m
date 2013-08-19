//
//  WMCreator.m
//  WeMake
//
//  Created by Michael Scaria on 8/11/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import "WMCreator.h"

@implementation WMCreator
+ (NSArray *)creatorsWithArray:(NSArray *)creatorsArray {
    NSMutableArray *creators = [NSMutableArray arrayWithCapacity:creatorsArray.count];
    for (NSDictionary *dictionary in creatorsArray) {
        WMCreator *creator = [[self alloc] initWithDictionary:dictionary];
        [creators addObject:creator];
    }
    return [creators copy];
}

+ (id)creatorWithDictionary:(NSDictionary *)creatorDictionary {
    WMCreator *creator = [[self alloc] initWithDictionary:creatorDictionary];
    return creator;
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if ((self = [super init])) {
        [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
            if (value == [NSNull null]) ;
            else if ([key isEqualToString:@"name"]) {
                _name = value;
            }
            else if ([key isEqualToString:@"username"]) {
                _username = value;
            }
            else if ([key isEqualToString:@"photo_url"]) {
                _photoURL = value;
            }
            else if ([key isEqualToString:@"start_time"]) {
                _startTime = [value floatValue];
            }
            else if ([key isEqualToString:@"length"]) {
                _length = [value floatValue];
            }
        }];
    }
    return self;
    
}
@end
