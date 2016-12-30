//
//  alertSetTwoCell.m
//  tpt
//
//  Created by apple on 16/8/11.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import "alertSetTwoCell.h"

@interface alertSetTwoCell()

@end

@implementation alertSetTwoCell

- (void)awakeFromNib {
    // Initialization code

    [super awakeFromNib];

    self.bgImgView.image = [[UIImage imageNamed:@"tui_cell_bg"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];

    self.titleLable.textColor = MainContentColor;

    self.switchBtn.onTintColor = [UIColor colorWithRed:0.20f green:0.42f blue:0.86f alpha:1.00f];
    self.switchBtn.selectType = SevenSwitchImageType;
    [self.switchBtn addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    if (UserModel.max_alert_state) {
        self.switchBtn.on = YES;
    }else{
        self.switchBtn.on = NO;
    }
    self.titleLable.text = NSLocalizedString(@"max_tem_switch", @"");
}

- (void)switchChanged:(SevenSwitch *)sender {

    if (sender.on == YES) {
         UserModel.max_alert_state = YES;
    }else{
         UserModel.max_alert_state = NO;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"All_STATE" object:nil];
    }
}

+ (instancetype)thealertSetTwoCellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexpath{
    static NSString *ID = @"alertwoCell";
    alertSetTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = (alertSetTwoCell*)[[NSBundle mainBundle]loadNibNamed:@"alertSetTwoCell" owner:nil options:nil][0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
