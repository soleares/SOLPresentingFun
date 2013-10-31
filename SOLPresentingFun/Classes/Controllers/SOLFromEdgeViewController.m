//
//  SOLFromEdgeViewController.m
//  PresentingFun
//
//  Created by Jesse Wolff on 10/31/13.
//  Copyright (c) 2013 Soleares, Inc. All rights reserved.
//

#import "SOLFromEdgeViewController.h"
#import "SOLOptions.h"
#import "SOLSlideTransitionAnimator.h"

static NSString * const kCellID = @"cellID";

@implementation SOLFromEdgeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SOLOptions *options = [SOLOptions sharedOptions];
    self.checkedItem = [NSIndexPath indexPathForRow:options.edge inSection:0];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [SOLSlideTransitionAnimator edgeDisplayNames].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID forIndexPath:indexPath];

    cell.textLabel.text = [SOLSlideTransitionAnimator edgeDisplayNames][@(indexPath.row)];
    
    if ([indexPath isEqual:self.checkedItem]) {
        [self checkCell:cell];
    } else {
        [self uncheckCell:cell];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self uncheckCell:[tableView cellForRowAtIndexPath:self.checkedItem]];
    [self checkCell:[tableView cellForRowAtIndexPath:indexPath]];
    self.checkedItem = indexPath;
    
    SOLOptions *options = [SOLOptions sharedOptions];
    options.edge = indexPath.row;
}

#pragma mark - Tableview methods

- (void)checkCell:(UITableViewCell *)cell
{
	cell.accessoryType = UITableViewCellAccessoryCheckmark;
}

- (void)uncheckCell:(UITableViewCell *)cell
{
    cell.accessoryType = UITableViewCellAccessoryNone;
}

@end
