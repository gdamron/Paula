//
//  SinglePlayerViewController.m
//  Paula
//
//  Created by Grant Damron on 10/10/12.
//  Copyright (c) 2012 Grant Damron. All rights reserved.
//

#import "SinglePlayerViewController.h"
#import "Countdown.h"

#define OFFALPHA 0.5
#define BUTTONOFFSET 8.0

#define TEMP_BPM 100.0
#define TEMP_DUR 30.0
#define TEMP_LAYERS 1
#define TEMP_SECTIONS 1

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
@synthesize paula;
@synthesize game;

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
        
        [self.view addSubview:backButton];
        [self playCountdownAndStartGame];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	metronome = [[Metronome alloc] initWithBPM:TEMP_BPM AndResolution:2];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickListen:) name:@"metronomeClick" object:metronome];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [metronome turnOff];
}

- (void)clickListen:(id)sender {
    [self allNotesOff];
    Section *currentSection = game.level.song.sections[0];
    Layer *currentLayer = currentSection.layers[0];
    int index = [currentLayer.currentNote intValue];
    if (index < currentLayer.notes.count) {
        NSInteger i = [[currentLayer.notes objectAtIndex:index++] integerValue];
        if (i>0) {
            [self noteOnWithNumber:i sendMessage:NO];
        }
        currentLayer.currentNote = [NSNumber numberWithInt:index];
    } else {
        [self allNotesOff];
        [metronome turnOff];
    }
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

- (void)playCountdownAndStartGame {
    [NSTimer scheduledTimerWithTimeInterval:(3.5*(60.0/TEMP_BPM)) target:self selector:@selector(startGame) userInfo:nil repeats:NO];
    Countdown *countdown = [[Countdown alloc] initWithWidth:self.view.frame.size.width AndHeight:self.view.frame.size.height];
    UILabel *tempLabel = countdown.label;
    [self.view addSubview:tempLabel];
    [self.view bringSubviewToFront:tempLabel];
    [countdown countdownWithTempo:TEMP_BPM];
    
    
}

- (void)startGame {
    paula = [[Paula alloc] initWithDuration:TEMP_DUR Tempo:TEMP_BPM NumberOfLayers:TEMP_LAYERS AndSections:TEMP_SECTIONS];
    //melNotes = [NSArray arrayWithArray:[paula generateRandomLayer]];
    toneGen = [[ToneGenerator alloc] init];
    game = [self setupGame];
    [toneGen start];
    [metronome turnOn];
}

- (Game *)setupGame {
    Game *g = [[Game alloc] init];
    Layer *newLayer = [[Layer alloc] init];
    newLayer.notes = [[NSArray alloc] initWithArray:[paula generateRandomLayer]];
    Section *newSection = [[Section alloc] init];
    [newSection addLayer:newLayer];
    
    [g.level.song addSection:newSection];
    
    return g;

}

@end
