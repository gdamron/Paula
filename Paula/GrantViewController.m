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

#define OFFALPHA 0.5;

@interface GrantViewController () {
    NSArray *scale;
    int melIndex;
    double totalDur;
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
@synthesize toneGen;

@synthesize server, error, socketDelegate;

- (id)initWithType:(GameTypeCode)code {
    if(code == ServerMode) {
        self = [self initWithNibName:nil bundle:nil];
        [self startAsServer];
    } else if (code == ClientMode) {
        self = [self initWithNibName:nil bundle:nil];
        [self startAsClient];
    }
    return self;
}

- (void) startAsServer {
    self.server = [GameServer alloc];
    self.socketDelegate = [[SocketDelegate alloc] init];
    [self.server setDelegate:socketDelegate];
    [self.socketDelegate setController:self];
    
    BOOL result = [server startServer:error];
    
    NSString *test = [NSString stringWithFormat:@"_%@._tcp.", @"Paula"];

    if(result) {
        NSLog(@"init bonjour with %@", test);
    }
    if(![server enableBonjour:@"local" appProtocol:test name:nil]) {
        NSLog(@"bonjour failed");
    }
       
    NSLog(@"Server Started : %d", result);
}

- (void) startAsClient {
    NSNetServiceBrowser *serviceBrowser = [[NSNetServiceBrowser alloc] init];
    
    if(serviceBrowser) {
        
        self.socketDelegate = [[SocketDelegate alloc] init];
        [self.socketDelegate setController:self];
        
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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        melIndex = 0;
        totalDur = 0.0;
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
        toneGen = [[ToneGenerator alloc] init];
        
        sineButton1 = [self setupButton:sineButton1 OnScreenWithX:10 YOffset:8];
        sineButton2 = [self setupButton:sineButton2 OnScreenWithX:width/2+5 YOffset:8];
        sineButton3 = [self setupButton:sineButton3 OnScreenWithX:10 YOffset:height/4+8];
        sineButton4 = [self setupButton:sineButton4 OnScreenWithX:width/2+5 YOffset:height/4+8];
        sineButton5 = [self setupButton:sineButton5 OnScreenWithX:10 YOffset:height/2+8];
        sineButton6 = [self setupButton:sineButton6 OnScreenWithX:width/2+5 YOffset:height/2+8];
        sineButton7 = [self setupButton:sineButton7 OnScreenWithX:10 YOffset:height*.75+8];
        sineButton8 = [self setupButton:sineButton8 OnScreenWithX:width/2+5 YOffset:height*.75+8];
        backButton = [self addBackButton];
        //[toneGen start];
        
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
    //[toneGen stop];
    melIndex = 0;
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void) playNote:(NSInteger)num {
    int s = 1;
    if (num==1) {
        sineButton1.alpha = 1.0;
    } else if (num==2) {
        sineButton2.alpha = 1.0;
    } else if (num==3) {
        sineButton3.alpha = 1.0;
    } else if (num==4) {
        sineButton4.alpha = 1.0;
    } else if (num==5) {
        sineButton5.alpha = 1.0;
    } else if (num==6) {
        sineButton6.alpha = 1.0;
    } else if (num==7) {
        sineButton7.alpha = 1.0;
    } else if (num==8) {
        sineButton8.alpha = 1.0;
    }
    [toneGen noteOn:220*(pow (2, ([[scale objectAtIndex:num-1]intValue])/12.0)) withGain:1.0 andSoundType:s];
}

- (void) noteOn:(id)sender {
    int s = 1;
    int index = 0;
    if (sender==sineButton1) {
        index = 0;
        sineButton1.alpha = 1.0;
        [self.socketDelegate send:'1'];
    }
    if (sender==sineButton2) {
        index = 1;
        sineButton2.alpha = 1.0;
        [self.socketDelegate send:'2'];
    }
    if (sender==sineButton3) {
        index = 2;
        sineButton3.alpha = 1.0;
        [self.socketDelegate send:'3'];
    }
    if (sender==sineButton4) {
        index = 3;
        sineButton4.alpha = 1.0;
        [self.socketDelegate send:'4'];
    }
    if (sender==sineButton5) {
        index = 4;
        sineButton5.alpha = 1.0;
        [self.socketDelegate send:'5'];
    }
    if (sender==sineButton6) {
        index = 5;
        sineButton6.alpha = 1.0;
        [self.socketDelegate send:'6'];
    }
    if (sender==sineButton7) {
        index = 6;
        sineButton7.alpha = 1.0;
        [self.socketDelegate send:'7'];
    }
    if (sender==sineButton8) {
        index = 7;
        sineButton8.alpha = 1.0;
        [self.socketDelegate send:'8'];
    }
    [toneGen noteOn:220*(pow (2, ([[scale objectAtIndex:index]intValue])/12.0)) withGain:1.0 andSoundType:s];
}

- (void)noteOff:(id)sender {
    int index = 0;
    if (sender==sineButton1) {
        index = 0;
        sineButton1.alpha = OFFALPHA;
    } else if (sender==sineButton2) {
        index = 1;
        sineButton2.alpha = OFFALPHA;
    } else if (sender==sineButton3) {
        index = 2;
        sineButton3.alpha = OFFALPHA;
    } else if (sender==sineButton4) {
        index = 3;
        sineButton4.alpha = OFFALPHA;
    } else if (sender==sineButton5) {
        index = 4;
        sineButton5.alpha = OFFALPHA;
    } else if (sender==sineButton6) {
        index = 5;
        sineButton6.alpha = OFFALPHA;
    } else if (sender==sineButton7) {
        index = 6;
        sineButton7.alpha = OFFALPHA;
    } else if (sender==sineButton8) {
        index = 7;
        sineButton8.alpha = OFFALPHA;
    }
    [toneGen noteOff:220*(pow (2, ([[scale objectAtIndex:index]intValue])/12.0))];
    [self.socketDelegate send:'0'];
}

- (void)playNoteOff {
        sineButton1.alpha = OFFALPHA;
        sineButton2.alpha = OFFALPHA;
        sineButton3.alpha = OFFALPHA;
        sineButton4.alpha = OFFALPHA;
        sineButton5.alpha = OFFALPHA;
        sineButton6.alpha = OFFALPHA;
        sineButton7.alpha = OFFALPHA;
        sineButton8.alpha = OFFALPHA;
    
    [toneGen noteOff];
}

- (void)noteOff {
    [toneGen noteOff];
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
    sender.alpha = OFFALPHA;
    return sender;
}


/*- (void) playMelody {
    NSArray *durs = [[NSArray alloc] initWithObjects:
                     [NSNumber numberWithDouble:0.5],
                     [NSNumber numberWithDouble:0.5],
                     [NSNumber numberWithDouble:0.25],
                     [NSNumber numberWithDouble:0.5],
                     [NSNumber numberWithDouble:0.25],
                     [NSNumber numberWithDouble:0.25],
                     [NSNumber numberWithDouble:0.25],
                     [NSNumber numberWithDouble:0.5],
                     [NSNumber numberWithDouble:0.25],
                     [NSNumber numberWithDouble:0.5],
                     [NSNumber numberWithDouble:0.25],
                     [NSNumber numberWithDouble:1.0],
                     nil];
    
    for (int i = 0; i < durs.count; i++) {
        double dur = (60.0/80.0) * [[durs objectAtIndex:i] doubleValue];
        [NSTimer scheduledTimerWithTimeInterval:totalDur target:self selector:@selector(melNoteOn:) userInfo:nil repeats:NO];
        totalDur += dur;
        [NSTimer scheduledTimerWithTimeInterval:totalDur target:self selector:@selector(melNoteOff:) userInfo:nil repeats:NO];
    }
    melIndex = 0;
}

- (void)melNoteOn:(NSTimer *)theTimer {
    NSArray *melNotes = [[NSArray alloc] initWithObjects:
                         [NSNumber numberWithInt:2],
                         [NSNumber numberWithInt:1],
                         [NSNumber numberWithInt:2],
                         [NSNumber numberWithInt:3],
                         [NSNumber numberWithInt:4],
                         [NSNumber numberWithInt:4],
                         [NSNumber numberWithInt:5],
                         [NSNumber numberWithInt:6],
                         [NSNumber numberWithInt:7],
                         [NSNumber numberWithInt:8],
                         [NSNumber numberWithInt:7],
                         [NSNumber numberWithInt:8],
                         nil];
    NSInteger i = [[melNotes objectAtIndex:melIndex] integerValue];
    [self noteOnWithNumber:i];
   
}

- (void)melNoteOff:(NSTimer *)theTimer {
    NSArray *melNotes = [[NSArray alloc] initWithObjects:
                         [NSNumber numberWithInt:2],
                         [NSNumber numberWithInt:1],
                         [NSNumber numberWithInt:2],
                         [NSNumber numberWithInt:3],
                         [NSNumber numberWithInt:4],
                         [NSNumber numberWithInt:4],
                         [NSNumber numberWithInt:5],
                         [NSNumber numberWithInt:6],
                         [NSNumber numberWithInt:7],
                         [NSNumber numberWithInt:8],
                         [NSNumber numberWithInt:7],
                         [NSNumber numberWithInt:8],
                         nil];
    NSInteger i = [[melNotes objectAtIndex:melIndex++] integerValue];
    [self playNoteOff];
}*/

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

@end
