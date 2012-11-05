//
//  SinglePlayerViewController.h
//  Paula
//
//  Created by Grant Damron on 10/10/12.
//  Copyright (c) 2012 Grant Damron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToneGenerator.h"
#import "PaulaUtilities.m"
#import "HostGameViewController.h"
#import "Metronome.h"
#import "Paula.h"
#import "Game.h"

//#import "ToneGenerator2.h"

@interface SinglePlayerViewController : UIViewController

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
@property (strong, nonatomic) UILabel *scoreDisplay;
@property (strong, nonatomic) UILabel *mistakesLeftDisplay;
@property (strong, nonatomic) ToneGenerator *toneGen;
@property (strong, nonatomic) Metronome *metronome;
@property (strong, nonatomic) Paula *paula;
@property (strong, nonatomic) Game *game;

- (void) noteOnWithNumber:(NSInteger)num sendMessage:(BOOL)send;
- (void) noteOffWithNumber:(NSInteger)num sendMessage:(BOOL)send;
- (void)noteOn:(id)sender;
- (void)noteOff:(id)sender;
- (void) allNotesOff;

@end
