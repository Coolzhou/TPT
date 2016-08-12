//
//  alertSetFreeCell.h
//  tpt
//
//  Created by apple on 16/8/11.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomSwitch.h"
@interface alertSetFreeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;

@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *titleOneLable;
@property (weak, nonatomic) IBOutlet UILabel *titleTwoLable;

@property (weak, nonatomic) IBOutlet CustomSwitch *shengSwitchBtn;
@property (weak, nonatomic) IBOutlet CustomSwitch *dongSwitchBtn;

+ (instancetype)thealertSetFreeCellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexpath;

@end
