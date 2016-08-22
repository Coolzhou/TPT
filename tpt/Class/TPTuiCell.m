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
//    self.bgView.backgroundColor = [UIColor whiteColor];
//    self.bgView.layer.cornerRadius = 8;
    self.titleLabel.textColor = MainTitleColor;
    self.contentLable.textColor = MainContentColor;
    self.cellBgImage.image = [[UIImage imageNamed:@"tui_cell_bg"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];

}

+ (instancetype)theTuiWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexpath{
    static NSString *ID = @"samcell";
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
        cell.contentLable.numberOfLines = 0;
    }
    return cell;
}

-(void)theTuiWithTableViewWithIndexPath:(NSIndexPath *)indexPath andType:(NSInteger)type andDict:(NSDictionary *)dictionary{

    NSString *title = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"title"]];
    NSString *content = [dictionary objectForKey:@"content"];

    if ([NSString isNull:title]) {
        self.titleLabel.hidden = YES;
        self.contentLable.numberOfLines = 0;
        self.contentLable.preferredMaxLayoutWidth = kScreenWidth - 30;
    }else{
        self.contentLable.numberOfLines = 2;
        self.titleLabel.text = title;
    }
    self.contentLable.text = content;

    NSLog(@"content = %@",content);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
