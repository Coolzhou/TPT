//
//  TPLeftCell.h
//  tpt
//
//  Created by apple on 16/7/28.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPLeftCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *leftImgView;


@property (weak, nonatomic) IBOutlet UILabel *titlesLable;


+ (instancetype)theLeftCellWithTableView:(UITableView *)tableView;

@end
