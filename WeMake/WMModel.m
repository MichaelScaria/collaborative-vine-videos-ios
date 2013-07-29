//
//  WMModel.m
//  WeMake
//
//  Created by Michael Scaria on 6/30/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import "WMModel.h"
#import "WMSession.h"

#import "AFNetworking.h"
#import "JSONKit.h"

#define kRootURL @"http://localhost:3000/api"
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
        NSLog(@"user:%@", user);
        [[WMSession sharedInstance] loginWithUser:user];
        if (success) success();
    }
}

- (void)login:(NSString *)username password:(NSString *)password success:(void (^)(void))success failure:(void (^)(void))failure {    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/login", kRootURL]]];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setHTTPBody:[[NSString stringWithFormat:@"username=%@&password=%@&app_secret=%@", username, password, kAppSecret] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
//    [request setValue:kAppSecret forHTTPHeaderField:@"X-CSRF-Token"];
    NSError *error = nil; NSURLResponse *response = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error) {
        NSLog(@"Error:%@", error.localizedDescription);
        if (failure) failure();
    }
    else {
        NSDictionary *user = [[JSONDecoder decoder] objectWithData:data];
        NSLog(@"user:%@", user);
        [[WMSession sharedInstance] loginWithUser:user];
        if (success) success();
    }
}

- (void)loginWithAuthenticationTokenSuccess:(void (^)(void))success failure:(void (^)(void))failure {
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
        NSLog(@"user:%@", userInfo);
        [[WMSession sharedInstance] loginWithUser:userInfo];
        if (success) success();
    }
}
#pragma mark Relationships

- (void)follow:(int)user success:(void (^)(void))success failure:(void (^)(void))failure {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/relationships/follow", kRootURL]]];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setHTTPBody:[[NSString stringWithFormat:@"user=%d", user] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    [request setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"CSRFToken"] forHTTPHeaderField:@"X-CSRF-Token"];
    NSError *error = nil; NSURLResponse *response = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error) {
        NSLog(@"Error:%@", error.localizedDescription);
        if (failure) failure();
    }
    else {
        NSDictionary *userInfo = [[JSONDecoder decoder] objectWithData:data];
        NSLog(@"user:%@", userInfo);
        if (success) success();
    }
}

- (void)unfollow:(int)user success:(void (^)(void))success failure:(void (^)(void))failure {
    
}

#pragma mark Uploads

- (void)uploadURL:(NSURL *)url {
    NSString *mediaurl = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mov"];

    NSData *postData = [self generatePostDataForData:[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:mediaurl]]];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSLog(@"%@", postLength);
    
    // Setup the request:
    NSMutableURLRequest *uploadRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/videos", kRootURL]] cachePolicy: NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
    [uploadRequest setHTTPMethod:@"POST"];
    [uploadRequest setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"CSRFToken"] forHTTPHeaderField:@"X-CSRF-Token"];
    [uploadRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [uploadRequest setValue:@"multipart/form-data; boundary=AaB03x" forHTTPHeaderField:@"Content-Type"];
    [uploadRequest setHTTPBody:postData];
    
    // Execute the reqest:
    NSURLConnection *conn=[[NSURLConnection alloc] initWithRequest:uploadRequest delegate:self];
    if (conn)
    {
        // Connection succeeded (even if a 404 or other non-200 range was returned).
        NSLog(@"sucess");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Got Server Response" message:@"Success" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        // Connection failed (cannot reach server).
        NSLog(@"fail");
    }

}

#pragma mark Helpers
- (NSData *)generatePostDataForData:(NSData *)uploadData {
    NSMutableData *body = [NSMutableData data];
    NSDictionary *dictionary = @{@"movie": uploadData, @"qwerty" : @"2"};
    for (NSString *key in dictionary) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
        id value = [dictionary objectForKey:key];
        
        if ([value isKindOfClass:[NSData class]]) {
            [body appendData: [[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"movie.mov\"\r\nContent-Type: application/octet-stream\r\nContent-Transfer-Encoding: binary\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
        } else {
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        if ([value isKindOfClass:[NSData class]]) {
            
            
            [body appendData:value];
            
        } else {
            [body appendData:[value dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
    return body;
}

/*- (NSData *)generatePostDataForData:(NSData *)uploadData
{
//    // Generate the post header:
//    NSString *post = [NSString stringWithCString:"--AaB03x\r\nContent-Disposition: form-data; name=\"upload[file]\"; filename=\"movie.mov\"\r\nContent-Type: application/octet-stream\r\nContent-Transfer-Encoding: binary\r\n\r\n" encoding:NSASCIIStringEncoding];
//    
//    // Get the post header int ASCII format:
//    NSData *postHeaderData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
//    
//    // Generate the mutable data variable:
//    NSMutableData *postData = [[NSMutableData alloc] initWithLength:[postHeaderData length] ];
//    [postData setData:postHeaderData];
//    
//    // Add the image:
//    [postData appendData: uploadData];
//    
//    // Add the closing boundry:
//    [postData appendData: [@"\r\n--AaB03x--" dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES]];
//    [postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"qwerty\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postData appendData:[@"2" dataUsingEncoding:NSUTF8StringEncoding]];
//    [postData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    // Return the post data:
//    return postData;
    
//    NSMutableData *body = [NSMutableData data];
    NSString *post = [NSString stringWithCString:"--AaB03x\r\nContent-Disposition: form-data; name=\"upload[file]\"; filename=\"movie.mov\"\r\nContent-Type: application/octet-stream\r\nContent-Transfer-Encoding: binary\r\n\r\n" encoding:NSASCIIStringEncoding];
    NSData *postHeaderData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSMutableData *postData = [[NSMutableData alloc] initWithLength:[postHeaderData length] ];
    [postData setData:postHeaderData];
    [postData appendData: uploadData];
    [postData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"qwerty\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[@"2" dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[[NSString stringWithFormat:@"--AaB03x--\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    return postData;
    
//    for (NSString *key in dictionary) {
//        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
//        id value = [dictionary objectForKey:key];
//        
//        if ([value isKindOfClass:[NSData class]]) {
//            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"photo.jpg\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
//        } else {
//            [body appendData:
//             [[NSString stringWithFormat:
//               @"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key]
//              dataUsingEncoding:NSUTF8StringEncoding]];
//        }
//        
//        if ([value isKindOfClass:[NSData class]]) {
//            
//            
//            [body appendData:value];
//            
//        } else if ([value isKindOfClass:[NSNumber class]]) {
//            [body appendData:[[value stringValue] dataUsingEncoding:NSUTF8StringEncoding]];
//            
//        } else {
//            [body appendData:[value dataUsingEncoding:NSUTF8StringEncoding]];
//        }
//        
//        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    }
//    
//    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
}*/


@end
