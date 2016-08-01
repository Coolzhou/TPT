//
//  ZCmainCell.m
//  zctx
//
//  Created by Yi luqi on 15/10/7.
//  Copyright © 2015年 sanliang. All rights reserved.
//

#import "TPTuiCell.h"

@implementation TPTuiCell

- (void)awakeFromNib {
    // Initialization code
    self.titleLabel.textColor = MainTitleColor;

}

+ (instancetype)theTuiWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexpath{
    static NSString *ID = @"tuiCell";
    TPTuiCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = (TPTuiCell*)[[NSBundle mainBundle]loadNibNamed:@"TPTuiCell" owner:nil options:nil][0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexpath.row==0) {
        cell.titleLabel.hidden = YES;
        cell.rightImageView.hidden = YES;
        cell.titleConstraintW.constant = 0;
        cell.rightImgConstraintW.constant = 0;
        cell.contentleftConstraintMarge.constant = 0;
        cell.contentrightConstraintMarge.constant = 0;
    }
    return cell;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
