//
//  TPTSetBuyCell.h
//  tpt
//
//  Created by zhou on 2017/6/1.
//  Copyright © 2017年 MDJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPTSetBuyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *messageLable;

+ (instancetype)theTPTSetOtherCellWithTableView:(UITableView *)tableView;
@end
