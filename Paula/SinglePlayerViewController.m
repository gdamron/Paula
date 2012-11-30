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
#define BUTTONOFFSET 2.0

#define TEMP_BPM 100.0
#define TEMP_DUR 10.0
#define TEMP_LAYERS 3
#define TEMP_SECTIONS 1

#pragma mark - SinglePlayerViewController private interface
@interface SinglePlayerViewController () {
    // These are all temporary
    NSArray *scale;
    double totalDur;
    NSArray *melNotes;
}

@property (strong) NSNetServiceBrowser *browser;
@property (nonatomic) NSError *error;
@property (assign) BOOL isMultiPlayerMode;
@property (strong, nonatomic) GameOver *gameOver;
@property (nonatomic) NSNumber *currentInstrument;
@end

#pragma mark - SinglePlayerViewController inplementation
@implementation SinglePlayerViewController

//@synthesize controller=_controller;
@synthesize backButton;
@synthesize sineButton1;
@synthesize sineButton2;
@synthesize sineButton3;
@synthesize sineButton4;
@synthesize sineButton5;
@synthesize sineButton6;
@synthesize sineButton7;
@synthesize sineButton8;
@synthesize scoreDisplay;
@synthesize mistakesLeftDisplay;
@synthesize toneGen;
@synthesize isMultiPlayerMode;
@synthesize metronome;
@synthesize game;
@synthesize currentInstrument;
@synthesize gameOver;
@synthesize delegate=_delegate;

//////////////////  NOTE ON AND OFF /////////////
#pragma mark - Note on and Off Methods

//
//  noteOnWithNumber
//
//  take tile number and whether or not to send over network as input and
//  add a tone to the stack
//
- (void) noteOnWithNumber:(NSInteger)num sendMessage:(BOOL)send {
    Section *section = game.level.sections[[game.level.currentSection intValue]];
    int s = [section.currentLayer intValue];
    [self noteOnWithNumber:num sendMessage:send AndSoundType:s];
}

//
//  noteOffWithNumber
//
//  take tile number and whether or not to send over network as input and
//  remove a tone from the stack
//
- (void) noteOffWithNumber:(NSInteger)num sendMessage:(BOOL)send {
    Section *section = game.level.sections[[game.level.currentSection intValue]];
    int s = [section.currentLayer intValue];
    [self noteOffWithNumber:num sendMessage:send AndSoundType:s];
}

- (void)noteOnWithNumber:(NSInteger)num sendMessage:(BOOL)send AndSoundType:(NSInteger)s {
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
        //        [self.controller send:c];
    }
    [toneGen noteOn:220*(pow (2, ([[scale objectAtIndex:num-1]intValue])/12.0)) withGain:1.0 andSoundType:s];
    
    if (![game isPaulasTurn] ) 
        [game addPlayerInput:num];
}

// keeping this separate until after merging branches
- (void)noteOnNoLightWithNumber:(NSInteger)num sendMessage:(BOOL)send AndSoundType:(NSInteger)s {
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
        //        [self.controller send:c];
    }
    [toneGen noteOn:220*(pow (2, ([[scale objectAtIndex:num-1]intValue])/12.0)) withGain:1.0 andSoundType:s];
    
    if (![game isPaulasTurn] )
        [game addPlayerInput:num];
}

- (void)noteOffWithNumber:(NSInteger)num sendMessage:(BOOL)send AndSoundType:(NSInteger)s {
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
        //        [self.controller send:'0'];
    }
    [toneGen noteOff:220*(pow (2, ([[scale objectAtIndex:num-1]intValue])/12.0))withSoundType:s];
    
    if (![game isPaulasTurn])
        [self checkContinueConditions];
}

// keeping this separate until after merging branches
- (void)noteOffNoLightWithNumber:(NSInteger)num sendMessage:(BOOL)send AndSoundType:(NSInteger)s {
    if(send) {
        //        [self.controller send:'0'];
    }
    [toneGen noteOff:220*(pow (2, ([[scale objectAtIndex:num-1]intValue])/12.0))withSoundType:s];
    
    if (![game isPaulasTurn])
        [self checkContinueConditions];
}

//
//  noteOn
//
//  wrapper for noteOnWithNumber, used by UIButtons
//
- (void)noteOn:(id)sender {
    UIButton *button = (UIButton *)sender;
    [self noteOnWithNumber:[button.titleLabel.text integerValue] sendMessage:NO];
}

