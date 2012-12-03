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

// these don't do anything
#define TEMP_BPM 100.0
#define TEMP_DUR 5.0
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
@property (nonatomic) UIButton *instrSelect0;
@property (nonatomic) UIButton *instrSelect1;
@property (nonatomic) UIButton *instrSelect2;
@property (nonatomic) UIButton *instrSelect3;
@property (nonatomic) UIButton *instrSelect4;
@property (nonatomic) NSNumber *currentInstrument;
@property (nonatomic) BOOL isRecording;

@property (nonatomic) NSMutableArray *notesRecording;
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
@synthesize instrSelect0;
@synthesize instrSelect1;
@synthesize instrSelect2;
@synthesize instrSelect3;
@synthesize instrSelect4;
@synthesize scoreDisplay;
@synthesize mistakesLeftDisplay;
@synthesize toneGen;
@synthesize isMultiPlayerMode;
@synthesize metronome;
@synthesize game;
@synthesize currentInstrument;
@synthesize gameOver;
@synthesize delegate=_delegate;
@synthesize startDoneButton;

//////////////////  NOTE ON AND OFF /////////////
#pragma mark - Note on and Off Methods

//
//  noteOnWithNumber
//
//  take tile number and whether or not to send over network as input and
//  add a tone to the stack
//
- (void) noteOnWithNumber:(NSInteger)num sendMessage:(BOOL)send {
    int s = 1;
    if(self.isMultiPlayerMode == NO) {
        Section *section = game.level.sections[[game.level.currentSection intValue]];
        s = [section.currentLayer intValue];
    }
    else if (self.isRecording == NO) {
        Section *section = game.level.sections[[game.level.currentSection intValue]];
        s = [section.currentLayer intValue];
    }
    
    [self noteOnWithNumber:num sendMessage:send AndSoundType:s];
}

//
//  noteOffWithNumber
//
//  take tile number and whether or not to send over network as input and
//  remove a tone from the stack
//
- (void) noteOffWithNumber:(NSInteger)num sendMessage:(BOOL)send {
    int s = 1;
    if(self.isMultiPlayerMode == NO) {
        Section *section = game.level.sections[[game.level.currentSection intValue]];
        s = [section.currentLayer intValue];
    }
    else if (self.isRecording == NO) {
        Section *section = game.level.sections[[game.level.currentSection intValue]];
        s = [section.currentLayer intValue];
    }
    
    [self noteOffWithNumber:num sendMessage:send AndSoundType:s];
}

//
//  noteOnWithNumber:SendMessage:AndSoundType:
//
//  Plays a tone and lights up a tile.  Takes tile number, whether or not to
//  send a multiplayer message, and the instrument type (converted to enum waveforms)
// 
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
    
    if (![game isPaulasTurn])
        [game addPlayerInput:num];
}

//  keeping this separate until after merging branches
//
//  noteOnNoLightWithNumber:SendMessage:AndSoundType:
//
//  similar to noteOnWithNumber:SendMessage:AndSoundType but does not light up a tile
//
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

//
//  noteOffWithNumber:sendMessage:AndSoundType
//
//  Sends noteOff message to ToneGenerator and returns tile alpha of corresponding note
//  to resting state.  If send=YES, a multiplayer message is sent (nothing happens now, though)
//
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
    
    if (![game isPaulasTurn] && self.isRecording == NO)
        [self checkContinueConditions];
}

//  keeping this separate until after merging branches
//
//  noteOffNoLightWithNumber:sendMessage:AndSoundType
//
//  Sends noteOff message to ToneGenerator without altering alpha of tile.  If
//  send=YES, a multiplayer message is sent (nothing happens now, though)
//
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
    if(game) {
        if(game.state == GAME_MY_TURN) {
            UIButton *button = (UIButton *)sender;
            [self noteOnWithNumber:[button.titleLabel.text integerValue] sendMessage:NO];
            
            if(self.isRecording) {
                [self.notesRecording addObject:[NSNumber numberWithInt:[button.titleLabel.text integerValue]]];
            }
        }
    }
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

//
//  playCountdownAndContinueGame
//
//  Show countdown and tempo before starting a new layer
//
- (void)playCountdownAndContinueGame {
    [self playCountdownWithSelector:@selector(continueGame)];
}

//
//  playCountdownWithSelector:
//
//  Starts countdown, assigning appropriate selector
//
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
//    toneGen = [[ToneGenerator alloc] init];
    [self setupGame];
//    [toneGen start];
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

- (void) setGameWithNotes:(NSArray *)notes {
    if(notes) {
        melNotes = notes;
    } else {
        [self setTempMultiPlayerMelody];
    }
}

