//
//  BWRSSDetailViewController.m
//  BWRSS
//
//  Created by Bill Weinman on 11/14/12.
//  Copyright (c) 2012 Bill Weinman. All rights reserved.
//

#import "BWRSSDetailViewController.h"

@interface BWRSSDetailViewController () {
	UIPopoverController *_popoverController;
	UIBarButtonItem *_popoverButtonItem;
}

@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UILabel *webTitle;

@end

@implementation BWRSSDetailViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	// NSLog(@"%s", __FUNCTION__);
	[self setPopoverButton];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - set up the view when called

- (void)configureView {
	// webViewController uses feedItem
	self.feedItem = self.detailItem;
	[self.webView loadRequest:
	 [NSURLRequest requestWithURL:[NSURL URLWithString:self.feedItem[@"url"]]]];
}

// setter for detailItem property
- (void)setDetailItem:(id)newDetailItem {
	if (_detailItem != newDetailItem) {
		_detailItem = newDetailItem;
		
		// Update the view.
		[self configureView];
	}
	
	// dismiss the popover
	if (_popoverController != nil) {
		[_popoverController dismissPopoverAnimated:YES];
	}
}

#pragma mark - Split view support

// called when the root (left) view is hidden
- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController
		  withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
	// NSLog(@"%s", __FUNCTION__);
	
	_popoverController = pc;
	_popoverButtonItem = barButtonItem;
	
	// the toolbar may not be setup the first time we get this message
	if (self.toolbar.items.count) {
		[self setPopoverButton];
	}
}

// Called when the root (left) view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
	// NSLog(@"%s", __FUNCTION__);
	[self clearPopoverButton];
}

- (void) setPopoverButton {
	// NSLog(@"%s", __FUNCTION__);
	if (!_popoverButtonItem || !_popoverController) return;
	_popoverButtonItem.title = @"Feeds";
	NSMutableArray *items = [[self.toolbar items] mutableCopy];
	[items insertObject:_popoverButtonItem atIndex:0];
	[self.toolbar setItems:items animated:YES];
}

- (void) clearPopoverButton {
	// NSLog(@"%s", __FUNCTION__);
	if (!_popoverButtonItem || !_popoverController) return;
	NSMutableArray *items = [[self.toolbar items] mutableCopy];
	// if the "Feeds" button is on the button bar, remove it
	if (((UIBarButtonItem *)items[0]).title == @"Feeds") {
		[items removeObjectAtIndex:0];
	}
	[self.toolbar setItems:items animated:YES];
	_popoverController = nil;
}

#pragma mark - Rotation support

// Allow rotation to any orientation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}


#pragma mark - View lifecycle

- (void)viewDidUnload {
	_popoverController = nil;
}


#pragma mark - UIWebViewDelegate methods

// don't try to load an empty page
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType {
	if ([request URL]) {
		return YES;
	} else {
		return NO;
	}
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	// finished loading, hide the activity indicator in the status bar
	self.webTitle.text = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
	[super webViewDidFinishLoad:webView];
}

@end
