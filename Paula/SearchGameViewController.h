//
//  SearchGameViewController.h
//  Paula
//
//  Created by Kevin Tseng on 11/1/12.
//  Copyright (c) 2012 inomadmusic.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkViewController.h"

@interface SearchGameViewController : UIViewController <GameCommunicationDelegate>

- (void) insertGameService:(NSMutableArray*)services;

@end
