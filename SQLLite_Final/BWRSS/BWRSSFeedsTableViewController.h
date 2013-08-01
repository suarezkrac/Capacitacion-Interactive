//
//  BWRSSMasterViewController.h
//  BWRSS
//
//  Created by Bill Weinman on 2012-10-21.
//  Copyright (c) 2012 Bill Weinman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSSDB.h"
#import "BWRSSAddViewController.h"

@class BWRSSDetailViewController;

@interface BWRSSFeedsTableViewController : UITableViewController <RSSAddViewControllerDelegate>

@property (strong, nonatomic) BWRSSDetailViewController *detailViewController;

@end
