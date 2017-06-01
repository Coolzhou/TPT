//
//  TPTSetBuyCell.m
//  tpt
//
//  Created by zhou on 2017/6/1.
//  Copyright © 2017年 MDJ. All rights reserved.
//

#import "TPTSetBuyCell.h"

@implementation TPTSetBuyCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.bgImgView.image = [[UIImage imageNamed:@"set_bg_red"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
//    self.titleLable.textColor = MainContentColor;
//    self.messageLable.textColor = MainContentColor;
    
    self.titleLable.text = NSLocalizedString(@"setting_buy",@"");
    self.messageLable.text = NSLocalizedString(@"setting_buy_content",@"");
}


+ (instancetype)theTPTSetOtherCellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"buycell";
    TPTSetBuyCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = (TPTSetBuyCell*)[[NSBundle mainBundle]loadNibNamed:@"TPTSetBuyCell" owner:nil options:nil][0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
