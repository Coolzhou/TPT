//
//  TPTSetOtherCell.m
//  tpt
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import "TPTSetOtherCell.h"

@implementation TPTSetOtherCell

- (void)awakeFromNib {
    // Initialization code
    self.bgImgView.image = [[UIImage imageNamed:@"set_bg_red"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
}


+ (instancetype)theTPTSetOtherCellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexpath{
    static NSString *ID = @"othercell";
    TPTSetOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = (TPTSetOtherCell*)[[NSBundle mainBundle]loadNibNamed:@"TPTSetOtherCell" owner:nil options:nil][0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (IBAction)rightOneBtnClick:(UIButton *)sender {
    self.setOtherBlock(sender.tag);
}
- (IBAction)rightTwoBtnClick:(UIButton *)sender {
    self.setOtherBlock(sender.tag);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