//
//  noteOff
//
//  wrapper for noteOffWithNumber, used by UIButtons
//
- (void)noteOff:(id)sender {
    UIButton *button = (UIButton *)sender;
    [self noteOffWithNumber:[button.titleLabel.text integerValue] sendMessage:NO];
}

//
//  allNotesOff
//
//  Stops all tones currently playing.  Bonjour currently uses this
//
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

//////////////// GAME MECHANICS ///////////////
#pragma mark - Game Mechanics

//
//  playCountdownAndStartGame
//
//  Show countdown in tempo and then start game
//
- (void)playCountdownAndStartGame {
    [self playCountdownWithSelector:@selector(startGame)];
}

- (void)playCountdownAndContinueGame {
    [self playCountdownWithSelector:@selector(continueGame)];
}

- (void)playCountdownWithSelector:(SEL)sel {
    [NSTimer scheduledTimerWithTimeInterval:(3.25*(60.0/TEMP_BPM)) target:self selector:sel userInfo:nil repeats:NO];
    Countdown *countdown = [[Countdown alloc] initWithWidth:self.view.frame.size.width AndHeight:self.view.frame.size.height];
    UILabel *tempLabel = countdown.label;
    [self.view addSubview:tempLabel];
    [self.view bringSubviewToFront:tempLabel];
    [countdown countdownWithTempo:TEMP_BPM];
}

//
//  startGame
//
//  Instantiate Paula, turn on Tone Generator, turn on metronome
//
- (void)startGame {
    game.paula = [[Paula alloc] initWithDuration:TEMP_DUR Tempo:TEMP_BPM NumberOfLayers:TEMP_LAYERS AndSections:TEMP_SECTIONS];
    toneGen = [[ToneGenerator3 alloc] init];
    [self setupGame];
    [toneGen start];
    Section *section = game.level.sections[[game.level.currentSection intValue]];
    currentInstrument = [NSNumber numberWithInt:[section.currentLayer intValue]];
    [metronome turnOnWithNotification:@"paulaClick"];
}

//
//  continueGame
//
//  increment current layer and possibly current section, turn on metronome
//
- (void)continueGame {
    Section *section = game.level.sections[[game.level.currentSection intValue]];
    if ([section.currentLayer intValue] < section.layers.count-1)
        section.currentLayer = [NSNumber numberWithInt:[section.currentLayer intValue] + 1];
    currentInstrument = [NSNumber numberWithInt:[section.currentLayer intValue]];
    [metronome turnOnWithNotification:@"paulaClick"];
}

//
//  setupGame
//
//  configure game's initial settings, depending on the current mode
//
- (void)setupGame {
    
    if (game.mode==SINGLE_PLAYER) {
        [game generateSimpleLevel];
    } else if (game.mode==MULTI_PLAYER_COMPETE) {
        Layer *newLayer = [[Layer alloc] init];
        [self setTempMultiPlayerMelody];
        newLayer.notes = [[NSArray alloc] initWithArray:melNotes];
        Section *newSection = [[Section alloc] init];
        [newSection addLayer:newLayer];
        [game.level addSection:newSection];
    }
    
}

//
//  turnBackOverToPaula
//
//  restart metronome, set to be paula's turn
//
- (void)turnBackOverToPaula {
    [game newRound];
    [metronome turnOnWithNotification:@"paulaClick"];
}

//
//  checkContinueConditions
//
//  determines whether it is player's turn, paula's turn, game has been won, etc
//
- (void)checkContinueConditions {
    [self updatePlayerDisplayInfo];
    BOOL mistakesWereMade = [game.paula checkMistakesInInput:[NSArray arrayWithArray: game.player.currentInput]
                                              VsCurrentLayer:[game currentRound]];
    int continueCondition = [game rewardOrPenalize:mistakesWereMade];
    if (continueCondition==0) {
        //[self updatePlayerDisplayInfo];
    } else if (continueCondition==1) {
        [game makePaulasTurn];
        [game newRound];
        [NSTimer scheduledTimerWithTimeInterval:metronome.beatDuration
                                         target:self selector:@selector(turnBackOverToPaula)
                                       userInfo:nil
                                        repeats:NO];
        //[self updatePlayerDisplayInfo];
    } else if (continueCondition==2) {
        [self gameLost];
    } else if (continueCondition==3) {
        [self gameWon];
    } else if (continueCondition==4) {
        [game makePaulasTurn];
        [game newRound];
        [self layerComplete];
    }
}

