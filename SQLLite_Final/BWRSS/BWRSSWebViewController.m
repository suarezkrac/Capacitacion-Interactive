//
//  BWRSSWebViewController.m
//  BWRSS
//
//  Created by Bill Weinman on 2012-11-13.
//  Copyright (c) 2012 Bill Weinman. All rights reserved.
//

#import "BWRSSWebViewController.h"

@interface BWRSSWebViewController ()

@end

@implementation BWRSSWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionButton:(id)sender {
    [UIApplication.sharedApplication openURL:self.webView.request.URL];
}

#pragma mark - UIViewController delegate methods

- (void)viewDidLoad {
	// NSLog(@"%s feedItem: %@", __FUNCTION__, feedItem);
	[super viewDidLoad];
	self.title = self.feedItem[@"title"];
	self.webView.scalesPageToFit = YES;
	self.webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	[self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.feedItem[@"url"]]]];
}

- (void)viewDidUnload {
	self.webView = nil;
	self.backButton = nil;
	self.forwardButton = nil;
	[super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
	self.webView.delegate = self;	// setup the delegate as the web view is shown
}

- (void)viewWillDisappear:(BOOL)animated {
	[self.webView stopLoading]; // in case the web view is still loading its content
	self.webView.delegate = nil;	// disconnect the delegate as the webview is hidden
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO; // turn off the twirly
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// we support rotation in this view controller
	return YES;
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
	// starting the load, show the activity indicator (twirly) in the status bar
	UIApplication.sharedApplication.networkActivityIndicatorVisible = YES;
	self.backButton.enabled = self.webView.canGoBack;
	self.forwardButton.enabled = self.webView.canGoForward;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	// finished loading, hide the activity indicator in the status bar
	UIApplication.sharedApplication.networkActivityIndicatorVisible = NO;
	self.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	// load error, hide the activity indicator in the status bar
	UIApplication.sharedApplication.networkActivityIndicatorVisible = NO;
	
	// report the error inside the webview
	// NSLog(@"webView didFailLoadWithError: %@, %d", [self.webView.request URL], [error code]);
	if (error.code != -999) {
		NSString* errorString =
		[NSString stringWithFormat:
		 @"<html><style>\n"
		 @"body {background-color: #ccc; margin-top: 50px;}\n"
		 @".e1 { font-family: verdana, sans-serif; color:#f66; font-size: 32px; font-weight:bold; text-align: center; }\n"
		 @".e2 { font-family: verdana; color:#066; font-size: 32px; font-weight:bold; text-align: center; }\n"
		 @".u1 { font-family: monospace; color:#000; font-size: 24px; text-align: center; }\n"
		 @"</style>\n"
		 @"<p class='e1'>Error fetching web page:</p>\n"
		 @"<p class='u1'>%@</p>\n"
		 @"<p class='e2'>%@</p>\n"
		 @"</html>",
		 self.webView.request.URL.absoluteString,
		 error.localizedDescription];
		[self.webView loadHTMLString:errorString baseURL:nil];
	}
}

@end
