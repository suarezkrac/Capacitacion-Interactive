//
//  FeedsTableViewController.h
//  SQLLiteRSS
//
//  Created by Equipo Desarrollo 2 on 31/07/13.
//  Copyright (c) 2013 Cymetria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSSDB.h"
#import "AddViewViewController.h"

@class DetailViewController;

@interface FeedsTableViewController : UITableViewController 

@property (strong, nonatomic) DetailViewController * detailViewController;

@end
