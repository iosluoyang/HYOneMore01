//
//  HYCartModel.h
//  HYOneMore
//
//  Created by 海洋 on 16/9/5.
//  Copyright © 2016年 海洋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYCartModel : NSObject
/**
 *  商品id
 */
@property (nonatomic, strong) NSString  *id;
/**
 *  商品图片
 */
@property (nonatomic, strong) NSString * img;
/**
 *  商品名称
 */
@property (nonatomic, strong) NSString  *title;
/**
 *  商品规格
 */
@property (nonatomic, strong) NSString  *color;
/**
 *  商品价格
 */
@property (nonatomic, strong) NSString *price;
/**
 *  商品数量
 */
@property (nonatomic, strong) NSString *count;
/**
 *  是否失效0否1是
 */
@property (nonatomic, strong) NSString *issx;
/**
 *  是否有库存 0无有的话为库存数值
 */
@property (nonatomic, strong) NSString *p_stock;
/**
 *  小区id
 */
@property (nonatomic, strong) NSString  *vid;

/**
 *  购物车商品id
 */
@property (nonatomic, strong) NSString  *sGoodId;


//商品是否被选中 0未选中 1选中
@property (nonatomic, strong) NSString *isSelect;

/**
 *  当前商品是否处于编辑状态 0否 1是
 */
@property (nonatomic, strong) NSString *isEditing;
/**
 *  当前商品是否被修改过 0否 1是
 */
@property (nonatomic, strong) NSString *isfixed;


/**
 *  赋值方法
 *
 *  @param dic 数据源
 *
 *  @return 模型对象
 */
- (id)initWithDic:(NSDictionary *)dic;
@end
