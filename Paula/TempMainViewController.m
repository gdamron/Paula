//
//  TempMainViewController.m
//  Paula
//
//  Created by Grant Damron on 10/10/12.
//  Copyright (c) 2012 Grant Damron. All rights reserved.
//

#import "TempMainViewController.h"

@interface TempMainViewController ()
@property (strong) ToneGenerator *tone;
@end


@implementation TempMainViewController

@synthesize toEnyu;
@synthesize toEugene;
@synthesize toSinglePlayer;
@synthesize toMultiPlayer;
@synthesize enyuViewController;
@synthesize eugeneViewController;
@synthesize singlePlayerViewController;
@synthesize networkViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        CGFloat width = self.view.bounds.size.width;
        CGFloat height = self.view.bounds.size.height;
        
        [self.view setBackgroundColor:[UIColor colorWithRed:0.2 green:0.4 blue:1.0 alpha:1.0]];
        
        toSinglePlayer = setupMenuButton(toSinglePlayer, 1, @"Single Player", width, height);
        [toSinglePlayer addTarget:self action:@selector(nameButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        toMultiPlayer = setupMenuButton(toMultiPlayer, 2, @"Multi-Player", width, height);
        [toMultiPlayer addTarget:self action:@selector(nameButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        toEnyu = setupMenuButton(toEnyu, 3, @"Enyu", width, height);
        [toEnyu addTarget:self action:@selector(nameButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        toEugene = setupMenuButton(toEugene, 4, @"Eugene", width, height);
        [toEugene addTarget:self action:@selector(nameButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:setupLogo(width, height)];
        [self.view addSubview:toEnyu];
        [self.view addSubview:toEugene];
        [self.view addSubview:toSinglePlayer];
        [self.view addSubview:toMultiPlayer];
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
        enyuViewController = [[EnyuViewController alloc] init];
        [self presentViewController:enyuViewController animated:YES completion:nil];
    } else if (sender==toEugene) {
        eugeneViewController = [[EugeneViewController alloc] init];
        [self presentViewController:eugeneViewController animated:YES completion:nil];
    } else if (sender==toSinglePlayer) {
        singlePlayerViewController = [[SinglePlayerViewController alloc] init];
        [self presentViewController:singlePlayerViewController animated:YES completion:nil];
    } else if (sender==toMultiPlayer) {
        networkViewController = [[NetworkViewController alloc] init];
        [self presentViewController:networkViewController animated:NO completion:nil];
    }
}

@end
