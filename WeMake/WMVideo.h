//
//  WMVideo.h
//  WeMake
//
//  Created by Michael Scaria on 8/1/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WMUser.h"

@interface WMVideo : NSObject
@property (nonatomic, assign) int theID;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *thumbnailUrl;
@property (nonatomic, strong) NSArray *creators;
@property (nonatomic, strong) WMUser *poster;

+ (NSArray *)videosWithArray:(NSArray *)videosArray;
+ (id)videoWithDictionary:(NSDictionary *)videoDictionary;
@end
