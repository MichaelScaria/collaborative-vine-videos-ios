//
//  WMModel.h
//  WeMake
//
//  Created by Michael Scaria on 6/30/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "WMInteraction.h"

@interface WMModel : NSObject
+ (WMModel *)sharedInstance;

//authentication
- (void)signUp:(NSDictionary *)userInfo success:(void (^)(void))success failure:(void (^)(BOOL))failure;
- (void)login:(NSString *)username password:(NSString *)password success:(void (^)(void))success failure:(void (^)(void))failure;
//- (void)loginWithAuthenticationTokenSuccess:(void (^)(void))success failure:(void (^)(void))failure;

//relationships
- (void)follow:(int)user success:(void (^)(void))success failure:(void (^)(void))failure;
- (void)unfollow:(int)user success:(void (^)(void))success failure:(void (^)(void))failure;
- (void)fetchFollowersSuccess:(void (^)(NSArray *))success failure:(void (^)(void))failure;

//uploads
- (void)uploadURL:(NSURL *)url thumbnail:(UIImage *)thumbnail length:(float)length startTime:(float)startTime to:(NSString *)followers success:(void (^)(void))success failure:(void (^)(void))failure;
- (void)updateVideo:(int)video url:(NSURL *)url thumbnail:(UIImage *)thumbnail length:(float)length startTime:(float)startTime to:(NSString *)followers postToFollowers:(BOOL)post caption:(NSString *)caption success:(void (^)(void))success failure:(void (^)(void))failure;

//interactions
- (void)getPostsSuccess:(void (^)(NSArray *))success failure:(void (^)(void))failure;
- (void)getNotificationsSuccess:(void (^)(NSArray *))success failure:(void (^)(void))failure;
- (void)updateRequest:(int)request accepted:(BOOL)accepted success:(void (^)(void))success failure:(void (^)(void))failure;
- (void)likeVideo:(int)video success:(void (^)(void))success failure:(void (^)(void))failure;
- (void)comment:(NSString *)body onVideo:(int)video success:(void (^)(WMInteraction *))success failure:(void (^)(void))failure;
@end
