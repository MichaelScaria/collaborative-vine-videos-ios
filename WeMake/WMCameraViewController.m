//
//  WMCameraViewController.m
//  WeMake
//
//  Created by Michael Scaria on 7/14/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "WMCreator.h"

#import "WMCameraViewController.h"

#import "UIImage+WeMake.h"
#import "Constants.h"

#define kGridLength 106
#define KSizeOfSquare 75.0f
#define KSizeOfSquareInset 10.0f

#define kCameraViewOffset 60
#define kTimeInterval 0.05

@interface WMCameraViewController ()
@property (readwrite) CMVideoCodecType videoType;
@property (readwrite, getter=isRecording) BOOL recording;
@end

@implementation WMCameraViewController

@synthesize videoPreviewView, context;
@synthesize videoType, recording;

@synthesize flipButton, gridButton, focusButton, progress, touches, device, delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    hasOverlay = YES;
    movieURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), @"Movie.MOV"]];
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    maxLength = kTotalVideoTime - _lengthOfInitialVideo;
    _doneButton.hidden = _lengthOfInitialVideo < kMinimumLength;
    if (_creators.count > 0) {
        //creatorsTableViewController = [[WMCreatorsViewController alloc] initWithCreators:_creators];
        creatorsTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Creator"];
        creatorsTableViewController.view.frame = CGRectMake(0, 0, 320, 135);
        //[creatorsTableViewController setCreators:@[[WMCreator creatorWithDictionary:@{@"username" : @"michaelscaria", @"photo_url" : @"http://graph.facebook.com/1679449736/picture?type=square&width=100&height=100&width=400&height=400", @"start_time" : @0.0, @"length" : @2.3}], [WMCreator creatorWithDictionary:@{@"username" : @"michaelscaria", @"photo_url" : @"http://graph.facebook.com/1679449736/picture?type=square&width=100&height=100&width=400&height=400", @"start_time" : @2.3, @"length" : @1.4}]]];
        [creatorsTableViewController setCreators:_creators];
        [_creatorsView addSubview:creatorsTableViewController.view];
    }
    else {
        [_creatorsView removeFromSuperview];
        /*creatorsTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Creator"];
        creatorsTableViewController.view.frame = CGRectMake(0, 0, 320, 135);
        [creatorsTableViewController setCreators:_creators];
        //[creatorsTableViewController setCreators:@[[WMCreator creatorWithDictionary:@{@"username" : @"michaelscaria", @"photo_url" : @"http://graph.facebook.com/1679449736/picture?type=square&width=100&height=100&width=400&height=400", @"start_time" : @0.0, @"length" : @2.3}], [WMCreator creatorWithDictionary:@{@"username" : @"michaelscaria", @"photo_url" : @"http://graph.facebook.com/1679449736/picture?type=square&width=100&height=100&width=400&height=400", @"start_time" : @2.3, @"length" : @1.4}]]];
        [_creatorsView addSubview:creatorsTableViewController.view];*/
    }
    touches = [[NSMutableArray alloc] init];
    self.videoPreviewView.context = self.context;
    self.videoPreviewView.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    screenSize = [[UIScreen mainScreen] bounds].size;
    
    coreImageContext = [CIContext contextWithEAGLContext:self.context];
    
    glGenRenderbuffers(1, &_renderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _renderBuffer);
    
    movieWritingQueue = dispatch_queue_create("com.michaelscaria.VidLab Movie", DISPATCH_QUEUE_SERIAL);
    
    NSError *error;
    self.device = [self videoDeviceWithPosition:AVCaptureDevicePositionBack];
    videoIn = [[AVCaptureDeviceInput alloc] initWithDevice:self.device error:&error];
    AVCaptureDeviceInput *audioIn = [[AVCaptureDeviceInput alloc] initWithDevice:[self audioDevice] error:nil];
    
    AVCaptureVideoDataOutput *videoOut = [[AVCaptureVideoDataOutput alloc] init];
    [videoOut setAlwaysDiscardsLateVideoFrames:YES];
    //    @{(id)kCVPixelBufferPixelFormatTypeKey: [NSNumber numberWithInt:kCVPixelFormatType_32BGRA]};
    [videoOut setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
    [videoOut setSampleBufferDelegate:self queue:dispatch_queue_create("com.michaelscaria.VidLab Video", DISPATCH_QUEUE_SERIAL)];
    
    AVCaptureAudioDataOutput *audioOut = [[AVCaptureAudioDataOutput alloc] init];
	[audioOut setSampleBufferDelegate:self queue:dispatch_queue_create("com.michaelscaria.VidLab Audio", DISPATCH_QUEUE_SERIAL)];
    
    
    avCaptureSession = [[AVCaptureSession alloc] init];
    [avCaptureSession beginConfiguration];
//    [avCaptureSession setSessionPreset:AVCaptureSessionPreset1280x720];
    if ([avCaptureSession canAddInput:videoIn]) [avCaptureSession addInput:videoIn];
    if ([avCaptureSession canAddInput:audioIn]) [avCaptureSession addInput:audioIn];
    if ([avCaptureSession canAddOutput:videoOut]) [avCaptureSession addOutput:videoOut];
    videoConnection = [videoOut connectionWithMediaType:AVMediaTypeVideo];
    if ([avCaptureSession canAddOutput:audioOut]) [avCaptureSession addOutput:audioOut];
    audioConnection = [audioOut connectionWithMediaType:AVMediaTypeAudio];
    
    [avCaptureSession commitConfiguration];
    [avCaptureSession startRunning];
    
    [self setupCGContext];
    CGImageRef cgImg = CGBitmapContextCreateImage(cgContext);
    maskImage = [CIImage imageWithCGImage:cgImg];
    CGImageRelease(cgImg);
    
    [self.flipButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [self.focusButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    _finishButton.enabled = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    if (recordingView) flipButton.hidden = gridButton.hidden = focusButton.hidden = NO;
//    else flipButton.hidden = gridButton.hidden = focusButton.hidden = YES;
    
    [self.flipButton setImage:[UIImage ipMaskedImageNamed:@"Flip" color:(isFrontCamera) ? kColorLight :kColorNeutral] forState:UIControlStateNormal];
    [self.gridButton setImage:[UIImage ipMaskedImageNamed:@"Grid" color:(displayingGrid) ? kColorLight :kColorNeutral] forState:UIControlStateNormal];
    [self.focusButton setImage:[UIImage ipMaskedImageNamed:@"Crosshairs" color:(tapToFocus) ? kColorLight :kColorNeutral] forState:UIControlStateNormal];
    [self display:nil];
}

-(void)setupCGContext {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * screenSize.width;
    NSUInteger bitsPerComponent = 8;
    NSLog(@"%d %f", bytesPerRow, screenSize.width);
    cgContext = CGBitmapContextCreate(NULL, screenSize.width, screenSize.height, bitsPerComponent, bytesPerRow, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    if (!cgContext) {
        NSLog(@"nil");
    }
    CGColorSpaceRelease(colorSpace);
}

- (IBAction)focus:(UIButton *)sender {
    tapToFocus = !tapToFocus;
    [self.focusButton setImage:[UIImage ipMaskedImageNamed:@"Crosshairs" color:(tapToFocus) ? kColorLight :kColorNeutral] forState:UIControlStateNormal];
}

- (IBAction)grid:(UIButton *)sender {
    if (displayingGrid) {
        [grid removeFromSuperlayer];
    }
    else {
        if (!grid) {
            grid = [CAShapeLayer layer];
            float width = self.videoPreviewView.frame.size.width;
            float offset = (screenSize.height - 320)/2;
            float centerX = screenSize.width/2;
            float centerY = 160 + offset;
            //video preview is a square, so we only need width
            UIBezierPath *bezier = [UIBezierPath bezierPath];
            
            //line above - horizontal
            [bezier moveToPoint:CGPointMake(0, centerY - kGridLength/2 - kCameraViewOffset)];
            [bezier addLineToPoint:CGPointMake(width, centerY - kGridLength/2 - kCameraViewOffset)];
            //line below - horizontal
            [bezier moveToPoint:CGPointMake(0, centerY + kGridLength/2 - kCameraViewOffset)];
            [bezier addLineToPoint:CGPointMake(width, centerY + kGridLength/2 - kCameraViewOffset)];
            
            //line left - vertical
            [bezier moveToPoint:CGPointMake(centerX - kGridLength/2, offset - kCameraViewOffset)];
            [bezier addLineToPoint:CGPointMake(centerX - kGridLength/2, width + offset - kCameraViewOffset)];
            //line right - vertical
            [bezier moveToPoint:CGPointMake(centerX + kGridLength/2, offset - kCameraViewOffset)];
            [bezier addLineToPoint:CGPointMake(centerX + kGridLength/2, width + offset - kCameraViewOffset)];
            
            grid.path = bezier.CGPath;
            grid.fillColor = [UIColor clearColor].CGColor;
            grid.strokeColor = [UIColor whiteColor].CGColor;
            grid.lineWidth = 1.0;
            grid.opacity = .5;
        }
        [self.videoPreviewView.layer addSublayer:grid];
    }
    displayingGrid = !displayingGrid;
    [self.gridButton setImage:[UIImage ipMaskedImageNamed:@"Grid" color:(displayingGrid) ? kColorLight :kColorNeutral] forState:UIControlStateNormal];
}

- (IBAction)flip:(UIButton *)sender {
    if ([[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count] > 1)		//Only do if device has multiple cameras
	{
		NSLog(@"Toggle camera");
        [avCaptureSession stopRunning];
        isFrontCamera = !isFrontCamera;
        NSError *error;
        self.device = [self videoDeviceWithPosition:(isFrontCamera) ? AVCaptureDevicePositionFront : AVCaptureDevicePositionBack];
        if (!self.device) {
            NSLog(@"nil");
        }
        AVCaptureDeviceInput *newVideoIn = [[AVCaptureDeviceInput alloc] initWithDevice:self.device error:&error];
        [avCaptureSession beginConfiguration];
        [avCaptureSession removeInput:videoIn];
        
        NSArray *outputs = [avCaptureSession.outputs copy];
        for (AVCaptureOutput *output in outputs) {
            [avCaptureSession removeOutput:output];
        }
        AVCaptureVideoDataOutput *videoOut = [[AVCaptureVideoDataOutput alloc] init];
        [videoOut setAlwaysDiscardsLateVideoFrames:YES];
        //    @{(id)kCVPixelBufferPixelFormatTypeKey: [NSNumber numberWithInt:kCVPixelFormatType_32BGRA]};
        [videoOut setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
        [videoOut setSampleBufferDelegate:self queue:dispatch_queue_create("com.michaelscaria.VidLab Video", DISPATCH_QUEUE_SERIAL)];
        
        AVCaptureAudioDataOutput *audioOut = [[AVCaptureAudioDataOutput alloc] init];
        [audioOut setSampleBufferDelegate:self queue:dispatch_queue_create("com.michaelscaria.VidLab Audio", DISPATCH_QUEUE_SERIAL)];
        
        if ([avCaptureSession canAddInput:newVideoIn]) {
            [avCaptureSession addInput:newVideoIn];
            videoIn = newVideoIn;
        }
        if ([avCaptureSession canAddOutput:videoOut]) [avCaptureSession addOutput:videoOut];
        videoConnection = [videoOut connectionWithMediaType:AVMediaTypeVideo];
        if ([avCaptureSession canAddOutput:audioOut]) [avCaptureSession addOutput:audioOut];
        audioConnection = [audioOut connectionWithMediaType:AVMediaTypeAudio];
        
        [avCaptureSession commitConfiguration];
        [avCaptureSession startRunning];
	}
    [self.flipButton setImage:[UIImage ipMaskedImageNamed:@"Flip" color:(isFrontCamera) ? kColorLight :kColorNeutral] forState:UIControlStateNormal];
    
}

- (IBAction)cancel:(id)sender {
    [self.delegate cancel];
}

- (IBAction)next:(id)sender {
    if ([timer isValid]) [timer invalidate];
    [self stopRecording];
}

- (IBAction)finish:(id)sender {
    self.videoIsFinished = YES;
    if ([timer isValid]) [timer invalidate];
    [self stopRecording];
}

- (void)time {
    secondsElapsed += kTimeInterval;
    _finishButton.enabled = secondsElapsed > 1;
    if (secondsElapsed > maxLength) {
        [timer invalidate];
        [self stopRecording];
    }
    else
        progress.progress = secondsElapsed/maxLength;
    if (_lengthOfInitialVideo + secondsElapsed >= kMinimumLength) {
        _doneButton.hidden = NO;
    }
}

- (void)focusAtPoint:(CGPoint)locationPoint {
    [self autoFocusAtPoint:locationPoint];
    CGPoint resizedPoint = CGPointMake(locationPoint.x / self.videoPreviewView.bounds.size.width, locationPoint.y / self.videoPreviewView.bounds.size.height);
    CGAffineTransform translateTransform = CGAffineTransformMakeTranslation(0.5,0.5);
    CGAffineTransform rotationTransform = CGAffineTransformMakeRotation(-90);
    CGAffineTransform customRotation = CGAffineTransformConcat(CGAffineTransformConcat( CGAffineTransformInvert(translateTransform), rotationTransform), translateTransform);
    CGPoint newPoint = CGPointApplyAffineTransform(resizedPoint, customRotation);
    
    AVCaptureDevice *captureDevice = self.device;
    if ([device isFocusPointOfInterestSupported] && [captureDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        NSError *error;
        if ([captureDevice lockForConfiguration:&error]) {
            [captureDevice setFocusPointOfInterest:newPoint];
            [captureDevice setFocusMode:AVCaptureFocusModeAutoFocus];
            [captureDevice unlockForConfiguration];
        }
    }
}

- (void)touchesBegan:(NSSet *)touchSet withEvent:(UIEvent *)event {
    
    [touchSet enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        UITouch *touch = obj;
        CGPoint locationPoint = [touch locationInView:self.view];
        CGPoint viewPoint = [self.videoPreviewView convertPoint:locationPoint fromView:self.view];
        if ([self.videoPreviewView pointInside:viewPoint withEvent:event]) {
            NSLog(@"Camera was touched:%@", NSStringFromCGPoint(locationPoint));
            [touches addObject:touch];
            
            if (tapToFocus && locationPoint.y > (screenSize.height - 320)/2 - kCameraViewOffset && locationPoint.y < screenSize.height/2 + 160 - kCameraViewOffset) [self focusAtPoint:locationPoint];
            else if (!tapToFocus && locationPoint.y > (screenSize.height - 320)/2 - kCameraViewOffset && locationPoint.y < screenSize.height/2 + 160 - kCameraViewOffset/2) {
                timer = [NSTimer scheduledTimerWithTimeInterval:kTimeInterval target:self selector:@selector(time) userInfo:nil repeats:YES];
                [timer fire];
                if ([self isRecording]) [self resumeRecording];
                else{
                    [self startRecording];
                }
            }
        }
        
    }];
}

- (void)touchesEnded:(NSSet *)touchSet withEvent:(UIEvent *)event {
    UITouch *touch = [touchSet anyObject];
    [self.touches removeObject:touch];
    
    if (self.touches.count == 0 && [self isRecording]) {
        [timer invalidate];
        [self pauseRecording];
    }
}

- (UIBezierPath*)pathWithRect:(CGRect)rect{
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    
    CGFloat offset = rect.size.width/10.0;
    CGPoint origin = rect.origin;
    
    [path moveToPoint:(CGPoint){origin.x + rect.size.width/2.0,origin.y}];//Top
    [path addLineToPoint:(CGPoint){origin.x + rect.size.width/2.0,origin.y + offset}];
    
    [path moveToPoint:(CGPoint){origin.x,origin.y + rect.size.height/2.0}];//Left
    [path addLineToPoint:(CGPoint){origin.x + offset,origin.y + rect.size.height/2.0}];
    
    [path moveToPoint:(CGPoint){origin.x +rect.size.width,origin.y + rect.size.height/2.0}];//Right
    [path addLineToPoint:(CGPoint){origin.x + rect.size.width - offset,origin.y + rect.size.height/2.0}];
    
    [path moveToPoint:(CGPoint){origin.x + rect.size.width/2.0,origin.y + rect.size.height}];//Bottom
    [path addLineToPoint:(CGPoint){origin.x + rect.size.width/2.0,origin.y + rect.size.height - offset}];
    
    return path;
}

- (void) autoFocusAtPoint:(CGPoint)point
{
    //make square for focus
    float halfSize = KSizeOfSquare/2.0;
    [focusGrid removeAllAnimations];
    [focusGrid removeFromSuperlayer];
    focusGrid = nil;
    
    
    focusGrid = [[CAShapeLayer alloc] init];
    CGRect finalRect = (CGRect){
        point.x - halfSize,
        point.y - halfSize,
        KSizeOfSquare,KSizeOfSquare
    };
    UIBezierPath *finalPath = [self pathWithRect:finalRect];
    
    halfSize = KSizeOfSquare*3.0/2.0;
    CGRect initialRect = (CGRect){
        point.x - halfSize,
        point.y - halfSize,
        KSizeOfSquare*3,KSizeOfSquare*3
    };
    
    UIBezierPath *initialPath = [self pathWithRect:initialRect];
    
    focusGrid.path = initialPath.CGPath;
    focusGrid.lineWidth = 1.0;
    focusGrid.miterLimit = 5.0;
    focusGrid.fillColor = [UIColor clearColor].CGColor;
    //grid.shouldRasterize = YES;
    focusGrid.lineCap = kCALineCapRound;
    focusGrid.strokeColor = [UIColor whiteColor].CGColor;
    
    //grid.shadow
    focusGrid.strokeColor = [UIColor whiteColor].CGColor;
    
    CAShapeLayer *maskLayert = [[CAShapeLayer alloc] init];
    maskLayert.path = initialPath.CGPath;
    maskLayert.fillColor = [UIColor clearColor].CGColor;
    maskLayert.lineWidth = 2;
    maskLayert.miterLimit = 5.0;
    maskLayert.lineCap = kCALineCapRound;
    maskLayert.strokeColor = [UIColor whiteColor].CGColor;
    
    
    [self.videoPreviewView.layer addSublayer:focusGrid];
    focusGrid.mask = maskLayert;
    
    CABasicAnimation *animationColor = [CABasicAnimation animationWithKeyPath:@"fillColor"];
    animationColor.duration = 0.50;
    animationColor.repeatCount = 199;
    animationColor.removedOnCompletion = NO;
    animationColor.fillMode = kCAFillModeForwards;
    animationColor.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animationColor.fromValue = (id)[UIColor blueColor].CGColor;
    
    animationColor.toValue = (id)[UIColor clearColor].CGColor;
    [focusGrid addAnimation:animationColor forKey:@"animateColor"];
    
    [CATransaction begin];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.duration = 0.25;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.toValue = (id)finalPath.CGPath;
    [focusGrid addAnimation:animation forKey:@"animatePath"];
    [maskLayert addAnimation:animation forKey:@"animatePathII"];
    
    
    [CATransaction setCompletionBlock:^{
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            
            [focusGrid removeAllAnimations];
            [maskLayert removeAllAnimations];
            [focusGrid removeFromSuperlayer];
            [maskLayert removeFromSuperlayer];
            focusGrid = nil;
            
        });
    }];
    [CATransaction commit];
    
}

#pragma mark WMViewControllerCameraDelegate

- (void)display:(void (^)(void))completion {
    hasOverlay = NO;
    flipButton.hidden = gridButton.hidden = focusButton.hidden = NO;
    UIView *topOverlay = [[UIView alloc] initWithFrame:CGRectMake(0, (screenSize.height - 320)/-2 - kCameraViewOffset, 320, (screenSize.height - 320)/2 - kCameraViewOffset)];
    topOverlay.backgroundColor = [UIColor colorWithWhite:0 alpha:.9];
    topOverlay.tag = 11;
    [self.videoPreviewView addSubview:topOverlay];
    UIView *bottomOverlay = [[UIView alloc] initWithFrame:CGRectMake(0, screenSize.height, 320, (screenSize.height - 320)/2 + kCameraViewOffset)];
    bottomOverlay.tag = 12;
    bottomOverlay.backgroundColor = [UIColor colorWithWhite:0 alpha:1];
    [self.videoPreviewView addSubview:bottomOverlay];
    
    [UIView animateWithDuration:.5 animations:^{
        topOverlay.frame = CGRectMake(0, 0, 320, topOverlay.frame.size.height);
        bottomOverlay.frame = CGRectMake(0, screenSize.height - bottomOverlay.frame.size.height, 320, bottomOverlay.frame.size.height);
    }completion:^(BOOL isCompleted){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self focusAtPoint:CGPointMake(self.videoPreviewView.center.x, self.videoPreviewView.center.y - kCameraViewOffset)];
            if (completion) completion();
        });
    }];
}

