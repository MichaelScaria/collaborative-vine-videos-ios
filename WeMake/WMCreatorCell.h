//
//  WMCreatorCell.h
//  WeMake
//
//  Created by Michael Scaria on 8/11/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMCreatorCell : UITableViewCell {
    CGPoint initialPoint;
}

@property (strong, nonatomic) IBOutlet UIImageView *photoView;
@property (strong, nonatomic) IBOutlet UILabel *name;
@end
