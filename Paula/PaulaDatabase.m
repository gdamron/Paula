//
//  PaulaDatabase.m
//  Paula
//
//  Created by Yue Cao on 11/15/12.
//  Copyright (c) 2012 Yue Cao. All rights reserved.
//

#import "PaulaDatabase.h"


//@interface PaulaDatabase()
//
//    
//
//@end

@implementation PaulaDatabase
//@synthesize delegate = _delegate;
@synthesize game;

static PaulaDatabase *database;


+(PaulaDatabase *)database{
    if(database == Nil){
        database = [[PaulaDatabase alloc] openDB];
    }
    return database;
}


-(id) openDB {
    //—-create database—-
    NSString *dbPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"paulaNew.sqlite3"];
    //NSString *dbPath = @"paula.sqlite3"
    NSLog(@"documentsDir: %@",dbPath);
    if (sqlite3_open([dbPath UTF8String], &database) != SQLITE_OK ) {
        sqlite3_close(database);
        NSAssert(0, @"Database failed to open.");
        //return NO;
    }
    else{
        NSLog(@"Database is opened");
        //return YES;
    }
    [self createPlayer];
    [self createLevel];
    [self createLayer];
    [self createPlays];
    [self createSection];
    [self createSecInLevel];
    [self createLayerInSec];
    [self initDatabaseTables];
    [self updatePlayerAndPlays];
    return self;
}


-(void)createPlayer{
    char *errMsg;
    NSString *createPlayer = @"create table if not exists player (pid integer primary key, pname char, total_score integer, plevel integer)";
    if(sqlite3_exec(database, [createPlayer UTF8String], NULL, NULL, &errMsg)!=SQLITE_OK){
        sqlite3_close(database);
        NSAssert(0, @"Player failed to create.");
    }
    else{
        NSLog(@"Table Player created successfully!");
    }
    //[self createPlayer];
}


-(void)createLevel{
    char *errMsg;
    NSString *createLevel = @"create table if not exists level(levelid integer primary key, created_on timestamp default(strftime('%Y-%m-%d %H:%M:%f','now','localtime')),lname char, description text, difficuty integer)";
    if(sqlite3_exec(database, [createLevel UTF8String], NULL, NULL, &errMsg)!=SQLITE_OK){
        sqlite3_close(database);
        NSAssert(0, @"Level failed to create.");
    }
    else{
        NSLog(@"Table Level created successfully!");
    }
    //[self createLevel];
}

-(void)createPlays{
    char *errMsg;
    NSString *createPlays = @"create table if not exists plays(pid integer, levelid integer, timestamp timestamp primary key default(strftime('%Y-%m-%d %H:%M:%f','now','localtime')),score integer, mistakes integer, tempo integer, level integer, foreign key(pid) references player(pid), foreign key(levelid) references level(levelid))";
    if(sqlite3_exec(database, [createPlays UTF8String], NULL, NULL, &errMsg)!=SQLITE_OK){
        sqlite3_close(database);
        NSAssert(0, @"Plays failed to create.");
    }
    else{
        NSLog(@"Table Plays created successfully!");
    }
    //[self createPlays];
}

-(void)createLayer{
    char *errMsg;
    NSString *createLayer = @"create table if not exists layer(layerid integer primary key, notes clob)";
    if(sqlite3_exec(database, [createLayer UTF8String], NULL, NULL, &errMsg)!=SQLITE_OK){
        sqlite3_close(database);
        NSAssert(0, @"Layer failed to create.");
    }
    else{
        NSLog(@"Table Layer created successfully!");
    }
    //[self createLayer];
}

-(void)createSection{
    char *errMsg;
    NSString *createSection = @"create table if not exists layer(layerid integer primary key, notes clob)";
    if(sqlite3_exec(database, [createSection UTF8String], NULL, NULL, &errMsg)!=SQLITE_OK){
        sqlite3_close(database);
        NSAssert(0, @"Section failed to create.");
    }
    else{
        NSLog(@"Table Section created successfully!");
    }
}

-(void)createSecInLevel{
    char *errMsg;
    NSString *createSecInLevel = @"create table if not exists section_in_level(levelid integer, sectionid integer, section_number integer primary key, foreign key(levelid) references level(levelid), foreign key(sectionid) references section(sectionid))";
    if(sqlite3_exec(database, [createSecInLevel UTF8String], NULL, NULL, &errMsg)!=SQLITE_OK){
        sqlite3_close(database);
        NSAssert(0, @"Section_in_Level failed to create.");
    }
    else{
        NSLog(@"Table Section_in_Level created successfully!");
    }
}

