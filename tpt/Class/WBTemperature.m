//
//  WBTemperature.m
//  WenBoshi
//
//  Created by 马浩然 on 15/3/30.
//  Copyright (c) 2015年 luoshuisheng. All rights reserved.
//

#import "WBTemperature.h"
#import "MJExtension.h"
@implementation WBTemperature

-( void )encodeWithCoder:(NSCoder * )encoder
{

    [ encoder encodeFloat:self.temp forKey:@"temp"];
    [ encoder encodeObject:self.temp_state forKey:@"temp_state"];

    [ encoder encodeInt:self.temp_time forKey:@"temp_time"];
    [ encoder encodeInt :self.create_time forKey:@"create_time"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init ] ){
        //读取文件的内容

        self.temp = [decoder decodeFloatForKey:@"temp"];
        self.temp_state = [ decoder decodeObjectForKey:@"temp_state"];

        self.create_time = [decoder decodeIntForKey:@"create_time"];
        self.temp_time = [ decoder decodeIntForKey:@"temp_time"];
    }
    return self;
}


@end
