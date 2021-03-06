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
@class HYCartViewModel;
@class HYCartModel;
typedef void    (^DidSelectCellBlock)(NSIndexPath *indexPath, HYCartModel *cartmodel) ;


#import <Foundation/Foundation.h>

@interface HYCartUIService : NSObject<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) HYCartViewModel *viewModel;
@property (nonatomic, copy) DidSelectCellBlock          didSelectCellBlock ;

@end
