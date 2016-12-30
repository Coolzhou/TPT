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
    [super awakeFromNib];
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
        cell.contentLable.numberOfLines = 0;
        cell.rightImgConstraintW.constant = 0;
        cell.contentTopConstraintY.constant = -20;
        cell.contentrightConstraintMarge.constant = 0;
    }else{
        cell.titleLabel.hidden = NO;
        cell.rightImageView.hidden = NO;
        cell.contentLable.numberOfLines = 2;
        cell.rightImgConstraintW.constant = 19;
        cell.contentTopConstraintY.constant = 5;
        cell.contentrightConstraintMarge.constant = 10;
    }
    return cell;
}

-(void)theTuiWithTableViewWithIndexPath:(NSIndexPath *)indexPath andType:(NSInteger)type andDict:(NSDictionary *)dictionary{


    if (type ==1) {
        if (indexPath.row==0) {
            self.contentLable.text = NSLocalizedString(@"raiders_tab1_content_top",@"");
        }else if (indexPath.row==1){
            self.titleLabel.text = NSLocalizedString(@"raiders_tab1_title_1",@"");
            self.contentLable.text = NSLocalizedString(@"raiders_tab1_content_1",@"");
        }else if (indexPath.row==2){
            self.titleLabel.text = NSLocalizedString(@"raiders_tab1_title_2",@"");
            self.contentLable.text = NSLocalizedString(@"raiders_tab1_content_2",@"");
        }else if (indexPath.row==3){
            self.titleLabel.text = NSLocalizedString(@"raiders_tab1_title_3",@"");
            self.contentLable.text = NSLocalizedString(@"raiders_tab1_content_3",@"");
        }else if (indexPath.row==4){
            self.titleLabel.text = NSLocalizedString(@"raiders_tab1_title_4",@"");
            self.contentLable.text = NSLocalizedString(@"raiders_tab1_content_4",@"");
        }else if (indexPath.row==5){
            self.titleLabel.text = NSLocalizedString(@"raiders_tab1_title_5",@"");
            self.contentLable.text = NSLocalizedString(@"raiders_tab1_content_5",@"");
        }else{
            self.titleLabel.text = NSLocalizedString(@"raiders_tab1_title_6",@"");
            self.contentLable.text = NSLocalizedString(@"raiders_tab1_content_6",@"");
        }
    }else if(type==2){
        if (indexPath.row==0) {
            self.contentLable.text = NSLocalizedString(@"raiders_tab2_content_top",@"");
        }
    }else if (type==3){
        if (indexPath.row==0) {
            self.contentLable.text = NSLocalizedString(@"raiders_tab3_content_top",@"");
        }else if (indexPath.row==1){
            self.titleLabel.text = NSLocalizedString(@"raiders_tab3_title_1",@"");
            self.contentLable.text = NSLocalizedString(@"raiders_tab3_content_1",@"");
        }else{
            self.titleLabel.text = NSLocalizedString(@"raiders_tab3_title_2",@"");
            self.contentLable.text = NSLocalizedString(@"raiders_tab3_content_2",@"");
        }
    }else{
        if (indexPath.row==0) {
            self.contentLable.text = NSLocalizedString(@"raiders_tab4_content_top",@"");
        }else if (indexPath.row==1){
            self.titleLabel.text = NSLocalizedString(@"raiders_tab4_title_1",@"");
            self.contentLable.text = NSLocalizedString(@"raiders_tab4_content_1",@"");
        }else if (indexPath.row==2){
            self.titleLabel.text = NSLocalizedString(@"raiders_tab4_title_2",@"");
            self.contentLable.text = NSLocalizedString(@"raiders_tab4_content_2",@"");
        }else if (indexPath.row==3){
            self.titleLabel.text = NSLocalizedString(@"raiders_tab4_title_3",@"");
            self.contentLable.text = NSLocalizedString(@"raiders_tab4_content_3",@"");
        }else if (indexPath.row==4){
            self.titleLabel.text = NSLocalizedString(@"raiders_tab4_title_4",@"");
            self.contentLable.text = NSLocalizedString(@"raiders_tab4_content_4",@"");
        }else{
            self.titleLabel.text = NSLocalizedString(@"raiders_tab4_title_5",@"");
            self.contentLable.text = NSLocalizedString(@"raiders_tab4_content_5",@"");
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
