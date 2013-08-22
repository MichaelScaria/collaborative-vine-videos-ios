//
//  WMCommentBubble.m
//  WeMake
//
//  Created by Michael Scaria on 8/22/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import "WMCommentBubble.h"

#import "UIImage+WeMake.h"
#import "Constants.h"

@implementation WMCommentBubble

- (id)initWithOrigin:(CGPoint)origin
{
    self = [super initWithFrame:CGRectMake(origin.x, origin.y, 25, 25)];
    if (self) {
        //self.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
//    bubble = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    //bubble.contentMode = UIViewContentModeScaleAspectFit;
//    bubble.image = [[UIImage ipMaskedImageNamed:@"CommentBubble" color:kColorGray] resizableImageWithCapInsets:UIEdgeInsetsMake(12, 12, 12, 12) resizingMode:UIImageResizingModeTile];
    bubble = [UIButton buttonWithType:UIButtonTypeCustom];
    bubble.frame = CGRectMake(0, 0, 25, 25);
    [bubble setBackgroundImage:[[UIImage ipMaskedImageNamed:@"CommentBubble" color:kColorGray] resizableImageWithCapInsets:UIEdgeInsetsMake(12, 12, 12, 12)] forState:UIControlStateNormal];
    [bubble setBackgroundImage:[[UIImage ipMaskedImageNamed:@"CommentBubble" color:kColorDark] resizableImageWithCapInsets:UIEdgeInsetsMake(12, 12, 12, 12)] forState:UIControlStateHighlighted];
    [bubble addTarget:self action:@selector(tappedButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:bubble];
    dots = [[UIImageView alloc] initWithFrame:CGRectMake(5, 9.5, 15, 4.5)];
    dots.image = [UIImage imageNamed:@"BlackDots"];
    [self addSubview:dots];
    originalFrame = self.frame;
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(8, 0, 300, 25)];
    _textView.backgroundColor = [UIColor clearColor];
}

- (void)tappedButton {
    _isSelected = !_isSelected;
    _tapped(_isSelected);
    if (_isSelected) {
        dots.hidden = YES;
        [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.frame = CGRectMake(8, self.frame.origin.y, 300, 25);
            bubble.frame = CGRectMake(8, 0, 300, 25);
        }completion:^(BOOL isCompleted){
            
        }];
    }
    else {
        [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.frame = originalFrame;
            bubble.frame = CGRectMake(0, 0, 25, 25);
        }completion:^(BOOL isCompleted){
            dots.hidden = NO;
        }];
    }

}

#pragma mark UITextViewDelegate

//- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
//    return YES;
//}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)string {
    //limit comment count at 250 characters
    if (([[textView text] length] + string.length > 250 && range.length < string.length) || ([string hasSuffix:@"\n"] && isMax)) return NO;
    
    NSString *newString = [textView.text stringByReplacingCharactersInRange:range withString:string];
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    CGRect frame = textView.frame;
    float delta = textView.contentSize.height - frame.size.height;
    frame.origin.y -= delta;
    isMax =  frame.origin.y - 11 < -99;
}
@end
