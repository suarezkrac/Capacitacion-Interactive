//
//  BWRSSItemsTableViewController.h
//  BWRSS
//
//  Created by Bill Weinman on 2012-11-07.
//  Copyright (c) 2012 Bill Weinman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSSDB.h"

@interface BWRSSItemsTableViewController : UITableViewController <NSXMLParserDelegate>

@property (nonatomic, strong) RSSDB * rssDB;
@property (nonatomic, strong) NSNumber * currentFeedID;

@end
