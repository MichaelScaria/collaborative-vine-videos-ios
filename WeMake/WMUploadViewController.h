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

#import "WMVideo.h"

@interface WMUploadViewController : UIViewController <WMCameraViewControllerDelegate, WMReviewViewControllerDelegate, WMRequestViewControllerDelegate> {
    WMCameraViewController *cameraViewController;
    WMReviewViewController *reviewViewController;
    WMRequestViewController *requestViewController;
    
    NSURL *videoURL;
    NSURL *tempURL;
    NSURL *exportURL;
    
    float startTime;
}
@property (nonatomic, strong) WMVideo *initialVideo;
@end
