//
//  PlayerInfo.m
//  Paula
//
//  Created by Yue Cao on 11/15/12.
//  Copyright (c) 2012 Yue Cao. All rights reserved.
//

#import "PlayerInfo.h"

@implementation PlayerInfo

@synthesize pid, name, totalScore, level;

-(id)initWithUniqueID:(int)pid name:(NSString *)name score:(int)totalScore level:(int)level{
    self = [super init];
    if(self){
        self.pid = pid;
        self.name = name;
        self.totalScore = totalScore;
        self.level = level;
    }
    return self;
}

-(void)dealloc{
    self.name = nil;
    
}

@end
