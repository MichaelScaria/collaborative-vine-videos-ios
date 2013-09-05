//
//  WMVideo.m
//  WeMake
//
//  Created by Michael Scaria on 8/1/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import "WMVideo.h"
#import "WMCreator.h"
#import "WMInteraction.h"
#import "WMSession.h"

@implementation WMVideo

+ (NSArray *)videosWithArray:(NSArray *)videosArray {
    NSMutableArray *videos = [NSMutableArray arrayWithCapacity:videosArray.count];
    for (NSDictionary *dictionary in videosArray) {
        WMVideo *video = [[self alloc] initWithDictionary:dictionary];
        [videos addObject:video];
    }
    return [videos copy];
}

+ (id)videoWithDictionary:(NSDictionary *)videoDictionary {
    WMVideo *video = [[self alloc] initWithDictionary:videoDictionary];
    return video;
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if ((self = [super init])) {
        _views = 0;
        [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
            if ([key isEqualToString:@"id"]) {
                _theID = [value intValue];
            }
            else if ([key isEqualToString:@"url"]) {
                _url = value;
            }
            else if ([key isEqualToString:@"thumbnail_url"]) {
                _thumbnailUrl = value;
            }
            else if ([key isEqualToString:@"users"]) {
                _creators = [WMCreator creatorsWithArray:value];
            }
            else if ([key isEqualToString:@"interactions"]) {
                NSArray *interactions = [WMInteraction interactionsWithArray:value];
                NSMutableArray *mLikes = [[NSMutableArray alloc] initWithCapacity:interactions.count / 2];
                NSMutableArray *mComments = [[NSMutableArray alloc] initWithCapacity:interactions.count / 2];
                for (WMInteraction *interaction in interactions) {
                    switch (interaction.interactionType) {
                        case WMView:
                            _views++;
                            if (interaction.createdBy.theID == [WMSession sharedInstance].user) {
                                _viewed = YES;
                            }
                            break;
                        case WMLike:
                            [mLikes addObject:interaction];
                            if (interaction.createdBy.theID == [WMSession sharedInstance].user) {
                                _liked = YES;
                            }
                            break;
                        case WMComment:
                            [mComments addObject:interaction];
                            break;
                            
                        default:
                            break;
                    }
                }
                _likes = (NSArray *)mLikes;
                _comments = (NSArray *)mComments;
            }
            else if ([key isEqualToString:@"poster"]) {
                _poster = [WMUser userWithDictionary:value];
            }
        }];
    }
    return self;
    
}
@end
