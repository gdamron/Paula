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
#import "ScoreViewController.h"
#import "PaulaUtilities.m"

@protocol MainViewDelegate <NSObject>
@required
- (void) showScoreView:(NSMutableArray *)data;
- (void) showPlayView;
- (void) sendScore:(Player *)player;
@end

@interface TempMainViewController : UIViewController <MainViewDelegate>

@property (strong, nonatomic) UIButton *toSinglePlayer;
@property (strong, nonatomic) UIButton *toMultiPlayer;
@property (strong, nonatomic) ScoreViewController *scoreViewController;

@end
