//
//  alertSetFreeCell.m
//  tpt
//
//  Created by apple on 16/8/11.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import "alertSetFreeCell.h"

@implementation alertSetFreeCell

- (void)awakeFromNib {
    // Initialization code
    self.bgImgView.image = [[UIImage imageNamed:@"tui_cell_bg"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    self.titleLable.textColor = [UIColor orangeColor];
    self.titleOneLable.textColor = MainContentColor;
    self.titleTwoLable.textColor = MainContentColor;

    self.shengSwitchBtn.arrange = CustomSwitchArrangeONLeftOFFRight;
    self.shengSwitchBtn.onImage = [UIImage imageNamed:@"switchOne_on"];
    self.shengSwitchBtn.offImage = [UIImage imageNamed:@"switchOne_off"];
    self.shengSwitchBtn.status = CustomSwitchStatusOff;

    self.dongSwitchBtn.arrange = CustomSwitchArrangeONLeftOFFRight;
    self.dongSwitchBtn.onImage = [UIImage imageNamed:@"switchOne_on"];
    self.dongSwitchBtn.offImage = [UIImage imageNamed:@"switchOne_off"];
    self.dongSwitchBtn.status = CustomSwitchStatusOff;
}

+ (instancetype)thealertSetFreeCellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexpath{
    static NSString *ID = @"alerfreeCell";
    alertSetFreeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = (alertSetFreeCell*)[[NSBundle mainBundle]loadNibNamed:@"alertSetFreeCell" owner:nil options:nil][0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
