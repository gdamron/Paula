//
//  JoinedViewController.h
//  Paula
//
//  Created by Kevin Tseng on 12/2/12.
//  Copyright (c) 2012 inomadmusic.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchGameViewController.h"

@interface Jo_inedViewController : UIViewController

@property (nonatomic, assign) SearchGameViewController *searchController;

- (id) initWithNameAndMode:(NSString *)name modeName:(NSString *)mode;

@end
