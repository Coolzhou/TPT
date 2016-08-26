//
//  XPQRotateDials.h
//  XPQRotateDials
//
//  Created by RHC on 15/7/24.
//  Copyright (c) 2015年 com.launch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XPQRotateDials : UIView
{
    CALayer *tachLayer;
    CALayer *pinLayer;
}

@property (nonatomic,strong)NSString *refresh;

@property (nonatomic,strong)NSString *value;

/*
 * @brief   值转化成指针对应的角度。
 注意：必须要设定好minValue、maxValue、rulingStartAngle、rulingStopAngle此函数才可用，不然得到的结果将不正确。
 * @param   value   要转换的值
 * @return  转换后的角度
 */
-(CGFloat)angleWithValue:(CGFloat)value;

@end
