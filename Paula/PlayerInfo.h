//
//  PlayerInfo.h
//  Paula
//
//  Created by Yue Cao on 11/15/12.
//  Copyright (c) 2012 Yue Cao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayerInfo : NSObject{
    int pid;
    __unsafe_unretained NSString *name;
    int totalScore;
    int level;
}

@property (nonatomic,assign) int pid;
@property (nonatomic,assign) NSString *name;
@property (nonatomic,assign) int totalScore;
@property (nonatomic,assign) int level;

-(id)initWithUniqueID:(int)pid name:(NSString *)name score:(int)totalScore level:(int)level;
@end
