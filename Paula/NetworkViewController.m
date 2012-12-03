//
//  NetworkViewController.m
//  Paula
//
//  Created by Kevin Tseng on 11/1/12.
//  Copyright (c) 2012 inomadmusic.com. All rights reserved.
//

#import "NetworkViewController.h"
#import "HostGameViewController.h"
#import "SearchGameViewController.h"
#import "MultiPlayerOptionViewController.h"

@interface NetworkViewController ()
@property (nonatomic) HostGameViewController *hostGameView;
@property (nonatomic) SearchGameViewController *searchGameView;
@property (nonatomic) MultiPlayerOptionViewController *optionController;
@property (nonatomic) SinglePlayerViewController *singleViewController;
@property (nonatomic) enum GameModes mode;
@property (nonatomic) BOOL isServer;

@end

@implementation NetworkViewController

@synthesize backButton, hostGameButton, searchGameButton;
@synthesize hostGameView, searchGameView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        CGFloat width = self.view.bounds.size.width;
        CGFloat height = self.view.bounds.size.height;
        
        [self.view setBackgroundColor:[UIColor blackColor]];
        
        backButton = addBackButton(width, height);
        [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
        hostGameButton = setupMenuButton(hostGameButton, 1, @"Host Game", width, height);
        [hostGameButton addTarget:self action:@selector(nameButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        searchGameButton = setupMenuButton(searchGameButton, 2, @"Search Game", width, height);
        [searchGameButton addTarget:self action:@selector(nameButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:setupLogo(width, height)];
        [self.view addSubview:backButton];
        [self.view addSubview:hostGameButton];
        [self.view addSubview:searchGameButton];
    }
    return self;
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

- (void)setGameOption:(enum GameModes)mode {
    self.mode = mode;
    self.hostGameView = [HostGameViewController alloc];
    [self.hostGameView setNetworkViewDelegate:self];
    [self.hostGameView setMode:mode];
    self.hostGameView = [self.hostGameView init];
    [self presentViewController:self.hostGameView animated:NO completion:nil];
}

- (void) backButtonPressed {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)nameButtonPressed:(id)sender {
    if(sender == hostGameButton) {
        self.isServer = YES;
        self.optionController = [[MultiPlayerOptionViewController alloc] init];
        [self.optionController setNetworkController:self];
        [self presentViewController:self.optionController animated:YES completion:nil];
    } else if (sender == searchGameButton) {
        self.isServer = NO;
        self.searchGameView = [[SearchGameViewController alloc] init];
        [self.searchGameView setNetworkViewDelegate:self];
        [self presentViewController:self.searchGameView animated:NO completion:nil];
    }
}

- (void) sendMelody:(NSArray *)melody {
    if(self.isServer) {
        [self.hostGameView sendMelody:melody];
    } else {
        [self.searchGameView sendMelody:melody];
    }
}

- (void) showPlayView {
    enum GameStates gs = GAME_MY_TURN;
    if(self.singleViewController == nil) {
        self.singleViewController = [[SinglePlayerViewController alloc] initWithGameModeAndState:self.mode gameState:gs];
        [self.singleViewController setDelegate:self];
    }
    
    if(self.mode != MULTI_PLAYER_COMPETE) {
        gs = self.isServer?GAME_MY_TURN:GAME_WAITING;
    } else {
        [self setMelodyAndStartGame:nil];
    }
    
    [self presentViewController:self.singleViewController animated:YES completion:nil];
}

- (void) setMelodyAndStartGame:(NSArray *)melody {
    if(self.singleViewController) {
        if(self.mode == MULTI_PLAYER_COMPETE) {
            [self.singleViewController setGameWithNotes:nil];
            [self.singleViewController playCountdownAndStartGame];
        } else if (self.mode == MULTI_PLAYER_MIMIC) {
            [self.singleViewController setGameWithNotes:melody];
            [self.singleViewController playCountdownAndStartGame];
        }
    }
}

- (void) changeGameState {
    if(self.singleViewController) {
        [self.singleViewController changeGameState];
    }
}

- (void) grabMelodyFromGame {
    if(self.singleViewController) {
        
    }
}

- (void) showScoreView:(NSMutableArray *)data {
    [self dismissViewControllerAnimated:NO completion:^{
        ScoreViewController *scoreViewController = [[ScoreViewController alloc] initWithData:data];
        [self presentViewController:scoreViewController animated:YES completion:nil];
    }];
}

- (void) sendScore:(Player *)player {
    NSLog(@"SENDING SCORE CALLED");
    if(self.isServer) {
        [self.hostGameView sendScore:player];
    } else {
        [self.searchGameView sendScore:player];
    }
}

@end
