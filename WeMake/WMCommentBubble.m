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
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(2, -4, 290, 23)];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.hidden = YES;
    _textView.delegate = self;
    //[self addSubview:_textView];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(2, -4, 290, 23)];
    _textField.borderStyle = UITextBorderStyleNone;
    _textField.hidden = YES;
    _textField.delegate = self;

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
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeTextView) name:@"RemoveCommentView" object:nil];
        dots.hidden = YES;
        [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.frame = CGRectMake(8, self.frame.origin.y, 300, 25);
            bubble.frame = CGRectMake(5, 0, 295, 25);
        }completion:^(BOOL isCompleted){
            //_textView.hidden = NO;
            //[_textView becomeFirstResponder];
            _textView.text = @"Lorem ipsum dolor sit er";
        }];
    }
    else {
        //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"RemoveCommentView" object:nil];
        [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.frame = originalFrame;
            bubble.frame = CGRectMake(0, 0, 25, 25);
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
    NSLog(@"C:%@", NSStringFromClass([self.superview.superview class]));
    originalYOffset = self.superview.superview.frame.origin.y;
    return YES;
}

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
    CGRect textFrame = textView.frame;
    CGRect bubbleFrame = bubble.frame;
    float delta = textView.contentSize.height - bubbleFrame.size.height;
    textFrame.origin.y -= delta;
    textFrame.size.height += delta;
    bubbleFrame.origin.y -= delta;
    bubbleFrame.size.height += delta;
    isMax =  textFrame.origin.y > 99;
    bubble.frame = bubbleFrame;
    textView.frame = textFrame;
    NSLog(@"Bubble Frame:%@", NSStringFromCGRect(bubble.frame));
    NSLog(@"Frame:%@", NSStringFromCGRect(_textView.frame));
}
@end
