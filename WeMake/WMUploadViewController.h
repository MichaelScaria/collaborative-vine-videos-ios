//
//  WMUploadViewController.h
//  WeMake
//
//  Created by Michael Scaria on 7/24/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMCameraViewController.h"
#import "WMReviewViewController.h"
#import "WMRequestViewController.h"

@interface WMUploadViewController : UIViewController <WMCameraViewControllerDelegate, WMReviewViewControllerDelegate, WMRequestViewControllerDelegate> {
    WMCameraViewController *cameraViewController;
    WMReviewViewController *reviewViewController;
    WMRequestViewController *requestViewController;
    
    NSURL *videoURL;
}
@property (nonatomic, strong) NSURL *initalURL;
@end
