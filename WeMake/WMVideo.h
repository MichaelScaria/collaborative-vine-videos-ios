//
//  WMVideo.h
//  WeMake
//
//  Created by Michael Scaria on 8/1/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMVideo : NSObject
@property (nonatomic, assign) int theID;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSArray *creators;
+ (id)videoWithDictionary:(NSDictionary *)videoDictionary;
@end
