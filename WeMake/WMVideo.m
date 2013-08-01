//
//  WMVideo.m
//  WeMake
//
//  Created by Michael Scaria on 8/1/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import "WMVideo.h"

@implementation WMVideo

+ (id)videoWithDictionary:(NSDictionary *)videoDictionary {
    WMVideo *video = [[self alloc] initWithDictionary:videoDictionary];
    return video;
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
            else if ([key isEqualToString:@"url"]) {
                _url = value;
            }
        }
    }
    return self;
    
}
@end
