//
//  GrantViewController.m
//  Paula
//
//  Created by Grant Damron on 10/10/12.
//  Copyright (c) 2012 Grant Damron. All rights reserved.
//

#import "GrantViewController.h"

#define OFFALPHA 0.5;

@interface GrantViewController () {
    NSArray *scale;
    int melIndex;
    double totalDur;
}

@property (strong) NSNetServiceBrowser *browser;
@property (nonatomic) NSError *error;
@end

@implementation GrantViewController

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

        backButton = addBackButton(width, height);
        [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:backButton];
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
        [self.controller send:'1'];
    }
    if (sender==sineButton2) {
        index = 1;
        sineButton2.alpha = 1.0;
        [self.controller send:'2'];
    }
    if (sender==sineButton3) {
        index = 2;
        sineButton3.alpha = 1.0;
        [self.controller send:'3'];
    }
    if (sender==sineButton4) {
        index = 3;
        sineButton4.alpha = 1.0;
        [self.controller send:'4'];
    }
    if (sender==sineButton5) {
        index = 4;
        sineButton5.alpha = 1.0;
        [self.controller send:'5'];
    }
    if (sender==sineButton6) {
        index = 5;
        sineButton6.alpha = 1.0;
        [self.controller send:'6'];
    }
    if (sender==sineButton7) {
        index = 6;
        sineButton7.alpha = 1.0;
        [self.controller send:'7'];
    }
    if (sender==sineButton8) {
        index = 7;
        sineButton8.alpha = 1.0;
        [self.controller send:'8'];
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
    [self.controller send:'0'];
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
    [self.controller send:'0'];
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

@end
