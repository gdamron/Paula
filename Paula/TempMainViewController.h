//
//  TempMainViewController.h
//  Paula
//
//  Created by Grant Damron on 10/10/12.
//  Copyright (c) 2012 Grant Damron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnyuViewController.h"
#import "EugeneViewController.h"
#import "GrantViewController.h"

@interface TempMainViewController : UIViewController

@property (strong, nonatomic) UIButton *toEnyu;
@property (strong, nonatomic) UIButton *toEugene;
@property (strong, nonatomic) UIButton *toGrant;
@property (strong, nonatomic) UIButton *toKevin;
@property (strong, nonatomic) EnyuViewController *enyuViewController;
@property (strong, nonatomic) EugeneViewController *eugeneViewController;
@property (strong, nonatomic) GrantViewController *grantViewController;
@property (strong, nonatomic) GrantViewController *kevinViewController;

@end
