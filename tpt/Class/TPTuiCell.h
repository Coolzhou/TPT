//
//  ZCmainCell.h
//  zctx
//
//  Created by Yi luqi on 15/10/7.
//  Copyright © 2015年 sanliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPTuiCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLable;

@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleConstraintW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightImgConstraintW;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentleftConstraintMarge;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentrightConstraintMarge;

+ (instancetype)theTuiWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexpath;

@end
