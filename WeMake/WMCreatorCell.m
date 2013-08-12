//
//  WMCreatorCell.m
//  WeMake
//
//  Created by Michael Scaria on 8/11/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import "WMCreatorCell.h"

#define kCellThreshold 275

@implementation WMCreatorCell

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    UIPanGestureRecognizer *rightGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragging:)];
    [self addGestureRecognizer:rightGesture];
    
}
- (void)didMoveToSuperview {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:.25 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
            self.contentView.center = CGPointMake(self.contentView.center.x + 40, self.contentView.center.y);
        }completion:^(BOOL isCompleted){
            [UIView animateWithDuration:.25 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
                self.contentView.center = CGPointMake(self.contentView.center.x - 40, self.contentView.center.y);
            }completion:nil];
        }];
    });
}


-(void)dragging:(UIPanGestureRecognizer *)recognizer
{
    CGPoint newPoint = [recognizer locationInView:self];
    
    if(recognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Received a pan gesture");
        initialPoint = newPoint;
        
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded) {
        if ([(UITableViewCell *)recognizer.view contentView].frame.origin.x < 200) {
            [UIView animateWithDuration:.25 animations:^{
                [(UITableViewCell *)recognizer.view contentView].frame = CGRectMake(0, 0, 320, 45);
            }completion:nil];
        }
    }
    else {
        
        float delta = newPoint.x-initialPoint.x;
        CGRect originalFrame = [(UITableViewCell *)recognizer.view contentView].frame;
        if ([(UITableViewCell *)recognizer.view contentView].frame.origin.x < 200 || delta < 0) {
            [(UITableViewCell *)recognizer.view contentView].frame =CGRectMake(MIN(200, originalFrame.origin.x+delta), originalFrame.origin.y, originalFrame.size.width, originalFrame.size.height);
            initialPoint = newPoint;
        }
        else {
            [(UITableViewCell *)recognizer.view contentView].frame =CGRectMake(originalFrame.origin.x+delta, originalFrame.origin.y, originalFrame.size.width, originalFrame.size.height);
            [UIView animateWithDuration:.15 delay:.05 options:UIViewAnimationCurveEaseOut animations:^{
                [(UITableViewCell *)recognizer.view contentView].frame = CGRectMake(200, 0, 320, 45);
            }completion:nil];
        }
    }
}
@end