- (void)hide:(void (^)(void))completion {
    hasOverlay = YES;
    flipButton.hidden = gridButton.hidden = focusButton.hidden = YES;
    UIView *topOverlay = [self.videoPreviewView viewWithTag:11];
    UIView *bottomOverlay= [self.videoPreviewView viewWithTag:12];
    [UIView animateWithDuration:.5 animations:^{
        topOverlay.frame = CGRectMake(0, (screenSize.height - 320)/2 * -1, 320, (screenSize.height - 320)/2);
        bottomOverlay.frame = CGRectMake(0, screenSize.height, 320, (screenSize.height - 320)/2);
    }completion:^(BOOL isCompleted){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) completion();
            [topOverlay removeFromSuperview];
            [bottomOverlay removeFromSuperview];
        });
    }];
}

#pragma mark **AVFoundation**

#pragma mark Utilities

- (void)removeFile:(NSURL *)fileURL
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [fileURL path];
    if ([fileManager fileExistsAtPath:filePath]) {
        NSError *error;
        BOOL success = [fileManager removeItemAtPath:filePath error:&error];
		if (!success) NSLog(@"removeFile-Error:%@", error.localizedDescription);
    }
}

#pragma mark Recording

- (void)saveMovieToCameraRoll
{
	ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
	[library writeVideoAtPathToSavedPhotosAlbum:movieURL completionBlock:^(NSURL *assetURL, NSError *error) {
        if (error)
            NSLog(@"saveMovieToCameraRoll-Error:%@", error.localizedDescription);
        else{
            [self.delegate previewVideo:assetURL];
            [self removeFile:movieURL];
        }
        NSLog(@"Movie saved!");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .8 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            self.flipButton.enabled = YES;
            self.focusButton.enabled = YES;
            secondsElapsed = 0;
            progress.progress = 0.0;
        });
        dispatch_async(movieWritingQueue, ^{
            recordingWillBeStopped = NO;
            self.recording = NO;
        });
    }];
}

