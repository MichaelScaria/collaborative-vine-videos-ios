//
//  WMUploadViewController.h
//  WeMake
//
//  Created by Michael Scaria on 7/24/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMViewController.h"

#import "WMCameraViewController.h"
#import "WMReviewViewController.h"

@interface WMUploadViewController : UIViewController <WMViewControllerDelegate, WMCameraViewControllerDelegate, WMReviewViewControllerDelegate> {
    WMCameraViewController *cameraViewController;
    WMReviewViewController *reviewViewController;
}
@end
