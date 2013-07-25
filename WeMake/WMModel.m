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

//#define kRootURL @"http://localhost:5000"
#define kRootURL @"http://wemake.herokuapp.com/api"

#define kAppSecret @"MSwDp9CIMLzQ"

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

- (void)signUp:(NSDictionary *)userInfo success:(void (^)(void))success failure:(void (^)(BOOL))failure {
    NSMutableString *monkeySauce = [[NSMutableString alloc] initWithString:@""];
    for (NSString *key in userInfo) {
        [monkeySauce appendFormat:@"%@=%@&", key, userInfo[key]];
    }
    monkeySauce = [[monkeySauce substringToIndex:monkeySauce.length-1] mutableCopy];

    NSLog(@"Req:%@",[NSString stringWithFormat:@"%@/signup", kRootURL]);
    NSLog(@"body:%@", monkeySauce);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/signup", kRootURL]]];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [request setHTTPBody:[monkeySauce dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    [request setValue:kAppSecret forHTTPHeaderField:@"X-CSRF-Token"];
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
    [request setHTTPBody:[[NSString stringWithFormat:@"username=%@&password=%@", username, password] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    [request setValue:kAppSecret forHTTPHeaderField:@"X-CSRF-Token"];
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

@end
