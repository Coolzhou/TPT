//
//  TPTSetEleCell.h
//  tpt
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPTSetEleCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *contentLable;

+ (instancetype)theTPTSetEleCellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexpath;

@end
