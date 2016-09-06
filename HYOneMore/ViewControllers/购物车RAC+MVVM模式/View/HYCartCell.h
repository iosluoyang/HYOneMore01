//
//  HYCartCell.h
//  HYOneMore
//
//  Created by 海洋 on 16/9/5.
//  Copyright © 2016年 海洋. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HYCartModel,HYCartNumberCount;
@interface HYCartCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *selectShopGoodsButton;
@property (weak, nonatomic) IBOutlet HYCartNumberCount *nummberCount;
@property (nonatomic, strong) HYCartModel*model;

+ (CGFloat)getCartCellHeight;
@end
