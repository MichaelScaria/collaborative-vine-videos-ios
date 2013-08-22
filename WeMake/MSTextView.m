//
//  MSTextView.m
//  WeMake
//
//  Created by Michael Scaria on 8/21/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import "MSTextView.h"

#import "Constants.h"

@implementation MSTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.editable = NO;
        self.backgroundColor = [UIColor clearColor];
        self.scrollEnabled = NO;
    }
    return self;
}

- (void)setText:(NSString *)text withLinkedRange:(NSRange)range {
    //self.text = text;
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSForegroundColorAttributeName : kColorGray}];
    [attrString setAttributes:@{@"type": @"username", NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:13], NSForegroundColorAttributeName : kColorLight} range:range];
    self.attributedText = attrString;
    NSLog(@"self.h:%f", self.frame.size.height);
    [self sizeToFit];
    //self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.contentSize.height);
    NSLog(@"Nself.h:%f", self.frame.size.height);
}

@end
