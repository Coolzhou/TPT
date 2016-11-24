//
//  alertSetFreeCell.m
//  tpt
//
//  Created by apple on 16/8/11.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import "alertSetFreeCell.h"

@interface alertSetFreeCell()

@end

@implementation alertSetFreeCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.bgImgView.image = [[UIImage imageNamed:@"tui_cell_bg"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    self.titleLable.textColor = [UIColor orangeColor];
    self.titleOneLable.textColor = MainContentColor;
    self.titleTwoLable.textColor = MainContentColor;


    self.shengSwitchBtn.onTintColor = [UIColor colorWithRed:0.20f green:0.42f blue:0.86f alpha:1.00f];
    self.shengSwitchBtn.selectType = SevenSwitchImageType;
    [self.shengSwitchBtn addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    if (UserModel.max_notify_voice) {
        self.shengSwitchBtn.on = YES;
    }else{
        self.shengSwitchBtn.on = NO;
    }

    self.dongSwitchBtn.onTintColor = [UIColor colorWithRed:0.20f green:0.42f blue:0.86f alpha:1.00f];
    self.dongSwitchBtn.selectType = SevenSwitchImageType;
    [self.dongSwitchBtn addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    if (UserModel.max_notify_vibration) {
        self.dongSwitchBtn.on = YES;
    }else{
        self.dongSwitchBtn.on = NO;
    }

    self.lineView.backgroundColor = MainTitleColor;
    self.lineTwoView.backgroundColor = MainTitleColor;

    self.titleLable.text = NSLocalizedString(@"max_notify", @"");
    self.titleOneLable.text = NSLocalizedString(@"max_notify_voice", @"");
    self.titleTwoLable.text = NSLocalizedString(@"max_notify_vibration", @"");
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


- (void)switchChanged:(SevenSwitch *)sender {
    if (sender == self.shengSwitchBtn) {
        if (sender.on == YES) {
            UserModel.max_notify_voice = YES;
        }else{
            UserModel.max_notify_voice = NO;
        }
    }else{
        if (sender.on == YES) {
            UserModel.max_notify_vibration = YES;
        }else{
            UserModel.max_notify_vibration = NO;
        }
    }

    NSLog(@"11user.deve = %d  tempunit = %d ,sender.tag = %ld",UserModel.device_disconnect,UserModel.temp_unit ,(long)sender.tag);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
