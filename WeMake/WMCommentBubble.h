//
//  WMCommentBubble.h
//  WeMake
//
//  Created by Michael Scaria on 8/22/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^WMTapped)(BOOL);
typedef void(^WMComment)(NSString *);

@interface WMCommentBubble : UIView <UITextViewDelegate> {
    CGRect originalFrame;
    float originalYOffset;
    BOOL isMax;
    UIButton *bubble;
    UIImageView *dots;
}
@property (nonatomic, copy) WMTapped tapped;
@property (nonatomic, copy) WMComment comment;

@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, strong) UITextView *textView;
- (id)initWithOrigin:(CGPoint)origin;
- (void)tappedButton;
@end
