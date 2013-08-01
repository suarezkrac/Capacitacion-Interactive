//
//  BWRSSAddViewController.m
//  BWRSS
//
//  Created by Bill Weinman on 2012-11-09.
//  Copyright (c) 2012 Bill Weinman. All rights reserved.
//

#import "BWRSSAddViewController.h"
#import "BWUtilities.h"

#pragma mark Constants

// min and max size of NSURLConnection pages
static const NSUInteger minPageSize = 64;
static const NSUInteger maxPageSize = 10240;

// RSS MIME-type suffix
static NSString * const kRSSMIMESuffix = @"xml";

// rssRecord keys
static NSString * const kTitleKey = @"title";
static NSString * const kDescriptionKey = @"desc";
static NSString * const kUrlKey = @"url";

// RSS element names
static NSString * const kTitleElementName = @"title";
static NSString * const kDescriptionElementName = @"description";
static NSString * const kItemElementName = @"item";

@interface BWRSSAddViewController () {
    enum {
        BWRSSStateDiscovery = 1,
        BWRSSStateParseHeader
    };
    NSInteger bwrssState;   // used for NSConnection
	NSMutableData * _xmlData;
    NSString * _currentElement;
    NSMutableDictionary * _feedRecord;
    BOOL didFinishParsing;
    BOOL didReturnFeed;
    BOOL haveTitle;
    BOOL haveDescripton;
}

@property (nonatomic, weak) NSURLConnection * feedConnection;

@property (nonatomic, weak) NSString *feedURL;
@property (nonatomic, weak) NSString *feedHost;

@end

@implementation BWRSSAddViewController

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

- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	[self.URLTextField becomeFirstResponder];	// give focus to the text field
}

#pragma mark - Button actions

- (IBAction)cancelAction:(id)sender {
	if (self.feedConnection) {
		[self.feedConnection cancel];
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	}
	[self dismissViewControllerAnimated:YES completion:^{ return; }];
}

- (IBAction)addAction:(id)sender {
	// NSLog(@"%s", __FUNCTION__);
	if (self.feedConnection) [self.feedConnection cancel];
	[self getRSSFeed:trimString(self.URLTextField.text)];
	
	// disable the text field and gray it out (to make it look disabled)
	self.URLTextField.enabled = NO;
	self.URLTextField.textColor = [UIColor grayColor];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

#pragma mark - URLTextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	// treat it like the Add button was pressed
	[self addAction:self];
	return YES;
}

#pragma mark - RSS Feed Management

