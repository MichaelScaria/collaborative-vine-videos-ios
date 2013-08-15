//
//  WMFeedViewController.m
//  WeMake
//
//  Created by Michael Scaria on 8/15/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import "WMFeedViewController.h"
#import "WMModel.h"

#import "UIImageView+AFNetworking.h"

@interface WMFeedViewController ()

@end

@implementation WMFeedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
	[[WMModel sharedInstance] getPostsSuccess:^(NSArray *thumbnails) {
        int origin = 0;
        for (NSString *s in thumbnails) {
            UIImageView *i = [[UIImageView alloc] initWithFrame:CGRectMake(0, origin, 310, 310)];
            [i setImageWithURL:[NSURL URLWithString:s]];
            [_scrollView addSubview:i];
            origin += 320;
        }
    } failure:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
