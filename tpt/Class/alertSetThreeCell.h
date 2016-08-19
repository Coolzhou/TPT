//
//  alertSetThreeCell.h
//  tpt
//
//  Created by apple on 16/8/11.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface alertSetThreeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineMargeOne;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineMargeTwo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineMargeThree;

@property (weak, nonatomic) IBOutlet UIView *wLineOneView;
@property (weak, nonatomic) IBOutlet UIView *wLineTwoView;
@property (weak, nonatomic) IBOutlet UIView *hLineOneView;
@property (weak, nonatomic) IBOutlet UIView *hlineTwoView;
@property (weak, nonatomic) IBOutlet UIView *hLineThreeView;

@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *contentLable;

@property (weak, nonatomic) IBOutlet UIButton *OneBtn;
@property (weak, nonatomic) IBOutlet UIButton *TwoBtn;
@property (weak, nonatomic) IBOutlet UIButton *ThreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *FreeBtn;


@property (weak, nonatomic) IBOutlet UILabel *topTitleOneLable;
@property (weak, nonatomic) IBOutlet UILabel *topTitleTwoLable;
@property (weak, nonatomic) IBOutlet UILabel *topTitleThreeLable;
@property (weak, nonatomic) IBOutlet UILabel *topTitleFreeLable;

+ (instancetype)thealertSetThreeCellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexpath;

@end
