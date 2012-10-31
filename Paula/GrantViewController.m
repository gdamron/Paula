//
//  GrantViewController.m
//  Paula
//
//  Created by Grant Damron on 10/10/12.
//  Copyright (c) 2012 Grant Damron. All rights reserved.
//

#import "GrantViewController.h"
#import "GameServer.h"
#import "SocketDelegate.h"

@interface GrantViewController () {
    NSArray *scale;
}

@property (nonatomic) GameServer *server;
@property (nonatomic) NSError *error;
@property (strong) SocketDelegate *socketDelegate;
@property (strong) NSNetServiceBrowser *browser;
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

@synthesize server, error, socketDelegate;

- (void) setToneGen:(ToneGenerator *)tone {
    self.tone = tone;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.view.backgroundColor = [UIColor blackColor];
        scale = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:0],
                 [NSNumber numberWithInt:2],
                 [NSNumber numberWithInt:5],
                 [NSNumber numberWithInt:7],
                 [NSNumber numberWithInt:8],
                 [NSNumber numberWithInt:9],
                 [NSNumber numberWithInt:12],
                 [NSNumber numberWithInt:14], nil];
        
        CGFloat width = self.view.bounds.size.width;
        CGFloat height = self.view.bounds.size.height;
        sineButton1 = [self setupButton:sineButton1 OnScreenWithX:10 YOffset:8];
        sineButton2 = [self setupButton:sineButton2 OnScreenWithX:width/2+5 YOffset:8];
        sineButton3 = [self setupButton:sineButton3 OnScreenWithX:10 YOffset:height/4+8];
        sineButton4 = [self setupButton:sineButton4 OnScreenWithX:width/2+5 YOffset:height/4+8];
        sineButton5 = [self setupButton:sineButton5 OnScreenWithX:10 YOffset:height/2+8];
        sineButton6 = [self setupButton:sineButton6 OnScreenWithX:width/2+5 YOffset:height/2+8];
        sineButton7 = [self setupButton:sineButton7 OnScreenWithX:10 YOffset:height*.75+8];
        sineButton8 = [self setupButton:sineButton8 OnScreenWithX:width/2+5 YOffset:height*.75+8];
        backButton = [self addBackButton];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    self.server = [GameServer alloc];
    self.socketDelegate = [[SocketDelegate alloc] init];
    [self.server setDelegate:socketDelegate];
    [self.socketDelegate setGController:self];
    
    BOOL result = [server startServer:error];
    
    NSString *test = [NSString stringWithFormat:@"_%@._tcp.", @"Paula"];
    
    if(result) {
        NSLog(@"init bonjour with %@", test);
        if(![server enableBonjour:@"local" appProtocol:test name:nil]) {
            NSLog(@"bonjour failed");
        }
    }
    
    NSLog(@"Server Started : %d", result);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) backButtonPressed {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) playNote:(NSInteger)num {
    int s = 1;
    switch (num) {
        case 1: {
            [tone noteOn:220 withGain:1.0 andSoundType:s];
            break;
        }
        case 2: {
            [tone noteOn:220*(pow (2, (2.0/12))) withGain:1.0 andSoundType:s];
            break;
        }
        case 3: {
            [tone noteOn:220*(pow (2, (5.0/12))) withGain:1.0 andSoundType:s];
            break;
        }
        case 4: {
            [tone noteOn:220*(pow (2, (7.0/12))) withGain:1.0 andSoundType:s];
            break;
        }
        case 5: {
            [tone noteOn:220*(pow (2, (8.0/12))) withGain:1.0 andSoundType:s];
            break;
        }
        case 6: {
            [tone noteOn:220*(pow (2, (9.0/12))) withGain:1.0 andSoundType:s];
            break;
        }
        case 7: {
            [tone noteOn:220*(pow (2, (12.0/12))) withGain:1.0 andSoundType:s];
            break;
        }
        case 8: {
            [tone noteOn:220*(pow (2, (14.0/12))) withGain:1.0 andSoundType:s];
            break;
        }
    }
}

