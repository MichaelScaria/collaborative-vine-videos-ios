//
//  WMCreator.h
//  WeMake
//
//  Created by Michael Scaria on 8/11/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//
//WMCreator is the iOS model of the table UserToVideo

#import <Foundation/Foundation.h>
#import "WMUser.h"

@interface WMCreator : WMUser
@property (nonatomic, assign) float startTime;
@property (nonatomic, assign) float length;
+ (NSArray *)creatorsWithArray:(NSArray *)creatorsArray;
+ (id)creatorWithDictionary:(NSDictionary *)creatorDictionary;
@end
