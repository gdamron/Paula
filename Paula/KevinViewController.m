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
@property (strong) NSNetServiceBrowser *browser;
@end

@implementation KevinViewController

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
@synthesize error;
@synthesize server;
@synthesize socketDelegate;
@synthesize browser;

- (void) setToneGen:(ToneGenerator *)t {
    self.tone = t;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.view.backgroundColor = [UIColor blackColor];
        
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
        [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [sineButton1 addTarget:self action:@selector(noteOn:) forControlEvents:UIControlEventTouchDown];
        [sineButton1 addTarget:self action:@selector(noteOff) forControlEvents:UIControlEventTouchUpInside];
        [sineButton2 addTarget:self action:@selector(noteOn:) forControlEvents:UIControlEventTouchDown];
        [sineButton2 addTarget:self action:@selector(noteOff) forControlEvents:UIControlEventTouchUpInside];
        [sineButton3 addTarget:self action:@selector(noteOn:) forControlEvents:UIControlEventTouchDown];
        [sineButton3 addTarget:self action:@selector(noteOff) forControlEvents:UIControlEventTouchUpInside];
        [sineButton4 addTarget:self action:@selector(noteOn:) forControlEvents:UIControlEventTouchDown];
        [sineButton4 addTarget:self action:@selector(noteOff) forControlEvents:UIControlEventTouchUpInside];
        [sineButton5 addTarget:self action:@selector(noteOn:) forControlEvents:UIControlEventTouchDown];
        [sineButton5 addTarget:self action:@selector(noteOff) forControlEvents:UIControlEventTouchUpInside];
        [sineButton6 addTarget:self action:@selector(noteOn:) forControlEvents:UIControlEventTouchDown];
        [sineButton6 addTarget:self action:@selector(noteOff) forControlEvents:UIControlEventTouchUpInside];
        [sineButton7 addTarget:self action:@selector(noteOn:) forControlEvents:UIControlEventTouchDown];
        [sineButton7 addTarget:self action:@selector(noteOff) forControlEvents:UIControlEventTouchUpInside];
        [sineButton8 addTarget:self action:@selector(noteOn:) forControlEvents:UIControlEventTouchDown];
        [sineButton8 addTarget:self action:@selector(noteOff) forControlEvents:UIControlEventTouchUpInside];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSNetServiceBrowser *serviceBrowser = [[NSNetServiceBrowser alloc] init];
    
    if(serviceBrowser) {
        
        self.socketDelegate = [[SocketDelegate alloc] init];
        //[self.socketDelegate setKController:self];
        
        NSLog(@"net service browser initialized");
        serviceBrowser.delegate = self;
        self.browser = serviceBrowser;
        NSLog(@"call to searchForServicesOfType");
        NSString *test = [NSString stringWithFormat:@"_%@._tcp.", @"Paula"];
        
        NSLog(@"Search String: %@", test);
        
        [self.browser searchForServicesOfType:test inDomain:@"local"];
    } else {
        NSLog(@"Bonjour browser failed");
    }

}

- (void)didReceiveMemoryWarning {
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

- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didFindService:(NSNetService *)service moreComing:(BOOL)moreComing {

    NSLog(@"service browser found service %c", moreComing);
    
    NSLog(@"%@", service.name);
    
    NSLog(@"connecting to server...");
    [self.socketDelegate resolveInstance:service];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didFindDomain:(NSString *)domainString moreComing:(BOOL)moreComing {
    NSLog(@"domain found");
}

- (void)netServiceBrowserWillSearch:(NSNetServiceBrowser *)aNetServiceBrowser {
    NSLog(@"will search bonjour service");
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
    return sender;
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
}

- (void) playNoteOff {
    [tone noteOff];
}

- (void)noteOff {
    [tone noteOff];
    [self.socketDelegate send:'0'];
}

@end
