//
//  TPTdutyCell.m
//  tpt
//
//  Created by apple on 16/8/19.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import "TPTdutyCell.h"

@implementation TPTdutyCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];

    self.titleLableOne.textColor = MainTitleColor;
    self.contentLableOne.textColor = MainContentColor;
    self.titleLableTwo.textColor = MainTitleColor;
    self.contentLableTwo.textColor = MainContentColor;
    self.bgImgView.image = [[UIImage imageNamed:@"tui_cell_bg"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];

    self.titleLableOne.text = NSLocalizedString(@"setting_disclaimer", @"");
    self.titleLableTwo.text = NSLocalizedString(@"disclaimer_tip", @"");


    NSString *contentStr = NSLocalizedString(@"disclaimer_content", @"");

    CGFloat contentOneHeight = [contentStr sizeForMaxWidth:(SCREEN_WIDTH - 30) font:[UIFont systemFontOfSize:15]].height;

    self.contentOneConstraintH.constant = contentOneHeight;

    self.contentLableOne.text = contentStr;
    self.contentLableTwo.text = NSLocalizedString(@"disclaimer_tip_content", @"");


}

+ (instancetype)theTPTdutyCellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexpath{
    static NSString *ID = @"dutyCell";
    TPTdutyCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = (TPTdutyCell*)[[NSBundle mainBundle]loadNibNamed:@"TPTdutyCell" owner:nil options:nil][0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

+(CGFloat)theCellHeight{


    NSString *contentStr = @"该应用程序中的所有内容（特别是界面设计、文本、图片、标志、音频剪辑等）都是受版权保护的，在没有本公司书面证明和授权的情况下，对所有内容的复制、公众传达或者其它未经我公司许可的行为都属侵犯本公司合法权益行为，未经本公司许可，程序内所有涉及著作权、代码应用和商标等都不允许变更和移除。\n本智能软件是配合智能硬件使用的，在检测婴幼儿生命体征的过程中由于人体的复杂必，疾病并不能通过某些单一的症状发现，须要专业医生综合检查、分析判断。\n我们希望我们的产品在婴幼儿出现疾病征兆时，能够及时帮助您更好地掌握婴幼儿的身体健康情况。使您可能更加轻松，方便的照顾自己的孩子。";


    NSString *contentTwoStr = @"我方所有信息公供参考，不做个别诊断、用药和使用的根据。";

    CGFloat contentOneHeight = [contentStr sizeForMaxWidth:(SCREEN_WIDTH - 30) font:[UIFont systemFontOfSize:15]].height;

    CGFloat contentTwoHeight = [contentTwoStr sizeForMaxWidth:(SCREEN_WIDTH - 30) font:[UIFont systemFontOfSize:15]].height;

    return contentOneHeight+contentTwoHeight+20+10+10+10+15;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
