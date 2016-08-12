//
//  alertSetOneCell.m
//  tpt
//
//  Created by apple on 16/8/11.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import "alertSetOneCell.h"

@implementation alertSetOneCell

- (void)awakeFromNib {
    // Initialization code
    self.bgView.backgroundColor = RGB(211, 213, 208);
}

+ (instancetype)thealertSetOneCellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexpath{
    static NSString *ID = @"alertoneCell";
    alertSetOneCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = (alertSetOneCell*)[[NSBundle mainBundle]loadNibNamed:@"alertSetOneCell" owner:nil options:nil][0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
