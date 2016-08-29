//
//  TPTSetupCell.m
//  tpt
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import "TPTSetupCell.h"

@interface TPTSetupCell()

@end

@implementation TPTSetupCell

- (void)awakeFromNib {
    // Initialization code
    self.bgImgView.image = [[UIImage imageNamed:@"tui_cell_bg"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    self.lineOne.backgroundColor = MainTitleColor;
    self.lineTwo.backgroundColor = MainTitleColor;
    self.lineThree.backgroundColor = MainTitleColor;

    self.titleOneLable.textColor = MainTitleColor;
    self.titleTwoLable.textColor = MainTitleColor;
    self.titleThreeLable.textColor = MainTitleColor;
    self.titleFreeLable.textColor = MainTitleColor;

    self.contentOneLable.textColor = MainContentColor;
    self.contentTwoLable.textColor = MainContentColor;
    self.contentThreeLable.textColor = MainContentColor;
    self.contentFreeLable.textColor = MainContentColor;

    [self.rightBtnOne setTitleColor:MainContentColor forState:UIControlStateNormal];
    [self.rightBtnTwo setTitleColor:MainContentColor forState:UIControlStateNormal];


    self.switchOne.onTintColor = [UIColor colorWithRed:0.20f green:0.42f blue:0.86f alpha:1.00f];
    self.switchOne.selectType = SevenSwitchImageType;
    [self.switchOne addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    if (UserModel.device_disconnect) {
        self.switchOne.on = YES;
    }else{
        self.switchOne.on = NO;
    }

    self.switchTwo.selectType = SevenSwitchTitleType;
    [self.switchTwo addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    self.switchTwo.offTitleStr = @"℃";
    self.switchTwo.onTitleStr = @"℉";
    self.switchTwo.onTintColor = RGB(253, 221, 12);
    self.switchTwo.inactiveColor = RGB(45, 188, 187);
    self.switchTwo.isRounded = YES;
    if (UserModel.temp_unit) {
        self.switchTwo.on = YES;
    }else{
        self.switchTwo.on = NO;
    }

    NSLog(@"user.deve = %d  tempunit = %d",UserModel.device_disconnect,UserModel.temp_unit);
    self.titleOneLable.text = NSLocalizedString(@"setting_cut_tip",@"");
    self.titleTwoLable.text = NSLocalizedString(@"setting_max_tem",@"");
    self.titleThreeLable.text = NSLocalizedString(@"setting_tem_unit",@"");
    self.titleFreeLable.text = NSLocalizedString(@"setting_tem_check",@"");

    self.contentOneLable.text = NSLocalizedString(@"setting_cut_tip_content",@"");
    self.contentTwoLable.text = NSLocalizedString(@"setting_max_tem_content",@"");
    self.contentThreeLable.text = NSLocalizedString(@"setting_tem_unit_content",@"");
    self.contentFreeLable.text = NSLocalizedString(@"setting_tem_check_content",@"");

    [self.rightBtnOne setTitle:NSLocalizedString(@"setting",@"") forState:UIControlStateNormal];
    [self.rightBtnTwo setTitle:NSLocalizedString(@"setting",@"") forState:UIControlStateNormal];

}

+ (instancetype)theTPTSetupCellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexpath{
    static NSString *ID = @"setupCell";
    TPTSetupCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = (TPTSetupCell*)[[NSBundle mainBundle]loadNibNamed:@"TPTSetupCell" owner:nil options:nil][0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (IBAction)rightOneButClick:(UIButton *)sender {
    self.setUpBlock(sender.tag);
}
- (IBAction)rightTwoClick:(UIButton *)sender {
    self.setUpBlock(sender.tag);
}

- (void)switchChanged:(SevenSwitch *)sender {
    if (sender.tag == 10) {
        if (sender.on == YES) {
            UserModel.device_disconnect = YES;
        }else{
            UserModel.device_disconnect = NO;
        }
    }else{
        if (sender.on == YES) {
            UserModel.temp_unit = YES;
        }else{
            UserModel.temp_unit = NO;
        }
    }

    NSLog(@"11user.deve = %d  tempunit = %d ,sender.tag = %ld",UserModel.device_disconnect,UserModel.temp_unit ,(long)sender.tag);
}

//-(void)customSwitchView:(CustomSwitch *)switchViwe SetStatus:(CustomSwitchStatus)status{
//    if (switchViwe.tag == 10) {
//        if (status == CustomSwitchStatusOn) {
//            UserModel.device_disconnect = YES;
//        }else{
//            UserModel.device_disconnect = NO;
//        }
//    }else{
//        if (status == CustomSwitchStatusOn) {
//            UserModel.temp_unit = YES;
//        }else{
//            UserModel.temp_unit = NO;
//        }
//    }
//    NSLog(@"11user.deve = %d  tempunit = %d",UserModel.device_disconnect,UserModel.temp_unit);
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
