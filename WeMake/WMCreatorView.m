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
    int lineWidth = 3;
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
    [circle addAnimation:drawAnimation forKey:@"drawCircleAnimation"];
    creatorView = [[UIImageView alloc] initWithFrame:self.bounds];
    creatorView.layer.cornerRadius = creatorView.frame.size.width/2;
    creatorView.layer.masksToBounds = YES;
    [self addSubview:creatorView];
}

- (void)setCreatorUrl:(NSString *)creatorUrl {
    if (creatorUrl && ![creatorUrl isEqualToString:_creatorUrl]) {
        NSLog(@"%@", _creatorUrl);
        _creatorUrl = creatorUrl;
        [creatorView setImageWithURL:[NSURL URLWithString:_creatorUrl] placeholderImage:[UIImage imageNamed:@"missingPhoto.png"]];
    }
}

@end