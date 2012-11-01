//
//  GrantViewController.m
//  Paula
//
//  Created by Grant Damron on 10/10/12.
//  Copyright (c) 2012 Grant Damron. All rights reserved.
//

#import "GrantViewController.h"
#import "GameServer.h"
#import "GameClient.h"
#import "SocketDelegate.h"

#define OFFALPHA 0.5
#define BUTTONOFFSET 8.0

@interface GrantViewController () {
    NSArray *scale;
    int melIndex;
    double totalDur;
}

@property (nonatomic) GameServer *server;
@property (nonatomic) GameClient *client;
@property (nonatomic) SocketDelegate *socketDelegate;
@property (strong) NSNetServiceBrowser *browser;
@property (nonatomic) NSError *error;
@property (assign) BOOL isServer;
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
@synthesize isServer;

@synthesize server, error;

- (id)initWithType:(GameTypeCode)code {
    if(code == ServerMode) {
        self = [self initWithNibName:nil bundle:nil];
        self.server = [[GameServer alloc] initWithController:self];
        self.socketDelegate = [self.server getSocketDelegate];
        isServer = YES;
    } else if (code == ClientMode) {
        self = [self initWithNibName:nil bundle:nil];
        self.client = [[GameClient alloc] initWithController:self];
        self.socketDelegate = [self.client getSocketDelegate];
        isServer = NO;
    }
    return self;
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
        
        sineButton1 = [self setupButton:sineButton1 OnScreenWithX:10 YOffset:BUTTONOFFSET andNumber:1];
        sineButton2 = [self setupButton:sineButton2 OnScreenWithX:width/2+5 YOffset:BUTTONOFFSET andNumber:2];
        sineButton3 = [self setupButton:sineButton3 OnScreenWithX:10 YOffset:height/4+BUTTONOFFSET andNumber:3];
        sineButton4 = [self setupButton:sineButton4 OnScreenWithX:width/2+5 YOffset:height/4+BUTTONOFFSET andNumber:4];
        sineButton5 = [self setupButton:sineButton5 OnScreenWithX:10 YOffset:height/2+BUTTONOFFSET andNumber:5];
        sineButton6 = [self setupButton:sineButton6 OnScreenWithX:width/2+5 YOffset:height/2+BUTTONOFFSET andNumber:6];
        sineButton7 = [self setupButton:sineButton7 OnScreenWithX:10 YOffset:height*.75+BUTTONOFFSET andNumber:7];
        sineButton8 = [self setupButton:sineButton8 OnScreenWithX:width/2+5 YOffset:height*.75+BUTTONOFFSET andNumber:8];
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


- (void) noteOnWithNumber:(NSInteger)num {
    int s = 1;
    
    if (num==1) {
        sineButton1.alpha = 1.0;
        if (isServer) [self.socketDelegate send:'1'];
    } else if (num==2) {
        sineButton2.alpha = 1.0;
        if (isServer) [self.socketDelegate send:'2'];
    } else if (num==3) {
        sineButton3.alpha = 1.0;
        if (isServer) [self.socketDelegate send:'3'];
    } else if (num==4) {
        sineButton4.alpha = 1.0;
        if (isServer) [self.socketDelegate send:'4'];
    } else if (num==5) {
        sineButton5.alpha = 1.0;
        if (isServer) [self.socketDelegate send:'5'];
    } else if (num==6) {
        sineButton6.alpha = 1.0;
        if (isServer) [self.socketDelegate send:'6'];
    } else if (num==7) {
        sineButton7.alpha = 1.0;
        if (isServer) [self.socketDelegate send:'7'];
    } else if (num==8) {
        sineButton8.alpha = 1.0;
        if (isServer) [self.socketDelegate send:'8'];
        
    }
    
    /*if (isServer) {
        unsigned char socketChar = (unsigned char) num;
        [self.socketDelegate send:socketChar];
    }*/
    [toneGen noteOn:220*(pow (2, ([[scale objectAtIndex:num-1]intValue])/12.0)) withGain:1.0 andSoundType:s];
}

- (void) noteOffWithNumber:(NSInteger)num {
    
    if (num==1) {
        sineButton1.alpha = OFFALPHA;
    } else if (num==2) {
        sineButton2.alpha = OFFALPHA;
    } else if (num==3) {
        sineButton3.alpha = OFFALPHA;
    } else if (num==4) {
        sineButton4.alpha = OFFALPHA;
    } else if (num==5) {
        sineButton5.alpha = OFFALPHA;
    } else if (num==6) {
        sineButton6.alpha = OFFALPHA;
    } else if (num==7) {
        sineButton7.alpha = OFFALPHA;
    } else if (num==8) {
        sineButton8.alpha = OFFALPHA;
    }
    
    [toneGen noteOff:220*(pow (2, ([[scale objectAtIndex:num-1]intValue])/12.0))];
    if (isServer) [self.socketDelegate send:'0'];
}

- (void)noteOn:(id)sender {
    UIButton *button = (UIButton *)sender;
    [self noteOnWithNumber:[button.titleLabel.text integerValue]];
}

- (void)noteOff:(id)sender {
    UIButton *button = (UIButton *)sender;
    [self noteOffWithNumber:[button.titleLabel.text integerValue]];
}

- (void)allNotesOff {
    sineButton1.alpha = OFFALPHA;
    sineButton2.alpha = OFFALPHA;
    sineButton3.alpha = OFFALPHA;
    sineButton4.alpha = OFFALPHA;
    sineButton5.alpha = OFFALPHA;
    sineButton6.alpha = OFFALPHA;
    sineButton7.alpha = OFFALPHA;
    sineButton8.alpha = OFFALPHA;
    [toneGen noteOff];
    if (isServer) [self.socketDelegate send:'0'];
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

- (UIButton *)setupButton:(UIButton *)sender OnScreenWithX:(int)x YOffset:(int)y andNumber:(int)num {
    CGFloat width = self.view.bounds.size.width;
    CGFloat height = self.view.bounds.size.height;
    sender = [UIButton buttonWithType:UIButtonTypeCustom];
    sender.backgroundColor = [UIColor colorWithRed:(rand()%10)/10.0 green:(rand()%10)/10.0 blue:(rand()%10)/10.0 alpha:1.0];
    [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sender.frame = CGRectMake(x, y, width/2-15, (height-15)/4-10);
    sender.titleLabel.alpha = 0.0;
    [sender setTitle:[NSString stringWithFormat:@"%d", num] forState:UIControlStateNormal];
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

@end