//
//  setupGame
//
//  configure game's initial settings, depending on the current mode
//
- (void)setupGame {
    if (game.mode==SINGLE_PLAYER) {
        [game generateSimpleLevel];
    } else {
        Layer *newLayer = [[Layer alloc] init];
        newLayer.notes = [[NSArray alloc] initWithArray:melNotes];
        Section *newSection = [[Section alloc] init];
        [newSection addLayer:newLayer];
        [game.level addSection:newSection];
        game.state = GAME_MY_TURN;
//        [self playCountdownAndStartGame];
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
        [game makePaulasTurn];
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
    
    if(self.isRecording) {
        return;
    }
    
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
            //NSLog(@"%d", note);
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
//  listenClickListen
//
//
//
- (void)listenClickListen:(id)sender {
    [self allNotesOff];
    Section *currentSection = game.level.sections[[game.level.currentSection intValue]];
    Layer *currentLayer = currentSection.layers[[currentSection.currentLayer intValue]];
    // get the index in the layer of the current note
    int index = [currentLayer.currentNote intValue];
    //NSLog(@"note index: %d", index);
    // get the index in the layer of the note stop at for this round
    int noteCount = currentLayer.notes.count;
    
    if (index >= noteCount) {
        index = 0;
        [metronome turnOff];
        [self playbackFinished];
    } else {
        for (int j = 0; j < [currentSection.currentLayer intValue]+1; j++) {
            Layer *layer = currentSection.layers[j];
            int note = [layer.notes[index] intValue];
            // not very safe
            if (note > 0) {
                [self noteOnWithNumber:note sendMessage:NO AndSoundType:j];
            }
        }
        index++;
    }
    currentLayer.currentNote = [NSNumber numberWithInt:index];
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
    //[toneGen noteOff];
    [game newRound];
    [self processGameStatus:2];
}

- (void) showScoreViewScreen {
    //show score view
    [self dismissViewControllerAnimated:YES completion:^{
        if(game.mode == SINGLE_PLAYER) {
            game.player.name = @"Me";
            [_delegate showScoreView:[NSMutableArray arrayWithObject:game.player]];
        }
        else {
            [_delegate sendScore:game.player];
        }
    }];
}

// For now, this just goes back to the main view controller
- (void)gameLostButtonPressed {
    [toneGen stop];
    [self setupGame];
    [self removeLabelsAndButtons];
    //    [self playCountdownAndStartGame];
    
    [self showScoreViewScreen];
}

// Starts the next layer
- (void)layerCompleteButtonPressed {
    [self removeLabelsAndButtons];
    [self playCountdownAndContinueGame];
}

// For now, this just goes back to the main view controller
- (void)gameWonButtonPressed {
    [toneGen stop];
    [self setupGame];
    [self removeLabelsAndButtons];
    //    [self playCountdownAndStartGame];
    
    [self showScoreViewScreen];
}

- (void)listenButtonPressed {
    [self removeLabelsAndButtons];
    [self listenToCurrentLevel];
}

- (void) removeLabelsAndButtons {
    [gameOver.label removeFromSuperview];
    [gameOver.button removeFromSuperview];
    [gameOver.listenButton removeFromSuperview];
}
    
- (void)playbackFinished {
    //[toneGen noteOff];
    [game newRound];
    [self processGameStatus:3];
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
    
    SEL selector = nil;
    switch (status) {
        case 0:
            [gameOver gameLost:multi gameMode:game.mode];
            
            selector = nil;
            if (game.mode == SINGLE_PLAYER)
                selector = @selector(gameLostButtonPressed);
            else if (game.mode == MULTI_PLAYER_MIMIC)
                selector = @selector(removeLabelsAndButtons);
            
            if(selector != nil)
                [gameOver.button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
            break;
        case 1:
            [gameOver layerComplete:[game.player.score intValue] isMultiPlayer:multi];
            
            selector = nil;
            if (game.mode == SINGLE_PLAYER)
                selector = @selector(layerCompleteButtonPressed);
            else if (game.mode == MULTI_PLAYER_MIMIC)
                selector = @selector(removeLabelsAndButtons);
            
            if (selector != nil)
                [gameOver.button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
            break;
        case 2:
            [gameOver gameWon:[game.player.score intValue] isMultiPlayer:multi gameMode:game.mode];
            if (game.mode == SINGLE_PLAYER) {
                [gameOver.button addTarget:self action:@selector(gameWonButtonPressed) forControlEvents:UIControlEventTouchUpInside];
                [gameOver.listenButton addTarget:self action:@selector(listenButtonPressed) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:gameOver.listenButton];
            } else if (game.mode == MULTI_PLAYER_MIMIC) {
                [gameOver.button addTarget:self action:@selector(removeLabelsAndButtons) forControlEvents:UIControlEventTouchUpInside];
            }
            break;
        case 3:
            [gameOver levelPlayedBack:[game.player.score intValue] isMultiPlayer:multi];
            if (!multi) {
                [gameOver.button addTarget:self action:@selector(gameWonButtonPressed) forControlEvents:UIControlEventTouchUpInside];
                [gameOver.listenButton addTarget:self action:@selector(listenButtonPressed) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:gameOver.listenButton];
            }
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


//
//
//
//
//
- (void)listenToCurrentLevel {
    game.level.currentSection = 0;
    for (int i = 0; i < game.level.sections.count; i++) {
        Section *section = game.level.sections[i];
        section.currentLayer = [NSNumber numberWithInt:section.layers.count-1];
        for (int j = 0; j < section.layers.count; j++) {
            Layer *layer = section.layers[j];
            layer.currentNote = 0;
            layer.currentStopIndex = [NSNumber numberWithInt:layer.notes.count-1];
        }
    }
    [metronome turnOnWithNotification:@"listenClick"];
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
    // melIndex = 0;
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)instrButtonPressed:(id)sender {
    [instrSelect0 setTitle:@"" forState:UIControlStateNormal];
    [instrSelect1 setTitle:@"" forState:UIControlStateNormal];
    [instrSelect2 setTitle:@"" forState:UIControlStateNormal];
    [instrSelect3 setTitle:@"" forState:UIControlStateNormal];
    [instrSelect4 setTitle:@"" forState:UIControlStateNormal];
    
    UIButton *button = (UIButton*)sender;
    [button setTitle:@"X" forState:UIControlStateNormal];
    currentInstrument = [NSNumber numberWithInt:button.tag];
}

/////////////////// VIEW SETUP ////////////
#pragma mark - Initialize and Setup

- (void)viewDidLoad
{
    if (toneGen==nil)
        toneGen = [[ToneGenerator alloc] init];
    
    [super viewDidLoad];
    game = [[Game alloc] init];
    currentInstrument = [NSNumber numberWithInt:1];
	metronome = [[Metronome alloc] initWithBPM:TEMP_BPM AndResolution:2];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paulaClickListen:) name:@"paulaClick" object:metronome];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerClickListen:) name:@"playerClick" object:metronome];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listenClickListen:) name:@"listenClick" object:metronome];
    
    toneGen = [[ToneGenerator alloc] init];
    [toneGen start];
}

