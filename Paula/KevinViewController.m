//
//  KevinViewController.m
//  Paula
//
//  Created by Grant Damron on 10/10/12.
//  Copyright (c) 2012 Grant Damron. All rights reserved.
//

#import "KevinViewController.h"
#import "GameServer.h"
#import "SocketDelegate.h"

@interface KevinViewController ()
@property (nonatomic) NSError *error;
@property (strong) SocketDelegate *socketDelegate;
@end

@implementation KevinViewController

@synthesize backButton;
@synthesize error;
@synthesize server;
@synthesize socketDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        backButton = [self addBackButton];
        [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
//        server = [GameServer alloc];
//        socketDelegate = [[SocketDelegate alloc] init];
//        [server setDelegate:socketDelegate];
//        
//        BOOL result = [server startServer:error];
//        
//        NSLog(@"Server Started : %d", result);
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

- (UIButton *) addBackButton {
    //CGFloat width = self.view.bounds.size.width;
    CGFloat height = self.view.bounds.size.height;
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.backgroundColor = [UIColor colorWithRed:0.25 green:1.0 blue:0.5 alpha:1.0];
    [back setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    back.frame = CGRectMake(16, height-32, 32, 16);
    [back setTitle:@"<<" forState:UIControlStateNormal];
    [self.view addSubview:back];
    return back;
}

- (void) backButtonPressed {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
