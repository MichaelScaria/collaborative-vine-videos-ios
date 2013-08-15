//
//  WMRequest.m
//  WeMake
//
//  Created by Michael Scaria on 8/1/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import "WMRequest.h"

@implementation WMRequest
+ (NSArray *)requestsWithArray:(NSArray *)requestsArray {
    NSMutableArray *requests = [NSMutableArray arrayWithCapacity:requestsArray.count];
    for (NSDictionary *dictionary in requestsArray) {
        WMRequest *request = [[self alloc] initWithDictionary:dictionary];
        [requests addObject:request];
    }
    return [requests copy];
}

+ (id)requestWithDictionary:(NSDictionary *)requestDictionary {
    WMRequest *request = [[self alloc] initWithDictionary:requestDictionary];
    return request;
}

- (WMRequestStatus)getRequestStatusFromNumber:(int)number
{
    switch (number) {
        case 0:
            return WMSent;
            break;
            
        case 1:
            return WMSeen;
            break;
            
        case 2:
            return WMAccepted;
            break;
            
        case 3:
            return WMRejected;
            break;
            
        default:
            return WMSent;
            break;
    }
}

- (WMRequestType)getRequestTypeFromNumber:(int)number
{
    switch (number) {
        case 0:
            return WMCreate;
            break;
            
        case 1:
            return WMPublish;
            break;
            
        default:
            return WMCreate;
            break;
    }
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if ((self = [super init])) {
        [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
            if ([key isEqualToString:@"id"]) {
                _theID = [value intValue];
            }
            else if ([key isEqualToString:@"sent"]) {
                _sent = [WMUser userWithDictionary:value];
            }
            else if ([key isEqualToString:@"recipient"]) {
                _recipient = [WMUser userWithDictionary:value];
            }
            else if ([key isEqualToString:@"request_type"]) {
                _type = [self getRequestTypeFromNumber:[value intValue]];
            }
            else if ([key isEqualToString:@"status"]) {
                _status = [self getRequestStatusFromNumber:[value intValue]];
            }
            else if ([key isEqualToString:@"created_at"]) {
                _createdAt = [value integerValue];
            }
            else if ([key isEqualToString:@"video"]) {
                _video = [WMVideo videoWithDictionary:value];
            }
        }];
    }
    return self;
    
}
@end
