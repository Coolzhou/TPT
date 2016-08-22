//
//  TPTCorrectCell.m
//  tpt
//
//  Created by apple on 16/8/22.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import "TPTCorrectCell.h"

@implementation TPTCorrectCell

- (void)awakeFromNib {
    // Initialization code
    self.tempLable.textColor = MainTitleColor;
    self.infoLable.textColor = MainContentColor;

    self.addButton.layer.masksToBounds = YES;
    self.addButton.layer.cornerRadius = 5;

    self.jianButton.layer.masksToBounds = YES;
    self.jianButton.layer.cornerRadius = 5;
    self.bgImgView.image = [[UIImage imageNamed:@"tui_cell_bg"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
}

+ (instancetype)theTPTCorrectCellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"corrects";
    TPTCorrectCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = (TPTCorrectCell*)[[NSBundle mainBundle]loadNibNamed:@"TPTCorrectCell" owner:nil options:nil][0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (IBAction)clickAddButton:(UIButton *)sender {
}

- (IBAction)clickJianButton:(UIButton *)sender {
}

- (IBAction)clickSaveButton:(UIButton *)sender {
}

- (IBAction)clickDissButton:(UIButton *)sender {
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
