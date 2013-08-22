//
//  MSTextView.h
//  WeMake
//
//  Created by Michael Scaria on 8/21/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^MSLinkClicked)(NSString *, NSString *);
@interface MSTextView : UITextView
@property (nonatomic, copy) MSLinkClicked linktapped;

- (void)setText:(NSString *)text withLinkedRange:(NSRange)range;
@end
