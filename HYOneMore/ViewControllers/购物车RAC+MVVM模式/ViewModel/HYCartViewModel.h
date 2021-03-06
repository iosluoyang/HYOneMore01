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
/**
 *  删除按钮是否可以点击 0否 1是
 */
@property (nonatomic, strong) NSString *deleteenabel;
/**
 *  编辑状态下的记录数组，内容为商品的id（为了之后的传递后台用,拼接）
 */
@property (nonatomic, strong) NSMutableSet       *editcartData;
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
/**
 *  购物车sid
 */
@property (nonatomic, strong) NSString              *sid;
/**
 *  当前是否是编辑状态
 */
@property (nonatomic, assign) BOOL  isIdit;

//获取数据
- (void)getData;

/**
 *  是否全部选中或者全部取消选中
 *
 *  @param isSelect  是否选中
 *  @param ifconnect 是否需要和后台交互
 */
- (void)selectAll:(BOOL)isSelect ifconnect:(BOOL)ifconnect;

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
