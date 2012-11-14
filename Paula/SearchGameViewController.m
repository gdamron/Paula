//
//  SearchGameViewController.m
//  Paula
//
//  Created by Kevin Tseng on 11/1/12.
//  Copyright (c) 2012 inomadmusic.com. All rights reserved.
//
#import "SearchGameViewController.h"
#import "NetworkTableViewController.h"
#import "SinglePlayerViewController.h"
#import "GK_GameServer.h"
#import "GK_GameClient.h"

@interface SearchGameViewController ()
@property SinglePlayerViewController* singlePlayerController;
@property (strong, nonatomic) UIButton* startButton;
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) NetworkTableViewController *ntvc;
@end

@implementation SearchGameViewController {
    GK_GameClient *_gameClient;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        [self.view setBackgroundColor:[UIColor colorWithRed:0.2 green:0.4 blue:1.0 alpha:1.0]];

        CGFloat width = self.view.bounds.size.width;
        CGFloat height = self.view.bounds.size.height;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, width, 30)];
        [titleLabel setBackgroundColor:[UIColor colorWithRed:0.2 green:0.4 blue:1.0 alpha:1.0]];
        titleLabel.text = @"- Available Games -";
        titleLabel.textAlignment = UITextAlignmentCenter;
        
        self.ntvc = [[NetworkTableViewController alloc] initWithTitle:@"Search Game" selectable:YES];

        self.backButton = addBackButton(width, height);
        [self.backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:titleLabel];
        [self.view addSubview:self.backButton];
        [self.view addSubview:self.ntvc.view];
        
//        [self.ntvc setCommunicationDelegate:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if (_gameClient == nil) {
        _gameClient = [[GK_GameClient alloc] init];
        [_gameClient startSearchServerForSessionID:SESSION_ID];
        [_gameClient setDelegate:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) backButtonPressed {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) presentGame {
    [self presentViewController:self.singlePlayerController animated:YES completion:nil];
    [self.singlePlayerController playCountdownAndStartGame];
}


@end