- (void) writeSampleBuffer:(CMSampleBufferRef)sampleBuffer ofType:(NSString *)mediaType
{
	if ( assetWriter.status == AVAssetWriterStatusUnknown ) {
		
        if ([assetWriter startWriting]) {
			[assetWriter startSessionAtSourceTime:CMSampleBufferGetPresentationTimeStamp(sampleBuffer)];
		}
		else NSLog(@"1writeSampleBuffer-Error:%@", assetWriter.error.localizedDescription);
	}
	
	if ( assetWriter.status == AVAssetWriterStatusWriting ) {
		if (!paused) {
            if (mediaType == AVMediaTypeVideo) {
                if (assetWriterVideoIn.readyForMoreMediaData) {
                    if (![assetWriterVideoIn appendSampleBuffer:sampleBuffer]){
                        NSLog(@"writeSampleBuffer-Errorn:%@", assetWriter.error.description);
                    }
                }
            }
            else if (mediaType == AVMediaTypeAudio) {
                if (assetWriterAudioIn.readyForMoreMediaData) {
                    if (![assetWriterAudioIn appendSampleBuffer:sampleBuffer]) NSLog(@"writeSampleBuffer-Error:%@", assetWriter.error.localizedDescription);
                }
            }
        }
	}
}

- (BOOL) setupAssetWriterAudioInput:(CMFormatDescriptionRef)currentFormatDescription
{
	const AudioStreamBasicDescription *currentASBD = CMAudioFormatDescriptionGetStreamBasicDescription(currentFormatDescription);
    
	size_t aclSize = 0;
	const AudioChannelLayout *currentChannelLayout = CMAudioFormatDescriptionGetChannelLayout(currentFormatDescription, &aclSize);
	NSData *currentChannelLayoutData = nil;
	
	// AVChannelLayoutKey must be specified, but if we don't know any better give an empty data and let AVAssetWriter decide.
	if ( currentChannelLayout && aclSize > 0 )
		currentChannelLayoutData = [NSData dataWithBytes:currentChannelLayout length:aclSize];
	else
		currentChannelLayoutData = [NSData data];
	
	NSDictionary *audioCompressionSettings = [NSDictionary dictionaryWithObjectsAndKeys:
											  [NSNumber numberWithInteger:kAudioFormatMPEG4AAC], AVFormatIDKey,
											  [NSNumber numberWithFloat:currentASBD->mSampleRate], AVSampleRateKey,
											  @64000, AVEncoderBitRatePerChannelKey,
											  [NSNumber numberWithInteger:currentASBD->mChannelsPerFrame], AVNumberOfChannelsKey,
											  currentChannelLayoutData, AVChannelLayoutKey,
											  nil];
	if ([assetWriter canApplyOutputSettings:audioCompressionSettings forMediaType:AVMediaTypeAudio]) {
		assetWriterAudioIn = [[AVAssetWriterInput alloc] initWithMediaType:AVMediaTypeAudio outputSettings:audioCompressionSettings];
		assetWriterAudioIn.expectsMediaDataInRealTime = YES;
		if ([assetWriter canAddInput:assetWriterAudioIn])
			[assetWriter addInput:assetWriterAudioIn];
		else {
			NSLog(@"Couldn't add asset writer audio input.");
            return NO;
		}
	}
	else {
		NSLog(@"Couldn't apply audio output settings.");
        return NO;
	}
    
    return YES;
}

