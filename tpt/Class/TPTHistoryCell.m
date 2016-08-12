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

    if (IS_IPHONE_6 ||IS_IPHONE_6) {
        self.iconConstraint.constant = 55;
        self.iconConstraintH.constant = 55;
        self.stateConstraintM.constant = 15;
        self.fangConstraint.constant = 15;
        self.timeConstraint.constant = 15;
    }
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


    //低热 2中热 3高热4 超热
    if ([tempModel.temp_state isEqualToString:@"0"]) {
        self.stateLable.text = @"正常";
        self.methodLable.text = @"无需处理";
    }else if ([tempModel.temp_state isEqualToString:@"1"]){
        self.stateLable.text = @"低热";
        self.methodLable.text = @"酒精擦拭";
    }else if ([tempModel.temp_state isEqualToString:@"2"]){
        self.stateLable.text = @"中热";
        self.methodLable.text = @"酒精擦拭";
    }else if ([tempModel.temp_state isEqualToString:@"3"]){
        self.stateLable.text = @"高热";
        self.methodLable.text = @"酒精擦拭";
    }else if ([tempModel.temp_state isEqualToString:@"4"]){
        self.stateLable.text = @"超热";
        self.methodLable.text = @"酒精擦拭";
    }else{
        self.stateLable.text = @"正常";
    }
    self.timeLable.text = tempModel.create_time;

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
