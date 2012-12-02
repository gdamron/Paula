//
//  UIUtilities.m
//  Paula
//
//  Created by Kevin Tseng on 11/1/12.
//  Copyright (c) 2012 inomadmusic.com. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

static UIButton* setupMenuButton(UIButton* sender, NSInteger idx, NSString* name, CGFloat screenWidth, CGFloat screenHeight) {
    CGFloat width = screenWidth;
    CGFloat height = screenHeight;
    sender = [UIButton buttonWithType:UIButtonTypeCustom];
    // clamping green to 0.6 seems to prevent buttons from getting too light
    sender.backgroundColor = [UIColor colorWithRed:(arc4random()%1000+1)/1000.0
                                             green:MIN((arc4random()%1000+1)/1000.0, 0.6)
                                              blue:(arc4random()%1000+1)/1000.0
                                             alpha:1.0];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sender.titleLabel.font = [UIFont boldSystemFontOfSize:32];
    sender.frame = CGRectMake(0, (height/7) * idx + 60, width, 60);
    [sender setTitle:name forState:UIControlStateNormal];

    return sender;
}

static UIButton* setupMenuButtonWithImage(UIButton* sender, NSInteger idx, UIImage *btnImage, CGFloat screenWidth, CGFloat screenHeight) {
    CGFloat width = screenWidth;
    CGFloat height = screenHeight;
    sender = [UIButton buttonWithType:UIButtonTypeCustom];
    // clamping green to 0.6 seems to prevent buttons from getting too light
    sender.backgroundColor = [UIColor colorWithRed:(arc4random()%1000+1)/1000.0
                                             green:MIN((arc4random()%1000+1)/1000.0, 0.6)
                                              blue:(arc4random()%1000+1)/1000.0
                                             alpha:1.0];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sender.titleLabel.font = [UIFont boldSystemFontOfSize:32];
    sender.frame = CGRectMake(0, (height/7) * idx + 60, width, 60);
    [sender setImage:btnImage forState:UIControlStateNormal];
    
    return sender;
}

static UIImageView* setupLogo(CGFloat width, CGFloat height) {
    UIImage *logo = [UIImage imageNamed:@"logo.gif"];
    UIImageView *logoView = [[UIImageView alloc] initWithImage:logo];
    logoView.frame = CGRectMake(0, 45, width, width*0.25);
    
    return logoView;
}

static UIButton* addBackButton(CGFloat width, CGFloat height) {
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.backgroundColor = [UIColor clearColor];
    [back setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    back.frame = CGRectMake(2, height-18, 32, 16);
    [[back layer] setBorderWidth:1.0f];
    [back.layer setBorderColor:[[UIColor cyanColor] CGColor]];
    [back setTitle:@"<<" forState:UIControlStateNormal];
    [back.titleLabel setFont:[UIFont systemFontOfSize:14]];
    return back;
}
