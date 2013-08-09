//
//  WMTabBarController.h
//  WeMake
//
//  Created by Michael Scaria on 7/29/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface WMTabBarController : UITabBarController
- (void)presentLoginView;
- (void)presentCameraView;
- (void)presentCameraViewWithURL:(NSString *)url;
@end
