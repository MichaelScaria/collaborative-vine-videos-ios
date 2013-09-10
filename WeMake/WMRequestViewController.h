//
//  WMRequestViewController.h
//  WeMake
//
//  Created by Michael Scaria on 7/30/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WMRequestViewControllerDelegate <NSObject>
- (void)sendToFollowers:(NSString *)followers;
- (void)cancelInvites;
@end

@interface WMRequestViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *selectedFollowers;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *followers;
@property (strong, nonatomic) IBOutlet UIButton *inviteButton;
@property (strong, nonatomic) id <WMRequestViewControllerDelegate>delegate;
- (IBAction)invite:(id)sender;
- (IBAction)cancel:(id)sender;
@end
