//
//  WMNotificationCell.m
//  WeMake
//
//  Created by Michael Scaria on 8/8/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import "WMNotificationCell.h"

#define kBlueColor [UIColor colorWithRed:.17 green:.62 blue:1 alpha:1]

@implementation WMNotificationCell
@synthesize accept, reject, request;
- (void)addAcceptButton {
    if (!accept) {
        accept = [UIButton buttonWithType:UIButtonTypeCustom];
        [accept setTitle:@"Accept" forState:UIControlStateNormal];
        [accept.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17]];
        [accept setTitleColor:kBlueColor forState:UIControlStateNormal];
        [accept setFrame:CGRectMake(70, 370, 60, 30)];
    }
    [self addSubview:accept];
}

- (void)addRejectButton {
    if (!reject) {
        reject = [UIButton buttonWithType:UIButtonTypeCustom];
        [reject setTitle:@"Reject" forState:UIControlStateNormal];
        [reject.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17]];
        [reject setTitleColor:kBlueColor forState:UIControlStateNormal];
        [reject setFrame:CGRectMake(190, 370, 60, 30)];
    }
    [self addSubview:reject];
}
@end
