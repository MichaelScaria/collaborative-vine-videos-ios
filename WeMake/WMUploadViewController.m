//
//  WMUploadViewController.m
//  WeMake
//
//  Created by Michael Scaria on 7/24/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import "WMUploadViewController.h"
#import "WMModel.h"

#import <AssetsLibrary/AssetsLibrary.h>

#define DEGREES_TO_RADIANS(x) (M_PI * x / 180.0)

@interface WMUploadViewController ()

@end

@implementation WMUploadViewController
@synthesize initalURL;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
	cameraViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Camera"];
    cameraViewController.delegate = self;
	reviewViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Review"];
    reviewViewController.delegate = self;
    reviewViewController.view.frame = CGRectMake(screenSize.width, 0, reviewViewController.view.frame.size.width, reviewViewController.view.frame.size.height);

    UIScrollView *scrollView = (UIScrollView *)self.view;
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(screenSize.width*3, screenSize.height);
    scrollView.scrollEnabled = NO;
    scrollView.backgroundColor = [UIColor blackColor];

    [scrollView addSubview:cameraViewController.view];
    [scrollView addSubview:reviewViewController.view];
    //NSString *mediaurl = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mov"];

    //[self previewVideo:[NSURL fileURLWithPath:mediaurl]];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//        [self merge];
//    });
    
}


- (void)merge {
    if (initalURL && videoURL) {
        NSString *mediaurl = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mov"];
        AVAsset *firstAsset = [AVAsset assetWithURL:initalURL];
        AVAsset *secondAsset = [AVAsset assetWithURL:videoURL];
        
        

        AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
        CMTime videoDuration1 = firstAsset.duration;
        NSLog(@"D1:%f", CMTimeGetSeconds(videoDuration1));
        
        //VIDEO TRACK
        AVMutableCompositionTrack *firstTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                            preferredTrackID:kCMPersistentTrackID_Invalid];
        [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, firstAsset.duration)
                            ofTrack:[firstAsset tracksWithMediaType:AVMediaTypeVideo][0] atTime:kCMTimeZero error:nil];
        AVMutableCompositionTrack *secondTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                             preferredTrackID:kCMPersistentTrackID_Invalid];
        [secondTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, secondAsset.duration)
                             ofTrack:[secondAsset tracksWithMediaType:AVMediaTypeVideo][0] atTime:firstAsset.duration error:nil];
        
        //AUDIO TRACK
        AVMutableCompositionTrack *trackAudio = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        [trackAudio insertTimeRange:CMTimeRangeMake(kCMTimeZero, firstAsset.duration) ofTrack:[[firstAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
        [trackAudio insertTimeRange:CMTimeRangeMake(kCMTimeZero, secondAsset.duration) ofTrack:[[secondAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:firstAsset.duration error:nil];
        
        
        
        
        AVMutableVideoCompositionInstruction *mainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeAdd(firstAsset.duration, secondAsset.duration));
        // 2.2 - Create an AVMutableVideoCompositionLayerInstruction for the first track
        AVMutableVideoCompositionLayerInstruction *firstlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:firstTrack];
        CGAffineTransform translateToCenter = CGAffineTransformMakeTranslation( 0,-320);
        CGAffineTransform rotateBy90Degrees = CGAffineTransformMakeRotation( M_PI_2);
        //CGAffineTransform shrinkWidth = CGAffineTransformMakeScale(0.66, 1); // needed because Apple does a "stretch" by default - really, we should find and undo apple's stretch - I suspect it'll be a CALayer defaultTransform, or UIView property causing this
        CGAffineTransform finalTransform = CGAffineTransformConcat(translateToCenter, rotateBy90Degrees);
        [firstlayerInstruction setTransform:finalTransform atTime:kCMTimeZero];
        [firstlayerInstruction setOpacity:0.0 atTime:firstAsset.duration];
        // 2.3 - Create an AVMutableVideoCompositionLayerInstruction for the second track
        AVMutableVideoCompositionLayerInstruction *secondlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:secondTrack];
        [secondlayerInstruction setTransform:finalTransform atTime:firstAsset.duration];
        
        
        mainInstruction.layerInstructions = [NSArray arrayWithObjects:firstlayerInstruction, secondlayerInstruction,nil];
        AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];
        mainCompositionInst.instructions = [NSArray arrayWithObject:mainInstruction];
        mainCompositionInst.frameDuration = CMTimeMake(1, 30);
        mainCompositionInst.renderSize = CGSizeMake(320, 320);
        
        
        
        
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"mergeVideo-%d.mov",arc4random() % 1000]];
        NSURL *url = [NSURL fileURLWithPath:myPathDocs];
        // 5 - Create exporter
        AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
        exporter.videoComposition = mainCompositionInst;
        exporter.outputURL=url;
        exporter.outputFileType = AVFileTypeQuickTimeMovie;
        exporter.shouldOptimizeForNetworkUse = YES;
        [exporter exportAsynchronouslyWithCompletionHandler:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self exportDidFinish:exporter];
            });
        }];
    }
    else {
        NSLog(@"URL nil");
    }
    
    
}

