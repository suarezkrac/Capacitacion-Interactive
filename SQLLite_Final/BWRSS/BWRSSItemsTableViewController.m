//
//  BWRSSItemsTableViewController.m
//  BWRSS
//
//  Created by Bill Weinman on 2012-11-07.
//  Copyright (c) 2012 Bill Weinman. All rights reserved.
//

#import "BWRSSItemsTableViewController.h"
#import "BWRSSWebViewController.h"
#import "BWRSSDetailViewController.h"
#import "BWUtilities.h"

// class extension for private members
@interface BWRSSItemsTableViewController () {
    NSUInteger parsedItemsCounter;
    BOOL haveSplitViewController;
    BOOL accumulatingParsedCharacterData;
    BOOL didAbortParsing;
	BOOL canRefresh;
}

// data properties
@property (nonatomic, strong) NSDictionary *feedRecord;
@property (nonatomic, strong) NSDictionary *itemRecord;
@property (nonatomic, strong) NSArray *itemRowIDs;

// parser properties
@property (nonatomic, strong) NSURLConnection *rssConnection;
@property (nonatomic, strong) NSMutableData *rssData;
@property (nonatomic, strong) NSMutableArray *currentParseBatch;
@property (nonatomic, strong) NSMutableString *currentParsedCharacterData;
@property (nonatomic, strong) NSMutableDictionary *currentItemObject;
@property (nonatomic, strong) NSMutableDictionary *currentFeedObject;

@end


@implementation BWRSSItemsTableViewController

#pragma mark Constants

// Dictionary keys
static NSString * const kItemFeedIDKey = @"feedID";
static NSString * const kItemUrlKey = @"url";
static NSString * const kItemTitleKey = @"title";
static NSString * const kItemDescKey = @"desc";
static NSString * const kItemPubDateKey = @"pubdateSQLString";
static NSString * const kDBItemFeedIDKey = @"feed_id";
static NSString * const kDBItemUrlKey = @"url";
static NSString * const kDBItemTitleKey = @"title";
static NSString * const kDBItemDescKey = @"desc";
static NSString * const kDBItemPubDateKey = @"pubdate";
static NSString * const kDBFeedTitleKey = @"title";
static NSString * const kDBFeedDescKey = @"desc";

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	[self loadRSSFeed];
	
	// setup refreshControl for iOS 6
	if([self respondsToSelector:@selector(refreshControl)]) {
		self.refreshControl = [[UIRefreshControl alloc] init];
		[self.refreshControl addTarget:self action:@selector(refreshInvoked:forState:) forControlEvents:UIControlEventValueChanged];
		canRefresh = YES;
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	if ([self splitViewController]) haveSplitViewController = YES;
    [self.rssDB deleteOldItems:self.currentFeedID];     // clean up old feed items
	self.feedRecord = [self.rssDB getFeedRow:self.currentFeedID];
    self.title = self.feedRecord[@"title"];
    self.tableView.rowHeight = 55.0;
}

#pragma mark - Segue delegate

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"SegueToWebView"]) {
		BWRSSWebViewController * webViewController = [segue destinationViewController];
		
		// setup some context
		NSIndexPath * path = [self.tableView indexPathForSelectedRow];
		self.itemRecord = [self.rssDB getItemRow:(self.itemRowIDs)[path.row]];
		webViewController.feedItem = self.itemRecord;
	}
}

#pragma mark - Support for reload getstures

// iOS 6 adds UIRefreshControl (see viewDidLoad: above)
-(void) refreshInvoked:(id)sender forState:(UIControlState)state {
	[self loadRSSFeed];
	[self.refreshControl endRefreshing];
}

-(BOOL)canBecomeFirstResponder
{
	return !canRefresh;
}

