//
//  TPTCorrectCell.m
//  tpt
//
//  Created by apple on 16/8/22.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import "TPTCorrectCell.h"

@interface TPTCorrectCell ()

@property (nonatomic,assign) CGFloat currentTemp;

@end

@implementation TPTCorrectCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];

    self.currentTemp = UserModel.temp_check.floatValue;
    self.tempLable.textColor = MainTitleColor;
    self.infoLable.textColor = MainContentColor;

    self.saveButton.layer.masksToBounds = YES;
    self.saveButton.layer.cornerRadius = 5;

    self.dissButton.layer.masksToBounds = YES;
    self.dissButton.layer.cornerRadius = 5;
    self.bgImgView.image = [[UIImage imageNamed:@"tui_cell_bg"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];

    if (UserModel.temp_unit) {
        self.tempLable.text = [NSString stringWithFormat:@"%.1f℉",[TPTool getUnitCurrentTemp:UserModel.temp_check]];
    }else{
        self.tempLable.text = [NSString stringWithFormat:@"%.1f℃",[TPTool getUnitCurrentTemp:UserModel.temp_check]];
    }

    self.infoLable.text = NSLocalizedString(@"cur_temperature", @"");

    [self.saveButton setTitle:NSLocalizedString(@"max_save", @"") forState:UIControlStateNormal];
    [self.dissButton setTitle:NSLocalizedString(@"max_cancel", @"") forState:UIControlStateNormal];
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

    if (self.currentTemp<1) {
        self.currentTemp = self.currentTemp + 0.1;
        if (UserModel.temp_unit) {
            self.tempLable.text = [NSString stringWithFormat:@"%.1f℉",[TPTool getUnitCurrentTempFloat:self.currentTemp]];
        }else{
            self.tempLable.text = [NSString stringWithFormat:@"%.1f℃",[TPTool getUnitCurrentTempFloat:self.currentTemp]];
        }
    }
}

- (IBAction)clickJianButton:(UIButton *)sender {

    if (self.currentTemp > -1) {
        self.currentTemp = self.currentTemp  - 0.1;
        if (UserModel.temp_unit) {
            self.tempLable.text = [NSString stringWithFormat:@"%.1f℉",[TPTool getUnitCurrentTempFloat:self.currentTemp]];
        }else{
            self.tempLable.text = [NSString stringWithFormat:@"%.1f℃",[TPTool getUnitCurrentTempFloat:self.currentTemp]];
        }
    }
}

//保存
- (IBAction)clickSaveButton:(UIButton *)sender {

    UserModel.temp_check = [NSString stringWithFormat:@"%.1f",self.currentTemp];
    self.dissBlock();
}


//关闭
- (IBAction)clickDissButton:(UIButton *)sender {
    self.dissBlock();
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
