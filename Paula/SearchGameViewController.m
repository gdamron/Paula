//
//  SearchGameViewController.m
//  Paula
//
//  Created by Kevin Tseng on 11/1/12.
//  Copyright (c) 2012 inomadmusic.com. All rights reserved.
//
#import "HostGameViewController.h"
#import "SearchGameViewController.h"
#import "GameClient.h"
#import "SocketDelegate.h"

@interface SearchGameViewController ()
@property SinglePlayerViewController* singlePlayerController;
@property (nonatomic) GameClient *client;
@property (nonatomic) SocketDelegate *socketDelegate;
@property (strong, nonatomic) UIButton* startButton;
@end

@implementation SearchGameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.view setBackgroundColor:[UIColor colorWithRed:0.2 green:0.4 blue:1.0 alpha:1.0]];
        
        self.startButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 50, 50, 50)];
        [self.startButton setTitle:@"Start" forState:UIControlStateNormal];
        [self.startButton addTarget:self action:@selector(startGame) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.startButton];
    }
    return self;
}

- (void) startGame {
    self.singlePlayerController = [[SinglePlayerViewController alloc] init];
    [self.singlePlayerController setController:self];
    self.client = [[GameClient alloc] init];
    self.socketDelegate = [[SocketDelegate alloc] init];
    [self.client setDelegate:self.socketDelegate];
    [self.socketDelegate setController:self];
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

@end