-(void)exportDidFinish:(AVAssetExportSession*)session {
    AVAsset *firstAsset = [AVAsset assetWithURL:initalURL];
    AVAsset *secondAsset = [AVAsset assetWithURL:videoURL];
    CMTime videoDuration1 = firstAsset.duration;
    NSLog(@"D1:%f", CMTimeGetSeconds(videoDuration1));
    CMTime videoDuration2 = secondAsset.duration;
    NSLog(@"D2:%f", CMTimeGetSeconds(videoDuration2));
    
    CMTime videoDuration3 = session.asset.duration;
    NSLog(@"D3:%f", CMTimeGetSeconds(videoDuration3));
    
    NSLog(@"Status:%d", session.status);
    if (session.status & AVAssetExportSessionStatusCompleted) {
        NSURL *outputURL = session.outputURL;
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputURL]) {
            [library writeVideoAtPathToSavedPhotosAlbum:outputURL completionBlock:^(NSURL *assetURL, NSError *error){
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Video Saving Failed"
                                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];
                    } else {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Video Saved" message:@"Saved To Photo Album"
                                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alert show];
                    }
                });
            }];
        }
    }
    else if (session.status & AVAssetExportSessionStatusFailed) {
        NSLog(@"Error:%@", session.error.description);
    }
}

- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark WMCameraViewControllerDelegate

- (void)previewVideo:(NSURL *)url {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        videoURL = url;
        if (initalURL) [self merge];
        UIScrollView *scrollView = (UIScrollView *)self.view;
        [scrollView scrollRectToVisible:CGRectMake(320, 0, 320, 1) animated:YES];
        reviewViewController.url = url;
        if (!requestViewController) {
            CGSize screenSize = [[UIScreen mainScreen] bounds].size;
            requestViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Request"];
            requestViewController.delegate = self;
            requestViewController.view.frame = CGRectMake(screenSize.width * 2, 0, requestViewController.view.frame.size.width, requestViewController.view.frame.size.height);
            [scrollView addSubview:requestViewController.view];
        }
        [[WMModel sharedInstance] fetchFollowersSuccess:^(NSArray *followers){
            NSLog(@"Followers:%@", followers);
            [requestViewController setFollowers:[followers mutableCopy]];
        }failure:nil];
    });
    
}

#pragma mark WMReviewViewControllerDelegate

- (void)approved {
    UIScrollView *scrollView = (UIScrollView *)self.view;
    [scrollView scrollRectToVisible:CGRectMake(640, 0, 320, 1) animated:YES];
}

- (void)back {
    UIScrollView *scrollView = (UIScrollView *)self.view;
    [scrollView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

#pragma mark WMRequestViewControllerDelegate

- (void)sendToFollowers:(NSString *)followers {
    NSLog(@"F:%@", followers);
    [[WMModel sharedInstance] uploadURL:videoURL to:followers success:^{
        [self dismissViewControllerAnimated:YES completion:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Sent Request%@", (followers.length > 1) ? @"s" : @""] message:@"Success" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            });
        }];
    }failure:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
}

@end