- (void) noteOn:(id)sender {
    int s = 1;
    int index = 0;
    if (sender==sineButton1) {
        [tone noteOn:220 withGain:1.0 andSoundType:s];
        [self.socketDelegate send:'1'];
    }
    if (sender==sineButton2) {
        [tone noteOn:220*(pow (2, (2.0/12))) withGain:1.0 andSoundType:s];
        [self.socketDelegate send:'2'];
    }
    if (sender==sineButton3) {
        [tone noteOn:220*(pow (2, (5.0/12))) withGain:1.0 andSoundType:s];
        [self.socketDelegate send:'3'];
    }
    if (sender==sineButton4) {
        [tone noteOn:220*(pow (2, (7.0/12))) withGain:1.0 andSoundType:s];
        [self.socketDelegate send:'4'];
    }
    if (sender==sineButton5) {
        [tone noteOn:220*(pow (2, (8.0/12))) withGain:1.0 andSoundType:s];
        [self.socketDelegate send:'5'];
    }
    if (sender==sineButton6) {
        [tone noteOn:220*(pow (2, (9.0/12))) withGain:1.0 andSoundType:s];
        [self.socketDelegate send:'6'];
    }
    if (sender==sineButton7) {
        [tone noteOn:220*(pow (2, (12.0/12))) withGain:1.0 andSoundType:s];
        [self.socketDelegate send:'7'];
    }
    if (sender==sineButton8) {
        [tone noteOn:220*(pow (2, (14.0/12))) withGain:1.0 andSoundType:s];
        [self.socketDelegate send:'8'];
    }
    [tone noteOn:220*(pow (2, ([[scale objectAtIndex:index]intValue])/12.0)) withGain:1.0 andSoundType:s];
}

- (void)noteOff:(id)sender {
    int index = 0;
    if (sender==sineButton1) {
        index = 0;
        sineButton1.alpha = 0.8;
    } else if (sender==sineButton2) {
        index = 1;
        sineButton2.alpha = 0.8;
    } else if (sender==sineButton3) {
        index = 2;
        sineButton3.alpha = 0.8;
    } else if (sender==sineButton4) {
        index = 3;
        sineButton4.alpha = 0.8;
    } else if (sender==sineButton5) {
        index = 4;
        sineButton5.alpha = 0.8;
    } else if (sender==sineButton6) {
        index = 5;
        sineButton6.alpha = 0.8;
    } else if (sender==sineButton7) {
        index = 6;
        sineButton7.alpha = 0.8;
    } else if (sender==sineButton8) {
        index = 7;
        sineButton8.alpha = 0.8;
    }
    [tone noteOff:220*(pow (2, ([[scale objectAtIndex:index]intValue])/12.0))];
}

- (void) playNoteOff {
    [tone noteOff];
}

- (void)noteOff {
    [tone noteOff];
    [self.socketDelegate send:'0'];
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
    [back addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    return back;
}

- (UIButton *)setupButton:(UIButton *)sender OnScreenWithX:(int)x YOffset:(int)y {
    CGFloat width = self.view.bounds.size.width;
    CGFloat height = self.view.bounds.size.height;
    sender = [UIButton buttonWithType:UIButtonTypeCustom];
    sender.backgroundColor = [UIColor colorWithRed:(rand()%10)/10.0 green:(rand()%10)/10.0 blue:(rand()%10)/10.0 alpha:1.0];
    [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sender.frame = CGRectMake(x, y, width/2-15, (height-15)/4-10);
    [sender setTitle:nil forState:UIControlStateNormal];
    [self.view addSubview:sender];
    [sender addTarget:self action:@selector(noteOn:) forControlEvents:UIControlEventTouchDown|UIControlEventTouchDragEnter];
    [sender addTarget:self action:@selector(noteOff:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside|UIControlEventTouchDragExit];
    return sender;
}



@end
