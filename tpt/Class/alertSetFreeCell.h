//
//  alertSetFreeCell.h
//  tpt
//
//  Created by apple on 16/8/11.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface alertSetFreeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;

+ (instancetype)thealertSetFreeCellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexpath;

@end
