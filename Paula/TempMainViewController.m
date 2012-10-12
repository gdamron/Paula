//
//  TempMainViewController.m
//  Paula
//
//  Created by Grant Damron on 10/10/12.
//  Copyright (c) 2012 Grant Damron. All rights reserved.
//

#import "TempMainViewController.h"

@interface TempMainViewController ()

@end


@implementation TempMainViewController

@synthesize toEnyu;
@synthesize toEugene;
@synthesize toGrant;
@synthesize toKevin;
@synthesize enyuViewController;
@synthesize eugeneViewController;
@synthesize grantViewController;
@synthesize kevinViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        CGFloat width = self.view.bounds.size.width;
        CGFloat height = self.view.bounds.size.height;
        
        [self.view setBackgroundColor:[UIColor colorWithRed:0.2 green:0.4 blue:1.0 alpha:1.0]];
        enyuViewController = [[EnyuViewController alloc] init];
        eugeneViewController = [[EugeneViewController alloc] init];
        grantViewController = [[GrantViewController alloc] init];
        kevinViewController = [[KevinViewController alloc] init];
        
        toEnyu = [self setupButton:toEnyu OnScreenWithX:-86 YOffset:-72 AndName:[NSString stringWithFormat:@"Enyu"]];
        [toEnyu addTarget:self action:@selector(nameButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        toEugene = [self setupButton:toEugene OnScreenWithX:-86 YOffset:22 AndName:[NSString stringWithFormat:@"Eugene"]];
        [toEugene addTarget:self action:@selector(nameButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        toGrant = [self setupButton:toGrant OnScreenWithX:10 YOffset:-72 AndName:[NSString stringWithFormat:@"Grant"]];
        [toGrant addTarget:self action:@selector(nameButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        toKevin = [self setupButton:toKevin OnScreenWithX:10 YOffset:22 AndName:[NSString stringWithFormat:@"Kevin"]];
        [toKevin addTarget:self action:@selector(nameButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImage *logo = [UIImage imageNamed:@"logo.gif"];
        UIImageView *logoView = [[UIImageView alloc] initWithImage:logo];
        logoView.frame = CGRectMake(width/2-86, height/2-135, 172, 49);
        
        [self.view addSubview:logoView];
        
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

- (void)nameButtonPressed:(id)sender {
    if (sender==toEnyu) {
        [self presentViewController:enyuViewController animated:YES completion:nil];
    } else if (sender==toEugene) {
        [self presentViewController:eugeneViewController animated:YES completion:nil];
    } else if (sender==toGrant) {
        [self presentViewController:grantViewController animated:YES completion:nil];
    } else if (sender==toKevin) {
        [self presentViewController:kevinViewController animated:YES completion:nil];
    }
}

- (UIButton *)setupButton:(UIButton *)sender OnScreenWithX:(int)x YOffset:(int)y AndName:(NSString *)name{
    CGFloat width = self.view.bounds.size.width;
    CGFloat height = self.view.bounds.size.height;
    sender = [UIButton buttonWithType:UIButtonTypeCustom];
    sender.backgroundColor = [UIColor colorWithRed:(rand()%1000)/1000.0 green:(rand()%1000)/1000.0 blue:(rand()%1000)/1000.0 alpha:1.0];
    [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sender.frame = CGRectMake(width/2+x, height/2+y, 76, 76);
    [sender setTitle:name forState:UIControlStateNormal];
    [self.view addSubview:sender];
    return sender;
}

@end
