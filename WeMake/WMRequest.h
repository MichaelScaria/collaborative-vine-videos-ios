//
//  WMRequest.h
//  WeMake
//
//  Created by Michael Scaria on 8/1/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMUser.h"
#import "WMVideo.h"

typedef enum {
    WMSent,
    WMSeen,
    WMAccepted,
    WMRejected
}WMRequestStatus;

typedef enum {
    WMCreate,
    WMPublish,
}WMRequestType;

@interface WMRequest : NSObject
@property (nonatomic, assign) int theID;
@property (nonatomic, strong) WMUser *sent;
@property (nonatomic, strong) WMUser *recipient;
@property (nonatomic, strong) WMVideo *video;
@property (nonatomic, assign) WMRequestType type;
@property (nonatomic, assign) WMRequestStatus status;
@property (nonatomic) NSInteger createdAt;

+ (NSArray *)requestsWithArray:(NSArray *)requestsArray;
+ (id)requestWithDictionary:(NSDictionary *)requestDictionary;
@end
