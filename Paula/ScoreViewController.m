//
//  ScoreViewController.m
//  Paula
//
//  Created by Kevin Tseng on 11/24/12.
//  Copyright (c) 2012 inomadmusic.com. All rights reserved.
//

#import "ScoreViewController.h"
#import "SharetoFBViewController.h"
#import "PaulaUtilities.m"

@interface ScoreViewController ()
@property UILabel *title;
@property NSInteger screenHeight;
@property NSInteger screenWidth;
@property NSInteger rowHeight;
@property UIButton *startButton;
@property UIButton *shareButton;
@property SharetoFBViewController *sharetoFBViewController;
@property NSString *scoreText;
@end

@implementation ScoreViewController

@synthesize title;
@synthesize screenHeight;
@synthesize screenWidth;
@synthesize rowHeight;
@synthesize shareButton;
@synthesize sharetoFBViewController = _sharetoFBViewController;
@synthesize scoreText;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.rowHeight = 20;
        self.screenHeight = self.view.bounds.size.height;
        self.screenWidth = self.view.bounds.size.width;
        
        [self.view setBackgroundColor:[UIColor colorWithRed:0.2 green:0.4 blue:1.0 alpha:1.0]];
        
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, screenWidth-5, rowHeight)];
        [self.title setBackgroundColor:[UIColor colorWithRed:0.2 green:0.4 blue:1.0 alpha:1.0]];
        self.title.text = @"- Game Result -";
        self.title.textAlignment = UITextAlignmentCenter;
        
        [self.view addSubview:self.title];
        
        UILabel *nameColumn = [[UILabel alloc] initWithFrame:CGRectMake(5, rowHeight + 15, (screenWidth/4)*2, 20)];
        [nameColumn setBackgroundColor:[UIColor colorWithRed:0.2 green:0.4 blue:1.0 alpha:1.0]];
        nameColumn.text = @"Name";
        UILabel *mistakeColumn = [[UILabel alloc] initWithFrame:CGRectMake((screenWidth/4)*2, rowHeight + 15, (screenWidth/4), 20)];
        [mistakeColumn setBackgroundColor:[UIColor colorWithRed:0.2 green:0.4 blue:1.0 alpha:1.0]];
        mistakeColumn.text = @"Mistakes";
        mistakeColumn.textAlignment = UITextAlignmentCenter;
        UILabel *scoreColumn = [[UILabel alloc] initWithFrame:CGRectMake((screenWidth/4)*3, rowHeight + 15, (screenWidth/4), 20)];
        [scoreColumn setBackgroundColor:[UIColor colorWithRed:0.2 green:0.4 blue:1.0 alpha:1.0]];
        scoreColumn.text = @"Score";
        scoreColumn.textAlignment = UITextAlignmentCenter;
        
        [self.view addSubview:nameColumn];
        [self.view addSubview:mistakeColumn];
        [self.view addSubview:scoreColumn];
        
        self.startButton = [[UIButton alloc] initWithFrame:CGRectMake(self.screenWidth/2 - 40, self.screenHeight - 100, 80, 30)];
        
        self.startButton.backgroundColor = randomColor();
        [self.startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.startButton setTitle:@"Okay" forState:UIControlStateNormal];
        [self.startButton addTarget:self action:@selector(endGame) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:self.startButton];
        
        self.shareButton = [[UIButton alloc] initWithFrame:CGRectMake(self.screenWidth/2 - 40, self.screenHeight - 150, 80, 30)];
        self.shareButton.backgroundColor = randomColor();
        [self.shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.shareButton setTitle:@"Share" forState:UIControlStateNormal];
        [self.shareButton addTarget:self action:@selector(shareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.shareButton];
    }
    return self;
}

- (void)endGame {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (id)initWithData:(NSMutableArray *)data {
    self = [self initWithNibName:nil bundle:nil];
    
    if(self) {
        //populate score here
        if(data == nil) {
            data = [[NSMutableArray alloc] initWithCapacity:4];
            Player *p1 = [[Player alloc] init];
            p1.name = @"Kevin's iPhone";
            p1.score = [[NSNumber alloc] initWithInt:101];
            p1.mistakesMade = [[NSNumber alloc] initWithInt:5];
            [data addObject:p1];
            
            Player *p2 = [[Player alloc] init];
            p2.name = @"Grant's Iphone";
            p2.score = [[NSNumber alloc] initWithInt:50];
            p2.mistakesMade = [[NSNumber alloc] initWithInt:10];
            [data addObject:p2];
            
            self.scoreText = @"101";
        }
        
        if(data != nil) {
            NSInteger rowheight = 20;
            for (int idx=0; idx<[data count]; idx++) {
                Player *tmpPlayer = [data objectAtIndex:idx];
                UILabel *nameColumn = [[UILabel alloc] initWithFrame:CGRectMake(5, rowHeight + (rowheight * (idx+2)), (screenWidth/4)*2, 20)];
                [nameColumn setBackgroundColor:[UIColor colorWithRed:0.2 green:0.4 blue:1.0 alpha:1.0]];
                nameColumn.text = tmpPlayer.name;
                UILabel *mistakeColumn = [[UILabel alloc] initWithFrame:CGRectMake((screenWidth/4)*2, rowHeight + (rowheight * (idx+2)), (screenWidth/4), 20)];
                [mistakeColumn setBackgroundColor:[UIColor colorWithRed:0.2 green:0.4 blue:1.0 alpha:1.0]];
                mistakeColumn.text = [[NSString alloc] initWithFormat:@"%d", tmpPlayer.mistakesMade.intValue];
                mistakeColumn.textAlignment = UITextAlignmentCenter;
                UILabel *scoreColumn = [[UILabel alloc] initWithFrame:CGRectMake((screenWidth/4)*3, rowHeight + (rowheight * (idx+2)), (screenWidth/4), 20)];
                [scoreColumn setBackgroundColor:[UIColor colorWithRed:0.2 green:0.4 blue:1.0 alpha:1.0]];
                scoreColumn.text = [[NSString alloc] initWithFormat:@"%d", tmpPlayer.score.intValue];
                scoreColumn.textAlignment = UITextAlignmentCenter;
                
                [self.view addSubview:nameColumn];
                [self.view addSubview:mistakeColumn];
                [self.view addSubview:scoreColumn];
                
                self.scoreText = scoreColumn.text;
            }
        }
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

- (void)shareButtonPressed:(id)sender {
    if (sender == shareButton)
    {
        self.sharetoFBViewController = [[SharetoFBViewController alloc] init];
        self.sharetoFBViewController.scoreShare = self.scoreText;
        [self presentViewController:self.sharetoFBViewController animated:YES completion:nil];
    }
}

@end
