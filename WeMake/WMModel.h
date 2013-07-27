//
//  WMModel.h
//  WeMake
//
//  Created by Michael Scaria on 6/30/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WMModel : NSObject
+ (WMModel *)sharedInstance;

//authentication
- (void)signUp:(NSDictionary *)userInfo success:(void (^)(void))success failure:(void (^)(BOOL))failure;
- (void)login:(NSString *)username password:(NSString *)password success:(void (^)(void))success failure:(void (^)(void))failure;
- (void)loginWithAuthenticationTokenSuccess:(void (^)(void))success failure:(void (^)(void))failure;

//relationships
- (void)follow:(int)user success:(void (^)(void))success failure:(void (^)(void))failure;
- (void)unfollow:(int)user success:(void (^)(void))success failure:(void (^)(void))failure;

//uploads
- (void)uploadURL:(NSURL *)url;
@end