//  paulaCLickListen
//
//  Listens for the metronome's "paulaClick" notification.  Plays the next note in
//  the round.
//
//  This is OK for now, but it will have to be revised when variable note durations
//  is possible.
//
- (void)paulaClickListen:(id)sender {
    [self allNotesOff];
    Section *currentSection = game.level.sections[[game.level.currentSection intValue]];
    Layer *currentLayer = currentSection.layers[[currentSection.currentLayer intValue]];
    // get the index in the layer of the current note
    int index = [currentLayer.currentNote intValue];
    // get the index in the layer of the note stop at for this round
    int stopNote = [currentLayer.currentStopIndex intValue];
    
    if (index >= stopNote) {
        index = 0;
        [metronome turnOff];
        [game makePlayersTurn];
        currentLayer.currentStopIndex = [NSNumber numberWithInt:stopNote+1];
    } else {
        NSInteger i = [[currentLayer.notes objectAtIndex:index] integerValue];
        if (i > 0)
            [game addPaulaInput:i];
        
        for (int j = 0; j < [currentSection.currentLayer intValue]+1; j++) {
            Layer *layer = currentSection.layers[j];
            int note = [layer.notes[index] intValue];
            NSLog(@"%d", note);
            // not very safe
            if (note > 0) {
                if (j < [currentSection.currentLayer intValue]) {
                    [self noteOnNoLightWithNumber:note sendMessage:NO AndSoundType:j];
                } else {
                    [self noteOnWithNumber:note sendMessage:NO AndSoundType:j];
                }
            }
        }
            //[self noteOnWithNumber:i sendMessage:NO];
        index++;
    }
    currentLayer.currentNote = [NSNumber numberWithInt:index];
}

//
//  playerClickListen
//
//  respond to "playerClick" message sent by metronome
//
- (void)playerClickListen:(id)sender {
    [self allNotesOff];
    NSLog(@"click!");
}

//
//  updatPlayerDisplayInfo
//
//  update view to show accurate score and number of mistakes left
//
- (void)updatePlayerDisplayInfo {
    scoreDisplay.text = [NSString stringWithFormat: @"score: %d", [game.player.score intValue]];
    mistakesLeftDisplay.text = [NSString stringWithFormat: @"mistakes: %d", ([game.player.mistakesAllowed intValue] - [game.player.mistakesMade intValue])];
}


//
//  gameLost
//
//  if player makes too many mistakes, stop all notes and show gameOver view
//
- (void)gameLost {
    mistakesLeftDisplay.text = @"mistakes: 0";
    [toneGen noteOff];
    [game newRound];
    [self processGameStatus:0];
}

//
//  layerComplete
//
//  if player performs layer without too many mistakes but there are more layers to play,
//  play contdown and continue to the next layer
//

- (void)layerComplete {
    [game newRound];
    [self processGameStatus:1];
}

//
//  gameWon
//
//  for now, this means a layer was correctly input without making too many mistakes
//
- (void)gameWon {
    [toneGen noteOff];
    [game newRound];
    [self processGameStatus:2];
}

//
//  processGameStatus
//
//  called by gameLost, layerFinished, and gameWon and displays a GameOver view because either
//  the game has been lost, a layer has been completed, or the game has been completed.
//
//  0 = lost; 1 = layer completed; 2 = game completed
//

