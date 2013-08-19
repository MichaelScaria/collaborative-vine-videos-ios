//
//  WMModel.m
//  WeMake
//
//  Created by Michael Scaria on 6/30/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//
#import <AssetsLibrary/AssetsLibrary.h>

#import "WMModel.h"
#import "WMSession.h"
#import "WMUser.h"
#import "WMRequest.h"
#import "WMInteraction.h"

#import "AFNetworking.h"
#import "JSONKit.h"

//#define kRootURL @"http://localhost:3000/api"
#define kRootURL @"http://Michaels-MacBook-Pro.local:3000/api"
//#define kRootURL @"http://wemake.herokuapp.com/api"

#define kAppSecret @"MSwDp9CIMLzQ"
#define BOUNDARY @"AaB03x"

@implementation WMModel

+ (WMModel *)sharedInstance
{
    static WMModel *sharedInstance = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        sharedInstance = [[WMModel alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark Authentication

- (void)signUp:(NSDictionary *)userInfo success:(void (^)(void))success failure:(void (^)(BOOL))failure {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableString *monkeySauce = [[NSMutableString alloc] initWithString:@""];
        for (NSString *key in userInfo) {
            [monkeySauce appendFormat:@"%@=%@&", key, userInfo[key]];
        }
        [monkeySauce appendFormat:@"app_secret=%@", kAppSecret];
        //    monkeySauce = [[monkeySauce substringToIndex:monkeySauce.length-1] mutableCopy];
        
        NSLog(@"Req:%@",[NSString stringWithFormat:@"%@/signup", kRootURL]);
        NSLog(@"body:%@", monkeySauce);
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/signup", kRootURL]]];
        [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
        [request setHTTPBody:[monkeySauce dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPMethod:@"POST"];
        NSError *error = nil; NSHTTPURLResponse *response = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if (error) {
            NSLog(@"Error:%@", error.localizedDescription);
            if (failure) failure(NO);
        }
        else {
            if ([response statusCode] == 200) {
                NSLog(@"%@", [[JSONDecoder decoder] objectWithData:data]);
                if ([[[JSONDecoder decoder] objectWithData:data][@"error"] isEqualToString:@"user exists"]) {
                    if (failure) failure(YES);
                    return;
                }
            }
            NSDictionary *user = [[JSONDecoder decoder] objectWithData:data];
            NSLog(@"user-sign:%@", user);
            [[WMSession sharedInstance] loginWithUserInfo:@{@"token": user[@"token"], @"username" : userInfo[@"username"], @"password" : userInfo[@"password"], @"id" : user[@"user"][@"id"]}];
            if (success) success();
        }
    });
    
}

- (void)login:(NSString *)username password:(NSString *)password success:(void (^)(void))success failure:(void (^)(void))failure {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/login", kRootURL]]];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setHTTPBody:[[NSString stringWithFormat:@"username=%@&password=%@&app_secret=%@", username, password, kAppSecret] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    NSError *error = nil; NSURLResponse *response = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error) {
        NSLog(@"Error:%@", error.localizedDescription);
        if (failure) failure();
    }
    else {
        NSDictionary *user = [[JSONDecoder decoder] objectWithData:data];
        NSLog(@"user-login:%@", user);
        if (user) {
            [[WMSession sharedInstance] loginWithUserInfo:@{@"token": user[@"token"], @"username" : username, @"password" : password, @"id" : user[@"user"][@"id"]}];
            if (success) success();
        }
        else {
            if (failure) failure();
        }
    }
}

/*- (void)loginWithAuthenticationTokenSuccess:(void (^)(void))success failure:(void (^)(void))failure {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/token_login", kRootURL]]];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setHTTPBody:[[NSString stringWithFormat:@"token=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"UserToken"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    //    [request setValue:kAppSecret forHTTPHeaderField:@"X-CSRF-Token"];
    NSError *error = nil; NSURLResponse *response = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error) {
        NSLog(@"Error:%@", error.localizedDescription);
        if (failure) failure();
    }
    else {
        NSDictionary *userInfo = [[JSONDecoder decoder] objectWithData:data];
        NSLog(@"user-auth:%@", userInfo);
        [[WMSession sharedInstance] loginWithUser:userInfo];
        if (success) success();
    }
}*/

#pragma mark Relationships

- (void)follow:(int)user success:(void (^)(void))success failure:(void (^)(void))failure {
    NSMutableURLRequest *request = [self generateMutableRequestForPath:@"/relationships/follow" type:@"POST"];
    [request setHTTPBody:[[NSString stringWithFormat:@"user=%d", user] dataUsingEncoding:NSUTF8StringEncoding]];
    NSError *error = nil; NSURLResponse *response = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error) {
        NSLog(@"Error:%@", error.localizedDescription);
        if (failure) failure();
    }
    else {
        if (success) success();
    }
}

- (void)unfollow:(int)user success:(void (^)(void))success failure:(void (^)(void))failure {
    
}

- (void)fetchFollowersSuccess:(void (^)(NSArray *))success failure:(void (^)(void))failure {
    NSMutableURLRequest *req = [self generateMutableRequestForPath:@"/relationships/followers" type:@"GET"];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = (NSData *)responseObject;
        if (data){
            NSArray *followers = [[JSONDecoder decoder] objectWithData:data];
            if (success) success(followers);
        }
        else if (failure) failure();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if (failure) failure();
    }];
    [operation start];
}

