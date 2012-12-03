//
//  HostGameViewController.h
//  Paula
//
//  Created by Kevin Tseng on 11/1/12.
//  Copyright (c) 2012 inomadmusic.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkViewController.h"
#import "GK_GameComm.h"

@interface HostGameViewController : UIViewController <GK_GameCommDelegate>

@property (nonatomic) UIButton* startButton;
@property (nonatomic, assign) NetworkViewController *networkViewDelegate;
@property (nonatomic, assign) enum GameModes mode;

-(void) sendScore:(Player *)player;
@end
