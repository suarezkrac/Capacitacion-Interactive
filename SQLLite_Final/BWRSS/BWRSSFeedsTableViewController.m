//
//  BWRSSMasterViewController.m
//  BWRSS
//
//  Created by Bill Weinman on 2012-10-21.
//  Copyright (c) 2012 Bill Weinman. All rights reserved.
//

#import "BWRSSFeedsTableViewController.h"
#import "BWRSSItemsTableViewController.h"

@interface BWRSSFeedsTableViewController () {
    BOOL iPadIdiom;
    NSDictionary * _newFeed;
    RSSDB * _rssDB;
    NSArray * _feedIDs;
}
@end

@implementation BWRSSFeedsTableViewController

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad) iPadIdiom = YES;
	[self loadFeedIDs];
	[self.tableView reloadData];
}

- (void) viewDidAppear:(BOOL)animated {
    if (_newFeed)  [self loadNewFeed];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segue delegate

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"SegueToItemTableView"]) {
		BWRSSItemsTableViewController * itemsTableViewController = [segue destinationViewController];
		NSIndexPath * path = [self.tableView indexPathForSelectedRow];
		NSNumber * feedID = _feedIDs[path.row];
        
		// setup some context
		itemsTableViewController.currentFeedID = feedID;
		itemsTableViewController.rssDB = _rssDB;
	} else if([segue.identifier isEqualToString:@"SegueToAddView"]) {
        BWRSSAddViewController *rssAddViewController = [segue destinationViewController];
        rssAddViewController.delegate = self;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [self loadFeedIDs];
    return _feedIDs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedsCell" forIndexPath:indexPath];

    [self loadFeedIDsIfEmpty];
    
    NSDictionary * feedRow = [_rssDB getFeedRow:_feedIDs[indexPath.row]];
    cell.textLabel.text = feedRow[@"title"];
    cell.detailTextLabel.text = feedRow[@"desc"];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self loadFeedIDsIfEmpty];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // must update the database before updating the tableView
        // so that the tableView never has a row that's missing from the database
        [_rssDB deleteFeedRow:_feedIDs[indexPath.row]];
        [self loadFeedIDs];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - RSSAddViewControllerDelegate delegate methods

-(void) haveAddViewRecord:(NSDictionary *) avRecord {
	// NSLog(@"%s %@", __FUNCTION__, avRecord);
	_newFeed = avRecord;
	if (iPadIdiom) [self loadNewFeed];
}

-(void) haveAddViewError:(NSError *) error {
	// NSLog(@"%s %@", __FUNCTION__, error);
	NSString *errorMessage = [error localizedDescription];
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"URL Error" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
}

-(void) haveAddViewMessage:(NSString *)message {
	// NSLog(@"%s %@", __FUNCTION__, message);
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"RSS Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
}


#pragma mark - Database methods

- (void) loadNewFeed {
    // NSLog(@"%s", __FUNCTION__);
    if (!_newFeed) return;
    
    NSDictionary * newFeed = _newFeed;
    _newFeed = nil;
    
    NSNumber * rc = [_rssDB addFeedRow:newFeed];
    NSIndexPath * idx = [self indexPathForDBRec:newFeed];
    if (rc == nil) {    // inserted row in DB
        [self.tableView insertRowsAtIndexPaths:@[idx] withRowAnimation:UITableViewRowAnimationLeft];
    }
    [self.tableView scrollToRowAtIndexPath:idx atScrollPosition:UITableViewScrollPositionNone animated:YES];
    if (rc != nil) {    // updated existing row in DB
        [self.tableView reloadRowsAtIndexPaths:@[idx] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

- (NSIndexPath *) indexPathForDBRec:(NSDictionary *) dbRec {
    NSNumber * rowID = [_rssDB valueFromQuery:@"SELECT id FROM feed WHERE url = ?", dbRec[@"url"]];
    if (rowID) {
        NSArray * tempFeedIDs = [_rssDB getFeedIDs];
        return [NSIndexPath indexPathForRow:[tempFeedIDs indexOfObject:rowID] inSection:0];
    } else {
        return nil;
    }
}

- (NSArray *) loadFeedIDs {
    // NSLog(@"%s", __FUNCTION__);
    if (!_rssDB) [self loadFeedDB];
    _feedIDs = [_rssDB getFeedIDs];
    return _feedIDs;
}

- (NSArray *) loadFeedIDsIfEmpty {
    // NSLog(@"%s", __FUNCTION__);
    if (!_rssDB) [self loadFeedDB];
    if (!_feedIDs || ![_feedIDs count]) _feedIDs = [_rssDB getFeedIDs];
    return _feedIDs;
}

- (RSSDB *) loadFeedDB {
    // NSLog(@"%s", __FUNCTION__);
    // use self.rssDB? or rssDB?
    if (!_rssDB) _rssDB = [[RSSDB alloc] initWithRSSDBFilename:@"bwrss.db"];
    return _rssDB;
}


@end
