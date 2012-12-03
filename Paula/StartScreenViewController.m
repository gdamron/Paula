//
// StartScreenViewController.m
// Paula
//
// Created by Grant Damron on 10/10/12.
// Copyright (c) 2012 Grant Damron. All rights reserved.
//

#import "StartScreenViewController.h"
#import "SinglePlayerViewController.h"

@interface StartScreenViewController ()
@property (nonatomic) SinglePlayerViewController *singlePlayerViewController;
@property (nonatomic) SinglePlayerViewController *justPlayViewController;
@property (nonatomic) NetworkViewController *networkViewController;

@end


@implementation StartScreenViewController

@synthesize toSinglePlayer;
@synthesize toMultiPlayer;
@synthesize toJustPlay;
@synthesize networkViewController;
@synthesize scoreViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        CGFloat width = self.view.bounds.size.width;
        CGFloat height = self.view.bounds.size.height;
        
        [self.view setBackgroundColor:[UIColor blackColor]];
        
        toSinglePlayer = setupMenuButton(toSinglePlayer, 1, @"single player", width, height);
        [toSinglePlayer addTarget:self action:@selector(nameButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        toMultiPlayer = setupMenuButton(toMultiPlayer, 2, @"multi-player", width, height);
        [toMultiPlayer addTarget:self action:@selector(nameButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        toJustPlay = setupMenuButton(toJustPlay, 3, @"just play", width, height);
        [toJustPlay addTarget:self action:@selector(nameButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:setupLogo(width, height)];
        [self.view addSubview:toSinglePlayer];
        [self.view addSubview:toMultiPlayer];
        [self.view addSubview:toJustPlay];
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

- (void)nameButtonPressed:(id)sender {
    if (sender==toSinglePlayer) {
        self.singlePlayerViewController = [[SinglePlayerViewController alloc] initWithGameModeAndState:SINGLE_PLAYER gameState:GAME_MY_TURN];
        [self.singlePlayerViewController setDelegate:self];
        [self.singlePlayerViewController playCountdownAndStartGame];
        [self presentViewController:self.singlePlayerViewController animated:YES completion:nil];
    } else if (sender==toMultiPlayer) {
        networkViewController = [[NetworkViewController alloc] init];
        [self presentViewController:networkViewController animated:NO completion:nil];
    } else if (sender==toJustPlay) {
        self.justPlayViewController = [[SinglePlayerViewController alloc] initWithGameModeAndState:JUST_PlAY gameState:GAME_MY_TURN];
        [self.justPlayViewController setDelegate:self];
        [self presentViewController:self.justPlayViewController animated:YES completion:nil];
    }
}

#pragma mark - MainViewDelegate
- (void) showScoreView:(NSMutableArray *)data {
    scoreViewController = [[ScoreViewController alloc] initWithData:data];
    [self presentViewController:scoreViewController animated:YES completion:nil];
}

- (void) showPlayView {
    if(self.singlePlayerViewController != nil) {
        [self.singlePlayerViewController playCountdownAndStartGame];
        [self presentViewController:self.singlePlayerViewController animated:YES completion:nil];
    }
}

- (void) sendScore:(Player *)player {
    //does nothing
}

@end