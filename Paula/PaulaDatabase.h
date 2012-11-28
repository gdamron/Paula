//
//  PaulaDatabase.h
//  Paula
//
//  Created by Yue Cao on 11/15/12.
//  Copyright (c) 2012 Yue Cao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Game.h"

@interface PaulaDatabase : NSObject{
    sqlite3 *database;
    
}
+(PaulaDatabase *)database;
-(NSArray *)getAllPlayer;
-(NSArray *)getAllPlays;
-(void)addPlayer:(NSString *)name TScore:(float)total_score level:(int)plevle;
-(void)addPlays:(float)score mistakeNum:(int)mistakes tempo:(int)tempo;
@end
