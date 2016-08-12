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
