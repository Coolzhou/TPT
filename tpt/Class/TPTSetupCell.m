//
//  TPTSetupCell.m
//  tpt
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import "TPTSetupCell.h"

@implementation TPTSetupCell

- (void)awakeFromNib {
    // Initialization code
    self.bgImgView.image = [[UIImage imageNamed:@"tui_cell_bg"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    self.lineOne.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"set_bg_red"]];
    self.lineTwo.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"set_bg_red"]];
    self.lineThree.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"set_bg_red"]];

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

    self.switchOne.arrange = CustomSwitchArrangeONLeftOFFRight;
    self.switchOne.onImage = [UIImage imageNamed:@"switchOne_on"];
    self.switchOne.offImage = [UIImage imageNamed:@"switchOne_off"];
    self.switchOne.status = CustomSwitchStatusOff;


    self.switchTwo.arrange = CustomSwitchArrangeONLeftOFFRight;
    self.switchTwo.onImage = [UIImage imageNamed:@"switchOne_on"];
    self.switchTwo.offImage = [UIImage imageNamed:@"switchOne_off"];
    self.switchTwo.status = CustomSwitchStatusOff;

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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
