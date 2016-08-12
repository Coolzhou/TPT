//
//  alertSetTwoCell.m
//  tpt
//
//  Created by apple on 16/8/11.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import "alertSetTwoCell.h"

@implementation alertSetTwoCell

- (void)awakeFromNib {
    // Initialization code

    self.bgImgView.image = [[UIImage imageNamed:@"tui_cell_bg"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
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
