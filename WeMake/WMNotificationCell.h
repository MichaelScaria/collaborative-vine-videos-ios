//
//  WMNotificationCell.h
//  WeMake
//
//  Created by Michael Scaria on 8/8/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMRequest.h"

@interface WMNotificationCell : UITableViewCell
@property (nonatomic, strong) UIButton *accept;
@property (nonatomic, strong) UIButton *reject;
@property (nonatomic, strong) WMRequest *request;
- (void)addAcceptButton;
- (void)addRejectButton;
@end
