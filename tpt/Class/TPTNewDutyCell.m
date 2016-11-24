//
//  TPTNewDutyCell.m
//  tpt
//
//  Created by apple on 16/8/19.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import "TPTNewDutyCell.h"

@interface TPTNewDutyCell ()
{
    UIImageView            *_bgImgView;
    UIView                 *_bgView;
    UILabel                * _titleLableOne;
    UILabel                * _titleLableTwo;

    UILabel                * _contentLableOne;
    UILabel                * _contentLableTwo;
}

@end

@implementation TPTNewDutyCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

+ (instancetype)theTPTNewDutyCellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"newdutyCell";
    TPTNewDutyCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[TPTNewDutyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initLayout];
    }
    return self;
}

- (void)createLayoutView {
    _titleLableOne = [UILabel new];
    _titleLableTwo = [UILabel new];
    _contentLableOne = [UILabel new];
    _contentLableTwo = [UILabel new];
    _bgView = [UIView new];
    _bgImgView = [UIImageView new];

    [self.contentView addSubview:_bgView];
    [_bgView addSubview:_bgImgView];
    [_bgView addSubview:_titleLableOne];
    [_bgView addSubview:_titleLableTwo];
    [_bgView addSubview:_contentLableOne];
    [_bgView addSubview:_contentLableTwo];

    _titleLableOne.textColor = MainTitleColor;
    _titleLableOne.font = [UIFont systemFontOfSize:17];
    _titleLableTwo.textColor = MainTitleColor;
    _titleLableTwo.font = [UIFont systemFontOfSize:17];


    _contentLableOne.textColor = MainContentColor;
    _contentLableOne.font = [UIFont systemFontOfSize:16];
    _contentLableTwo.textColor = MainContentColor;
    _contentLableTwo.font = [UIFont systemFontOfSize:16];

    _titleLableOne.numberOfLines = 0;
    _titleLableTwo.numberOfLines = 0;
    _contentLableOne.numberOfLines = 0;
    _contentLableTwo.numberOfLines = 0;

    _bgImgView.image = [[UIImage imageNamed:@"tui_cell_bg"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
}

- (void)initLayout {
    [self createLayoutView];

    /// 使用先进的WHC_AutoLayoutKit进行自动布局


    [_bgView whc_TopSpace:0];
    [_bgView whc_RightSpace:15];
    [_bgView whc_LeftSpace:15];
    [_bgView whc_BottomSpace:0];


    [_bgImgView whc_TopSpace:0];
    [_bgImgView whc_RightSpace:0];
    [_bgImgView whc_LeftSpace:0];
    [_bgImgView whc_BottomSpace:0];

    [_titleLableOne whc_LeftSpace:15];
    [_titleLableOne whc_TopSpace:20];
    [_titleLableOne whc_Size:CGSizeMake(SCREEN_WIDTH-30,21)];

    [_contentLableOne whc_TopSpace:10 toView:_titleLableOne];
    [_contentLableOne whc_LeftSpace:15];
    [_contentLableOne whc_RightSpace:15];
    [_contentLableOne whc_heightAuto];


    [_titleLableTwo whc_TopSpace:10 toView:_contentLableOne];
    [_titleLableTwo whc_LeftSpace:15];
    [_titleLableTwo whc_RightSpace:15];
    [_titleLableTwo whc_heightAuto];

    [_contentLableTwo whc_TopSpace:10 toView:_titleLableTwo];
    [_contentLableTwo whc_LeftSpace:15];
    [_contentLableTwo whc_RightSpace:15];
    [_contentLableTwo whc_heightAuto];

    NSString *contentStr = NSLocalizedString(@"disclaimer_content",@"");
    NSString *contentTwoStr = NSLocalizedString(@"disclaimer_tip_content",@"");

    _titleLableOne.text = NSLocalizedString(@"setting_disclaimer", @"");
    _titleLableTwo.text = NSLocalizedString(@"disclaimer_tip", @"");
    _contentLableOne.text = contentStr;
    _contentLableTwo.text = contentTwoStr;


    /// 设置cell底部间隙
    self.whc_CellBottomView = _contentLableTwo;
    self.whc_CellBottomOffset = 15;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
