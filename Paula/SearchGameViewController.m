//
//  SearchGameViewController.m
//  Paula
//
//  Created by Kevin Tseng on 11/1/12.
//  Copyright (c) 2012 inomadmusic.com. All rights reserved.
//
#import "SearchGameViewController.h"
#import "GameClient.h"
#import "SocketDelegate.h"
#import "NetworkTableViewController.h"

@interface SearchGameViewController ()
@property SinglePlayerViewController* singlePlayerController;
@property (nonatomic) GameClient *client;
@property (nonatomic) SocketDelegate *socketDelegate;
@property (strong, nonatomic) UIButton* startButton;
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) NetworkTableViewController *ntvc;
@end

@implementation SearchGameViewController

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
        
        [self.ntvc setCommunicationDelegate:self];
    }
    return self;
}

- (void) startGame {
    self.singlePlayerController = [[SinglePlayerViewController alloc] init];
    // later, we'll need to have a more complicated control structure
    // but for now, assuming MULTI_BASIC multiplayer mode
    self.singlePlayerController.game.mode = MULTI_BASIC;
    [self.singlePlayerController setController:self];
    self.client = [[GameClient alloc] init];
    self.socketDelegate = [[SocketDelegate alloc] init];
    [self.client setDelegate:self.socketDelegate];
    [self.client setGameController:self];
    [self.socketDelegate setController:self];
    [self.singlePlayerController playCountdownAndStartGame];
}

- (void) insertGameService:(NSMutableArray *)services {
    NSLog(@"number of host found: %d", services.count);
    [self.ntvc reloadTableData:services];
}

- (void) selectedRowAtIndexPath:(NSUInteger*)idx {
    [self.client connectToService:idx];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self startGame];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) send:(const uint8_t)message {
    [self.socketDelegate send:message];
}

- (void) noteOnWithNumber:(NSInteger)num sendMessage:(BOOL)send {
    [self.singlePlayerController noteOnWithNumber:num sendMessage:send];
}

- (void) allNotesOff {
    [self.singlePlayerController allNotesOff];
}

- (void) presentGame {
    [self presentViewController:self.singlePlayerController animated:YES completion:nil];
}

- (void) backButtonPressed {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end