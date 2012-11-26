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
@property (strong, nonatomic) UIButton* startButton;
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) NetworkTableViewController *ntvc;
@end

@implementation SearchGameViewController {
    GK_GameClient *_gameClient;
}

@synthesize networkViewDelegate=_networkViewDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
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
        
        if (_gameClient == nil) {
            _gameClient = [[GK_GameClient alloc] init];
            [_gameClient setDelegate:self];
            [_gameClient startSearchServerForSessionID:SESSION_ID];
            
            NSLog(@"setting client delegates");
            [self.ntvc setCommDelegate:self];
            [self.ntvc setDataDelegate:_gameClient];
        }
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

- (void) backButtonPressed {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - GK_GameCommDelegate
- (void) updateUI:(NSMutableArray *)data {
    [self.ntvc reloadTableData];
}

- (void) connectToServer:(NSInteger)idx {
    NSLog(@"connecting to server at idx : %d", idx);
    [_gameClient connectToServerWithIdx:idx];
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

- (void) startGame {
    [self dismissViewControllerAnimated:NO completion:^{
        [self.networkViewDelegate showPlayView];
    }];
}

- (void) sendScore:(Player *)player {
    [_gameClient sendScore:player.score mistakes:player.mistakesMade];
}

- (void) showScore:(NSMutableArray *)data {
    [self.networkViewDelegate showScoreView:data];
}

@end