-(void)createLayerInSec{
    char *errMsg;
    NSString *createLayerInSec = @"create table if not exists layer_in_section(sectionid integer, layerid integer, layer_number integer primary key, instrument integer, foreign key(sectionid) references section(sectionid), foreign key(layerid) references layer(layerid))";
    if(sqlite3_exec(database, [createLayerInSec UTF8String], NULL, NULL, &errMsg)!=SQLITE_OK){
        sqlite3_close(database);
        NSAssert(0, @"Layer_in_Sec failed to create.");
    }
    else{
        NSLog(@"Table Layer_in_Sec created successfully!");
    }
}

-(void)initDatabaseTables{
    char *errorMsg;
    int itemCount = 0;
    NSString *checkPlayer = @"select count(pid) from player";
    sqlite3_stmt *statement;
    if(sqlite3_prepare_v2(database, [checkPlayer UTF8String], -1, &statement, nil)==SQLITE_OK){
        while(sqlite3_step(statement)==SQLITE_ROW){
            itemCount = sqlite3_column_int(statement, 0);
            NSLog(@"%d",itemCount);
        }
        if(itemCount == 0){
            NSString *insertPlayer = [[NSString alloc] initWithFormat:@"insert into player(pname,total_score,plevel) values('Me', '0', '0')"];
            if(sqlite3_exec(database, [insertPlayer UTF8String], NULL, NULL, &errorMsg)!=SQLITE_OK){
                sqlite3_close(database);
                NSLog(@"insert failed");
            }
        }
    }    
}

-(void)updatePlayerAndPlays{
    //SinglePlayerViewController *singlePlayer = [[SinglePlayerViewController alloc] init];
    //NSString *score = singlePlayer.scoreDisplay.text;
    //NSString *mistake = singlePlayer.mistakesLeftDisplay.text;
    char *errorMsg;
    NSLog(@"%u",game.mode);
    if(game.mode == SINGLE_PLAYER){
        //game.player.name = [NSString stringWithFormat:@"Me"];
        NSString *pname = @"Me";
        NSString *query1 = [NSString stringWithFormat:@"select pid, total_score from player where pname = '%@'",pname];
        //NSString *query1 = [NSString stringWithFormat:@"select * from player"];
        sqlite3_stmt *statement1;
        int test = sqlite3_prepare_v2(database, [query1 UTF8String], -1, &statement1, nil);
        if(test==SQLITE_OK){
        //const char * pnameChar = [pname UTF8String];
            while(sqlite3_step(statement1)==SQLITE_ROW){
                int pid = sqlite3_column_int(statement1, 0);
                int totalScore = sqlite3_column_int(statement1, 1)+ [game.player.score intValue];
                NSString *updatePlayer = [[NSString alloc] initWithFormat:@"update player set total_score = %d where pid = '%d'",totalScore, pid];
                NSString *insertPlays = [[NSString alloc] initWithFormat:@"insert into plays(pid,score,mistakes) values('%d','%d','%d')",pid,[game.player.score intValue],[game.player.mistakesMade intValue]];
                if(sqlite3_exec(database, [updatePlayer UTF8String], NULL, NULL, &errorMsg)!=SQLITE_OK  || sqlite3_exec(database, [insertPlays UTF8String], NULL, NULL, &errorMsg)!=SQLITE_OK){
                        //NSLog(@"Update successfully");
                    sqlite3_close(database);
                    NSLog(@"update failed");
                }
            }
            sqlite3_finalize(statement1);
            //}
        }
        else{
            sqlite3_finalize(statement1);
            NSLog(@"sql implementation failed");
        }
    }
    //return self;
    
}

-(void)insertLayer{
    char *errorMsg;
    Note *note = [[Note alloc] init];
    int degree = (int)note.degree;
    int duration = (int)note.duration;
    NSString *notes =[NSString stringWithFormat:@"%d.%d",degree,duration];
    NSString *insertLayer = [NSString stringWithFormat:@"insert into layer(notes) values('%@')",notes];
    if(sqlite3_exec(database, [insertLayer UTF8String], NULL, NULL, &errorMsg)!=SQLITE_OK){
        sqlite3_close(database);
        NSLog(@"insertLayer failed");
    }
    
}

// get layerid to combine the order for section
-(NSMutableArray *)getLayer{
    NSString *getLayer = [NSString stringWithFormat:@"select * from layer"];
    sqlite3_stmt *statement;
    NSMutableArray *layerColumn = [[NSMutableArray alloc] init];
    if(sqlite3_prepare_v2(database, [getLayer UTF8String], -1, &statement, nil)==SQLITE_OK){
        while (sqlite3_step(statement)==SQLITE_ROW) {
            NSArray *eachColumn = [[NSArray alloc]init];
            NSNumber *layerid = [NSNumber numberWithInt:sqlite3_column_int(statement, 0)];
            NSString *notes = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
            NSArray *notesColumn = [notes componentsSeparatedByString:@"."];
            NSNumber *degree = [NSNumber numberWithInt:[[notesColumn objectAtIndex:0] intValue]];
            NSNumber *duration = [NSNumber numberWithInt:[[notesColumn objectAtIndex:1] intValue]];
            
            [eachColumn arrayByAddingObject:layerid];
            [eachColumn arrayByAddingObject: degree];
            [eachColumn arrayByAddingObject: duration];
            [layerColumn addObject:eachColumn];
        }
        sqlite3_finalize(statement);
    }
    else{
        sqlite3_finalize(statement);
        NSLog(@"getLayer failed");
    }
    return layerColumn;
}

