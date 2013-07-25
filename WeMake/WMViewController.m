//
//  WMViewController.m
//  WeMake
//
//  Created by Michael Scaria on 6/30/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import "WMViewController.h"
#import "WMModel.h"
#import "WMLoginViewController.h"
//#import "WMCameraViewController.h"
#import "WMUploadViewController.h"

#define kCameraViewOffset 50.0

@interface WMViewController ()

@end

@implementation WMViewController

@synthesize posts, scrollView, delegate;

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    /*UIImage* image = [UIImage imageNamed:@"test"];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    CGImageRef cgImage = [image CGImage];
    size_t width = CGImageGetWidth(cgImage);
    size_t height = CGImageGetHeight(cgImage);
    //    NSUInteger x = (NSUInteger)floor(point.x);
    //    NSUInteger y = height - (NSUInteger)floor(point.y);
    
    for (int y = 1; y < height; y++) {
        for (int x = 1; x < width; x++){
            //NSLog(@"%d", array.count);
            CGDataProviderRef provider = CGImageGetDataProvider(cgImage);
            CFDataRef bitmapData = CGDataProviderCopyData(provider);
            const UInt8* data = CFDataGetBytePtr(bitmapData);
            NSUInteger yt = height - (NSUInteger)floor(y);
            size_t offset = ((width * yt) + x) * 4;
            UInt8 red = data[offset];
            UInt8 blue = data[offset+1];
            UInt8 green = data[offset+2];
            UInt8 alpha = data[offset+3];

            CFRelease(bitmapData);
            
            BOOL matchFound = NO;
            for (int i = 0; i < array.count; i++) {
                //iterate through previous colors
                NSDictionary *dict = array[i];
                UIColor *color = dict[@"color"];
                CGFloat nred = 0.0, ngreen = 0.0, nblue = 0.0, nalpha =0.0;
                [color getRed:&nred green:&ngreen blue:&nblue alpha:&nalpha];
                
                //NSLog(@"%f AND %f", red/255.0, nred);
                //NSLog(@"m%f", fabsf(red/255.0 - nred));
                if (fabs(red/255.0 - nred) < kMargin && fabs(green/255.0 - ngreen) < kMargin && fabs(blue/255.0 - nblue) < kMargin) {
                    //similar, increment
                    matchFound = YES;
                    [array removeObject:dict];
                    int freq = [dict[@"frequency"] intValue];
                    freq++;
                    NSDictionary *nd = @{@"color": color, @"frequency" : [NSNumber numberWithInt:freq]};
                    [array addObject:nd];
                    break;
                }
            }
            if (!matchFound){
                NSLog(@"%d", red);
                NSLog(@"%d", green);
                NSLog(@"%d", blue);
                [array addObject:@{@"color" : [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha/255.0f], @"frequency" : @1}];
            }
        }
    }
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"frequency"  ascending:NO];
    array = [[array sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]] mutableCopy];
    
    for (int i = 0; i <4; i++) {
        NSDictionary *d = array[i];
        NSLog(@"1:%@", d[@"frequency"]);
    }
    NSLog(@"Array:%d", array.count);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 305, 62, 64)];
    imageView.image = image;
    [self.view addSubview:imageView];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 405, 64, 64)];
    view.backgroundColor = array[0][@"color"];
    [self.view addSubview:view];
    
    NSMutableArray *test = [[NSMutableArray alloc] initWithCapacity:array.count * .75];
    for (NSDictionary *d in array) {
        UIColor *ncolor = d[@"color"];
        CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha =0.0;
        [ncolor getRed:&red green:&green blue:&blue alpha:&alpha];
        BOOL matchFound = NO;
        for (int i = 0; i < test.count; i++) {
            NSDictionary *dict = test[i];
            UIColor *color = dict[@"color"];
            CGFloat nred = 0.0, ngreen = 0.0, nblue = 0.0, nalpha =0.0;
            [color getRed:&nred green:&ngreen blue:&nblue alpha:&nalpha];
            if (fabs(red/255.0 - nred) < k2Margin && fabs(green/255.0 - ngreen) < k2Margin && fabs(blue/255.0 - nblue) < k2Margin) {
                //similar, increment
                matchFound = YES;
                [test removeObject:dict];
                int freq = [dict[@"frequency"] intValue];
                freq++;
                NSDictionary *nd = @{@"color": color, @"frequency" : [NSNumber numberWithInt:freq]};
                [test addObject:nd];
                break;
            }        }
        if (!matchFound)[test addObject:@{@"color" : d[@"color"], @"frequency" : @1}];
    }
    
    for (int i = 0; i < 4; i++) {
        NSDictionary *d = test[i];
        NSLog(@"2:%@", d);
    }
    NSLog(@"Test:%d", test.count);
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(100, 405, 64, 64)];
    view2.backgroundColor = test[test.count - 2][@"color"];
    [self.view addSubview:view2];
     */
    WMUploadViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"Upload"];
    if (vc) {
        self.delegate = vc;
        [self.view insertSubview:vc.view atIndex:0];
    }
//    
//    WMCameraViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"Camera"];
//    if (vc) {
//        self.delegate = vc;
//        //[self.view insertSubview:vc.view atIndex:0];
//    }
//    UIScrollView *aScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
//    aScrollView.contentSize = CGSizeMake(640, 568);
//    [self.view insertSubview:aScrollView atIndex:0];
//    [aScrollView addSubview:vc.view];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    screenSize = [[UIScreen mainScreen] bounds].size;
    [self setUpScrollView];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setUpScrollView {
    self.scrollView.contentSize = CGSizeMake(320, screenSize.height);
}

- (void)presentLoginView {
    //[self performSegueWithIdentifier:@"Login" sender:nil];
}

- (IBAction)flipCameraView:(UIButton *)sender {
    sender.enabled = NO;
    if (recordingView) {
        [UIView animateWithDuration:.5 animations:^{
            self.scrollView.frame = CGRectMake(0, 0, 320, scrollView.frame.size.height);
        } completion:nil];
        
        [self.delegate hide:^{
            [UIView animateWithDuration:.2 animations:^{
                self.scrollView.alpha = .85;
            } completion:^(BOOL isCompleted){
                recordingView = NO;
                sender.enabled = YES;
            }];
        }];
        [sender setTitle:@"Record" forState:UIControlStateNormal];
    }
    else {
        if (!self.delegate) {
            NSLog(@"nil");
        }
        [self.delegate display:^{
            [UIView animateWithDuration:.65 animations:^{
                self.scrollView.frame = CGRectMake(scrollView.frame.origin.x, scrollView.frame.size.height, 320, scrollView.frame.size.height);
            }completion:^(BOOL isCompleted){
                recordingView = YES;
                sender.enabled = YES;
            }];
        }];
        [sender setTitle:@"X" forState:UIControlStateNormal];
        [UIView animateWithDuration:.2 animations:^{
            self.scrollView.alpha = 0;
        } completion:nil];
        
    }
}




@end
