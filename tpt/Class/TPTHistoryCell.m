//
//  TPTHistoryCell.m
//  tpt
//
//  Created by apple on 16/8/12.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import "TPTHistoryCell.h"

@implementation TPTHistoryCell

- (void)awakeFromNib {
    // Initialization code

    self.bgImgView.image = [[UIImage imageNamed:@"tui_cell_bg"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    self.delectBtn.layer.cornerRadius = 3;
    self.delectBtn.layer.masksToBounds = YES;
    self.methodLable.layer.cornerRadius = 3;
    self.methodLable.layer.masksToBounds = YES;
    self.stateLable.textColor = MainContentColor;
    self.changLable.textColor = MainContentColor;
    self.timeLable.textColor = MainContentColor;

    self.changLable.text = NSLocalizedString(@"history_common_method", @"");

    [self.delectBtn setTitle:NSLocalizedString(@"history_del", @"") forState:UIControlStateNormal];
}

+ (instancetype)theTPTHistoryCellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexpath{
    static NSString *ID = @"historyCell";
    TPTHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = (TPTHistoryCell*)[[NSBundle mainBundle]loadNibNamed:@"TPTHistoryCell" owner:nil options:nil][0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
}

- (IBAction)clickDelecBtn:(UIButton *)sender {
    self.delectHistBlock(_indexPath.row);
}

-(void)setTempModel:(WBTemperature *)tempModel{
    _tempModel = tempModel;

//    NSLog(@"tempModel = %@ = %@ = %f",tempModel.create_time,tempModel.temp_state,tempModel.temp);

    //常出来方法  history_common_method
    //低热 2中热 3高热4 超热
    if ([tempModel.temp_state isEqualToString:@"0"]) {
        self.stateLable.text = NSLocalizedString(@"history_normal",@"");
        self.methodLable.text = NSLocalizedString(@"history_common_method_1", @"");
    }else if ([tempModel.temp_state isEqualToString:@"1"]){
        self.stateLable.text = NSLocalizedString(@"max_tem_low", @"");;
        self.methodLable.text = NSLocalizedString(@"history_common_method_2", @"");
    }else if ([tempModel.temp_state isEqualToString:@"2"]){
        self.stateLable.text = NSLocalizedString(@"max_tem_middle", @"");;
        self.methodLable.text = NSLocalizedString(@"history_common_method_3", @"");
    }else if ([tempModel.temp_state isEqualToString:@"3"]){
        self.stateLable.text = NSLocalizedString(@"max_tem_high", @"");;
        self.methodLable.text = NSLocalizedString(@"history_common_method_4", @"");
;
    }else if ([tempModel.temp_state isEqualToString:@"4"]){
        self.stateLable.text = NSLocalizedString(@"max_tem_supper_high", @"");;
        self.methodLable.text = NSLocalizedString(@"history_common_method_5", @"");
;
    }else{
        self.stateLable.text = NSLocalizedString(@"history_normal",@"");
    }
    self.timeLable.text = [NSString stringWithFormat:@"%@",[TPTool dateTimeWithNStringTime:tempModel.create_time]];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
