//
//  alertSetTwoCell.h
//  tpt
//
//  Created by apple on 16/8/11.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SevenSwitch.h"
@interface alertSetTwoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet SevenSwitch *switchBtn;


+ (instancetype)thealertSetTwoCellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexpath;

@end