- (void)viewDidAppear:(BOOL)animated {
    [toneGen start];
}

- (void)viewDidDisappear:(BOOL)animated {
    [toneGen stop];
    [metronome turnOff];
}

- (id)initWithGameModeAndState:(enum GameModes)mode gameState:(enum GameStates)state {
    self = [self initWithNibName:nil bundle:nil];
    
    if(self) {
        
        if(game) {
            game.mode = mode;
            game.state = state;
        }
        
        if(game) {
            if(game.mode != SINGLE_PLAYER && game.mode != JUST_PlAY) {
                self.isMultiPlayerMode = YES;
                [self setupStartDoneFunc];
            } else {
                self.isMultiPlayerMode = NO;
            }
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
        sineButton3 = [self setupButton:sineButton3 OnScreenWithX:BUTTONOFFSET YOffset:(height-50)/4+BUTTONOFFSET/2 andNumber:3];
        sineButton4 = [self setupButton:sineButton4 OnScreenWithX:width/2+BUTTONOFFSET/2 YOffset:(height-50)/4+BUTTONOFFSET/2 andNumber:4];
        sineButton5 = [self setupButton:sineButton5 OnScreenWithX:BUTTONOFFSET YOffset:(height-50)/2 andNumber:5];
        sineButton6 = [self setupButton:sineButton6 OnScreenWithX:width/2+BUTTONOFFSET/2 YOffset:(height-50)/2 andNumber:6];
        sineButton7 = [self setupButton:sineButton7 OnScreenWithX:BUTTONOFFSET YOffset:(height-50)*.75-BUTTONOFFSET/2 andNumber:7];
        sineButton8 = [self setupButton:sineButton8 OnScreenWithX:width/2+BUTTONOFFSET/2 YOffset:(height-50)*.75-BUTTONOFFSET/2 andNumber:8];
        
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
    sender.frame = CGRectMake(x, y, width/2-BUTTONOFFSET, (height-50)/4-BUTTONOFFSET);
    sender.titleLabel.alpha = 0.0;
    [sender setTitle:[NSString stringWithFormat:@"%d", num] forState:UIControlStateNormal];
    [self.view addSubview:sender];
    [sender addTarget:self action:@selector(noteOn:) forControlEvents:UIControlEventTouchDown|UIControlEventTouchDragEnter];
    [sender addTarget:self action:@selector(noteOff:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside|UIControlEventTouchDragExit];
    sender.alpha = OFFALPHA;
    return sender;
}

- (void) setupStartDoneFunc {
    CGFloat width = self.view.bounds.size.width;
    CGFloat height = self.view.bounds.size.height;
    startDoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    startDoneButton.backgroundColor = [UIColor colorWithRed:(arc4random()%1000+1)/1000.0
                                             green:MIN((arc4random()%1000+1)/1000.0, 0.6)
                                              blue:(arc4random()%1000+1)/1000.0
                                             alpha:1.0];
    [startDoneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    startDoneButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    startDoneButton.frame = CGRectMake(75, height - 50, width - 150, 32);
    [startDoneButton setTitle:@"Start" forState:UIControlStateNormal];
    
    [self refreshButtonStatus];
    
    [startDoneButton addTarget:self action:@selector(startStopRecording) forControlEvents:UIControlEventTouchDown|UIControlEventTouchDragEnter];
}

- (void) startStopRecording {
    if(self.isRecording) {
        self.isRecording = NO;
        [startDoneButton setTitle:@"Start" forState:UIControlStateNormal];
        NSLog(@"%@", self.notesRecording);
        [self.delegate sendMelody:self.notesRecording];
        game.state = GAME_WAITING;
    } else {
        self.isRecording = YES;
        self.notesRecording = [[NSMutableArray alloc] initWithCapacity:20];
        [startDoneButton setTitle:@"Done" forState:UIControlStateNormal];
    }
}

- (void) refreshButtonStatus {
    if(game) {
        if(game.state == GAME_WAITING) {
            [startDoneButton removeFromSuperview];
        } else {
            [self.view addSubview:startDoneButton];
        }
    }
}

- (void) changeGameState {
    if(self.game) {
        if(game.state == GAME_WAITING) {
            game.state = GAME_MY_TURN;
        } else {
            game.state = GAME_WAITING;
        }
        
        [self refreshButtonStatus];
    }
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

//
//  setupJustPlayMode
//
//  remove score and mistake info and (TODO) add settings page
//
- (void) setupJustPlayMode {
    CGFloat width = self.view.bounds.size.width;
    CGFloat height = self.view.bounds.size.height;
    
    [scoreDisplay removeFromSuperview];
    [mistakesLeftDisplay removeFromSuperview];
    currentInstrument = [NSNumber numberWithInt:0];
    
    UILabel *instrLabel = [[UILabel alloc] initWithFrame:CGRectMake(width/2-120, height-18, 80, 16)];
    instrLabel.backgroundColor = [UIColor clearColor];
    [instrLabel setTextColor:[UIColor cyanColor]];
    instrLabel.text = @" instrument: ";
    [instrLabel setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:instrLabel];
    
    
    instrSelect0 = [self addJustplayInstrumentButton:instrSelect0 index:0];
    instrSelect1 = [self addJustplayInstrumentButton:instrSelect1 index:1];
    instrSelect2 = [self addJustplayInstrumentButton:instrSelect2 index:2];
    instrSelect3 = [self addJustplayInstrumentButton:instrSelect3 index:3];
    instrSelect4 = [self addJustplayInstrumentButton:instrSelect4 index:4];
    
    [self.view addSubview:instrSelect0];
    [self.view addSubview:instrSelect1];
    [self.view addSubview:instrSelect2];
    [self.view addSubview:instrSelect3];
    [self.view addSubview:instrSelect4];
    
    [instrSelect0 setTitle:@"X" forState:UIControlStateNormal];
    
    [instrSelect0 addTarget:self action:@selector(instrButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [instrSelect1 addTarget:self action:@selector(instrButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [instrSelect2 addTarget:self action:@selector(instrButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [instrSelect3 addTarget:self action:@selector(instrButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [instrSelect4 addTarget:self action:@selector(instrButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (UIButton *) addJustplayInstrumentButton:(UIButton *)button index:(int)idx {
    CGFloat width = self.view.bounds.size.width;
    CGFloat height = self.view.bounds.size.height;
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    [button setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(width/2+idx*40-40, height-18, 38, 16);
    [[button layer] setBorderWidth:1.0f];
    [button.layer setBorderColor:[[UIColor cyanColor] CGColor]];
    [button setTitle:@"" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [button setTag:idx];
    return button;
}


@end
