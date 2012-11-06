//
//  NetworkTableViewController.h
//  Paula
//
//  Created by Kevin Tseng on 11/5/12.
//  Copyright (c) 2012 inomadmusic.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkViewController.h"

@interface NetworkTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (assign) id<GameCommunicationDelegate> communicationDelegate;

- (id) initWithTitle:(NSString*)title selectable:(BOOL)select;
- (void) reloadTableData:(NSMutableArray*)data;

@end
