//
//  TPTSetOtherCell.h
//  tpt
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SetOtherCellBlock)(NSInteger tag);

@interface TPTSetOtherCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleOneLable;
@property (weak, nonatomic) IBOutlet UILabel *titleTwoLable;
@property (weak, nonatomic) IBOutlet UILabel *contentOneLable;
@property (weak, nonatomic) IBOutlet UILabel *contentTwoLable;

@property (nonatomic,copy) SetOtherCellBlock setOtherBlock;

+ (instancetype)theTPTSetOtherCellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexpath;

@end