// user generate the name of sectionte
-(void)insertSection:(NSString *)sname{
    char *errorMsg;
    NSString *insertsection = [NSString stringWithFormat:@"insert into section(sname) values('%@')",sname];
    if(sqlite3_exec(database, [insertsection UTF8String], NULL, NULL, &errorMsg)!=SQLITE_OK){
        sqlite3_close(database);
        NSLog(@"insertSection failed");
    }
}

-(void)insertLayerInSection{
    char *errorMsg;
    Section *layerinsection = [[Section alloc] init];
    Layer *layer = [[Layer alloc] init];
    int layerid = [layerinsection.currentLayer intValue];
    NSArray *orderinarray = [NSArray arrayWithArray:layerinsection.order];
    NSMutableString *orderinstring = [[NSMutableString alloc] init];
    for(NSObject * obj in orderinarray){
        [orderinstring appendString:[obj description]];
    }
    int order = [orderinstring intValue];
    NSString *insertLayerInSection = [NSString stringWithFormat:@"insert into layer_in_section(sectionid,layerid,layer_number) values ('', '%d','%d')",layerid,order];
    if(sqlite3_exec(database, [insertLayerInSection UTF8String], NULL, NULL, &errorMsg)!=SQLITE_OK){
        sqlite3_close(database);
        NSLog(@"insertLayerInsection failed");
    }
    
}

-(NSMutableArray *)getLayerInSection{
    NSString *getLayerInSection = @"select * from layer_in_section";
    sqlite3_stmt *statement;
    NSMutableArray *result = [[NSMutableArray alloc] init];
    if (sqlite3_prepare_v2(database, [getLayerInSection UTF8String], -1, &statement, nil)==SQLITE_OK) {
        while (sqlite3_step(statement)==SQLITE_ROW) {
            NSArray * eachColumn = [[NSArray alloc]init];
            NSNumber *sectionid = [NSNumber numberWithInt:sqlite3_column_int(statement, 0)];
            NSNumber *layerid = [NSNumber numberWithInt:sqlite3_column_int(statement, 1)];
            NSNumber *order = [NSNumber numberWithInt:sqlite3_column_int(statement, 2)];
            NSNumber *instrument = [NSNumber numberWithInt:sqlite3_column_int(statement, 3)];
            [eachColumn arrayByAddingObject:sectionid];
            [eachColumn arrayByAddingObject:layerid];
            [eachColumn arrayByAddingObject:order];
            [eachColumn arrayByAddingObject:instrument];
            [result addObject:eachColumn];
                                   
        }
        sqlite3_finalize(statement);
    }
    else{
        sqlite3_finalize(statement);
        NSLog(@"getLayer failed");
    }
    return result;
}

-(void)insertSectionInLevel{
    char *errorMsg;
    Level *sectioninlevel = [[Level alloc] init];
    int sectionid = [sectioninlevel.currentSection intValue];
    NSArray *orderinarray = [NSArray arrayWithArray:sectioninlevel.order];
    NSMutableString *orderinstring = [[NSMutableString alloc]init];
    for (NSObject *obj in orderinarray) {
        [orderinstring appendString:[obj description]];
    }
    int order = [orderinstring intValue];
    NSString *insertSectionInLevel = [NSString stringWithFormat:@"insert into section_in_level(levelid,sectionid,section_number) values('','%d','%d')",sectionid,order];
    if(sqlite3_exec(database, [insertSectionInLevel UTF8String], NULL, NULL, &errorMsg)!=SQLITE_OK){
        sqlite3_close(database);
        NSLog(@"insertSectionInLevel failed");
    }
    
}

-(void)implementationForLevel{}


//-(NSMutableArray *)getLevel{
//    NSString *getLevel = @"select * from level";
//    sqlite3_stmt *statement;
//    NSMutableArray *result = [[NSMutableArray alloc]init];
//    if (sqlite3_prepare_v2(database, [getLevel UTF8String], -1, &statement, nil)==SQLITE_OK) {
//        while (sqlite3_step(statement)==SQLITE_ROW) {
//            NSArray *eachColum = [[NSArray alloc]init];
//            
//        }
//    }
//}
@end
