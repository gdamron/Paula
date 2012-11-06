//
//  NetworkTableViewController.m
//  Paula
//
//  Created by Kevin Tseng on 11/5/12.
//  Copyright (c) 2012 inomadmusic.com. All rights reserved.
//

#import "NetworkTableViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface NetworkTableViewController ()
@property (strong, nonatomic) NSMutableArray* internalData;
@property (nonatomic) BOOL respondToSelection;
@end

@implementation NetworkTableViewController

@synthesize communicationDelegate=_communicationDelegate;

- (id) initWithTitle:(NSString *)title selectable:(BOOL)select {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        [self.tableView setDelegate:self];
        [self.tableView setDataSource:self];
        
        CGFloat width = self.view.bounds.size.width;
        CGFloat height = self.view.bounds.size.height;
        
        self.tableView.frame = CGRectMake(25, 50, width-50, height-200);
        self.tableView.layer.cornerRadius = 10;
        
        self.respondToSelection = select;
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.internalData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"paulaCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.font = [[[UIFont alloc] init] fontWithSize:14];
    cell.textLabel.textAlignment = UITextAlignmentCenter;
    NSString *service = [self.internalData objectAtIndex:indexPath.row];
    cell.textLabel.text = service;
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.respondToSelection) {
        NSUInteger uint = (NSUInteger)indexPath.row;
        [self.communicationDelegate selectedRowAtIndexPath:&uint];
    }
}

- (void) reloadTableData:(NSMutableArray *)data {
    self.internalData = nil;
    self.internalData = data;
    
    [self.tableView reloadData];
}

@end