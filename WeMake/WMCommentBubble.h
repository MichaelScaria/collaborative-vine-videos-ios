//
//  WMCommentBubble.h
//  WeMake
//
//  Created by Michael Scaria on 8/22/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WMInteraction.h"

typedef void(^WMTapped)(BOOL);
typedef void(^WMCommentCompletion)(BOOL, WMInteraction *);
typedef void(^WMCommentSend)(NSString *, WMCommentCompletion);

@protocol WMCommentBubbleDelegate <NSObject>

- (void)heightChanged:(float)changedHeight;

@end

@interface WMCommentBubble : UIView <UITextViewDelegate> {
    CGRect originalFrame;
    float originalYOffset;
    BOOL isMax;
    UIButton *bubble;
    UIImageView *dots;
}
@property (nonatomic, copy) WMTapped tapped;
@property (nonatomic, copy) WMCommentCompletion commentCompletion;
@property (nonatomic, copy) WMCommentSend comment;

@property (nonatomic, assign) id <WMCommentBubbleDelegate> delegate;

@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, strong) UITextView *textView;
- (id)initWithOrigin:(CGPoint)origin;
- (void)tappedButton;
@end
