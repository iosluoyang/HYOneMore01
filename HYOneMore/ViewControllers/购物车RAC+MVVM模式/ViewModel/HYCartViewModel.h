//
//  HYCartViewModel.h
//  HYOneMore
//
//  Created by 海洋 on 16/9/6.
//  Copyright © 2016年 海洋. All rights reserved.
//

/**
 *  @brief  CartViewModel
 *  @author HY
 *  @date   2016.09.06
 */

#import <Foundation/Foundation.h>
#import "HYCartVC.h"

@interface HYCartViewModel : NSObject

@property (nonatomic, strong  ) HYCartVC *cartVC;
@property (nonatomic, strong) NSMutableArray       *cartData;
@property (nonatomic, strong  ) UITableView          *cartTableView;
/**
 *  存放货源方选中
 */
@property (nonatomic, strong) NSMutableArray       *shopSelectArray;
/**
 *  carbar 观察的属性变化
 */
@property (nonatomic, assign) float                 allPrices;
/**
 *  carbar 全选的状态
 */
@property (nonatomic, assign) BOOL                  isSelectAll;
/**
 *  购物车商铺数量
 */
@property (nonatomic, assign) NSInteger             cartGoodsCount;
/**
 *  购物车商品总数数量
 */
@property (nonatomic, assign) NSInteger             cartGoodsTotalCount;
/**
 *  购物车商品种类数量
 */
@property (nonatomic, assign) NSInteger             cartGoodsKindsCount;

/**
 *  当前所选商品数量
 */
@property (nonatomic, assign) NSInteger             currentSelectCartGoodsCount;

//获取数据
- (void)getData;

//全选
- (void)selectAll:(BOOL)isSelect;

//row select
- (void)rowSelect:(BOOL)isSelect
        IndexPath:(NSIndexPath *)indexPath;

//row change quantity
- (void)rowChangeQuantity:(NSInteger)quantity
                indexPath:(NSIndexPath *)indexPath;

//获取价格
- (float)getAllPrices;

//左滑删除商品
- (void)deleteGoodsBySingleSlide:(NSIndexPath *)path;

//选中删除
- (void)deleteGoodsBySelect;




@end
