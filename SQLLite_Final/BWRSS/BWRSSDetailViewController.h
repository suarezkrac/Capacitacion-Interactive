//
//  BWRSSDetailViewController.h
//  BWRSS
//
//  Created by Bill Weinman on 11/14/12.
//  Copyright (c) 2012 Bill Weinman. All rights reserved.
//

#import "BWRSSWebViewController.h"

@interface BWRSSDetailViewController : BWRSSWebViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate>

@property (nonatomic, strong) id detailItem;

@end
