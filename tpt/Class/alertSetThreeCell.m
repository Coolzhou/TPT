//
//  alertSetThreeCell.m
//  tpt
//
//  Created by apple on 16/8/11.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import "alertSetThreeCell.h"
#import "CustomAlertView.h"
@implementation alertSetThreeCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];

    self.lineMargeOne.constant = (kScreenWidth - 30-3)/4;
    self.lineMargeTwo.constant = (kScreenWidth - 30-3)/4;
    self.lineMargeThree.constant = (kScreenWidth - 30-3)/4;

    self.wLineOneView.backgroundColor = LineColor;
    self.wLineTwoView.backgroundColor = LineColor;
    self.hLineOneView.backgroundColor = LineColor;
    self.hlineTwoView.backgroundColor = LineColor;
    self.hLineThreeView.backgroundColor = LineColor;

    self.bgView.backgroundColor = RGBA(211, 213, 190,0.5);
    self.bgView.layer.cornerRadius = 5;
    self.bgView.layer.masksToBounds = YES;

    self.bgView.layer.borderWidth = 1;
    self.bgView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;

    self.contentLable.textColor = MainContentColor;
    self.titleLable.textColor = [UIColor orangeColor];

    self.topTitleOneLable.textColor = kColorWithRGB(0x62922C);
    self.topTitleTwoLable.textColor = kColorWithRGB(0x62922C);
    self.topTitleThreeLable.textColor = kColorWithRGB(0x62922C);
    self.topTitleFreeLable.textColor = kColorWithRGB(0x62922C);


    [self getTemp];//获得各个温度

    self.topTitleOneLable.text = NSLocalizedString(@"max_tem_low", @"");
    self.topTitleTwoLable.text = NSLocalizedString(@"max_tem_middle", @"");
    self.topTitleThreeLable.text = NSLocalizedString(@"max_tem_high", @"");
    self.topTitleFreeLable.text = NSLocalizedString(@"max_tem_supper_high", @"");

    self.titleLable.text = NSLocalizedString(@"max_tem_click_tip", @"");



    //self.contentLable.text = NSLocalizedString(@"max_tem_click_explanation_f", @"");
}

+ (instancetype)thealertSetThreeCellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexpath{
    static NSString *ID = @"alerthreeCell";
    alertSetThreeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = (alertSetThreeCell*)[[NSBundle mainBundle]loadNibNamed:@"alertSetThreeCell" owner:nil options:nil][0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (IBAction)clickChangeTemp:(UIButton *)sender {


    CustomAlertView *alert = [[CustomAlertView alloc]initWithAlertViewType:CustomAlert andTag:sender.tag];

    __weak typeof(self) weakself = self;
    alert.ButtonClick = ^void(NSInteger buttonTag){
        NSLog(@"buttonTaghou = %ld",(long)buttonTag);
        [weakself saveButtonTemp:buttonTag];
    };
}

//保存按钮的值
-(void)saveButtonTemp:(NSInteger)tag{

    [self getTemp];
}

-(void)getTemp{
    NSString *max_tem_low =@"";
    NSString *max_tem_middle =@"";
    NSString *max_tem_high =@"";
    NSString *max_tem_supper_high =@"";
    if (UserModel.temp_unit) {
        max_tem_low =[NSString stringWithFormat:@"%.1f℉", [TPTool getUnitCurrentTemp:UserModel.max_tem_low]];
        max_tem_middle =[NSString stringWithFormat:@"%.1f℉", [TPTool getUnitCurrentTemp:UserModel.max_tem_middle]];
        max_tem_high =[NSString stringWithFormat:@"%.1f℉", [TPTool getUnitCurrentTemp:UserModel.max_tem_high]];
        max_tem_supper_high =[NSString stringWithFormat:@"%.1f℉", [TPTool getUnitCurrentTemp:UserModel.max_tem_supper_high]];
        self.contentLable.text = NSLocalizedString(@"max_tem_click_explanation_f", @"");
    }else{
        max_tem_low =[NSString stringWithFormat:@"%.1f℃", [TPTool getUnitCurrentTemp:UserModel.max_tem_low]];
        max_tem_middle =[NSString stringWithFormat:@"%.1f℃", [TPTool getUnitCurrentTemp:UserModel.max_tem_middle]];
        max_tem_high =[NSString stringWithFormat:@"%.1f℃", [TPTool getUnitCurrentTemp:UserModel.max_tem_high]];
        max_tem_supper_high =[NSString stringWithFormat:@"%.1f℃", [TPTool getUnitCurrentTemp:UserModel.max_tem_supper_high]];

        self.contentLable.text = NSLocalizedString(@"max_tem_click_explanation_c", @"");
    }
    [self.OneBtn setTitle:max_tem_low forState:UIControlStateNormal];
    [self.TwoBtn setTitle:max_tem_middle forState:UIControlStateNormal];
    [self.ThreeBtn setTitle:max_tem_high forState:UIControlStateNormal];
    [self.FreeBtn setTitle:max_tem_supper_high forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