-(void)viewDidAppear:(BOOL)animated {
	[self becomeFirstResponder];
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[self resignFirstResponder];
	[super viewWillDisappear:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	self.itemRowIDs = [self.rssDB getItemIDs:self.currentFeedID];
	return [self.itemRowIDs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ItemCell";
    
    // set up the cell with the subtitle style
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Get the feed item
    NSNumber *itemID = self.itemRowIDs[indexPath.row];
    NSDictionary * thisFeedItem = [self.rssDB getItemRow:itemID];
	
    // Clever variable font size trick
    CGFloat systemFontSize = [UIFont labelFontSize];
    CGFloat headFontSize = systemFontSize * .9;
    CGFloat smallFontSize = systemFontSize * .8;
    CGFloat widthOfCell = [tableView rectForRowAtIndexPath:indexPath].size.width - 40.0;
	
    NSString * itemText = thisFeedItem[kDBItemTitleKey];
    if (itemText) {
        [cell.textLabel setNumberOfLines:2];
        if ([itemText sizeWithFont:[UIFont boldSystemFontOfSize:headFontSize]].width > widthOfCell)
            [cell.textLabel setFont:[UIFont boldSystemFontOfSize:smallFontSize]];
        else
            [cell.textLabel setFont:[UIFont boldSystemFontOfSize:headFontSize]];
        
        [cell.textLabel setText:itemText];
    }
	
    // Format the date -- this goes in the detailTextLabel property, which is the "subtitle" of the cell
    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:smallFontSize]];
    [cell.detailTextLabel setText:
     [self dateToLocalizedString:[self SQLDateToDate:thisFeedItem[kDBItemPubDateKey]]]
     ];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// NSLog(@"%s", __FUNCTION__);
	
	// display the web page in the detailViewController
	if (haveSplitViewController) {
		// get the record
		self.itemRecord = [_rssDB getItemRow:[self.itemRowIDs objectAtIndex:indexPath.row]];
		// find the webViewController
		UINavigationController * detailController = self.splitViewController.viewControllers[1];
		BWRSSDetailViewController * webViewController = detailController.viewControllers[0];
		webViewController.detailItem = self.itemRecord;
	}
}

#pragma mark - Parser constants

// Limit the number of parsed items to 50.
static NSUInteger const kMaximumNumberOfItemsToParse = 50;

// Number of items in a parse batch
static NSUInteger const kSizeOfItemsBatch = 10;

// Reduce potential parsing errors by using string constants declared in a single place.
static NSString * const kChannelElementName = @"channel";
static NSString * const kItemElementName = @"item";
static NSString * const kDescriptionElementName = @"description";
static NSString * const kLinkElementName = @"link";
static NSString * const kTitleElementName = @"title";
static NSString * const kUpdatedElementName = @"pubDate";
static NSString * const kPubDateElementName = @"PubDate";
static NSString * const kDCDateElementName = @"dc:date";

#pragma mark -	Support methods

-(void) loadRSSFeed {
	self.feedRecord = [self.rssDB getFeedRow:self.currentFeedID];
	NSURLRequest *rssURLRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.feedRecord[@"url"]]];
	self.rssConnection = [[NSURLConnection alloc] initWithRequest:rssURLRequest delegate:self];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	NSAssert(self.rssConnection != nil, @"Could not create URL connection.");
}

// --> This method runs in the secondary thread <--
// This calls the parser
- (void)parseRSSData:(NSData *)data {
	// We must create an autorelease pool for the secondar thread.
	// This is the new syntax for use with ARC
	@autoreleasepool {
		self.currentParseBatch = [NSMutableArray array];
		self.currentParsedCharacterData = [NSMutableString string];
		parsedItemsCounter = 0;
		
		NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
		[parser setDelegate:self];
		[parser parse];
		
		// depending on the total number of items parsed, the last batch might not have been a "full" batch, and thus
		// not been part of the regular batch transfer. So, we check the count of the array and, if necessary, send it to the main thread.
		if ([self.currentParseBatch count] > 0) {
			[self performSelectorOnMainThread:@selector(addItemsToList:) withObject:self.currentParseBatch waitUntilDone:NO];
		}
		self.currentParseBatch = nil;
		self.currentItemObject = nil;
		self.currentFeedObject = nil;
		self.currentParsedCharacterData = nil;
	}
}

// addToItemsList:
// --> This method runs in the main thread <--
// This is called from the parser thread with batches of parsed objects.
- (void)addItemsToList:(NSArray *)items {
	// uses new @{} dictionary literals syntax
	for ( NSDictionary * item in items ) { // add rows to the item table
		[self.rssDB addItemRow:@{
			 kDBItemFeedIDKey : item[kItemFeedIDKey],
                kDBItemUrlKey : item[kItemUrlKey],
              kDBItemTitleKey : trimString(flattenHTML(item[kItemTitleKey])),
               kDBItemDescKey : trimString(flattenHTML(item[kItemDescKey])),
            kDBItemPubDateKey : item[kItemPubDateKey],
		 }];
	}
	self.itemRowIDs = [self.rssDB getItemIDs:self.currentFeedID];
	[self.tableView reloadData];
}

