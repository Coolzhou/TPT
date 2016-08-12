//
//  TPTSetupCell.h
//  tpt
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CustomSwitch.h"

typedef void(^SetupCellBlock)(NSInteger tag);

@interface TPTSetupCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;

@property (weak, nonatomic) IBOutlet UILabel *titleOneLable;
@property (weak, nonatomic) IBOutlet UILabel *titleTwoLable;
@property (weak, nonatomic) IBOutlet UILabel *titleThreeLable;
@property (weak, nonatomic) IBOutlet UILabel *titleFreeLable;

@property (weak, nonatomic) IBOutlet UILabel *contentOneLable;
@property (weak, nonatomic) IBOutlet UILabel *contentTwoLable;
@property (weak, nonatomic) IBOutlet UILabel *contentThreeLable;
@property (weak, nonatomic) IBOutlet UILabel *contentFreeLable;

@property (weak, nonatomic) IBOutlet UIView *lineOne;
@property (weak, nonatomic) IBOutlet UIView *lineTwo;
@property (weak, nonatomic) IBOutlet UIView *lineThree;

@property (weak, nonatomic) IBOutlet UIButton *rightBtnOne;
@property (weak, nonatomic) IBOutlet UIButton *rightBtnTwo;

@property (weak, nonatomic) IBOutlet CustomSwitch *switchOne;
@property (weak, nonatomic) IBOutlet CustomSwitch *switchTwo;


@property (nonatomic,copy) SetupCellBlock setUpBlock;

+ (instancetype)theTPTSetupCellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexpath;

@end
