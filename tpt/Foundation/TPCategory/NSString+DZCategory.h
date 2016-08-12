//
//  NSString+DZCategory.h
//  Meidaojia
//
//  Created by Darren on 15/5/20.
//  Copyright (c) 2015年 Darren Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (DZCategory)

//字符串为空
+(BOOL)isNull:(NSString *)string;


- (CGSize)sizeForMaxWidth:(CGFloat)width
                     font:(UIFont *)font
            numberOfLines:(int)numberOfLines;
- (CGSize)sizeForMaxWidth:(CGFloat)width
                     font:(UIFont *)font;



@end
