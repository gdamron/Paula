//
//  PaulaDatabase.m
//  Paula
//
//  Created by Yue Cao on 11/15/12.
//  Copyright (c) 2012 Yue Cao. All rights reserved.
//

#import "PaulaDatabase.h"
#import "PlayerInfo.h"

@implementation PaulaDatabase

static PaulaDatabase *database;

+(PaulaDatabase *)database{
    if(database == Nil){
        database = [[PaulaDatabase alloc] init];
    }
    return database;
}

-(id)init{
    self = [super init];
    if(self){
        NSString *sqliteDB = [[NSBundle mainBundle] pathForResource:@"paula" ofType:@"sqlite3"];
        if(sqlite3_open([sqliteDB UTF8String], &database) != SQLITE_OK){
            NSLog(@"Failed to open the database");
        }
    }
    return self;
}
-(NSArray *)getAllPlayer{
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    NSString *query = @"select * from player";
    sqlite3_stmt *statement;
    if(sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, Nil)==SQLITE_OK){
        while (sqlite3_step(statement)==SQLITE_ROW){
            int pid = sqlite3_column_int(statement, 0);
            char *pnameChar = (char *)sqlite3_column_text(statement, 1);
            int total_score = sqlite3_column_int(statement, 2);
            int plevel = sqlite3_column_int(statement, 3);
            NSString *pname = [[NSString alloc] initWithUTF8String:pnameChar];
            
            PlayerInfo *info = [[PlayerInfo alloc]initWithUniqueID:pid name:pname score:total_score level:plevel];
            [returnArray addObject:info];
            
        }
        sqlite3_finalize(statement);
    }
    return returnArray;
}

-(void)addPlayer:(NSString *)name TScore:(float)total_score level:(int)plevel{
    char pname = (char)name;
    char *errorMsg;
    NSString *query = [[NSString alloc] initWithFormat:@"insert into player(pname,total_score,plevel) values(%c,%f,%d)",pname,total_score,plevel];
    
    if (sqlite3_exec(database, [query UTF8String], NULL, NULL, &errorMsg)==SQLITE_OK) {
        NSLog(@"Insert successfully");
    }
}

-(void)addPlays:(float)score mistakeNum:(int)mistakes tempo:(int)tempo{
    NSArray *player = [[PaulaDatabase alloc] getAllPlayer];
    int level = (int)[player objectAtIndex:3];
    float addScore = score;
    int mistakesNum = mistakes;
    int Tempo = tempo;
    char *errorMsg;
    NSString *query = [[NSString alloc] initWithFormat:@"insert into plays(score, mistakes, tempo, level) values(%d, %f, %d, %d)",level,addScore,mistakesNum, Tempo];
    //sqlite3_stmt *statement;
    if (sqlite3_exec(database, [query UTF8String], NULL, NULL, &errorMsg)==SQLITE_OK){
        NSLog(@"Insert successfuly");
    }
}

-(void) dealloc{
    sqlite3_close(database);
    //[super dealloc];
}
@end
