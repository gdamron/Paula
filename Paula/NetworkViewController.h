//
//  NetworkViewController.h
//  Paula
//
//  Created by Kevin Tseng on 11/1/12.
//  Copyright (c) 2012 inomadmusic.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaulaUtilities.m"
#import "StartScreenViewController.h"
#import "SinglePlayerViewController.h"

@class NetworkViewController;

@interface NetworkViewController : UIViewController <MainViewDelegate>

@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UIButton *hostGameButton;
@property (strong, nonatomic) UIButton *searchGameButton;

-(void) showGameView;

@end
