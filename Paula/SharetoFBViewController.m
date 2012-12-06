//
//  SharetoFBViewController.m
//  Paula
//
//  Created by Enyu Wang on 12/2/12.
//  Copyright (c) 2012 poly. All rights reserved.
//


#import "AppDelegate.h"
#import "SharetoFBViewController.h"
#import "ScoreViewController.h"
#import "PaulaUtilities.m"
#import "SHK.h"

@interface SharetoFBViewController ()

@property UILabel *title1;
@property NSInteger screenHeight;
@property NSInteger screenWidth;
@property NSInteger rowHeight;
@property UIImage *icon;
@property UIImageView *iconView;
@property UILabel *text;
@property UILabel *title2;
@property UIButton *cancelButton;
@property UIButton *loginButton;
@property NSString *sText;
- (void)configureView;

@end

@implementation SharetoFBViewController

@synthesize title1;
@synthesize screenHeight;
@synthesize screenWidth;
@synthesize rowHeight;
@synthesize icon;
@synthesize iconView;
@synthesize text;
@synthesize title2;
@synthesize cancelButton;
@synthesize loginButton = _loginButton;
@synthesize scoreShare = _scoreShare;
@synthesize sText;

- (void) setKey:(id)newKey
{
    if (_scoreShare != newKey) {
        _scoreShare = newKey;
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    if (self.scoreShare)
        self.sText = self.scoreShare;
    self.text = [[UILabel alloc] initWithFrame:CGRectMake(128, 165, 172, 50)];
    [self.text setBackgroundColor:[UIColor colorWithRed:0.2 green:0.4 blue:1.0 alpha:1.0]];
    self.text.textAlignment = UITextAlignmentCenter;
    self.text.text = [[NSString alloc] initWithFormat:@"I got %@ points.", self.sText];
    [self.view addSubview:self.text];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];    if (self) {
        // Custom initialization
        self.rowHeight = 20;
        self.screenHeight = self.view.bounds.size.height;
        self.screenWidth = self.view.bounds.size.width;
        
        [self.view setBackgroundColor:[UIColor colorWithRed:0.2 green:0.4 blue:1.0 alpha:1.0]];
        self.title1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, screenWidth-5, rowHeight)];
        [self.title1 setBackgroundColor:[UIColor colorWithRed:0.2 green:0.4 blue:1.0 alpha:1.0]];
        self.title1.textAlignment = UITextAlignmentCenter;
        self.title1.text = @"-Share to Facebook-";
        
        [self.view addSubview:self.title1];
        
        self.cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(self.screenWidth/2 - 40, self.screenHeight - 100, 80, 30)];
        
        self.cancelButton.backgroundColor = randomColor();
        [self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [self.cancelButton addTarget:self action:@selector(endGame) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:self.cancelButton];
        
        self.loginButton = [[UIButton alloc] initWithFrame:CGRectMake(self.screenWidth/2 - 40, self.screenHeight - 150, 80, 30)];
        
        self.loginButton.backgroundColor = randomColor();
        [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
        [self.loginButton addTarget:self action:@selector(performLogin) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:self.loginButton];
        
        
        icon = [UIImage imageNamed:@"icon.png"];
        iconView = [[UIImageView alloc] initWithImage:icon];
        iconView.frame = CGRectMake(20, 115, 100, 100);
        [self.view addSubview:self.iconView];
        
        self.title2 = [[UILabel alloc] initWithFrame:CGRectMake(128, 115, 172, 50)];
        [self.title2 setBackgroundColor:[UIColor colorWithRed:0.2 green:0.4 blue:1.0 alpha:1.0]];
        self.title2.textAlignment = UITextAlignmentCenter;
        self.title2.text = @"Let's beat Paula!";
        [self.view addSubview:self.title2];
    }
    return self;
}

- (void)endGame {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)performLogin
{
    //    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    //    [appDelegate openSessionWithAllowLoginUI:YES];
    NSString *line = [[NSString alloc] initWithFormat:@"%@ %@", title2.text, sText];
    SHKItem *item = [SHKItem text:line];
    SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
    [actionSheet showInView:self.loginButton];
}

- (void) viewWillAppear:(BOOL)animated
{
    [self configureView];
    [super viewWillAppear:animated];
}

- (void)viewDidUnload
{
    [self configureView];
    self.loginButton = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
