//
//  TPTHistoryCell.h
//  tpt
//
//  Created by apple on 16/8/12.
//  Copyright © 2016年 MDJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBTemperature.h"
typedef void(^HistoryCellBlock)(NSInteger row);

@interface TPTHistoryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *stateLable;

@property (weak, nonatomic) IBOutlet UILabel *changLable;

@property (weak, nonatomic) IBOutlet UILabel *timeLable;

@property (weak, nonatomic) IBOutlet UIButton *delectBtn;

@property (weak, nonatomic) IBOutlet UILabel *methodLable;

@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;


@property (nonatomic,strong)WBTemperature *tempModel;

@property (nonatomic,strong)NSIndexPath *indexPath;

@property (nonatomic,copy)HistoryCellBlock delectHistBlock;

+ (instancetype)theTPTHistoryCellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexpath;

@end
