//
//  WMInteraction.h
//  WeMake
//
//  Created by Michael Scaria on 8/1/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMUser.h"
#import "WMVideo.h"

typedef enum {
    WMFollow,
    WMView,
    WMLike,
    WMComment,
    WMShare
} WMInteractionType;

@interface WMInteraction : NSObject
@property (nonatomic, assign) int theID;
@property (nonatomic, strong) WMUser *user;
@property (nonatomic, strong) WMUser *createdBy;
@property (nonatomic, strong) WMVideo *video;
@property (nonatomic, assign) WMInteractionType interactionType;
@property (nonatomic, strong) NSString *body;
@property (nonatomic) NSInteger createdAt;

+ (NSArray *)interactionsWithArray:(NSArray *)interactionsArray;
+ (id)interactionWithDictionary:(NSDictionary *)interactionDictionary;
@end
