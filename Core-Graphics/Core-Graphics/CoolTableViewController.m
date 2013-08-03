//
//  CoolTableViewController.m
//  Core-Graphics
//
//  Created by Equipo Desarrollo 2 on 3/08/13.
//  Copyright (c) 2013 Cymetria. All rights reserved.
//

#import "CoolTableViewController.h"
#import "CustomHeader.h"

@interface CoolTableViewController ()
@property (copy) NSArray* array;
@property (copy) NSMutableArray* thingsToLearn;
@property (copy) NSMutableArray* thingsToLearned;
@end

@implementation CoolTableViewController

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
    
    self.title = @"Core Graphics";
    self.thingsToLearn = [@[@"SqlLite", @"TableView", @"Core-Graphics"] mutableCopy];
    self.thingsToLearned = [@[@"UIKit", @"XCODE", @"Objective-C"] mutableCopy];
    
    UIImageView * background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_bg.jpg"]];
    
    self.tableView.backgroundView = background;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CustomHeader *header = [[CustomHeader alloc] init];
    
    header.titleLabel.text = [self tableView: tableView titleForHeaderInSection:section];
    
    if (section == 1) {
        header.lightColor = [UIColor colorWithRed:0.591 green:0.500 blue:0.847 alpha:1.000];
        header.darkColor = [UIColor colorWithRed:72/255.0 green:22/255.0 blue:137/255.0 alpha:1.0];
    }
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50.0f;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  // Return the number of rows in the section.
    if (section == 0) {
        return self.thingsToLearn.count;
    } else {
        return self.thingsToLearned.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
