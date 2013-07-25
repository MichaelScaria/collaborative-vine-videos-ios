//
//  WMUploadViewController.h
//  WeMake
//
//  Created by Michael Scaria on 7/24/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMViewController.h"
@protocol WMUploadViewControllerDelegate <NSObject>
- (void)display:(void (^)(void))completion;
- (void)hide:(void (^)(void))completion;
@end
@interface WMUploadViewController : UIViewController <WMViewControllerDelegate>
@property (nonatomic, strong) id <WMUploadViewControllerDelegate>delegate;
@end
