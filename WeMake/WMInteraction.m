//
//  WMInteraction.m
//  WeMake
//
//  Created by Michael Scaria on 8/1/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import "WMInteraction.h"

@implementation WMInteraction
+ (NSArray *)interactionsWithArray:(NSArray *)interactionsArray {
    NSMutableArray *interactions = [NSMutableArray arrayWithCapacity:interactionsArray.count];
    for (NSDictionary *dictionary in interactionsArray) {
        WMInteraction *interaction = [[self alloc] initWithDictionary:dictionary];
        [interactions addObject:interaction];
    }
    return [interactions copy];
}

+ (id)requestWithDictionary:(NSDictionary *)interactionDictionary {
    WMInteraction *interaction = [[self alloc] initWithDictionary:interactionDictionary];
    return interaction;
}

- (WMInteractionType)getInteractionFromNumber:(int)number
{
    switch (number) {
        case 0:
            return WMFollow;
            break;
            
        case 1:
            return WMLike;
            break;
            
        case 2:
            return WMComment;
            break;
            
        case 3:
            return WMShare;
            break;
            
        default:
            return WMFollow;
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
            else if ([key isEqualToString:@"user"]) {
                _user = [WMUser userWithDictionary:value];
            }
            else if ([key isEqualToString:@"created_by"]) {
                _createdBy = [WMUser userWithDictionary:value];
            }
            else if ([key isEqualToString:@"interaction_type"]) {
                _interactionType = [self getInteractionFromNumber:[value intValue]];
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
