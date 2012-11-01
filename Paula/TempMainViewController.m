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
@synthesize toGrant;
@synthesize toKevin;
@synthesize enyuViewController;
@synthesize eugeneViewController;
@synthesize grantViewController;
@synthesize networkViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        CGFloat width = self.view.bounds.size.width;
        CGFloat height = self.view.bounds.size.height;
        
        [self.view setBackgroundColor:[UIColor colorWithRed:0.2 green:0.4 blue:1.0 alpha:1.0]];
        
        enyuViewController = [[EnyuViewController alloc] init];
        eugeneViewController = [[EugeneViewController alloc] init];
        
        toEnyu = setupMenuButton(toEnyu, 1, @"Enyu", width, height);
        [toEnyu addTarget:self action:@selector(nameButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        toEugene = setupMenuButton(toEugene, 2, @"Eugene", width, height);
        [toEugene addTarget:self action:@selector(nameButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        toGrant = setupMenuButton(toGrant, 3, @"Grant", width, height);
        [toGrant addTarget:self action:@selector(nameButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        toKevin = setupMenuButton(toKevin, 4, @"Multi-Player", width, height);
        [toKevin addTarget:self action:@selector(nameButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:setupLogo(width, height)];
        [self.view addSubview:toEnyu];
        [self.view addSubview:toEugene];
        [self.view addSubview:toGrant];
        [self.view addSubview:toKevin];
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
        [self presentViewController:enyuViewController animated:YES completion:nil];
    } else if (sender==toEugene) {
        [self presentViewController:eugeneViewController animated:YES completion:nil];
    } else if (sender==toGrant) {
        grantViewController = [[GrantViewController alloc] init];
        [self presentViewController:grantViewController animated:YES completion:nil];
    } else if (sender==toKevin) {
        networkViewController = [[NetworkViewController alloc] init];
        [self presentViewController:networkViewController animated:NO completion:nil];
    }
}

@end
