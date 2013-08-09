//
//  WMRequestViewController.m
//  WeMake
//
//  Created by Michael Scaria on 7/30/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import "WMRequestViewController.h"

@interface WMRequestViewController ()

@end

@implementation WMRequestViewController
@synthesize tableView, delegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    _inviteButton.enabled = NO;
}
- (void)setFollowers:(NSMutableArray *)followers {
    if (followers != _followers) {
        _followers = followers;
        [self.tableView reloadData];
    }
}

- (IBAction)invite:(id)sender {
    NSString *string = [selectedFollowers componentsJoinedByString:@","];
    [self.delegate sendToFollowers:string];
}

- (IBAction)cancel:(id)sender {
    [self.delegate cancel];
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%d", _followers.count);
    return _followers.count;
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"Follower"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Follower"];
    }
    NSDictionary *dictionary = _followers[indexPath.row];
    UILabel *name = (UILabel *)[cell viewWithTag:1];
    name.text = dictionary[@"name"];
    cell.accessoryType = ([dictionary[@"selected"] boolValue] == YES) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    return cell;
}

#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    BOOL adding = (cell.accessoryType == UITableViewCellAccessoryNone);
    NSMutableDictionary *dictionary = [_followers[indexPath.row] mutableCopy];
    [_followers removeObjectAtIndex:indexPath.row];
    [dictionary setObject:[NSNumber numberWithBool:adding] forKey:@"selected"];
    cell.accessoryType = (adding) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    [_followers insertObject:dictionary atIndex:indexPath.row];
    
    if (adding) {
        if (!selectedFollowers)  selectedFollowers = [[NSMutableArray alloc] init];
        [selectedFollowers addObject:dictionary[@"id"]];
    }
    else
        [selectedFollowers removeObject:dictionary[@"id"]];
    _inviteButton.enabled = selectedFollowers.count > 0;
}


@end