- (void)processGameStatus:(int)status {
    [self.metronome turnOff];
    BOOL multi = (game.mode != SINGLE_PLAYER)?YES:NO;
    gameOver = [[GameOver alloc] initWithWidth:self.view.bounds.size.width AndHeight:self.view.bounds.size.height];
    switch (status) {
        case 0:
            [gameOver gameLost:multi];
            if (!multi)
                [gameOver.button addTarget:self action:@selector(gameLostButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            break;
        case 1:
            [gameOver layerComplete:[game.player.score intValue] isMultiPlayer:multi];
            if (!multi)
                [gameOver.button addTarget:self action:@selector(layerCompleteButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            break;
        case 2:
            [gameOver gameWon:[game.player.score intValue] isMultiPlayer:multi];
            if (!multi)
                [gameOver.button addTarget:self action:@selector(gameWonButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            break;
            
        default:
            break;
    }
    [self updatePlayerDisplayInfo];
    [self.view addSubview:gameOver.label];
    [self.view addSubview:gameOver.button];
    [_delegate sendScore:game.player];
    //if(!multi)
      //  [gameOver.button addTarget:self action:@selector(gameWonButtonPressed) forControlEvents:UIControlEventTouchUpInside];
}

//
//  setTempMultiPlayerMelody
//
//  Until we can send arrays between devices, this is the melody for multiplayer mode
//
- (void)setTempMultiPlayerMelody {
    melNotes = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:2],
                [NSNumber numberWithInt:3],
                [NSNumber numberWithInt:0],
                [NSNumber numberWithInt:4],
                [NSNumber numberWithInt:3],
                [NSNumber numberWithInt:2],
                [NSNumber numberWithInt:1],
                [NSNumber numberWithInt:5],
                [NSNumber numberWithInt:5],
                [NSNumber numberWithInt:4],
                [NSNumber numberWithInt:0],
                [NSNumber numberWithInt:6],
                [NSNumber numberWithInt:8],
                [NSNumber numberWithInt:7], nil];
}

/////////////////// NAVIGATION ////////////
#pragma mark - Navigation

- (void)didReceiveMemoryWarning
{
    NSLog(@"DAMNIT!");
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Back to the main view controller
- (void) backButtonPressed {
    [toneGen stop];
    // melIndex = 0;
    [self dismissViewControllerAnimated:YES completion:nil];
}

// For now, this just goes back to the main view controller
- (void)gameLostButtonPressed {
    [toneGen stop];
    [self setupGame];
    [gameOver.label removeFromSuperview];
    [gameOver.button removeFromSuperview];
//    [self playCountdownAndStartGame];
    
    //show score view
    [self dismissViewControllerAnimated:YES completion:^{
        if(game.mode != SINGLE_PLAYER)
            [_delegate sendScore:game.player];
        else {
            game.player.name = @"Me";
            [_delegate showScoreView:[NSMutableArray arrayWithObject:game.player]];
        }
    }];
}

// Starts the next layer
- (void)layerCompleteButtonPressed {
    
    [gameOver.label removeFromSuperview];
    [gameOver.button removeFromSuperview];
    [self playCountdownAndContinueGame];
}

// For now, this just goes back to the main view controller
- (void)gameWonButtonPressed {
    [toneGen stop];
    [self setupGame];
    [gameOver.label removeFromSuperview];
    [gameOver.button removeFromSuperview];
//    [self playCountdownAndStartGame];
    
    //show score view
    [self dismissViewControllerAnimated:YES completion:^{
        if(game.mode != SINGLE_PLAYER)
            [_delegate sendScore:game.player];
        else {
            game.player.name = @"Me";
            [_delegate showScoreView:[NSMutableArray arrayWithObject:game.player]];
        }
    }];
}

/////////////////// VIEW SETUP ////////////
#pragma mark - Initialize and Setup

- (void)viewDidLoad
{
    [super viewDidLoad];
    game = [[Game alloc] init];
    currentInstrument = [NSNumber numberWithInt:1];
	metronome = [[Metronome alloc] initWithBPM:TEMP_BPM AndResolution:2];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paulaClickListen:) name:@"paulaClick" object:metronome];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerClickListen:) name:@"playerClick" object:metronome];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [toneGen stop];
    [metronome turnOff];
}

- (id)initWithGameMode:(enum GameModes)mode {
    self = [self initWithNibName:nil bundle:nil];
    
    if(self) {
        if(game) {
            game.mode = mode;
        }
        
        if (game.mode == JUST_PlAY) {
            toneGen = [[ToneGenerator3 alloc] init];
            [toneGen start];
        }
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // melIndex = 0;
        totalDur = 0.0;
        self.view.backgroundColor = [UIColor blackColor];
        scale = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:0],
                 [NSNumber numberWithInt:2],
                 [NSNumber numberWithInt:5],
                 [NSNumber numberWithInt:7],
                 [NSNumber numberWithInt:9],
                 [NSNumber numberWithInt:12],
                 [NSNumber numberWithInt:14],
                 [NSNumber numberWithInt:17], nil];
        
        CGFloat width = self.view.bounds.size.width;
        CGFloat height = self.view.bounds.size.height;
        
        [self setupPlayerDisplayInfo];
        
        sineButton1 = [self setupButton:sineButton1 OnScreenWithX:BUTTONOFFSET YOffset:BUTTONOFFSET andNumber:1];
        sineButton2 = [self setupButton:sineButton2 OnScreenWithX:width/2+BUTTONOFFSET/2 YOffset:BUTTONOFFSET andNumber:2];
        sineButton3 = [self setupButton:sineButton3 OnScreenWithX:BUTTONOFFSET YOffset:(height-20)/4+BUTTONOFFSET/2 andNumber:3];
        sineButton4 = [self setupButton:sineButton4 OnScreenWithX:width/2+BUTTONOFFSET/2 YOffset:(height-20)/4+BUTTONOFFSET/2 andNumber:4];
        sineButton5 = [self setupButton:sineButton5 OnScreenWithX:BUTTONOFFSET YOffset:(height-20)/2 andNumber:5];
        sineButton6 = [self setupButton:sineButton6 OnScreenWithX:width/2+BUTTONOFFSET/2 YOffset:(height-20)/2 andNumber:6];
        sineButton7 = [self setupButton:sineButton7 OnScreenWithX:BUTTONOFFSET YOffset:(height-20)*.75-BUTTONOFFSET/2 andNumber:7];
        sineButton8 = [self setupButton:sineButton8 OnScreenWithX:width/2+BUTTONOFFSET/2 YOffset:(height-20)*.75-BUTTONOFFSET/2 andNumber:8];
        
        backButton = addBackButton(width, height);
        [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:backButton];
        //[self playCountdownAndStartGame];
        
    }
    return self;
}
//
//  setupButton
//
//  setup the individual tiles
//
- (UIButton *)setupButton:(UIButton *)sender OnScreenWithX:(int)x YOffset:(int)y andNumber:(int)num {
    CGFloat width = self.view.bounds.size.width;
    CGFloat height = self.view.bounds.size.height;
    sender = [UIButton buttonWithType:UIButtonTypeCustom];
    sender.backgroundColor = [UIColor colorWithRed:(arc4random()%11)/10.0 green:(arc4random()%11)/10.0 blue:(arc4random()%11)/10.0 alpha:1.0];
    [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sender.frame = CGRectMake(x, y, width/2-BUTTONOFFSET, (height-20)/4-BUTTONOFFSET);
    sender.titleLabel.alpha = 0.0;
    [sender setTitle:[NSString stringWithFormat:@"%d", num] forState:UIControlStateNormal];
    [self.view addSubview:sender];
    [sender addTarget:self action:@selector(noteOn:) forControlEvents:UIControlEventTouchDown|UIControlEventTouchDragEnter];
    [sender addTarget:self action:@selector(noteOff:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside|UIControlEventTouchDragExit];
    sender.alpha = OFFALPHA;
    return sender;
}

//
//  setupPlayerDisplayInfo
//
//  setup the status bar at the bottom
//
- (void)setupPlayerDisplayInfo {
    CGFloat width = self.view.bounds.size.width;
    CGFloat height = self.view.bounds.size.height;
    
    scoreDisplay = [[UILabel alloc] initWithFrame:CGRectMake(width/2-48, height-18, 96, 16)];
    scoreDisplay.backgroundColor = [UIColor clearColor];
    scoreDisplay.textColor = [UIColor cyanColor];
    scoreDisplay.text = @"score: 0";
    scoreDisplay.textAlignment = NSTextAlignmentCenter;
    scoreDisplay.font = [UIFont systemFontOfSize:14];
    
    mistakesLeftDisplay = [[UILabel alloc] initWithFrame:CGRectMake(width-74, height-18, 72, 16)];
    mistakesLeftDisplay.backgroundColor = [UIColor clearColor];
    mistakesLeftDisplay.textColor = [UIColor cyanColor];
    mistakesLeftDisplay.text = @"mistakes: 5";
    mistakesLeftDisplay.textAlignment = NSTextAlignmentRight;
    mistakesLeftDisplay.font = [UIFont systemFontOfSize:14];
    
    [self.view addSubview:scoreDisplay];
    [self.view addSubview:mistakesLeftDisplay];
}

@end