- (BOOL) setupAssetWriterVideoInput:(CMFormatDescriptionRef)currentFormatDescription
{
	float bitsPerPixel;
	CMVideoDimensions dimensions = CMVideoFormatDescriptionGetDimensions(currentFormatDescription);
	int numPixels = dimensions.width * dimensions.height;
	int bitsPerSecond;
	
	// Assume that lower-than-SD resolutions are intended for streaming, and use a lower bitrate
	if ( numPixels < (640 * 480) )
		bitsPerPixel = 4.05; // This bitrate matches the quality produced by AVCaptureSessionPresetMedium or Low.
	else
		bitsPerPixel = 11.4; // This bitrate matches the quality produced by AVCaptureSessionPresetHigh.
	
	bitsPerSecond = numPixels * bitsPerPixel;
    
#warning check this later
    NSDictionary *videoCleanApertureSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                                @320, AVVideoCleanApertureWidthKey,
                                                @320, AVVideoCleanApertureHeightKey,
                                                @10, AVVideoCleanApertureHorizontalOffsetKey,
                                                @10, AVVideoCleanApertureVerticalOffsetKey,
                                                nil];
    
    
    NSDictionary *videoAspectRatioSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                              @3, AVVideoPixelAspectRatioHorizontalSpacingKey,
                                              @3,AVVideoPixelAspectRatioVerticalSpacingKey,
                                              nil];
    
    
    
    NSDictionary *codecSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInteger:bitsPerSecond], AVVideoAverageBitRateKey,
                                   @1,AVVideoMaxKeyFrameIntervalKey,
                                   videoCleanApertureSettings, AVVideoCleanApertureKey,
                                   videoAspectRatioSettings, AVVideoPixelAspectRatioKey,
                                   //AVVideoProfileLevelH264Main30, AVVideoProfileLevelKey, - this is bad
                                   nil];
    
    NSDictionary *videoCompressionSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                   AVVideoCodecH264, AVVideoCodecKey,
                                   codecSettings,AVVideoCompressionPropertiesKey,
                                              AVVideoScalingModeResizeAspectFill,AVVideoScalingModeKey,
                                   @320, AVVideoWidthKey,
                                   @320, AVVideoHeightKey,
                                   nil];
	if ([assetWriter canApplyOutputSettings:videoCompressionSettings forMediaType:AVMediaTypeVideo]) {
		assetWriterVideoIn = [[AVAssetWriterInput alloc] initWithMediaType:AVMediaTypeVideo outputSettings:videoCompressionSettings];
		assetWriterVideoIn.expectsMediaDataInRealTime = YES;
		assetWriterVideoIn.transform = CGAffineTransformMakeRotation(M_PI_2);
		if ([assetWriter canAddInput:assetWriterVideoIn])
			[assetWriter addInput:assetWriterVideoIn];
		else {
			NSLog(@"Couldn't add asset writer video input.");
            return NO;
		}
	}
	else {
		NSLog(@"Couldn't apply video output settings.");
        return NO;
	}
    
    return YES;
}