#pragma mark - NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	// NSLog(@"%s %@", __FUNCTION__, [response MIMEType]);
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	if (!self.rssData) self.rssData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	// NSLog(@"%s (length: %d)", __FUNCTION__, [data length]);
	[self.rssData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	// NSLog(@"%s", __FUNCTION__);
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	self.rssConnection = nil;
	
	// Spawn a thread to parse the RSS feed so that the UI is not blocked while parsing.
	// IMPORTANT! - Don't access UIKit objects on secondary threads.
	[NSThread detachNewThreadSelector:@selector(parseRSSData:) toTarget:self withObject:self.rssData];
    
	// rssData will be retained by the thread until parseRSSData: has finished executing, so we no longer need
	// a reference to it in the main thread.
	self.rssData = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	// NSLog(@"%s %@", __FUNCTION__, error);
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	if ([error code] == kCFURLErrorNotConnectedToInternet) {
		// if we can identify the error, we can present a more precise message to the user.
		NSDictionary *userInfo =
		@{NSLocalizedDescriptionKey: NSLocalizedString(@"No Connection Error", @"Not connected to the Internet.")};
		NSError *noConnectionError = [NSError errorWithDomain:NSCocoaErrorDomain code:kCFURLErrorNotConnectedToInternet userInfo:userInfo];
		[self handleError:noConnectionError];
	} else {
		// otherwise handle the error generically
		[self handleError:error];
	}
	self.rssConnection = nil;
}

#pragma mark - Error handling

- (void)handleError:(NSError *)error {
	// NSLog(@"%s", __FUNCTION__);
	// NSLog(@"error is %@, %@", error, [error domain]);
	NSString *errorMessage = [error localizedDescription];
	
	// errors in NSXMLParserErrorDomain >= 10 are harmless parsing errors
	if ([error domain] == NSXMLParserErrorDomain && [error code] >= 10) {
		alertMessage(@"Cannot parse feed: %@", errorMessage);  // tell the user why parsing is stopped
	} else {
		UIAlertView *alertView = [[UIAlertView alloc]
								  initWithTitle:@"Error" message:errorMessage delegate:nil
								  cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alertView show];
		[self dismissViewControllerAnimated:YES completion:nil];
	}
}

