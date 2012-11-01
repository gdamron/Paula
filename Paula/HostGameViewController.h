//
//  HostGameViewController.h
//  Paula
//
//  Created by Kevin Tseng on 11/1/12.
//  Copyright (c) 2012 inomadmusic.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GameCommunicationDelegate <NSObject>
@required
- (void) send:(uint8_t)message;
- (void) noteOnWithNumber:(NSInteger)num sendMessage:(BOOL)send;
- (void) allNotesOff;
- (void) presentGame;
@end

@interface HostGameViewController : UIViewController <GameCommunicationDelegate>

@end
