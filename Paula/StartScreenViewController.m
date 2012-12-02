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
@property (nonatomic) NetworkViewController *networkViewController;

@end


@implementation StartScreenViewController

@synthesize toEnyu;
@synthesize toEugene;
@synthesize toSinglePlayer;
@synthesize toMultiPlayer;
@synthesize networkViewController;
@synthesize scoreViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        CGFloat width = self.view.bounds.size.width;
        CGFloat height = self.view.bounds.size.height;
        
        [self.view setBackgroundColor:[UIColor blackColor]];
        
        toSinglePlayer = setupMenuButtonWithImage(toSinglePlayer, 1, [UIImage imageNamed:@"single-player.gif"], width, height);
        [toSinglePlayer addTarget:self action:@selector(nameButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        toMultiPlayer = setupMenuButtonWithImage(toMultiPlayer, 2, [UIImage imageNamed:@"multi-player.gif"], width, height);
        [toMultiPlayer addTarget:self action:@selector(nameButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        toEnyu = setupMenuButtonWithImage(toEnyu, 3, [UIImage imageNamed:@"just-play.gif"], width, height);
        [toEnyu addTarget:self action:@selector(nameButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        toEugene = setupMenuButtonWithImage(toEugene, 4, [UIImage imageNamed:@"scoreboard.gif"], width, height);
        [toEugene addTarget:self action:@selector(nameButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:setupLogo(width, height)];
        [self.view addSubview:toEnyu];
        [self.view addSubview:toEugene];
        [self.view addSubview:toSinglePlayer];
        [self.view addSubview:toMultiPlayer];
        
        //toneGenerator = [[ToneGenerator alloc] init];
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
    if (sender==toEnyu) {
        self.singlePlayerViewController = [[SinglePlayerViewController alloc] initWithGameMode:JUST_PlAY];
        [self.singlePlayerViewController setDelegate:self];
        [self presentViewController:self.singlePlayerViewController animated:YES completion:nil];
    } else if (sender==toEugene) {
        scoreViewController = [[ScoreViewController alloc] initWithData:nil];
        [self presentViewController:scoreViewController animated:YES completion:nil];
    } else if (sender==toSinglePlayer) {
        self.singlePlayerViewController = [[SinglePlayerViewController alloc] initWithGameMode:SINGLE_PLAYER];
        [self.singlePlayerViewController setDelegate:self];
        [self.singlePlayerViewController playCountdownAndStartGame];
        [self presentViewController:self.singlePlayerViewController animated:YES completion:nil];
    } else if (sender==toMultiPlayer) {
        networkViewController = [[NetworkViewController alloc] init];
        [self presentViewController:networkViewController animated:NO completion:nil];
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
    } else {
        self.singlePlayerViewController = [[SinglePlayerViewController alloc] initWithGameMode:MULTI_PLAYER_COMPETE];
        [self.singlePlayerViewController setDelegate:self];
        [self.singlePlayerViewController playCountdownAndStartGame];
        [self presentViewController:self.singlePlayerViewController animated:YES completion:nil];
    }
}

- (void) sendScore:(Player *)player {
    //does nothing
}

@end