//
//  WMReviewViewController.h
//  WeMake
//
//  Created by Michael Scaria on 7/25/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>


@protocol WMReviewViewControllerDelegate
- (void)approvedWithThumbnail:(UIImage *)thumbnail;
- (void)back;
@end

@interface WMReviewViewController : UIViewController {
    MPMoviePlayerController *player;
    UIImage *thumbnailImage;
}
@property (nonatomic, strong) id <WMReviewViewControllerDelegate>delegate;
@property (nonatomic, strong) NSURL *url;
- (IBAction)next:(id)sender;
- (IBAction)back:(id)sender;
@end
