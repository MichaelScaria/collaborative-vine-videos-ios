//
//  WMCreatorView.m
//  WeMake
//
//  Created by Michael Scaria on 8/19/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//
#import "WMCreatorView.h"

#import "Constants.h"
#import "UIImageView+AFNetworking.h"

@implementation WMCreatorView

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    [self setBackgroundColor:[UIColor clearColor]];
    /*int lineWidth = 3;
    int radius = self.frame.size.width/2;
    CAShapeLayer *circleUnder = [CAShapeLayer layer];
    // Make a circular shape
    circleUnder.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(-lineWidth/2, -lineWidth/2, 2.0*(radius + lineWidth/2), 2.0*(radius + lineWidth/2)) cornerRadius:(radius + lineWidth/2)].CGPath;
    // Center the shape in self.view
    //circleUnder.position = CGPointMake(CGRectGetMidX(self.frame)-(radius + 3), CGRectGetMidY(self.frame)-(radius + 3));
    
    // Configure the apperence of the circle
    circleUnder.fillColor = [UIColor blackColor].CGColor;
    circleUnder.strokeColor = [UIColor clearColor].CGColor;
    circleUnder.lineWidth = 0;
    
    // Add to parent layer
    [self.layer addSublayer:circleUnder];
    CAShapeLayer *circle = [CAShapeLayer layer];
    // Make a circular shape
    circle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0*radius, 2.0*radius)
                                             cornerRadius:radius].CGPath;
    // Center the shape in self.view
   // circle.position = CGPointMake(CGRectGetMidX(self.frame)-radius, CGRectGetMidY(self.frame)-radius);
    
    // Configure the apperence of the circle
    circle.fillColor = [UIColor clearColor].CGColor;
    circle.strokeColor = kColorLight.CGColor;
    circle.lineWidth = lineWidth;
    
    // Add to parent layer 
    [self.layer addSublayer:circle];
    
    // Configure animation
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    drawAnimation.duration            =3.0; // "animate over 10 seconds or so.."
    drawAnimation.repeatCount         = 10.0;  // Animate only once..
    drawAnimation.removedOnCompletion = NO;   // Remain stroked after the animation..
    
    // Animate from no part of the stroke being drawn to the entire stroke being drawn
    drawAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    drawAnimation.toValue   = [NSNumber numberWithFloat:1.0f];
    
    // Experiment with timing to get the appearence to look the way you want
    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    // Add the animation to the circle
    [circle addAnimation:drawAnimation forKey:@"drawCircleAnimation"];*/
    
    creatorView = [[UIImageView alloc] initWithFrame:self.bounds];
    creatorView.layer.cornerRadius = creatorView.frame.size.width/2;
    creatorView.layer.masksToBounds = YES;
    [self addSubview:creatorView];

    self.layer.shadowOffset = CGSizeMake(0, 1);
    self.layer.shadowRadius = 1.0;
    self.layer.shadowOpacity = 1.0;
//    int radius = self.frame.size.width/2;
//    self.center = CGPointMake(radius, self.center.y);
}

- (void)setCreatorUrl:(NSString *)creatorUrl {
    if (creatorUrl && ![creatorUrl isEqualToString:_creatorUrl]) {
        NSLog(@"New:%@", creatorUrl);
        _creatorUrl = creatorUrl;
        CGPoint oldCenter = self.center;
        [creatorView setImageWithURL:[NSURL URLWithString:_creatorUrl] placeholderImage:[UIImage imageNamed:@"missingPhoto.png"]];
        [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.center = CGPointMake(self.frame.size.width/2 + 5, self.center.y);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:.2 delay:1.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.center = oldCenter;
            }completion:nil];
        }];
    }
}

/*- (void)dragged:(UIPanGestureRecognizer *)recognizer {
    CGPoint newPoint = [recognizer locationInView:self];
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Received a pan gesture");
        initialPoint = newPoint;
        
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded) {
        float radius = self.frame.size.width/2;
        float roundedCenter = self.center.x + 160;
        float finalX;
        float offset = 5;
        if (roundedCenter > 320) {
            //closer to the right side
            finalX = 320 - radius;
        }
        else {
            offset *= -1;
            finalX = radius;
        }
        [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.center = CGPointMake(finalX + offset, self.center.y);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.center = CGPointMake(finalX, self.center.y);
            }completion:nil];
        }];
    }
    else {
        float radius = self.frame.size.width/2;
        float finalX, finalY;
        
        float deltaX = newPoint.x-initialPoint.x;
        float deltaY = newPoint.y-initialPoint.y;
        //pin the x value
        if (self.center.x + deltaX - radius < 0) {
            finalX = 0 + radius;
        }
        else if (self.center.x + deltaX + radius > 320) {
            finalX = 320 - radius;
        }
        else {
            finalX = self.center.x + deltaX;
        }
        //pin the y value
        if (self.center.y + deltaY - radius < 0) {
            finalY = 0 + radius;
        }
        else if (self.center.y + deltaY + radius > 320) {
            finalY = 320 - radius;
        }
        else {
            finalY = self.center.y + deltaY;
        }
        
        self.center = CGPointMake(finalX, finalY);
        //initialPoint = newPoint;
    }
}
*/
@end
