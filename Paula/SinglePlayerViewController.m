//
//  SinglePlayerViewController.m
//  Paula
//
//  Created by Grant Damron on 10/10/12.
//  Copyright (c) 2012 Grant Damron. All rights reserved.
//

#import "SinglePlayerViewController.h"

#define OFFALPHA 0.5
#define BUTTONOFFSET 8.0

@interface SinglePlayerViewController () {
    // These are all temporary
    NSArray *scale;
    // used for keeping track of time while a melody plays
    int melIndex;
    double totalDur;
    //Metronome *met;
    NSArray *melNotes;
}

@property (strong) NSNetServiceBrowser *browser;
@property (nonatomic) NSError *error;
@property (assign) BOOL isMultiPlayerMode;
@end

@implementation SinglePlayerViewController

@synthesize controller=_controller;
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
@synthesize isMultiPlayerMode;
@synthesize metronome;

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
        
        sineButton1 = [self setupButton:sineButton1 OnScreenWithX:10 YOffset:BUTTONOFFSET andNumber:1];
        sineButton2 = [self setupButton:sineButton2 OnScreenWithX:width/2+5 YOffset:BUTTONOFFSET andNumber:2];
        sineButton3 = [self setupButton:sineButton3 OnScreenWithX:10 YOffset:height/4+BUTTONOFFSET andNumber:3];
        sineButton4 = [self setupButton:sineButton4 OnScreenWithX:width/2+5 YOffset:height/4+BUTTONOFFSET andNumber:4];
        sineButton5 = [self setupButton:sineButton5 OnScreenWithX:10 YOffset:height/2+BUTTONOFFSET andNumber:5];
        sineButton6 = [self setupButton:sineButton6 OnScreenWithX:width/2+5 YOffset:height/2+BUTTONOFFSET andNumber:6];
        sineButton7 = [self setupButton:sineButton7 OnScreenWithX:10 YOffset:height*.75+BUTTONOFFSET andNumber:7];
        sineButton8 = [self setupButton:sineButton8 OnScreenWithX:width/2+5 YOffset:height*.75+BUTTONOFFSET andNumber:8];

        backButton = addBackButton(width, height);
        [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:backButton];;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickListen:) name:@"metronomeClick" object:metronome];
    // for testing out melody playback with metronome
    melNotes = [[NSArray alloc] initWithObjects:
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
    toneGen = [[ToneGenerator alloc] init];
    [toneGen start];
	metronome = [[Metronome alloc] initWithBPM:80.0 AndResolution:2];
    [metronome turnOn];
}

- (void)viewDidDisappear:(BOOL)animated {
    [metronome turnOff];
}

- (void)clickListen:(id)sender {
    /*[self allNotesOff];*/
    NSLog(@"Click!");
    /*NSInteger i = [[melNotes objectAtIndex:melIndex++] integerValue];
    [self noteOnWithNumber:i sendMessage:NO];
    if (melIndex >= melNotes.count) {
        melIndex = 0;
    }*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Back to the main view controller
- (void) backButtonPressed {
    //[toneGen stop];
    melIndex = 0;
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void) noteOnWithNumber:(NSInteger)num sendMessage:(BOOL)send {
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
    
    if(send) {
        uint8_t c = 0;
        switch (num) {
                case 1: c = '1'; break;
                case 2: c = '2'; break;
                case 3: c = '3'; break;
                case 4: c = '4'; break;
                case 5: c = '5'; break;
                case 6: c = '6'; break;
                case 7: c = '7'; break;
                case 8: c = '8'; break;
        }
        [self.controller send:c];
    }
    [toneGen noteOn:220*(pow (2, ([[scale objectAtIndex:num-1]intValue])/12.0)) withGain:1.0 andSoundType:s];
}

- (void) noteOffWithNumber:(NSInteger)num sendMessage:(BOOL)send {
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
    if(send) {
        [self.controller send:'0'];
    }
    [toneGen noteOff:220*(pow (2, ([[scale objectAtIndex:num-1]intValue])/12.0))];
}

// wrapper for noteOnWithNumber, used by UIButtons
- (void)noteOn:(id)sender {
    UIButton *button = (UIButton *)sender;
    [self noteOnWithNumber:[button.titleLabel.text integerValue] sendMessage:YES];
}

// wrapper for noteOffWithNumber, used by UIButtons
- (void)noteOff:(id)sender {
    UIButton *button = (UIButton *)sender;
    [self noteOffWithNumber:[button.titleLabel.text integerValue] sendMessage:YES];
}

// Stops all tones currently playing.  Bonjour currently uses this
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
}


// The small button in the bottom left of the screen, which will eventually disappear
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

// The individual tiles
- (UIButton *)setupButton:(UIButton *)sender OnScreenWithX:(int)x YOffset:(int)y andNumber:(int)num {
    CGFloat width = self.view.bounds.size.width;
    CGFloat height = self.view.bounds.size.height;
    sender = [UIButton buttonWithType:UIButtonTypeCustom];
    sender.backgroundColor = [UIColor colorWithRed:(arc4random()%11)/10.0 green:(arc4random()%11)/10.0 blue:(arc4random()%11)/10.0 alpha:1.0];
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


/*----------------EXPERIMENTING WITH MELODY PLAYBACK---------------------*/

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
