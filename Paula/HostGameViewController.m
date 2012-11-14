//
//  HostGameViewController.m
//  Paula
//
//  Created by Kevin Tseng on 11/1/12.
//  Copyright (c) 2012 inomadmusic.com. All rights reserved.
//

#import "HostGameViewController.h"
#import "NetworkTableViewController.h"
#import "SinglePlayerViewController.h"
#import "GK_GameServer.h"

@interface HostGameViewController ()
@property SinglePlayerViewController* singlePlayerController;
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) NetworkTableViewController *ntvc;
@end

@implementation HostGameViewController {
    GK_GameServer *_gameServer;
}

@synthesize startButton;

//@synthesize singlePlayerController, server, socketDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        CGFloat width = self.view.bounds.size.width;
        CGFloat height = self.view.bounds.size.height;
        
        [self.view setBackgroundColor:[UIColor colorWithRed:0.2 green:0.4 blue:1.0 alpha:1.0]];
        
        UILabel* waitingLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, width, 30)];
        waitingLabel.text = @"Waiting for player to join...";
        [waitingLabel setBackgroundColor:[UIColor colorWithRed:0.2 green:0.4 blue:1.0 alpha:1.0]];
        waitingLabel.textAlignment = UITextAlignmentCenter;
        
        [self.view addSubview:waitingLabel];
        
        self.ntvc = [[NetworkTableViewController alloc] initWithTitle:@"Search Game" selectable:NO];
        
        self.backButton = addBackButton(width, height);
        [self.backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:self.backButton];
        [self.view addSubview:self.ntvc.view];
        
        [self.ntvc setCommunicationDelegate:self];
        self.startButton = [[UIButton alloc] initWithFrame:CGRectMake(width/2 - 40, height - 100, 80, 30)];
        
        self.startButton.backgroundColor = [UIColor colorWithRed:(arc4random()%1000+1)/1000.0
                                                           green:(arc4random()%1000+1)/1000.0
                                                            blue:(arc4random()%1000+1)/1000.0
                                                           alpha:1.0];
        [self.startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.startButton setTitle:@"Start" forState:UIControlStateNormal];
        [self.startButton addTarget:self action:@selector(startGame) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:self.startButton];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_gameServer == nil) {
        _gameServer = [[GK_GameServer alloc] init];
        [_gameServer startAcceptConnectionForSessionID:SESSION_ID];
        [_gameServer setDelegate:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) backButtonPressed {
//    [self.server disableBonjour];
    [_gameServer close];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - GK_GameCommDelegate
- (void) updateUI:(NSMutableArray *)data {
    [self.ntvc reloadTableData:data];
}

@end
