//
//  TPTCorrectInfoCell.m
//  tpt
//
//  Created by apple on 16/8/22.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import "TPTCorrectInfoCell.h"

@interface TPTCorrectInfoCell()
{
    UIImageView            *_bgImgView;
    UIView                 *_bgView;
    UILabel                * _titleLableOne;
    UILabel                * _contentLableOne;
}

@end

@implementation TPTCorrectInfoCell

- (void)awakeFromNib {
    // Initialization code
}

+ (instancetype)theTPTCorrectInfoCellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"correctCell";
    TPTCorrectInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[TPTCorrectInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    _contentLableOne = [UILabel new];
    _bgView = [UIView new];
    _bgImgView = [UIImageView new];

    [self.contentView addSubview:_bgView];
    [_bgView addSubview:_bgImgView];
    [_bgView addSubview:_titleLableOne];
    [_bgView addSubview:_contentLableOne];

    _titleLableOne.textColor = MainTitleColor;
    _titleLableOne.font = [UIFont systemFontOfSize:17];

    _titleLableOne.numberOfLines = 0;
    _contentLableOne.numberOfLines = 0;
    _contentLableOne.textColor = MainContentColor;
    _contentLableOne.font = [UIFont systemFontOfSize:16];

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


    NSString *contentStr = @"1：用医用体温计测量宝宝的腋温并记录。\n2：通过上面的“+”、“-”按键调节显示的温度与医用体温计测量的温度一致。\n3：温度误差建议控制在0.1~0.2℃之间";
    _titleLableOne.text = @"体温误差校正步骤指引：";
    _contentLableOne.text = contentStr;

    /// 设置cell底部间隙
    self.whc_CellBottomView = _contentLableOne;
    self.whc_CellBottomOffset = 15;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
