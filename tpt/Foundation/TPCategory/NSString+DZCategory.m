//
//  NSString+DZCategory.m
//  Meidaojia
//
//  Created by Darren on 15/5/20.
//  Copyright (c) 2015年 Darren Zheng. All rights reserved.
//

#import "NSString+DZCategory.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (DZCategory)


- (CGSize)sizeForMaxWidth:(CGFloat)width
                     font:(UIFont *)font
{
    return [self sizeForMaxWidth:width font:font numberOfLines:0];
}

- (CGSize)sizeForMaxWidth:(CGFloat)width
                     font:(UIFont *)font
            numberOfLines:(int)numberOfLines
{
    CGRect rect = [self boundingRectWithSize:CGSizeMake(width, numberOfLines == 0 ? CGFLOAT_MAX : [font pointSize] * (numberOfLines + 1))
                                     options:NSLineBreakByWordWrapping | NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName: font}
                                     context:nil];
    rect.size.width = ceil(rect.size.width);
    rect.size.height = ceil(rect.size.height);
    return rect.size;
}

//判断字符是否空

+(BOOL)isNull:(NSString *)string
{
    if (string == nil) {
        return YES;
    }
    if (string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([string isEqualToString:@"(null)"]) {
        return YES;
    }
    if ([string isEqualToString:@"<null>"]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

@end
