//
//  UIImage+DZCategory.h
//  DZFoundation
//
//  Created by Darren on 15/5/28.
//  Copyright (c) 2015年 Darren Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (DZCategory)



// 压缩图片大小：改变其分辨率
- (UIImage *)resizedImageWithWidth:(CGFloat)width
                            height:(CGFloat)height
                            opaque:(BOOL)bOpaque
                             scale:(CGFloat)fScale;

/**
 *  通过指定图片最长边，获得等比例的图片size
 *
 *  @param image       原始图片
 *  @param imageLength 图片允许的最长宽度（高度）
 *
 *  @return 获得等比例的size
 */
+ (CGSize)scaleImage:(UIImage *) image withLength:(CGFloat) imageLength;


/**
 *  通过指定图片最长边，获得等比例的图片NSData
 *
 *  @param image       原始图片
 *  @param imageLength 图片允许的最长宽度（高度）
 *
 *  @return 获得等比例的size
 */
- (NSData *)datascaleImage:(UIImage *) image withLength:(CGFloat) imageLength;



//将图片剪切成圆形
+(UIImage*)circleImage:(UIImage*) image withParam:(CGFloat) inset;

+ (UIImage *)fixOrientation:(UIImage *)aImage;

//根据颜色返回一个1*1像素的图像
+(UIImage *)imageWithColor:(UIColor *)color;

//返回一个特定尺寸的图像
+(UIImage *)imageWithColor:(UIColor *)color imageSize:(CGSize)imageSize;

//图片等比例压缩
- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize;
@end
