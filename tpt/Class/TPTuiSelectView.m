//
//  TPTuiSelectView.m
//  tpt
//
//  Created by Yi luqi on 16/7/31.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import "TPTuiSelectView.h"

#define headMargeW 18
#define margeW 10
#define buttonW ((kScreenWidth -2*headMargeW - 3*margeW)/4)

@interface TPTuiSelectView ()

@property (nonatomic,strong)NSArray *titleButArray;

@property (nonatomic, strong) UIButton * receiveButton;

@end

@implementation TPTuiSelectView

-(instancetype)init{
    if (self = [super init]) {
        self.titleButArray = [NSArray arrayWithObjects:NSLocalizedString(@"raiders_tab_1",@""),NSLocalizedString(@"raiders_tab_2",@""),NSLocalizedString(@"raiders_tab_3",@""),NSLocalizedString(@"raiders_tab_4",@""),nil];
        [self addButtonView];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleButArray = [NSArray arrayWithObjects:NSLocalizedString(@"raiders_tab_1",@""),NSLocalizedString(@"raiders_tab_2",@""),NSLocalizedString(@"raiders_tab_3",@""),NSLocalizedString(@"raiders_tab_4",@""),nil];
        [self addButtonView];
    }
    return self;
}

-(void)addButtonView{
    for (int i=0;i<self.titleButArray.count; i++) {
        UIButton *titleButton = [[UIButton alloc]initWithFrame:CGRectMake(headMargeW +(buttonW + margeW)*i,0,buttonW, self.frame.size.height)];
        [self addSubview:titleButton];
        titleButton.layer.cornerRadius = 5;
        titleButton.layer.masksToBounds = YES;
        titleButton.tag = 1+i;
        titleButton.titleLabel.font = [UIFont systemFontOfSize:13];
        titleButton.titleLabel.numberOfLines = 0;
        titleButton.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        if (i==0) {
            titleButton.selected = YES;
            _receiveButton = titleButton;
        }
        [titleButton setTitle:self.titleButArray[i] forState:UIControlStateNormal];
        [titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //自定义按钮的背景颜色,并附带状态选择
        
        [titleButton setBackgroundImage:[UIImage imageNamed:@"tui_button_n"] forState:UIControlStateNormal];
        [titleButton setBackgroundImage:[UIImage imageNamed:@"tui_button_p"] forState:UIControlStateSelected];
        
//        [titleButton setBackgroundColor:MainTitleColor forState:UIControlStateNormal];
//        [titleButton setBackgroundColor:[UIColor yellowColor] forState:UIControlStateSelected];
        [titleButton addTarget:self action:@selector(clickTitleButton:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)clickTitleButton:(UIButton *)sender{
    
    if (_receiveButton == sender) {
        return;
    }
    _receiveButton.selected = NO;
    //当前点击按钮选中
    sender.selected = YES;
    _receiveButton = sender;
    
    int num =(int)sender.tag;
    self.tuiBlock(num);
}

@end
