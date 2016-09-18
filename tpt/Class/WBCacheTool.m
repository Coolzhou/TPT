//
//  WBCacheTool.m
//  WenBoshi
//
//  Created by 马浩然 on 15/3/30.
//  Copyright (c) 2015年 luoshuisheng. All rights reserved.
//

#import "WBCacheTool.h"
#import "WBTemperature.h"
#import "FMDB.h"

@implementation WBCacheTool

static FMDatabaseQueue *_queue;

+(void)setup
{

    //0.获得沙盒的数据库文件名
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"temps.sqlite"];
    
    NSLog(@"path = %@",path);
    //1. 创建队列
    _queue = [FMDatabaseQueue databaseQueueWithPath:path];
    
    //2.创表
    [_queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"create table if not exists t_temp (id integer primary key autoincrement, create_time integer, temperture real,temp blob);"];
    }];
    
}

+(void)addtemperatures:(NSArray *)tempAry
{
    for (WBTemperature *temp in tempAry) {
        [self addTemperature:temp];
    }
}

+(void)addTemperature:(WBTemperature *)temp
{
    [self setup];
    [_queue inDatabase:^(FMDatabase *db) {
        
        //1.获得需要存储的数据
        int create_time = temp.create_time;
        NSNumber *temperture = @(temp.temp);
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:temp];
        //2.存储数据
        [db executeUpdate:@"insert into t_temp (create_time, temperture,temp) values(? ,? ,?)",@(create_time), temperture,data];
    }];
    
    [_queue close];
    NSLog(@"缓存数据");
}

//得到历史记录数组

+(NSArray *)getTemperature
{
    [self setup];
    //1. 定义数组
    __block NSMutableArray *tempAry = nil;
    
    //2. 使用数据库
    [_queue inDatabase:^(FMDatabase *db) {
        tempAry = [NSMutableArray array];
        FMResultSet *rs = nil;
        rs = [db executeQuery:@"select  * from t_temp order by id asc"];
        while (rs.next) {
            NSLog(@"11111111");
            NSData *data = [rs dataForColumn:@"temp"];
            WBTemperature *temp = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [tempAry addObject:temp];
        }
    }];
    [_queue close];
    
    return tempAry;
}

+(CGFloat)getMaxTemp:(int)tempID
{
    [self setup];

    __block WBTemperature *temp;
    [_queue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *rs = nil;
        rs = [db executeQuery:@"select* from t_temp where tempID = ? order by temperture desc limit 0,1",@(tempID)];
        while (rs.next) {
            NSData *data = [rs dataForColumn:@"temp"];
            temp = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
    }];
    [_queue close];
    return temp.temp;
}

+(CGFloat)getMinTemp:(int)tempID
{
    [self setup];
    __block WBTemperature *temp;
    
    [_queue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *rs = nil;
        rs = [db executeQuery:@"select * from t_temp where tempID = ? order by temperture asc limit 0,1",@(tempID)];
        while (rs.next) {
            NSData *data = [rs dataForColumn:@"temp"];
            temp = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
        
    }];
    [_queue close];
    return temp.temp;
}

+(NSArray*)temperatureCounts
{
    [self setup];
    NSMutableArray *array = [NSMutableArray array];
    [_queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = nil;
        rs = [db executeQuery:@"select   *   from   t_temp t   group   by    t.tempID"];
        while (rs.next) {
             NSNumber  *tempID = @([rs intForColumn:@"tempID"]);
            [array addObject:tempID];
        }
        
    }];
    [_queue close];
    return  [array copy];
}

/** 当天记录的数组数*/
+(NSArray*)temperatureDateCounts:(int)tempID{
    [self setup];
    NSLog(@"tempID = %d",tempID);
    int tempDD = tempID + 86400;
    NSMutableArray *array = [NSMutableArray array];
    [_queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = nil;
        rs = [db executeQuery:@"select* from t_temp where create_time > ? and create_time <? order by id asc",@(tempID),@(tempDD)];
        while (rs.next) {
            NSData *data = [rs dataForColumn:@"temp"];
            WBTemperature *temp = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [array addObject:temp];
        }

    }];
    [_queue close];
    return  [array copy];
}

+(void)deleteTemp:(int)tempID
{
    [self setup];
    
    [_queue inDatabase:^(FMDatabase *db) {

        [db executeUpdate:@"delete from t_temp where create_time <?",@(tempID)];
        
    }];
    
    [_queue close];
}

+(void)deleteAllTemp
{
    [self setup];
    
    [_queue inDatabase:^(FMDatabase *db) {
        
        [db executeUpdate:@"drop table t_temp"];
    }];
    [_queue close];
}

@end
