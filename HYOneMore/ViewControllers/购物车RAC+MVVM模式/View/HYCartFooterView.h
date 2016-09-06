//
//  HYCartFooterView.h
//  HYOneMore
//
//  Created by 海洋 on 16/9/6.
//  Copyright © 2016年 海洋. All rights reserved.
//

/**
 *  @brief  每个分区的FootView
 *  @author HY
 *  @date   2016.09.06
 */
#import <UIKit/UIKit.h>

@interface HYCartFooterView : UITableViewHeaderFooterView
@property (nonatomic, strong) NSMutableArray *shopGoodsArray;
+ (CGFloat)getCartFooterHeight;
@end
