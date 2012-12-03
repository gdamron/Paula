//
//  JoinedViewController.m
//  Paula
//
//  Created by Kevin Tseng on 12/2/12.
//  Copyright (c) 2012 inomadmusic.com. All rights reserved.
//

#import "JoinedViewController.h"

@interface Jo_inedViewController ()
@property (nonatomic) UIButton *quitButton;
@end

@implementation Jo_inedViewController

@synthesize searchController=_searchController;

- (id)initWithNameAndMode:(NSString *)name modeName:(NSString *)mode {
    self = [self initWithNibName:nil bundle:nil];
    if(self) {
        CGFloat width = self.view.bounds.size.width;
        CGFloat height = self.view.bounds.size.height;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, width - 5, height - 150)];
        
        [self.view setBackgroundColor:[UIColor colorWithRed:0.2 green:0.4 blue:1.0 alpha:1.0]];
        
        label.text = [NSString stringWithFormat:@"You've successfully joined\n%@'s game\nplease wait for the host to start game!\nMode: %@", name, mode];
        label.textColor = [UIColor whiteColor];
        label.numberOfLines = 10;
        label.backgroundColor = [UIColor colorWithRed:0.2 green:0.4 blue:1.0 alpha:1.0];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:16];
        
        [self.view addSubview:label];
        
        self.quitButton = [[UIButton alloc] initWithFrame:CGRectMake(width/2 - 40, height - 100, 80, 30)];
        
        self.quitButton.backgroundColor = [UIColor colorWithRed:(arc4random()%1000+1)/1000.0
                                                          green:(arc4random()%1000+1)/1000.0
                                                           blue:(arc4random()%1000+1)/1000.0
                                                          alpha:1.0];
        [self.quitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.quitButton setTitle:@"Quit" forState:UIControlStateNormal];
        [self.quitButton addTarget:self action:@selector(quitGame) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:self.quitButton];
    }
    return self;
}

- (void) quitGame {
    if(_searchController) {
        [_searchController disconnect];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

@end
