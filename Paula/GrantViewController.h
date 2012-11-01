//
//  GrantViewController.h
//  Paula
//
//  Created by Grant Damron on 10/10/12.
//  Copyright (c) 2012 Grant Damron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToneGenerator.h"
#import "PaulaUtilities.m"
#import "HostGameViewController.h"

//#import "ToneGenerator2.h"

@interface GrantViewController : UIViewController

@property(assign) id<GameCommunicationDelegate> controller;
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UIButton *sineButton1;
@property (strong, nonatomic) UIButton *sineButton2;
@property (strong, nonatomic) UIButton *sineButton3;
@property (strong, nonatomic) UIButton *sineButton4;
@property (strong, nonatomic) UIButton *sineButton5;
@property (strong, nonatomic) UIButton *sineButton6;
@property (strong, nonatomic) UIButton *sineButton7;
@property (strong, nonatomic) UIButton *sineButton8;
@property (strong, nonatomic) ToneGenerator *toneGen;

- (void) playNote:(NSInteger)num;
- (void) playNoteOff;
- (void) noteOff;

@end
