//
//  WMPostViewController.m
//  WeMake
//
//  Created by Michael Scaria on 8/14/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import "WMPostViewController.h"

@interface WMPostViewController ()

@end

@implementation WMPostViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	_textView.text = @"insert your caption here...";
    _textView.textColor = [UIColor lightGrayColor];
    [_doneButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *newString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (newString.length == 0) {
        textView.text = @"insert your caption here...";
        textView.textColor = [UIColor lightGrayColor];
        _doneButton.enabled = NO;
        return NO;
    }
    else textView.textColor = [UIColor blackColor];
    _doneButton.enabled = YES;
    return YES;
}

- (IBAction)cancel:(id)sender {
    [self.delegate cancel];
}

- (IBAction)done:(id)sender {
    [self.delegate postVideoWithCaption:_textView.text];
}
@end
