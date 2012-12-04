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
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) NetworkTableViewController *ntvc;
@end

@implementation HostGameViewController {
    GK_GameServer *_gameServer;
}

@synthesize startButton;
@synthesize networkViewDelegate=_networkViewDelegate;
@synthesize mode=_mode;

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
        
        self.startButton = [[UIButton alloc] initWithFrame:CGRectMake(width/2 - 40, height - 100, 80, 30)];
        
        self.startButton.backgroundColor = [UIColor colorWithRed:(arc4random()%1000+1)/1000.0
                                                           green:(arc4random()%1000+1)/1000.0
                                                            blue:(arc4random()%1000+1)/1000.0
                                                           alpha:1.0];
        [self.startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.startButton setTitle:@"Start" forState:UIControlStateNormal];
        [self.startButton addTarget:self action:@selector(startGame) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:self.startButton];
        
        if (_gameServer == nil) {
            _gameServer = [[GK_GameServer alloc] init];
            [_gameServer setDelegate:self];
            [_gameServer startAcceptConnectionForSessionID:SESSION_ID];
            [_gameServer setMode:self.mode];
            [self.ntvc setCommDelegate:self];
            [self.ntvc setDataDelegate:_gameServer];
        }
    }
    return self;
}

- (enum GameModes) getGameMode {
    return self.mode;
}

- (void) setGameMode:(enum GameModes)mode {
    //do nothing
}

- (void) disconnect {
    [_gameServer close];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
- (void) startGame {
    [_gameServer startGame];
    [self dismissViewControllerAnimated:NO completion:^{
        [self.networkViewDelegate showPlayView];
    }];
}
- (void) updateUI:(NSMutableArray *)data {
    [self.ntvc reloadTableData];
}

- (void) connectToServer:(NSInteger)idx {
    
}

- (void) disAndReturn:(BOOL)ret error:(enum CommErrorType)error {
    NSString *errorTitle = nil;
    NSString *errorMsg = nil;
    switch(error) {
        case SERVER_DOWN: errorTitle = @"Server Down"; errorMsg = @"Server You're Connected To has Gone away!"; break;
        case SERVER_FULL: errorTitle = @"Server Full"; errorMsg = @"Server is Full!"; break;
        case NO_NETWORK: errorTitle = @"No Network"; errorMsg = @"Please check your network setting!";
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"NetworkError" message:errorMsg
                                                   delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"Button: OK") otherButtonTitles:nil];
    [alert show];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void) sendScore:(Player *)player {
    [_gameServer trackScores:nil score:player.score mistakes:player.mistakesMade];
}

- (void) showScore:(NSMutableArray *)data {
    [self.networkViewDelegate showScoreView:data];
}

- (void) setGameMelody:(NSArray *)melody {
    [self.networkViewDelegate setMelodyAndStartGame:melody];
}

- (void) sendMelody:(NSArray *)melody {
    [_gameServer sendMelody:melody];
    [_gameServer setTurn:nil];
}

- (void) changeGameState {
    
}

-(void)reset {
    [_gameServer close];
}

@end
