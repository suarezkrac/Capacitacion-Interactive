//
//  BWRSSAddViewController.h
//  BWRSS
//
//  Created by Bill Weinman on 2012-11-09.
//  Copyright (c) 2012 Bill Weinman. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RSSAddViewControllerDelegate
-(void) haveAddViewRecord:(NSDictionary *) avRecord;
-(void) haveAddViewError:(NSError *) error;
-(void) haveAddViewMessage:(NSString *) message;
@end

@interface BWRSSAddViewController : UIViewController <NSURLConnectionDelegate, NSXMLParserDelegate>

@property (nonatomic, weak) id<RSSAddViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *URLTextField;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

- (IBAction)cancelAction:(id)sender;
- (IBAction)addAction:(id)sender;

@end
