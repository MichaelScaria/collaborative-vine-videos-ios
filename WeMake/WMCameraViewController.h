//
//  WMCameraViewController.h
//  WeMake
//
//  Created by Michael Scaria on 7/14/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreImage/CoreImage.h>
#import <ImageIO/ImageIO.h>

@protocol WMCameraViewControllerDelegate
- (void)previewVideo:(NSURL *)url;
- (void)cancel;
@end

@interface WMCameraViewController : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate> {
    AVCaptureSession *avCaptureSession;
    CIContext *coreImageContext;
    CIImage *maskImage;
    CGSize screenSize;
    CGContextRef cgContext;
    GLuint _renderBuffer;
    float scale;
    CAShapeLayer *grid;
    CAShapeLayer *focusGrid;
    NSTimer *timer;
    float secondsElapsed;
    BOOL hasOverlay;
    BOOL creatingVideo;
    
    AVCaptureConnection *audioConnection;
	AVCaptureConnection *videoConnection;
    AVCaptureDeviceInput *videoIn;
    
    NSURL *movieURL;
	AVAssetWriter *assetWriter;
	AVAssetWriterInput *assetWriterAudioIn;
	AVAssetWriterInput *assetWriterVideoIn;
    dispatch_queue_t movieWritingQueue;
    
    
    BOOL isFrontCamera;
    BOOL displayingGrid;
    BOOL tapToFocus;
    
    BOOL paused;
    BOOL discontinued;
    CMTime _timeOffset;
    CMTime _lastVideo;
    CMTime _lastAudio;
    
    // Only accessed on movie writing queue
    BOOL readyToRecordAudio;
    BOOL readyToRecordVideo;
	BOOL recordingWillBeStarted;
	BOOL recordingWillBeStopped;
	BOOL recording;
}
@property (nonatomic, strong) NSMutableArray *touches;
@property (nonatomic, strong) AVCaptureDevice *device;
@property (strong, nonatomic) EAGLContext *context;
@property (nonatomic, strong) id <WMCameraViewControllerDelegate>delegate;

@property (nonatomic,retain) IBOutlet GLKView *videoPreviewView;
@property (strong, nonatomic) IBOutlet UIButton *flipButton;
@property (strong, nonatomic) IBOutlet UIButton *focusButton;
@property (strong, nonatomic) IBOutlet UIButton *gridButton;
@property (strong, nonatomic) IBOutlet UIProgressView *progress;

-(void)setupCGContext;

- (IBAction)focus:(UIButton *)sender;
- (IBAction)grid:(UIButton *)sender;
- (IBAction)flip:(UIButton *)sender;
- (IBAction)cancel:(id)sender;

- (void)display:(void (^)(void))completion;
- (void)hide:(void (^)(void))completion;
@end
