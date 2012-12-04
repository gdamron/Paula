//
//  PaulaDatabase.h
//  Paula
//
//  Created by Yue Cao on 11/15/12.
//  Copyright (c) 2012 Yue Cao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "Game.h"
#import "SinglePlayerViewController.h"
//#import "ScoreViewController.h"

@interface PaulaDatabase : NSObject{
    sqlite3 *database;
    
}
//@property (nonatomic, assign) id<MainViewDelegate> delegate;
//@property(strong) SingleViewController *scoreView;
@property(strong) Game *game;
//-(NSString *) filePath;
-(id) openDB;
+(PaulaDatabase *)database;
-(void)createPlayer;
-(void)createLevel;
-(void)createPlays;
-(void)createSection;
-(void)createLayer;
-(void)createSecInLevel;
-(void)createLayerInSec;
-(void)initDatabaseTables;
-(void)updatePlayerAndPlays;
@end
