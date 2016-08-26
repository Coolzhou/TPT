//
//  TPTCorrectCell.h
//  tpt
//
//  Created by apple on 16/8/22.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^clickBtnDissBlock)(void);

@interface TPTCorrectCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (weak, nonatomic) IBOutlet UIButton *jianButton;

@property (weak, nonatomic) IBOutlet UILabel *tempLable;

@property (weak, nonatomic) IBOutlet UILabel *infoLable;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (weak, nonatomic) IBOutlet UIButton *dissButton;

@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;

@property (copy, nonatomic) clickBtnDissBlock dissBlock;

+ (instancetype)theTPTCorrectCellWithTableView:(UITableView *)tableView;

@end
