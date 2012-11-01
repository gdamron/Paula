//
//  HostGameViewController.m
//  Paula
//
//  Created by Kevin Tseng on 11/1/12.
//  Copyright (c) 2012 inomadmusic.com. All rights reserved.
//

#import "HostGameViewController.h"
#import "GameServer.h"
#import "SocketDelegate.h"

@interface HostGameViewController ()
@property GrantViewController* grantController;
@property (nonatomic) GameServer *server;
@property (nonatomic) SocketDelegate *socketDelegate;

@end

@implementation HostGameViewController

//@synthesize grantController, server, socketDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        [self.view setBackgroundColor:[UIColor colorWithRed:0.2 green:0.4 blue:1.0 alpha:1.0]];
        
        UILabel* waitingLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 200, 50)];
        waitingLabel.text = @"Waiting for player to join...";
        [waitingLabel setBackgroundColor:[UIColor colorWithRed:0.2 green:0.4 blue:1.0 alpha:1.0]];
        
        [self.view addSubview:waitingLabel];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.grantController = [[GrantViewController alloc] init];
    [self.grantController setController:self];
    self.server = [[GameServer alloc] init];
    self.socketDelegate = [[SocketDelegate alloc] init];
    [self.server setDelegate:self.socketDelegate];
    [self.socketDelegate setController:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) send:(const uint8_t)message {
    [self.socketDelegate send:message];
}

- (void) playNote:(NSInteger)num {
    [self.grantController playNote:num];
}

- (void) playNoteOff {
    [self.grantController playNoteOff];
}

- (void) presentGame {
    [self presentViewController:self.grantController animated:YES completion:nil];
}

@end
