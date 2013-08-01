//
//  WMNotificationViewController.h
//  WeMake
//
//  Created by Michael Scaria on 7/31/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface WMNotificationViewController : UIViewController {
    NSMutableDictionary *selectedIndexes;
    MPMoviePlayerController *player;
}
@property (nonatomic, strong) NSArray *notifications;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end
