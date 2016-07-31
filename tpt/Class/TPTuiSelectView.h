//
//  TPTuiSelectView.h
//  tpt
//
//  Created by Yi luqi on 16/7/31.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^tuiSelectButBlock)(int Btntag);

@interface TPTuiSelectView : UIView

@property (nonatomic,copy)tuiSelectButBlock tuiBlock;

@end
