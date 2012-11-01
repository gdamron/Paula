//
//  NetworkViewController.h
//  Paula
//
//  Created by Kevin Tseng on 11/1/12.
//  Copyright (c) 2012 inomadmusic.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HostGameViewController.h"
#import "SearchGameViewController.h"
#import "PaulaUtilities.m"

@interface NetworkViewController : UIViewController

@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UIButton *hostGameButton;
@property (strong, nonatomic) UIButton *searchGameButton;

@property (strong, nonatomic) HostGameViewController *hostGameView;
@property (strong, nonatomic) SearchGameViewController *searchGameView;

@end
