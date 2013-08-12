//
//  WMCreatorsViewController.h
//  WeMake
//
//  Created by Michael Scaria on 8/11/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMCreatorsViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *creators;
- (id)initWithCreators:(NSArray *)creators;
@end
