//
//  WMPostViewController.h
//  WeMake
//
//  Created by Michael Scaria on 8/14/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WMPostViewControllerDelegate <NSObject>
- (void)postVideoWithCaption:(NSString  *)caption;
- (void)cancel;
@end

@interface WMPostViewController : UIViewController <UITextViewDelegate>

@property (strong, nonatomic) id <WMPostViewControllerDelegate>delegate;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;
@end
