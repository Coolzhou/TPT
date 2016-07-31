//
//  UIButton+FillColor.m
//  123456
//
//  Created by Meteorshower on 16/6/24.
//  Copyright © 2016年 Meteorshower. All rights reserved.
//

#import "UIButton+FillColor.h"

//@interface UIButton (FillColor)
//- (void)centerImageAndTitle:(float)space;
//- (void)centerImageAndTitle;
//@end

@implementation UIButton (FillColor)

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    [self setBackgroundImage:[UIButton imageWithColor:backgroundColor] forState:state];
}
//用颜色生成一个图片
+ (UIImage *)imageWithColor:(UIColor *)color {
    //定义一个尺寸
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    //开始图形绘制
    UIGraphicsBeginImageContext(rect.size);
    //一个不透明类型的Quartz 2D绘画环境,相当于一个画布,你可以在上面任意绘画
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //设置填充颜色(通过颜色设置填充颜色)
    CGContextSetFillColorWithColor(context, [color CGColor]);
    //填充框
    CGContextFillRect(context, rect);
    
    //设置图片(UIGraphicsGetImageFromCurrentImageContext(从当前图片的上下文获取图形图片))
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //绘制图形结束
    UIGraphicsEndImageContext();
    
    return image;
}

//- (void)centerImageAndTitle:(float)spacing{
//    
//    // get the size of the elements here for readability
//    CGSize imageSize = self.imageView.frame.size;
//    CGSize titleSize = self.titleLabel.frame.size;
//    
//    // get the height they will take up as a unit
//    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
//    
//    // raise the image and push it right to center it
//    self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
//    
//    // lower the text and push it left to center it
//    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (totalHeight - titleSize.height),0.0);
//}
//
//- (void)centerImageAndTitle{
//    
//    const int DEFAULT_SPACING = 6.0f;
//    [self centerImageAndTitle:DEFAULT_SPACING];
//}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    CGFloat imageW = self.bounds.size.width - 16;
//    CGFloat imageH = imageW;
//    
//    // Center image
//    CGRect imageFrame = [self imageView].bounds;
//    imageFrame.origin.x = self.bounds.size.width / 2;
//    imageFrame.origin.y = self.bounds.size.height / 2;
//    imageFrame.size.width = imageW;
//    imageFrame.size.height = imageH;
//    self.imageView.frame = imageFrame;
//    
//    //Center text
//    CGRect newFrame = [self titleLabel].bounds;
//    newFrame.origin.x = 0;
//    newFrame.origin.y = imageH + 1;
//    newFrame.size.width = self.bounds.size.width;
//    newFrame.size.height = self.bounds.size.width - imageH;
//    
//    self.titleLabel.frame = newFrame;
//    self.titleLabel.textAlignment = NSTextAlignmentCenter;
//
//}
@end
