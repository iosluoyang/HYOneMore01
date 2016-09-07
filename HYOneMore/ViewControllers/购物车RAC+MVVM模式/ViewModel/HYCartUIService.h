//
//  HYCartUIService.h
//  HYOneMore
//
//  Created by 海洋 on 16/9/6.
//  Copyright © 2016年 海洋. All rights reserved.
//
/**
 *  @brief  界面操作动态改变界面的样式
 *  @author HY
 *  @date   2016.09.06
 */
typedef void    (^DidSelectCellBlock)(NSIndexPath *indexPath, id item) ;

@class HYCartViewModel;
#import <Foundation/Foundation.h>

@interface HYCartUIService : NSObject<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) HYCartViewModel *viewModel;
@property (nonatomic, copy) DidSelectCellBlock          didSelectCellBlock ;

@end
