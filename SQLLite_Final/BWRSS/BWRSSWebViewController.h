//
//  BWRSSWebViewController.h
//  BWRSS
//
//  Created by Bill Weinman on 2012-11-13.
//  Copyright (c) 2012 Bill Weinman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BWRSSWebViewController : UIViewController <UIWebViewDelegate>

- (IBAction)actionButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardButton;

@property (nonatomic, strong) NSDictionary *feedItem;

@end
