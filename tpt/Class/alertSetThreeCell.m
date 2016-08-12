//
//  alertSetThreeCell.m
//  tpt
//
//  Created by apple on 16/8/11.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import "alertSetThreeCell.h"

@implementation alertSetThreeCell

- (void)awakeFromNib {
    // Initialization code

    self.lineMargeOne.constant = (kScreenWidth - 30-3)/4;
    self.lineMargeTwo.constant = (kScreenWidth - 30-3)/4;
    self.lineMargeThree.constant = (kScreenWidth - 30-3)/4;

    self.wLineOneView.backgroundColor = LineColor;
    self.wLineTwoView.backgroundColor = LineColor;
    self.hLineOneView.backgroundColor = LineColor;
    self.hlineTwoView.backgroundColor = LineColor;
    self.hLineThreeView.backgroundColor = LineColor;

    self.bgView.backgroundColor = RGBA(211, 213, 190,0.5);
    self.bgView.layer.cornerRadius = 5;
    self.bgView.layer.masksToBounds = YES;

    self.bgView.layer.borderWidth = 1;
    self.bgView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;

    self.contentLable.textColor = MainContentColor;
    self.titleLable.textColor = [UIColor orangeColor];

    self.topTitleOneLable.textColor = kColorWithRGB(0x62922C);
    self.topTitleTwoLable.textColor = kColorWithRGB(0x62922C);
    self.topTitleThreeLable.textColor = kColorWithRGB(0x62922C);
    self.topTitleFreeLable.textColor = kColorWithRGB(0x62922C);

    
}

+ (instancetype)thealertSetThreeCellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexpath{
    static NSString *ID = @"alerthreeCell";
    alertSetThreeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = (alertSetThreeCell*)[[NSBundle mainBundle]loadNibNamed:@"alertSetThreeCell" owner:nil options:nil][0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
