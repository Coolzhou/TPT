//
//  UIColor+Hex.h
//  Meidaojia
//
//  Created by apple on 15/9/7.
//  Copyright (c) 2015年 Darren Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)
+ (UIColor *)colorWithHex:(UInt32)hex;
+ (UIColor *)colorWithHex:(UInt32)hex andAlpha:(CGFloat)alpha;
+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (UIColor *)colorWithHexString:(NSString *)hexString andAlpha:(CGFloat)alpha;
- (NSString *)HEXString;

+ (UIColor *)colorWithWholeRed:(CGFloat)red
                         green:(CGFloat)green
                          blue:(CGFloat)blue
                         alpha:(CGFloat)alpha;

+ (UIColor *)colorWithWholeRed:(CGFloat)red
                         green:(CGFloat)green
                          blue:(CGFloat)blue;
@end
