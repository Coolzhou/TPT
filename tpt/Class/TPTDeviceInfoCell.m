//
//  TPTDeviceInfoCell.m
//  tpt
//
//  Created by apple on 16/8/19.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import "TPTDeviceInfoCell.h"

@interface TPTDeviceInfoCell()

{
    UIImageView            *_bgImgView;
    UIView                 *_bgView;
    UILabel                * _titleLableOne;
    UILabel                * _titleLableTwo;
    UILabel                * _titleLableThree;

    UILabel                * _contentLableOne;
    UILabel                * _contentLableTwo;
    UILabel                * _contentLableThree;
}

@end

@implementation TPTDeviceInfoCell

- (void)awakeFromNib {
    // Initialization code
}

+ (instancetype)theTPTDeviceInfoCellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"devoceCell";
    TPTDeviceInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[TPTDeviceInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    _titleLableThree = [UILabel new];
    _contentLableOne = [UILabel new];
    _contentLableTwo = [UILabel new];
    _contentLableThree = [UILabel new];
    _bgView = [UIView new];
    _bgImgView = [UIImageView new];

    [self.contentView addSubview:_bgView];
    [_bgView addSubview:_bgImgView];
    [_bgView addSubview:_titleLableOne];
    [_bgView addSubview:_titleLableTwo];
    [_bgView addSubview:_titleLableThree];
    [_bgView addSubview:_contentLableOne];
    [_bgView addSubview:_contentLableTwo];
    [_bgView addSubview:_contentLableThree];

    _titleLableOne.textColor = MainTitleColor;
    _titleLableOne.font = [UIFont systemFontOfSize:17];
    _titleLableTwo.textColor = MainTitleColor;
    _titleLableTwo.font = [UIFont systemFontOfSize:17];
    _titleLableThree.textColor = MainTitleColor;
    _titleLableThree.font = [UIFont systemFontOfSize:17];

    _contentLableOne.textColor = MainContentColor;
    _contentLableOne.font = [UIFont systemFontOfSize:16];
    _contentLableTwo.textColor = MainContentColor;
    _contentLableTwo.font = [UIFont systemFontOfSize:16];

    _contentLableThree.textColor = MainContentColor;
    _contentLableThree.font = [UIFont systemFontOfSize:16];

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
    [_contentLableOne whc_Height:21];


    [_titleLableTwo whc_TopSpace:10 toView:_contentLableOne];
    [_titleLableTwo whc_LeftSpace:15];
    [_titleLableTwo whc_RightSpace:15];
    [_titleLableTwo whc_Height:21];

    [_contentLableTwo whc_TopSpace:10 toView:_titleLableTwo];
    [_contentLableTwo whc_LeftSpace:15];
    [_contentLableTwo whc_RightSpace:15];
    [_contentLableTwo whc_Height:21];

    [_titleLableThree whc_TopSpace:10 toView:_contentLableTwo];
    [_titleLableThree whc_LeftSpace:15];
    [_titleLableThree whc_RightSpace:15];
    [_titleLableThree whc_Height:21];

    [_contentLableThree whc_TopSpace:10 toView:_titleLableThree];
    [_contentLableThree whc_LeftSpace:15];
    [_contentLableThree whc_RightSpace:15];
    [_contentLableThree whc_Height:21];

    NSString *contentStr = @"T1.0";
    NSString *contentTwoStr = @"1.0";
    NSString *contentThreeStr = @"T1.0";
    _titleLableOne.text = @"设备型号：";
    _titleLableTwo.text = @"软件版本：";
    _titleLableThree.text = @"硬件版本：";
    _contentLableOne.text = contentStr;
    _contentLableTwo.text = contentTwoStr;
    _contentLableThree.text = contentThreeStr;


    /// 设置cell底部间隙
    self.whc_CellBottomView = _contentLableThree;
    self.whc_CellBottomOffset = 15;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
