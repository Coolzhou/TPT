//
//  TPTStateCacheTool.m
//  tpt
//
//  Created by apple on 16/8/12.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import "TPTStateCacheTool.h"
#import "WBTemperature.h"
#import "FMDB.h"

@implementation TPTStateCacheTool

static FMDatabaseQueue *_queue;

+(void)setup
{
    //0.获得沙盒的数据库文件名
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"temps.sqlite"];

    NSLog(@"温度记录  path = %@",path);
    //1. 创建队列
    _queue = [FMDatabaseQueue databaseQueueWithPath:path];

    //2.创表
    [_queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"create table if not exists t_temp_state (id integer primary key autoincrement, create_time text, temperture real,temp blob,temp_state text);"];
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
        NSString *create_time = temp.create_time;
        NSString *temp_state = temp.temp_state;
        NSNumber *temperture = @(temp.temp);
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:temp];

        //2.存储数据
        [db executeUpdate:@"insert into t_temp_state (create_time, temperture,temp,temp_state) values(? ,? ,?,?)",create_time,temperture,data,temp_state];
    }];

    [_queue close];
    NSLog(@"缓存数据");
}

//返回状态数组

+(NSArray *)getTemperature
{
    [self setup];
    //1. 定义数组
    __block NSMutableArray *tempAry = nil;

    //2. 使用数据库
    [_queue inDatabase:^(FMDatabase *db) {
        tempAry = [NSMutableArray array];

        FMResultSet *rs = nil;
        rs = [db executeQuery:@"select * from t_temp_state  order by create_time desc"];
        while (rs.next) {
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
        rs = [db executeQuery:@"select* from t_temp_state where tempID = ? order by temperture desc limit 0,1",@(tempID)];
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
        rs = [db executeQuery:@"select * from t_temp_state where tempID = ? order by temperture asc limit 0,1",@(tempID)];
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
        rs = [db executeQuery:@"select   *   from   t_temp_state t   group   by    t.tempID"];
        while (rs.next) {
            NSNumber  *tempID = @([rs intForColumn:@"tempID"]);
            [array addObject:tempID];
        }

    }];
    [_queue close];
    return  [array copy];
}

+(void)deleteTemp:(NSString*)tempID
{
    [self setup];

    NSLog(@"tempID = %@",tempID);

    [_queue inDatabase:^(FMDatabase *db) {

        [db executeUpdate:@"delete from t_temp_state where create_time = ?",tempID];
    }];

    [_queue close];

}

+(void)deleteAllTemp
{
    [self setup];
    [_queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"drop table t_temp_state"];
    }];
    [_queue close];
}

@end
