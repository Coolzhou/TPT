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
    UILabel                * _titleLableZero;
    UILabel                * _titleLableOne;
    UILabel                * _titleLableTwo;
    UILabel                * _titleLableThree;

    UILabel                * _contentLableZero;
    UILabel                * _contentLableOne;
    UILabel                * _contentLableTwo;
    UILabel                * _contentLableThree;
}

@end

@implementation TPTDeviceInfoCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
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
    _titleLableZero = [UILabel new];
    _titleLableOne = [UILabel new];
    _titleLableTwo = [UILabel new];
    _titleLableThree = [UILabel new];
    _contentLableZero = [UILabel new];
    _contentLableOne = [UILabel new];
    _contentLableTwo = [UILabel new];
    _contentLableThree = [UILabel new];
    _bgView = [UIView new];
    _bgImgView = [UIImageView new];

    [self.contentView addSubview:_bgView];
    [_bgView addSubview:_bgImgView];
    [_bgView addSubview:_titleLableZero];
    [_bgView addSubview:_titleLableOne];
    [_bgView addSubview:_titleLableTwo];
    [_bgView addSubview:_titleLableThree];
    [_bgView addSubview:_contentLableZero];
    [_bgView addSubview:_contentLableOne];
    [_bgView addSubview:_contentLableTwo];
    [_bgView addSubview:_contentLableThree];

    _titleLableZero.textColor = MainTitleColor;
    _titleLableZero.font = [UIFont systemFontOfSize:17];
    _titleLableOne.textColor = MainTitleColor;
    _titleLableOne.font = [UIFont systemFontOfSize:17];
    _titleLableTwo.textColor = MainTitleColor;
    _titleLableTwo.font = [UIFont systemFontOfSize:17];
    _titleLableThree.textColor = MainTitleColor;
    _titleLableThree.font = [UIFont systemFontOfSize:17];

    _contentLableZero.textColor = MainContentColor;
    _contentLableZero.font = [UIFont systemFontOfSize:16];
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
    
    [_titleLableZero whc_LeftSpace:15];
    [_titleLableZero whc_TopSpace:20];
    [_titleLableZero whc_Size:CGSizeMake(SCREEN_WIDTH-30,21)];
    
    [_contentLableZero whc_TopSpace:10 toView:_titleLableZero];
    [_contentLableZero whc_LeftSpace:15];
    [_contentLableZero whc_RightSpace:15];
    [_contentLableZero whc_Height:21];

    [_titleLableOne whc_TopSpace:10 toView:_contentLableZero];
    [_titleLableOne whc_LeftSpace:15];
    [_titleLableOne whc_RightSpace:15];
    [_titleLableOne whc_Height:21];

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

    NSString *contentStr = @"T1";
    NSString *contentTwoStr = @"1.0";
    NSString *contentThreeStr = @"T1.0";
    
    _titleLableZero.text = NSLocalizedString(@"system_device_name",@"");
    _titleLableOne.text = NSLocalizedString(@"system_device_model",@"");
    _titleLableTwo.text = NSLocalizedString(@"system_software_version",@"");
    _titleLableThree.text = NSLocalizedString(@"system_hardware_version",@"");
    
    _contentLableZero.text = NSLocalizedString(@"system_device_name_1",@"");;
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
