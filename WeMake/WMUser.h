//
//  WMUser.h
//  WeMake
//
//  Created by Michael Scaria on 8/1/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMUser : NSObject
@property (nonatomic, assign) int theID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *photoURL;
+ (NSArray *)usersWithArray:(NSArray *)usersArray;
+ (id)userWithDictionary:(NSDictionary *)userDictionary;
@end
