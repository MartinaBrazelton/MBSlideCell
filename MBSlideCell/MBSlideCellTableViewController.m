//
//  MBSlideCellTableViewController.m
//  MBSlideToRevealCell
//
//  Created by Martina Brazelton on 6/12/13.
//  Copyright (c) 2013 Martina Brazelton. All rights reserved.
//

#import "MBSlideCellTableViewController.h"
#import "MBSlideCell.h"

#define REUSE_ID @"Reuse ID"

@interface MBSlideCellTableViewController ()

@property (nonatomic, strong) NSMutableArray *data;

@end

@implementation MBSlideCellTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.data = [NSMutableArray arrayWithArray:@[ @"Cell 1", @"Cell 2", @"Cell 3"]];
        [self.tableView registerClass:MBSlideCell.class forCellReuseIdentifier:REUSE_ID];
    }
    return self;
}

- (void)configureCell:(MBSlideCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    cell.textLabel.text = self.data[indexPath.row];
    cell.textLabel.backgroundColor = UIColor.clearColor;
    cell.shouldReturnAutomatically = YES;
    cell.maxRightInset = self.tableView.frame.size.width/3;
    [cell setSlideLeftBlock:^(MBSlideCell *cell, MBSlideCellPanGestureRecognizer *panGestureRecognizer) {
        CGFloat rightEdge = CGRectGetMaxX(cell.contentView.frame);
        cell.backgroundView.backgroundColor = [self backgroundViewColor:rightEdge];
    }];
}

- (UIColor *)backgroundViewColor:(CGFloat)x
{
    float val = x / self.tableView.frame.size.width;
    return [UIColor colorWithRed: 1.0 green:powf(val, 1.25) blue: 0.0 alpha:1.0];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MBSlideCell *cell = [tableView dequeueReusableCellWithIdentifier:REUSE_ID forIndexPath:indexPath];
    [self configureCell:cell forIndexPath:indexPath];
    
    return cell;
}

@end