- (void)errorAlert:(NSString *) message {
	// NSLog(@"%s", __FUNCTION__);
	UIAlertView *alertView = [[UIAlertView alloc]
							  initWithTitle:@"RSS Error" message:message delegate:nil
							  cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - NSXMLParser delegate methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	// NSLog(@"%s %@", __FUNCTION__, elementName);
	
	NSArray * containerElements =
	@[kLinkElementName, kTitleElementName, kDescriptionElementName,
    kUpdatedElementName, kPubDateElementName, kDCDateElementName];
	
	// If the number of parsed items is greater than kMaximumNumberOfItemsToParse, abort the parse.
	if (parsedItemsCounter >= kMaximumNumberOfItemsToParse) {
		// Use didAbortParsing flag to distinguish between this and real parser errors.
		didAbortParsing = YES;
		[parser abortParsing];
	}
	if ([elementName isEqualToString:kChannelElementName]) {
		NSMutableDictionary *channel = [[NSMutableDictionary alloc] init];
		self.currentFeedObject = channel;
		self.currentItemObject = channel;	// shortcut so parser can treat it the same
	}
	if ([elementName isEqualToString:kItemElementName]) {
		if (self.currentFeedObject) {		// first item element, update the feed table
			[self.feedRecord setValue:trimString(flattenHTML(self.currentFeedObject[kItemTitleKey])) forKey:kDBFeedTitleKey];
			[self.feedRecord setValue:trimString(flattenHTML(self.currentFeedObject[kItemDescKey])) forKey:kDBFeedDescKey];
			[self.rssDB updateFeed:self.feedRecord forRowID:self.currentFeedID];
			self.currentFeedObject = nil;
		}
		
		NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
		item[kItemFeedIDKey] = self.currentFeedID;
		self.currentItemObject = item;
	} else if ([containerElements containsObject:elementName]) {
		accumulatingParsedCharacterData = YES;
		// reset character accumulator
		[self.currentParsedCharacterData setString:@""];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	// NSLog(@"%s (%@) data: %@", __FUNCTION__, elementName, currentParsedCharacterData);
	if ([elementName isEqualToString:kItemElementName]) {
		[self.currentParseBatch addObject:self.currentItemObject];
		parsedItemsCounter++;
		
		if (parsedItemsCounter % kSizeOfItemsBatch == 0) {
			// message(@"processing batch: %d", parsedItemsCounter);
			[self performSelectorOnMainThread:@selector(addItemsToList:) withObject:self.currentParseBatch waitUntilDone:NO];
			self.currentParseBatch = [NSMutableArray array];	// old array passed to addItemsToList
		}
	} else if (!self.currentParsedCharacterData) {
		return;
	} else if ([elementName isEqualToString:kDescriptionElementName]) {
		NSString * currentString = [[NSString alloc] initWithString: self.currentParsedCharacterData];
		self.currentItemObject[kItemDescKey] = currentString;
	} else if ([elementName isEqualToString:kTitleElementName]) {
		NSString * currentString = [[NSString alloc] initWithString: self.currentParsedCharacterData];
		self.currentItemObject[kItemTitleKey] = currentString;
	} else if ([elementName isEqualToString:kLinkElementName]) {
		NSString * currentString = [[NSString alloc] initWithString: self.currentParsedCharacterData];
		self.currentItemObject[kItemUrlKey] = currentString;
	} else if ([elementName isEqualToString:kUpdatedElementName] || [elementName isEqualToString:kPubDateElementName] || [elementName isEqualToString:kDCDateElementName]) {
		self.currentItemObject[kItemPubDateKey] = [self dateStringToSQLDate:self.currentParsedCharacterData];
	}
	// Stop accumulating parsed character data. We won't start again until specific elements begin.
	accumulatingParsedCharacterData = NO;
}

// The parser delivers parsed character data (PCDATA) in chunks, not necessarily all at once.
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	// NSLog(@"%s (%@)", __FUNCTION__, string);
	if (accumulatingParsedCharacterData) {
		[self.currentParsedCharacterData appendString:string];
	}
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	// We abort parsing if we get more than kMaximumNumberOfItemsToParse.
	// We use the didAbortParsing flag to avoid treating this as an error.
	if (didAbortParsing == NO) {
		// Pass the error to the main thread for handling.
		[self performSelectorOnMainThread:@selector(handleError:) withObject:parseError waitUntilDone:NO];
	}
}

#pragma mark - Utility methods

-(NSString *) dateToLocalizedString:(NSDate *) date {
	// NSLog(@"%s %@", __FUNCTION__, date);
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"EEEE, MMMM d, hh:mm a"];
	NSString *s = [dateFormatter stringFromDate:date];
	return s;
}
-(NSDate *) SQLDateToDate:(NSString *) SQLDateString {
	// NSLog(@"%s %@", __FUNCTION__, SQLDateString);
	if ((id) SQLDateString == [NSNull null] || [SQLDateString length] == 0)
		return [NSDate date]; // current date/time
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];	// "SQL" format
	NSDate *date = [dateFormatter dateFromString:SQLDateString];
	return date;
}

-(NSString *) dateStringToSQLDate:(NSString *) dateString {
	// NSLog(@"%s %@", __FUNCTION__, dateString);
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setLenient:NO];
	[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];	// the formatter should live in UTC
	NSString *s = nil;
	
	// this is the new (as of WWDC 2012, Xcode 4.4) array literals format @[]
	NSArray *dateFormats = @[
    @"EEE, dd MMM yyyy HHmmss zzz",	 // no colons, see below
    @"dd MMM yyyy HHmmss zzz",
    @"yyyy-MM-dd'T'HHmmss'Z'",
    @"yyyy-MM-dd'T'HHmmssZ",
    @"EEE MMM dd HHmm zzz yyyy",
    @"EEE MMM dd HHmmss zzz yyyy",
    @"MMM, dd yyyy HHmmss zzz"	   // rollingstone.com, e.g.: Dec, 3 2010 18:21:00 EST
    ];
	
	// iOS's limited implementation of unicode date formating is missing support for colons in timezone offsets
	// so we just take all the colons out of the string -- it's more flexible like this anyway
	dateString = [dateString stringByReplacingOccurrencesOfString:@":" withString:@""];
	NSDate * date = nil;
	for (NSString *format in dateFormats) {
		[dateFormatter setDateFormat:format];
		// store the NSDate object
		if((date = [dateFormatter dateFromString:dateString])) {
			// message(@"%@ (%@) -> %@", dateString, format, date);
			break;
		}
	}
	
	if (!date) date = [NSDate date];	// no date? use now.
	
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];	// SQL date format
	s = [dateFormatter stringFromDate:date];
	return s;
}

@end
