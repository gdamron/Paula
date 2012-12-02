//
//  MultiPlayerOptionViewController.m
//  Paula
//
//  Created by Kevin Tseng on 12/1/12.
//  Copyright (c) 2012 inomadmusic.com. All rights reserved.
//

#import "MultiPlayerOptionViewController.h"

@interface MultiPlayerOptionViewController ()

@property (nonatomic) UIButton *competeButton;
@property (nonatomic) UIButton *challengeButton;
@property (nonatomic) UIButton *composeButton;

@end

@implementation MultiPlayerOptionViewController

@synthesize networkController=_networkController;
@synthesize competeButton;
@synthesize challengeButton;
@synthesize composeButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        CGFloat width = self.view.bounds.size.width;
        CGFloat height = self.view.bounds.size.height;
        
        [self.view setBackgroundColor:[UIColor colorWithRed:0.2 green:0.4 blue:1.0 alpha:1.0]];
        
        competeButton = setupMenuButton(competeButton, 1, @"Competition", width, height);
        [competeButton addTarget:self action:@selector(optionPressed:) forControlEvents:UIControlEventTouchUpInside];
        challengeButton = setupMenuButton(challengeButton, 2, @"Challenge", width, height);
        [challengeButton addTarget:self action:@selector(optionPressed:) forControlEvents:UIControlEventTouchUpInside];
        composeButton = setupMenuButton(composeButton, 3, @"Compose", width, height);
        [composeButton addTarget:self action:@selector(optionPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:competeButton];
        [self.view addSubview:challengeButton];
        [self.view addSubview:composeButton];
    }
    return self;
}

- (void)optionPressed:(id)sender {
    enum GameModes option;
    if(sender == competeButton) {
        option = MULTI_PLAYER_COMPETE;
    } else if (sender == challengeButton) {
        option = MULTI_PLAYER_MIMIC;
    } else if (sender == composeButton) {
        option = MULTI_PLAYER_COMPOSE;
    } else {
        //just return do nothing
        return;
    }
    
    [self dismissViewControllerAnimated:NO completion:^ {
        [_networkController setGameOption:option];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
