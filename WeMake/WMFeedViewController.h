//
//  WMFeedViewController.h
//  WeMake
//
//  Created by Michael Scaria on 8/15/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMFeedCell.h"


@interface WMFeedViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *players;
    NSMutableDictionary *indexes;
    BOOL commentScroll;
    
    WMFeedCell *displayedCell;
}
@property (nonatomic, strong) NSArray *videos;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@end
