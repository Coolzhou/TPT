//
//  alertSetOneCell.h
//  tpt
//
//  Created by apple on 16/8/11.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface alertSetOneCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *contentLable;

+ (instancetype)thealertSetOneCellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexpath;

@end