#pragma mark Uploads

- (void)uploadURL:(NSURL *)url thumbnail:(UIImage *)thumbnail length:(float)length startTime:(float)startTime to:(NSString *)followers success:(void (^)(void))success failure:(void (^)(void))failure{
    ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
    [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset) {
        ALAssetRepresentation *rep = [asset defaultRepresentation];
        Byte *buffer = (Byte*)malloc(rep.size);
        NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:rep.size error:nil];
        NSData *videoData = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
        NSData *postData = [self generatePostDataForVideoData:videoData thumbnail:UIImagePNGRepresentation(thumbnail) length:length startTime:startTime followers:followers post:NO caption:@""];
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];

        NSMutableURLRequest *uploadRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/videos", kRootURL]] cachePolicy: NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
         [uploadRequest setHTTPMethod:@"POST"];
         [uploadRequest setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"CSRFToken"] forHTTPHeaderField:@"X-CSRF-Token"];
         [uploadRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
         [uploadRequest setValue:@"multipart/form-data; boundary=AaB03x" forHTTPHeaderField:@"Content-Type"];
         [uploadRequest setHTTPBody:postData];
         
         NSURLConnection *conn=[[NSURLConnection alloc] initWithRequest:uploadRequest delegate:self];
         if (conn && success) success();
         else if (failure) failure();
        
    } failureBlock:^(NSError *err) {
        NSLog(@"Error: %@",[err localizedDescription]);
        if (failure) failure();
    }];

}

- (void)updateVideo:(int)video url:(NSURL *)url thumbnail:(UIImage *)thumbnail length:(float)length startTime:(float)startTime to:(NSString *)followers postToFollowers:(BOOL)post caption:(NSString *)caption success:(void (^)(void))success failure:(void (^)(void))failure {
    ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
    [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset) {
        ALAssetRepresentation *rep = [asset defaultRepresentation];
        Byte *buffer = (Byte*)malloc(rep.size);
        NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:rep.size error:nil];
        NSData *videoData = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
        NSData *postData = [self generatePostDataForVideoData:videoData thumbnail:UIImagePNGRepresentation(thumbnail) length:length startTime:startTime followers:followers ? followers : @"" post:post caption:caption ? caption : @""];
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *uploadRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/videos/%d", kRootURL, video]] cachePolicy: NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
        [uploadRequest setHTTPMethod:@"POST"];
        [uploadRequest setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"CSRFToken"] forHTTPHeaderField:@"X-CSRF-Token"];
        [uploadRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [uploadRequest setValue:@"multipart/form-data; boundary=AaB03x" forHTTPHeaderField:@"Content-Type"];
        [uploadRequest setHTTPBody:postData];
        
        NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:uploadRequest delegate:self];
        if (conn && success) success();
        else if (failure) failure();
        
    } failureBlock:^(NSError *err) {
        NSLog(@"Error: %@",[err localizedDescription]);
        if (failure) failure();
    }];
}

