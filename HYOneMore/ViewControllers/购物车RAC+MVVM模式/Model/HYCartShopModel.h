//
//  HYCartShopModel.h
//  SuperUserClientApp
//
//  Created by 海洋 on 16/9/10.
//  Copyright © 2016年 LC-World. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYCartModel.h"
@interface HYCartShopModel : NSObject
/**
 *  商户，社长或者商铺id
 */
@property (nonatomic, strong) NSString  *id;
/**
 *  商品类型 现在都是1代表原产地精选
 */
@property (nonatomic, strong) NSString * type;
/**
 *  商品集合
 */
@property (nonatomic, strong) NSMutableArray  *goods;
/**
 *  每一个货源方所有商品的总价  （保留两位小数）
 */
@property (nonatomic, strong) NSString  *totalPrice;
//店铺是否被选中 0未选中 1选中
@property (nonatomic, strong) NSString *isSelect;

/**
 *  赋值方法
 *
 *  @param dic 数据源
 *
 *  @return 模型对象
 */
- (id)initWithDic:(NSDictionary *)dic;
@end
