//
//  TPTSetEleCell.m
//  tpt
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import "TPTSetEleCell.h"

@implementation TPTSetEleCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.bgImgView.image = [[UIImage imageNamed:@"set_bg_red"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    self.titleLable.text = NSLocalizedString(@"setting_power",@"");
    NSString *content = NSLocalizedString(@"setting_power_lest",@"");

    if ([NSString isNull:UserModel.temp_currentElec]) {
        UserModel.temp_currentElec = @"35";
    }
    self.contentLable.text = [NSString stringWithFormat:@"%@%@%%",content,UserModel.temp_currentElec];
}

+ (instancetype)theTPTSetEleCellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexpath{
    static NSString *ID = @"SetEleCell";
    TPTSetEleCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = (TPTSetEleCell*)[[NSBundle mainBundle]loadNibNamed:@"TPTSetEleCell" owner:nil options:nil][0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
