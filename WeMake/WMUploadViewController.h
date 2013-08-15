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
#import "WMPostViewController.h"

#import "WMVideo.h"

@interface WMUploadViewController : UIViewController <WMCameraViewControllerDelegate, WMReviewViewControllerDelegate, WMRequestViewControllerDelegate, WMPostViewControllerDelegate> {
    WMCameraViewController *cameraViewController;
    WMReviewViewController *reviewViewController;
    WMRequestViewController *requestViewController;
    WMPostViewController *postViewController;
    
    NSURL *videoURL;
    NSURL *tempURL;
    NSURL *exportURL;
    
    UIImage *thumbnailImage;
    
    float startTime;
}
@property (nonatomic, strong) WMVideo *initialVideo;
@end