- (void) getRSSFeed:(NSString *) url {
	// NSLog(@"%s", __FUNCTION__);
	
	if ([url length] < 1) return;  // don't bother with empty string
	if (!([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"])) {
		url = [@"http://" stringByAppendingString:url];
	}
	
	[self fetchURL:url withState:BWRSSStateDiscovery];
}

- (void) fetchURL:(NSString *) url withState:(BOOL) urlState {
	// NSLog(@"%s %@ %d", __FUNCTION__, url, urlState);
	bwrssState = urlState;
	_xmlData = [NSMutableData dataWithCapacity:0];
	[self statusMessage:@"Requesting %@", url];
	NSURLRequest *rssURLRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
	self.feedConnection = [[NSURLConnection alloc] initWithRequest:rssURLRequest delegate:self];
	NSAssert(self.feedConnection != nil, @"Could not create xmlConnection");
}

// findFeedURL
// callback from connectionDidFinishLoading
// find a feed URL in an HTML page
- (void) findFeedURL {
	// NSLog(@"%s, data length: %d", __FUNCTION__, [xmlData length]);
	if ([_xmlData length] < minPageSize) {
		[self errorAlert:@"Page is empty."];
		return;
	}
	
	// web pages can be huge. we havd no use for more than maxPageSize bytes
	NSUInteger len = [_xmlData length];
	if (len > maxPageSize) len = maxPageSize;
	
	NSString * pageString = [[NSString alloc] initWithBytesNoCopy: (void *)[_xmlData bytes]
														   length:len encoding:NSUTF8StringEncoding freeWhenDone:NO];
	NSDictionary * rssLink = [self rssLinkFromHTML:pageString];
	
	[_xmlData setLength:0];
	
	if (rssLink) {
		[self fetchURL:[rssLink objectForKey:@"href"] withState:BWRSSStateParseHeader];
	} else {
		[self errorAlert:@"Did not find a feed."];
	}
}

- (void) haveFeed {
	// NSLog(@"%s", __FUNCTION__);
	// default values
	if (!_feedRecord[kTitleElementName]) _feedRecord[kTitleElementName] = self.feedHost;
	if (!_feedRecord[kDescriptionElementName]) _feedRecord[kDescriptionElementName] = @"";
	
	_feedRecord[kTitleKey] = trimString(flattenHTML(_feedRecord[kTitleElementName]));
	_feedRecord[kDescriptionKey] = trimString(flattenHTML(_feedRecord[kDescriptionElementName]));
	[_feedRecord removeObjectForKey:kDescriptionElementName];	 // not a database column

	[self statusMessage:@"Have feed: %@", _feedRecord[kTitleKey]];
    [self.delegate haveAddViewRecord:_feedRecord];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)parseRSSHeader {
	// NSLog(@"%s", __FUNCTION__);
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:_xmlData];
	[parser setDelegate:self];
	[parser parse];
}

#pragma mark -
#pragma mark RSS discovery methods

- (NSDictionary *) rssLinkFromHTML:(NSString *) htmlString {
	// NSLog(@"%s: htmlString %d bytes", __FUNCTION__, [htmlString length]);
	NSDictionary * rssLink = nil;
	
	// set up the string scanner
	NSScanner * pageScanner = [NSScanner scannerWithString:htmlString];
	[pageScanner setCaseSensitive:NO];
	[pageScanner setCharactersToBeSkipped:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	while ([pageScanner scanUpToString:@"<link " intoString:nil]) {
		NSString * linkString = nil;
		if ([pageScanner scanUpToString:@">" intoString:&linkString]) {
			rssLink = [self getAttributes:linkString];
			NSString * attRel = [rssLink valueForKey:@"rel"];
			NSString * attType = [rssLink valueForKey:@"type"];
			if (attRel && attType &&
				[attRel caseInsensitiveCompare:@"alternate"] == NSOrderedSame &&
				( [attType caseInsensitiveCompare:@"application/rss+xml"] == NSOrderedSame ||
				 [attType caseInsensitiveCompare:@"application/atom+xml"] == NSOrderedSame ) ) {
					break;
				} else {
					rssLink = nil;
				}
			
		}
	}
	if (rssLink && ![rssLink valueForKey:@"href"]) rssLink = nil;
	return rssLink;
}

// (NSDictionary *) getAttributes:(NSString *) htmlTag
// pass in a tag like "<tag foo="bar" baz="boz"> ...
// (ending ">" or "/>" optional, for convenience)
// and get back a dictionary with attributes as keys
- (NSDictionary *) getAttributes:(NSString *) htmlTag {
	// NSLog(@"%s: %@", __FUNCTION__, htmlTag);
	NSMutableDictionary * attribs = [NSMutableDictionary dictionaryWithCapacity:2];
	NSString * attributeString = nil;
	NSString * valueString = nil;
	
	NSScanner * linkScanner = [NSScanner scannerWithString:htmlTag];
	[linkScanner setCaseSensitive:NO];
	[linkScanner setCharactersToBeSkipped:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	[linkScanner scanUpToCharactersFromSet:[NSCharacterSet alphanumericCharacterSet] intoString:nil];
	
	while([linkScanner scanCharactersFromSet:[NSCharacterSet alphanumericCharacterSet] intoString:&attributeString]) {
		if([linkScanner scanString:@"=\"" intoString:nil] && [linkScanner scanUpToString:@"\"" intoString:&valueString]) {
			[attribs setObject:valueString forKey:attributeString];
		}
		[linkScanner scanUpToCharactersFromSet:[NSCharacterSet alphanumericCharacterSet] intoString:nil];
	}
	
	return attribs;
}

#pragma mark - NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // NSLog(@"%s %@", __FUNCTION__, [response MIMEType]);
    [self statusMessage:@"Connected to %@", [response URL]];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    if (bwrssState == BWRSSStateDiscovery && [[response MIMEType] hasSuffix:kRSSMIMESuffix]) {
        // message(@"MIME-type is RSS feed (%@) -- updating bwrssState", [response MIMEType]);
        bwrssState = BWRSSStateParseHeader;
    }
    if (bwrssState == BWRSSStateParseHeader) {
        self.feedURL = [[response URL] absoluteString];
        self.feedHost = [[response URL] host];
    }
    if ([_xmlData length]) [_xmlData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // NSLog(@"%s (length: %d)", __FUNCTION__, [data length]);
    if ( (bwrssState == BWRSSStateDiscovery) && ([_xmlData length] > maxPageSize) ) {
        [connection cancel];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self findFeedURL];
    } else {
        [_xmlData appendData:data];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // NSLog(@"%s", __FUNCTION__);
    self.feedConnection = nil;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	switch (bwrssState) {
		case BWRSSStateDiscovery:
			[self findFeedURL];
			break;
		case BWRSSStateParseHeader:
            [self statusMessage:@"Have RSS feed header (%d bytes)", _xmlData.length];
			[self parseRSSHeader];
			break;
		default:
			NSAssert(0, @"invalid bwrssState");
			break;
	}
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // NSLog(@"%s", __FUNCTION__);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if ([error code] == kCFURLErrorNotConnectedToInternet) {
        // if we can identify the error, we can present a more precise message to the user.
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:NSLocalizedString(
                                                                                      @"No Connection Error",
                                                                                      @"Not connected to the Internet.") forKey:NSLocalizedDescriptionKey];
        NSError *noConnectionError = [NSError errorWithDomain:NSCocoaErrorDomain code:kCFURLErrorNotConnectedToInternet userInfo:userInfo];
        [self handleURLError:noConnectionError];
    } else {
        // otherwise handle the error generically
        [self handleURLError:error];
    }
    self.feedConnection = nil;
}

#pragma mark - NSXMLParser delegate methods

- (void)parserDidStartDocument:(NSXMLParser *)parser {
	// NSLog(@"%s", __FUNCTION__);
	// reset the environment
	[self statusMessage:@"Parsing %@", self.feedURL];
	_feedRecord = [NSMutableDictionary dictionaryWithCapacity:0];
	_feedRecord[kUrlKey] = _feedURL;
	haveTitle = haveDescripton = FALSE;
	didReturnFeed = FALSE;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
	attributes:(NSDictionary *)attributeDict {
	// NSLog(@"%s, %@", __FUNCTION__, elementName);
	if (didFinishParsing) return;
	if ([elementName isEqualToString:kTitleElementName] || [elementName isEqualToString:kDescriptionElementName]) {
		_currentElement = elementName;
		[_feedRecord removeObjectForKey:_currentElement];
	} else if ([elementName isEqualToString:kItemElementName]) {
		didFinishParsing = TRUE;
		// [parser abortParsing];	// not working in iOS 6 beta 4
	} else {
		_currentElement = nil;
	}
	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	// NSLog(@"%s, %@", __FUNCTION__, elementName);
	if (didFinishParsing) return;
	if ([elementName isEqualToString:kTitleElementName]) {
		haveTitle = TRUE;
	} else if ([elementName isEqualToString:kDescriptionElementName]) {
		haveDescripton = TRUE;
	}
	
	if (haveTitle && haveDescripton) {
		didFinishParsing = TRUE;
		// [parser abortParsing];	// not working in iOS 6
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	// NSLog(@"%s", __FUNCTION__);
	if (didFinishParsing) return;
	if ([_currentElement isEqualToString:kTitleElementName] || [_currentElement isEqualToString:kDescriptionElementName]) {
		if (_feedRecord[_currentElement]) {
			_feedRecord[_currentElement] = [(NSString *)_feedRecord[_currentElement] stringByAppendingString:string];
		} else {
			_feedRecord[_currentElement] = string;
		}
	}
}


// abortParsing raises an error, so we usually end here
// warning: may be called more than once (hence, didReturnFeed)
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSLog(@"%s %@", __FUNCTION__, [parseError localizedDescription]);
	if (didFinishParsing && !didReturnFeed) {	// this is not getting called in iOS 6 beta 4
		didReturnFeed = TRUE;
		[self haveFeed];
	}
}

// not norally called -- we will usually end with abortParsing
- (void)parserDidEndDocument:(NSXMLParser *)parser {
	// NSLog(@"%s", __FUNCTION__);
	[self haveFeed];
}

#pragma mark - Error handling

- (void)handleURLError:(NSError *)error {
	// NSLog(@"%s", __FUNCTION__);
	[self.delegate haveAddViewError:error];
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)errorAlert:(NSString *) message {
	// NSLog(@"%s", __FUNCTION__);
	[self.delegate haveAddViewMessage:message];
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Utilities

- (void) statusMessage:(NSString *) format, ... {
	va_list args;
	va_start(args, format);
	
	NSString *outstr = [[NSString alloc] initWithFormat:format arguments:args];
	va_end(args);
	
	self.statusLabel.text = outstr;
	return;
}

- (void) clearStatusMessage {
	self.statusLabel.text = @"";
}


@end
