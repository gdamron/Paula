//
//  NetworkTableViewController.h
//  Paula
//
//  Created by Kevin Tseng on 11/5/12.
//  Copyright (c) 2012 inomadmusic.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkViewController.h"
#import "GK_GameComm.h"

@interface NetworkTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) id<GK_GameCommDelegate> commDelegate;
@property (nonatomic, assign) id<GK_GameDataDelegate> dataDelegate;
@property (nonatomic) BOOL respondToSelection;

- (id) initWithTitle:(NSString*)title selectable:(BOOL)select;
- (void) reloadTableData;

@end
