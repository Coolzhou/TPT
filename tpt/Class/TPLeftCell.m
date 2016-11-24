//
//  TPLeftCell.m
//  tpt
//
//  Created by apple on 16/7/28.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import "TPLeftCell.h"

@implementation TPLeftCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.titlesLable.numberOfLines = 0;
}

+ (instancetype)theLeftCellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"leftCell";
    TPLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = (TPLeftCell*)[[NSBundle mainBundle]loadNibNamed:@"TPLeftCell" owner:nil options:nil][0];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
