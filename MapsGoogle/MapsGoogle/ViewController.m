//
//  ViewController.m
//  MapsGoogle
//
//  Created by Equipo Desarrollo 2 on 23/07/13.
//  Copyright (c) 2013 Cymetria. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "Samples.h"
#import <GoogleMaps/GoogleMaps.h>

@implementation ViewController{
    NSArray *demos_;
    NSArray *demoSections_;
    BOOL isPhone_;
    UIPopoverController *popover_;
    UIBarButtonItem *samplesButton_;
    __weak UIViewController *controller_;
}

-(void)loadView{
        [super loadView];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isPhone_ =
    ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone);
    
    if (!isPhone_) {
        self.clearsSelectionOnViewWillAppear = NO;
    } else {
        UIBarButtonItem *backButton =
        [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"Back")
                                         style:UIBarButtonItemStyleBordered
                                        target:nil
                                        action:nil];
        [self.navigationItem setBackBarButtonItem:backButton];
    }
    
    self.title = NSLocalizedString(@"SDK Demos", @"SDK Demos");
    self.title = [NSString stringWithFormat:@"%@: %@", self.title,
                  [GMSServices SDKVersion]];
    
    self.tableView.autoresizingMask =
    UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    demoSections_ = [Samples loadSections];
    demos_ = [Samples loadDemos];
    
    if (!isPhone_) {
        [self loadDemo:0 atIndex:0];
    }
}

#pragma mark - UITableViewController

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return demoSections_.count;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section {
    return 35.0;
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
    return [demoSections_ objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [[demos_ objectAtIndex: section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentifier];
        
        if (isPhone_) {
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
    }
    
    NSDictionary *demo = [[demos_ objectAtIndex:indexPath.section]
                          objectAtIndex:indexPath.row];
    cell.textLabel.text = [demo objectForKey:@"title"];
    cell.detailTextLabel.text = [demo objectForKey:@"description"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // The user has chosen a sample; load it and clear the selection!
    [self loadDemo:indexPath.section atIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Split 

- (void)splitViewController:(UISplitViewController *)splitController
     willHideViewController:(UIViewController *)viewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc {
    popover_ = pc;
    samplesButton_ = barButtonItem;
    samplesButton_.title = NSLocalizedString(@"Samples", @"Samples");
    samplesButton_.style = UIBarButtonItemStyleDone;
    [self updateSamplesButton];
}

- (void)splitViewController:(UISplitViewController *)splitController
     willShowViewController:(UIViewController *)viewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    popover_ = nil;
    samplesButton_ = nil;
    [self updateSamplesButton];
}

#pragma mark - Metodos Privados
- (NSDictionary *)newDemo:(Class) class
                withTitle:(NSString *)title
           andDescription:(NSString *)description {
    return [[NSDictionary alloc] initWithObjectsAndKeys:class, @"controller",
            title, @"title", description, @"description", nil];
}

- (void)loadDemo:(int)section
         atIndex:(int)index {
    NSDictionary *demo = [[demos_ objectAtIndex:section] objectAtIndex:index];
    UIViewController *controller =
    [[[demo objectForKey:@"controller"] alloc] init];
    controller_ = controller;
    
    if (controller != nil) {
        controller.title = [demo objectForKey:@"title"];
        
        if (isPhone_) {
            [self.navigationController pushViewController:controller animated:YES];
        } else {
            [self.appDelegate setSample:controller];
            [popover_ dismissPopoverAnimated:YES];
        }
        
        [self updateSamplesButton];
    }
}

- (void)updateSamplesButton {
    controller_.navigationItem.leftBarButtonItem = samplesButton_;
}

@end