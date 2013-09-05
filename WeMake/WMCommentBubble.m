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


#define kTextViewFrame CGRectMake(8, 0, 290, 32)

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
    
    _textView = [[UITextView alloc] initWithFrame:kTextViewFrame];
    _textView.backgroundColor = [UIColor colorWithRed:.5 green:.3 blue:.8 alpha:.4];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
    _textView.contentMode = UIViewContentModeCenter;
    _textView.hidden = YES;
    _textView.delegate = self;
    _textView.returnKeyType = UIReturnKeyDone;
    [self addSubview:_textView];

}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (!CGRectContainsPoint(self.frame, point)) {
        if (_isSelected) {
            UITableView *tableView = (UITableView *)self.superview.superview.superview.superview;
            tableView.scrollEnabled = NO;
            [tableView setContentOffset:CGPointMake(tableView.contentOffset.x, originalYOffset) animated:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .75 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                tableView.scrollEnabled = YES;
            });
        }
        [self removeTextView];
    }
    // use this to pass the 'touch' onward in case no subviews trigger the touch
    return [super hitTest:point withEvent:event];
}

- (void)tappedButton {
    _isSelected = !_isSelected;
    _tapped(_isSelected);
    if ([_textView isFirstResponder]) [_textView resignFirstResponder];
    if (_isSelected) {
        dots.hidden = YES;
        [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.frame = CGRectMake(8, self.frame.origin.y, 300, 25);
            bubble.frame = CGRectMake(4, 0, 295, 32);
        }completion:^(BOOL isCompleted){
            _textView.hidden = NO;
            [_textView becomeFirstResponder];
            _textView.text = @"Lorem ipsum dolor sit er or";
            _textView.text = @"Neque porro quisquam est qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit. Lorem ipsum dolor sit er or Lorem ipsum dolor sit er or Lorem ipsum dolor sit er or Lorem ipsum dolor sit er or";
            _textView.frame = kTextViewFrame;
            [_textView scrollRectToVisible:CGRectMake(0, _textView.contentSize.height/2 * 0, 1, 1) animated:NO]; //random hack
        }];
    }
    else {
        [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.frame = originalFrame;
            bubble.frame = CGRectMake(0, 0, 25, 25);
            _textView.frame = CGRectMake(0, 0, 25, 25);
        }completion:^(BOOL isCompleted){
            dots.hidden = NO;
            _textView.hidden = YES;
        }];
    }
}

- (void)removeTextView {
    if (![_textView isFirstResponder]) return;
    [_textView resignFirstResponder];
    [self tappedButton];
}

#pragma mark UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ScrollToCommentBubble" object:self.superview.superview];
    originalYOffset = self.superview.superview.frame.origin.y;
    NSLog(@"textViewShouldBeginEditing:%@", NSStringFromCGRect(self.frame));
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    textView.text = @"";
    NSLog(@"textViewShouldEndEditing:%@", NSStringFromCGRect(self.frame));
    //[self.delegate heightChanged:0];
    [textView resignFirstResponder];
    return YES;
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)string {
    //limit comment count at 250 characters
    if ([string hasSuffix:@"\n"]) {
        //post comment to server
        _comment(textView.text, _commentCompletion);
        [self removeTextView];
        return NO;
    }
    if (([[textView text] length] + string.length > 250 && range.length < string.length) || isMax) return NO;
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    CGRect textFrame = textView.frame;
    CGRect bubbleFrame = bubble.frame;
    float delta = textView.contentSize.height - textFrame.size.height;
    if (fabsf(delta) > 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ScrollForCommentContent" object:[NSNumber numberWithFloat:delta]];
        [self.delegate heightChanged:delta];
    }
    
    textFrame.size.height = bubbleFrame.size.height = textView.contentSize.height;
    isMax =  textFrame.size.height > 100;
    bubble.frame = bubbleFrame;
    textView.frame = textFrame;
    NSLog(@"Bubble Frame:%@", NSStringFromCGRect(bubble.frame));
    NSLog(@"Frame:%@", NSStringFromCGRect(_textView.frame));
}
@end
