//
//  TPLeftCell.h
//  tpt
//
//  Created by apple on 16/7/28.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPLeftCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageLeftConstraint;
+ (instancetype)theLeftCellWithTableView:(UITableView *)tableView;

@end