- (void) startRecording
{
    discontinued = NO;
    _timeOffset = CMTimeMake(0, 0);
    self.flipButton.enabled = NO;
    self.focusButton.enabled = NO;
	dispatch_async(movieWritingQueue, ^{
        
		if ( recordingWillBeStarted || self.recording )
			return;
        
		recordingWillBeStarted = YES;
        
        
		// Remove the file if one with the same name already exists
		[self removeFile:movieURL];
        
		// Create an asset writer
		NSError *error;
		assetWriter = [[AVAssetWriter alloc] initWithURL:movieURL fileType:(NSString *)kUTTypeQuickTimeMovie error:&error];
		if (error) NSLog(@"startRecording-Error:%@", error.localizedFailureReason);
	});
}

- (void) stopRecording
{
	dispatch_async(movieWritingQueue, ^{
		
		if (recordingWillBeStopped || (self.recording == NO)) {
            NSLog(@"recordingWillBeStopped%d", recordingWillBeStopped);
            NSLog(@"self.recording%d", self.recording);
            NSLog(@"RETURNED");
            return;
        }
        else {
            NSLog(@"NOT RETURNED");
        }
			
		
		recordingWillBeStopped = YES;
        readyToRecordVideo = NO;
        readyToRecordAudio = NO;
		// recordingDidStop is called from saveMovieToCameraRoll
        
        [assetWriter finishWritingWithCompletionHandler:^(){
            assetWriter = nil;
			[self saveMovieToCameraRoll];
        }];
        
	});
}

