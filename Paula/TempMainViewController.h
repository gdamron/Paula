//
//  TempMainViewController.h
//  Paula
//
//  Created by Grant Damron on 10/10/12.
//  Copyright (c) 2012 Grant Damron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnyuViewController.h"
#import "EugeneViewController.h"
#import "SinglePlayerViewController.h"
#import "NetworkViewController.h"
#import "PaulaUtilities.m"

@interface TempMainViewController : UIViewController

@property (strong, nonatomic) UIButton *toEnyu;
@property (strong, nonatomic) UIButton *toEugene;
@property (strong, nonatomic) UIButton *toSinglePlayer;
@property (strong, nonatomic) UIButton *toMultiPlayer;
@property (strong, nonatomic) EnyuViewController *enyuViewController;
@property (strong, nonatomic) EugeneViewController *eugeneViewController;
@property (strong, nonatomic) SinglePlayerViewController *singlePlayerViewController;
@property (strong, nonatomic) NetworkViewController *networkViewController;

@end
