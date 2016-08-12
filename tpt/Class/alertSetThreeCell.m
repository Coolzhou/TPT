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
