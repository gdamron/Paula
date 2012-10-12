//
//  GrantViewController.m
//  Paula
//
//  Created by Grant Damron on 10/10/12.
//  Copyright (c) 2012 Grant Damron. All rights reserved.
//

#import "GrantViewController.h"

@interface GrantViewController ()

@end

@implementation GrantViewController

@synthesize backButton;
@synthesize sineButton1;
@synthesize sineButton2;
@synthesize sineButton3;
@synthesize sineButton4;
@synthesize sineButton5;
@synthesize sineButton6;
@synthesize sineButton7;
@synthesize sineButton8;
@synthesize tone;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        CGFloat width = self.view.bounds.size.width;
        CGFloat height = self.view.bounds.size.height;
        tone = [[ToneGenerator alloc] init];
        backButton = [self addBackButton];
        sineButton1 = [self setupButton:sineButton1 OnScreenWithX:10 YOffset:8 AndName:@"1"];
        sineButton2 = [self setupButton:sineButton2 OnScreenWithX:width/2+5 YOffset:8 AndName:@"2"];
        sineButton3 = [self setupButton:sineButton3 OnScreenWithX:10 YOffset:height/4+8 AndName:@"3"];
        sineButton4 = [self setupButton:sineButton4 OnScreenWithX:width/2+5 YOffset:height/4+8 AndName:@"4"];
        sineButton5 = [self setupButton:sineButton5 OnScreenWithX:10 YOffset:height/2+8 AndName:@"5"];
        sineButton6 = [self setupButton:sineButton6 OnScreenWithX:width/2+5 YOffset:height/2+8 AndName:@"6"];
        sineButton7 = [self setupButton:sineButton7 OnScreenWithX:10 YOffset:height*.75+8 AndName:@"7"];
        sineButton8 = [self setupButton:sineButton8 OnScreenWithX:width/2+5 YOffset:height*.75+8 AndName:@"8"];
        [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [sineButton1 addTarget:self action:@selector(noteOn:) forControlEvents:UIControlEventTouchDown];
        [sineButton1 addTarget:self action:@selector(noteOff) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
        [sineButton2 addTarget:self action:@selector(noteOn:) forControlEvents:UIControlEventTouchDown];
        [sineButton2 addTarget:self action:@selector(noteOff) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
        [sineButton3 addTarget:self action:@selector(noteOn:) forControlEvents:UIControlEventTouchDown];
        [sineButton3 addTarget:self action:@selector(noteOff) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
        [sineButton4 addTarget:self action:@selector(noteOn:) forControlEvents:UIControlEventTouchDown];
        [sineButton4 addTarget:self action:@selector(noteOff) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
        [sineButton5 addTarget:self action:@selector(noteOn:) forControlEvents:UIControlEventTouchDown];
        [sineButton5 addTarget:self action:@selector(noteOff) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
        [sineButton6 addTarget:self action:@selector(noteOn:) forControlEvents:UIControlEventTouchDown];
        [sineButton6 addTarget:self action:@selector(noteOff) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
        [sineButton7 addTarget:self action:@selector(noteOn:) forControlEvents:UIControlEventTouchDown];
        [sineButton7 addTarget:self action:@selector(noteOff) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
        [sineButton8 addTarget:self action:@selector(noteOn:) forControlEvents:UIControlEventTouchDown];
        [sineButton8 addTarget:self action:@selector(noteOff) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
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

- (void) noteOn:(id)sender {
    if (sender==sineButton1) {
        [tone noteOn:440 withGain:1.0];
    }
    if (sender==sineButton2) {
        [tone noteOn:440*(pow (2, (2.0/12))) withGain:1.0];
    }
    if (sender==sineButton3) {
        [tone noteOn:440*(pow (2, (3.0/12))) withGain:1.0];
    }
    if (sender==sineButton4) {
        [tone noteOn:440*(pow (2, (5.0/12))) withGain:1.0];
    }
    if (sender==sineButton5) {
        [tone noteOn:440*(pow (2, (7.0/12))) withGain:1.0];
    }
    if (sender==sineButton6) {
        [tone noteOn:440*(pow (2, (9.0/12))) withGain:1.0];
    }
    if (sender==sineButton7) {
        [tone noteOn:440*(pow (2, (10.0/12))) withGain:1.0];
    }
    if (sender==sineButton8) {
        [tone noteOn:880 withGain:1.0];
    }
}

- (void)noteOff {
    [tone noteOff];
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

- (UIButton *)setupButton:(UIButton *)sender OnScreenWithX:(int)x YOffset:(int)y AndName:(NSString *)name{
    CGFloat width = self.view.bounds.size.width;
    CGFloat height = self.view.bounds.size.height;
    sender = [UIButton buttonWithType:UIButtonTypeCustom];
    sender.backgroundColor = [UIColor colorWithRed:0.25 green:1.0 blue:0.5 alpha:1.0];
    [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sender.frame = CGRectMake(x, y, width/2-15, (height-15)/4-10);
    [sender setTitle:name forState:UIControlStateNormal];
    [self.view addSubview:sender];
    return sender;
}



@end
