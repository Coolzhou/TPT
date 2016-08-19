//
//  TPTdutyCell.h
//  tpt
//
//  Created by apple on 16/8/19.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPTdutyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;

@property (weak, nonatomic) IBOutlet UILabel *titleLableOne;

@property (weak, nonatomic) IBOutlet UILabel *contentLableOne;

@property (weak, nonatomic) IBOutlet UILabel *titleLableTwo;

@property (weak, nonatomic) IBOutlet UILabel *contentLableTwo;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentOneConstraintH;



+ (instancetype)theTPTdutyCellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexpath;

+(CGFloat)theCellHeight;

@end