- (void)pauseRecording
{
	paused = YES;
    discontinued= YES;
    flipButton.enabled = YES;
    focusButton.enabled = YES;
}

- (void)resumeRecording
{
	paused = NO;
    flipButton.enabled = NO;
    focusButton.enabled = NO;
}

#pragma mark Capture

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
    BOOL isVideo = NO;
    CMFormatDescriptionRef formatDescription = CMSampleBufferGetFormatDescription(sampleBuffer);
    if (connection == videoConnection) {
        isVideo = YES;
        if (self.videoType == 0) self.videoType = CMFormatDescriptionGetMediaSubType( formatDescription );
        CVPixelBufferRef pixelBuffer = (CVPixelBufferRef)CMSampleBufferGetImageBuffer(sampleBuffer);
        CIImage *image = [CIImage imageWithCVPixelBuffer:pixelBuffer];
        if (hasOverlay) {
            CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
            [filter setValue:image forKey:kCIInputImageKey]; [filter setValue:@15.0f forKey:@"inputRadius"];
            image = [filter valueForKey:kCIOutputImageKey];
        }
        CGAffineTransform transform = CGAffineTransformMakeRotation(-M_PI_2);
        image = [image imageByApplyingTransform:transform];
        if (isFrontCamera)
            image = [image imageByApplyingTransform:CGAffineTransformTranslate(CGAffineTransformMakeScale(-1, 1), -720, kCameraViewOffset*2.5)];
        else
            image = [image imageByApplyingTransform:CGAffineTransformTranslate(CGAffineTransformMakeScale(.665,  .665), 0, kCameraViewOffset*2.5)];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [coreImageContext drawImage:image inRect:CGRectMake(0, 0, screenSize.width*2, screenSize.height*2) fromRect:CGRectMake(0, -1280, 720, 1280)];
            [self.context presentRenderbuffer:GL_RENDERBUFFER];
        });
    }
    @synchronized(self)
    {
        if (paused) return;
        if (discontinued)
        {
            if (isVideo) return;
            NSLog(@"IN _DISCNT");
            discontinued = NO;
            // calc adjustment
            CMTime pts = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
            CMTime last = isVideo ? _lastVideo : _lastAudio;
            if (last.flags & kCMTimeFlags_Valid)
            {
                if (_timeOffset.flags & kCMTimeFlags_Valid)
                {
                    pts = CMTimeSubtract(pts, _timeOffset);
                }
                CMTime offset = CMTimeSubtract(pts, last);
                NSLog(@"Setting offset from %s", isVideo ? "video": "audio");
                NSLog(@"Adding %f to %f (pts %f)", ((double)offset.value)/offset.timescale, ((double)_timeOffset.value)/_timeOffset.timescale, ((double)pts.value/pts.timescale));
                
                // this stops us having to set a scale for _timeOffset before we see the first video time
                if (_timeOffset.value == 0)
                {
                    _timeOffset = offset;
                }
                else
                {
                    _timeOffset = CMTimeAdd(_timeOffset, offset);
                }
            }
            _lastVideo.flags = 0;
            _lastAudio.flags = 0;
        }
        CFRetain(sampleBuffer);
        CFRetain(formatDescription);
        
        if (_timeOffset.value > 0)
        {
            CFRelease(sampleBuffer);
            sampleBuffer = [self adjustTime:sampleBuffer by:_timeOffset];
        }
        
        // record most recent time so we know the length of the pause
        CMTime pts = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
        CMTime dur = CMSampleBufferGetDuration(sampleBuffer);
        if (dur.value > 0) pts = CMTimeAdd(pts, dur);
        if (isVideo) _lastVideo = pts;
        else  _lastAudio = pts;
        
        
        dispatch_async(movieWritingQueue, ^{
            
            if ( assetWriter ) {
                
                BOOL wasReadyToRecord = (readyToRecordAudio && readyToRecordVideo);
                
                if (connection == videoConnection) {
                    
                    // Initialize the video input if this is not done yet
                    if (!readyToRecordVideo)
                        readyToRecordVideo = [self setupAssetWriterVideoInput:formatDescription];
                    
                    // Write video data to file
                    if (readyToRecordVideo && readyToRecordAudio)
                        [self writeSampleBuffer:sampleBuffer ofType:AVMediaTypeVideo];
                }
                else if (connection == audioConnection) {
                    
                    // Initialize the audio input if this is not done yet
                    if (!readyToRecordAudio)
                        readyToRecordAudio = [self setupAssetWriterAudioInput:formatDescription];
                    
                    // Write audio data to file
                    if (readyToRecordAudio && readyToRecordVideo)
                        [self writeSampleBuffer:sampleBuffer ofType:AVMediaTypeAudio];
                }
                
                BOOL isReadyToRecord = (readyToRecordAudio && readyToRecordVideo);
                if ( !wasReadyToRecord && isReadyToRecord ) {
                    recordingWillBeStarted = NO;
                    self.recording = YES;
                }
            }
            CFRelease(sampleBuffer);
            CFRelease(formatDescription);
        });
    }
}

