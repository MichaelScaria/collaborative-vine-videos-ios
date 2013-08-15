//
//  WMCreatorsViewController.m
//  WeMake
//
//  Created by Michael Scaria on 8/11/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import "WMCreatorsViewController.h"
#import "WMCreatorCell.h"
#import "WMCreator.h"

#import "UIImageView+AFNetworking.h"
#import "Constants.h"
@interface WMCreatorsViewController ()

@end

@implementation WMCreatorsViewController

- (id)initWithCreators:(NSArray *)creators
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        _creators = creators;
    }
    return self;
}

- (void)setCreators:(NSArray *)creators {
    if (creators != _creators) {
        _creators = creators;
        //_creators = @[creators[0], creators[1], creators[0]];
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _creators.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Creator";
    WMCreatorCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[WMCreatorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    WMCreator *creator = _creators[indexPath.row];
    [cell.photoView setImageWithURL:[NSURL URLWithString:creator.photoURL] placeholderImage:[UIImage imageNamed:@"missingPhoto.png"]];
    cell.photoView.layer.cornerRadius = cell.photoView.frame.size.width/2;
    cell.photoView.layer.masksToBounds = YES;
    cell.name.text = creator.username;
    NSLog(@"Start:%f", creator.startTime/kTotalVideoTime * 320);
    NSLog(@"Length:%f", creator.length/kTotalVideoTime * 320);
    UIView *completionView = [[UIView alloc] initWithFrame:CGRectMake(creator.startTime/kTotalVideoTime * 320, 0, creator.length/kTotalVideoTime * 320, 45)];
    completionView.backgroundColor = kColorDark;
    [cell insertSubview:completionView atIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
