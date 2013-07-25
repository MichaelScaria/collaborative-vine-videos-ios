//
//  WMViewController.h
//  WeMake
//
//  Created by Michael Scaria on 6/30/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMRootViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <GLKit/GLKit.h>


@protocol WMViewControllerDelegate <NSObject>

- (void)display:(void (^)(void))completion;
- (void)hide:(void (^)(void))completion;
@end

@interface WMViewController : WMRootViewController {
    CGSize screenSize;
    BOOL recordingView;
}
@property (nonatomic, strong) NSArray *posts;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) id <WMViewControllerDelegate>delegate;
- (IBAction)flipCameraView:(UIButton *)sender;


@end