#pragma mark Interactions
- (void)getPostsSuccess:(void (^)(NSArray *))success failure:(void (^)(void))failure {
    NSMutableURLRequest *req = [self generateMutableRequestForPath:@"/users/feed" type:@"GET"];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = (NSData *)responseObject;
        if (data){
            NSArray *postsJSON = [[JSONDecoder decoder] objectWithData:data];
            NSLog(@"postsJSON:%@", postsJSON);
            NSArray *videos = [WMVideo videosWithArray:postsJSON];
            if (success) success(videos);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if (failure) failure();
    }];
    [operation start];
}
- (void)getNotificationsSuccess:(void (^)(NSArray *))success failure:(void (^)(void))failure {
    NSMutableURLRequest *req = [self generateMutableRequestForPath:[NSString stringWithFormat:@"/users/%@/notifications", [WMSession sharedInstance].user] type:@"GET"];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = (NSData *)responseObject;
        if (data){
            NSArray *notificationsJSON = [[JSONDecoder decoder] objectWithData:data];
            NSMutableArray *notifications = [[NSMutableArray alloc] initWithCapacity:2];
            [notifications addObjectsFromArray:[WMRequest requestsWithArray:notificationsJSON[0]]];
            [notifications addObjectsFromArray:[WMInteraction interactionsWithArray:notificationsJSON[1]]];
            if (success) success(notifications);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if (failure) failure();
    }];
    [operation start];
    


//    if (success) success(
//                         @[[WMRequest requestWithDictionary:@{@"sent" : @{@"username" : @"robinjoseph", @"photo_url" : @"http://graph.facebook.com/580207324/picture?type=square&width=100&height=100&width=400&height=400"}, @"recipient" : @{@"username" : @"michaelscaria"}, @"status" : @0, @"created_at" : @1375928440, @"video" : @{@"url" : @""https://s3.amazonaws.com/WeMake/users/1/2013-07-31%2023%3A04%3A11%20-0500/video-2.mov?AWSAccessKeyId=AKIAIAQUCYOECQCJOENA&Expires=2006481914&Signature=wyRbwYhgknxTKOnTD57zjjzzghM%3D}}]]
//                         );
}

- (void)updateRequest:(int)request accepted:(BOOL)accepted success:(void (^)(void))success failure:(void (^)(void))failure {
    NSMutableURLRequest *req = [self generateMutableRequestForPath:[NSString stringWithFormat:@"/requests/%d/%@", request, accepted ? @"accept" : @"decline"] type:@"POST"];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:req];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data = (NSData *)responseObject;
        if (data){
            if (success) success();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if (failure) failure();
    }];
    [operation start];
}

#pragma mark Helpers
- (NSMutableURLRequest *)generateMutableRequestForPath:(NSString *)path type:(NSString *)type {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kRootURL, path]]];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setHTTPMethod:type];
    if ([type isEqualToString:@"POST"]) [request setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"CSRFToken"] forHTTPHeaderField:@"X-CSRF-Token"];
    return request;
}

- (NSData *)generatePostDataForVideoData:(NSData *)uploadData thumbnail:(NSData *)thumbnailData length:(float)length startTime:(float)startTime followers:(NSString *)followers post:(BOOL)post caption:(NSString *)caption {
    NSMutableData *body = [NSMutableData data];
    if (!thumbnailData) {
        NSLog(@"No thumbnailData");
    }
    if (!followers) {
        NSLog(@"No followers");
    }
    if (!caption) {
        NSLog(@"No caption");
    }
    NSDictionary *dictionary = @{@"movie": uploadData, @"thumbnail" : thumbnailData, @"users" : followers, @"length" : [NSString stringWithFormat:@"%f", length], @"start_time" : [NSString stringWithFormat:@"%f", startTime], @"post" : (post) ? @"YES" : @"NO", @"caption" : caption};
//    for (NSString *key in dictionary) {
//        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
//        id value = [dictionary objectForKey:key];
//        
//        if ([value isKindOfClass:[NSData class]]) {
//            [body appendData: [[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"movie.mov\"\r\nContent-Type: application/octet-stream\r\nContent-Transfer-Encoding: binary\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
//        } else {
//            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
//        }
//        
//        if ([value isKindOfClass:[NSData class]]) {
//            
//            
//            [body appendData:value];
//            
//        } else {
//            [body appendData:[value dataUsingEncoding:NSUTF8StringEncoding]];
//        }
//        
//        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    }
    [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL *stop) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
        
        if ([value isKindOfClass:[NSData class]]) {
            NSString *name, *filename, *type;
            if ([key isEqualToString:@"movie"]) {
                name = @"movie";
                filename = @"movie.mov";
                type = @"application/octet-stream";
            }
            else {
                name = @"thumbnail";
                filename = @"thumbnail.png";
                type = @"image/png";
            }
            [body appendData: [[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\nContent-Type: %@\r\nContent-Transfer-Encoding: binary\r\n\r\n", name, filename, type] dataUsingEncoding:NSUTF8StringEncoding]];
        } else {
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        if ([value isKindOfClass:[NSData class]]) {
            
            
            [body appendData:value];
            
        } else {
            [body appendData:[value dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
    return body;
}



@end