- (CMSampleBufferRef)adjustTime:(CMSampleBufferRef)sample by:(CMTime)offset
{
    CMItemCount count;
    CMSampleBufferGetSampleTimingInfoArray(sample, 0, nil, &count);
    CMSampleTimingInfo* pInfo = malloc(sizeof(CMSampleTimingInfo) * count);
    CMSampleBufferGetSampleTimingInfoArray(sample, count, pInfo, &count);
    for (CMItemCount i = 0; i < count; i++)
    {
        pInfo[i].decodeTimeStamp = CMTimeSubtract(pInfo[i].decodeTimeStamp, offset);
        pInfo[i].presentationTimeStamp = CMTimeSubtract(pInfo[i].presentationTimeStamp, offset);
    }
    CMSampleBufferRef sout;
    CMSampleBufferCreateCopyWithNewTiming(nil, sample, count, pInfo, &sout);
    free(pInfo);
    return sout;
}

- (AVCaptureDevice *)videoDeviceWithPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *aDevice in devices)
        if ([aDevice position] == position)
            return aDevice;
    
    return nil;
}

- (AVCaptureDevice *)audioDevice
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio];
    if ([devices count] > 0) return [devices objectAtIndex:0];
    return nil;
}

- (void)pauseCaptureSession
{
	if ( avCaptureSession.isRunning )
		[avCaptureSession stopRunning];
}

- (void)resumeCaptureSession
{
	if ( !avCaptureSession.isRunning )
		[avCaptureSession startRunning];
}


@end
