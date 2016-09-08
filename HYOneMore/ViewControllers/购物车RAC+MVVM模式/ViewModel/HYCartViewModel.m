//
//  HYCartViewModel.m
//  HYOneMore
//
//  Created by 海洋 on 16/9/6.
//  Copyright © 2016年 海洋. All rights reserved.
//
#import "HYCartViewModel.h"
#import "HYCartModel.h"

@interface HYCartViewModel () {
    
    NSArray *_shopGoodsCount;
    NSArray *_goodsPicArray;
    NSArray *_goodsPriceArray;
    NSArray *_goodsQuantityArray;
    
}
//随机获取店铺下商品数
@property (nonatomic, assign) NSInteger random;
@end


@implementation HYCartViewModel
#pragma mark - 暂时模拟的购物车数据
- (instancetype)init {
    self = [super init];
    if (self) {
        //6
        _shopGoodsCount  = @[@(1),@(3),@(5),@(2),@(4),@(4)];//每一个商铺包含的商品数量
        _goodsPicArray  = @[@"smile", @"smile", @"smile", @"smile", @"smile", @"smile"];
        _goodsPriceArray = @[@(30.45),@(120.09),@(8887.88),@(181.11),@(56.1),@(12)];
        _goodsQuantityArray = @[@(6),@(16),@(26),@(36),@(46),@(56)];
    }
    return self;
}

- (NSInteger)random {
    
    NSInteger from = 0;
    NSInteger to   = 5;
    
    return (NSInteger)(from + (arc4random() % (to - from + 1)));
}

#pragma mark - make data

- (void)getData{
    //数据个数
    NSInteger allCount = 5;
    NSInteger allGoodsCount = 0;//所有商品种类的数量
    NSInteger allGoodsTotalCount = 0;//所有商品总数的数量
    NSMutableArray *storeArray = [NSMutableArray arrayWithCapacity:allCount];
    NSMutableArray *shopSelectAarry = [NSMutableArray arrayWithCapacity:allCount];
    //创造店铺数据
    for (int i = 0; i<allCount; i++) {
        //随机创造店铺下商品数据
        NSInteger goodsCount = [_shopGoodsCount[i] intValue];
        NSMutableArray *goodsArray = [NSMutableArray arrayWithCapacity:goodsCount];
        for (int x = 0; x<goodsCount; x++) {
            HYCartModel *cartModel = [[HYCartModel alloc] init];
            cartModel.p_id         = [NSString stringWithFormat:@"%d",x];
            cartModel.p_price      = [NSString stringWithFormat:@"%.2f",[_goodsPriceArray[x] floatValue]];
            cartModel.p_name       = [NSString stringWithFormat:@"(%@,%@)我的意中人是个盖世英雄，有一天他会他踏着七色祥云来娶我，我猜中的开头，却没有猜中结尾。",@(i),@(x)];
            cartModel.p_stock      = 0;//无库存
            cartModel.p_imageUrl   = _goodsPicArray[x];
            cartModel.p_quantity   = [_goodsQuantityArray[x] integerValue];
            [goodsArray addObject:cartModel];
            allGoodsCount++;
            allGoodsTotalCount += cartModel.p_quantity;
        }
        [storeArray addObject:goodsArray];
        [shopSelectAarry addObject:@(NO)];
    }
    self.cartData = storeArray;
    self.shopSelectArray = shopSelectAarry;
    self.cartGoodsCount = shopSelectAarry.count;
    self.cartGoodsKindsCount = allGoodsCount;
    self.cartGoodsTotalCount = allGoodsTotalCount;
    
}

//获取总价
- (float)getAllPrices {
    
    __block float allPrices   = 0;
    NSInteger shopCount       = self.cartData.count;
    NSInteger shopSelectCount = self.shopSelectArray.count;
    if (shopSelectCount == shopCount && shopCount!=0) {
        self.isSelectAll = YES;
    }
    NSArray *pricesArray = [[[self.cartData rac_sequence] map:^id(NSMutableArray *value) {
        return [[[value rac_sequence] filter:^BOOL(HYCartModel *model) {
            if (!model.isSelect) {
                self.isSelectAll = NO;
            }
            return model.isSelect;
        }] map:^id(HYCartModel *model) {
            return @(model.p_quantity*[model.p_price floatValue]);
        }];
    }] array];
    for (NSArray *priceA in pricesArray) {
        for (NSNumber *price in priceA) {
            allPrices += price.floatValue;
        }
    }
    
    return allPrices;
}

//全选
- (void)selectAll:(BOOL)isSelect {
    
    __block float allPrices = 0;
    __block float allgoodskind = 0;
    __block float allgooscount = 0;
    __block float allshopcount = 0;
    
    self.shopSelectArray = [[[[self.shopSelectArray rac_sequence] map:^id(NSNumber *value) {
        return @(isSelect);
    }] array] mutableCopy];
    self.cartData = [[[[self.cartData rac_sequence] map:^id(NSMutableArray *value) {
        return  [[[[value rac_sequence] map:^id(HYCartModel *model) {
            [model setValue:@(isSelect) forKey:@"isSelect"];
            if (model.isSelect) {
                allPrices += model.p_quantity*[model.p_price floatValue];
                //合计总共商品数量的数据:
                allgooscount += model.p_quantity;
                //合计总共商品种类的数据:
                allgoodskind ++;
                //合计总共商铺数量的数据:
                allshopcount = self.cartData.count;
            }
            return model;
        }] array] mutableCopy];
    }] array] mutableCopy];
    self.allPrices = allPrices;//总价
    self.cartGoodsTotalCount = allgooscount;//商品总数量
    self.cartGoodsCount = allshopcount;//商铺数量
    self.cartGoodsKindsCount = allgoodskind;//商品种类数量
    [self.cartTableView reloadData];
}

//选择某个商品
- (void)rowSelect:(BOOL)isSelect IndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section          = indexPath.section;
    NSInteger row              = indexPath.row;
    
    NSMutableArray *goodsArray = self.cartData[section];
    NSInteger shopCount        = goodsArray.count;
    HYCartModel *model         = goodsArray[row];
    [model setValue:@(isSelect) forKey:@"isSelect"];
     //在此根据是否选中增加或者减少商品总数量或者商品种类总数量（仅在非编辑状态下选中,根据tableview的编辑状态决定是否做如下操作）
//    if (!self.cartTableView.editing) {
        //正处于非编辑状态，进行记录更改等的操作（注意isediting和tableview的editing为取反状态）
        if (model.isSelect) {
            //选中，为增值
            self.cartGoodsTotalCount += model.p_quantity;//商品总数量
            self.cartGoodsKindsCount ++;//商品总种类
        }
        else{
            //未选中，为减值
            self.cartGoodsTotalCount -= model.p_quantity;
            self.cartGoodsKindsCount --;
        }

//    }
       //判断是否都到达足够数量,展示是否选中商铺
    NSInteger isSelectShopCount = 0;
    for (HYCartModel *model in goodsArray) {
        if (model.isSelect) {
            isSelectShopCount++;
        }
    }
    [self.shopSelectArray replaceObjectAtIndex:section withObject:@(isSelectShopCount==shopCount?YES:NO)];
    
    //给商铺数量赋值,通过对self.shopselectarray中数值的监控拿到当前的商铺数量:
    NSInteger shopsnum = 0;
    for (id type in self.shopSelectArray) {
        if ([type integerValue] == 1) {
            shopsnum ++;
        }
    }
    self.cartGoodsCount = shopsnum;//商铺总数量
    
    [self.cartTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    
    /*重新计算价格*/
    self.allPrices = [self getAllPrices];
#if DEBUG
    NSLog(@"商铺数量:%ld,商品种类:%ld,商品总数量为:%ld",(long)self.cartGoodsCount,(long)self.cartGoodsKindsCount,(long)self.cartGoodsTotalCount);
#endif
}
//某个商品的数量加减
- (void)rowChangeQuantity:(NSInteger)quantity indexPath:(NSIndexPath *)indexPath {
    
    NSInteger section  = indexPath.section;
    NSInteger row      = indexPath.row;
    
    HYCartModel *model = self.cartData[section][row];
    
    [model setValue:@(quantity) forKey:@"p_quantity"];
    if (quantity > model.p_quantity) {
        //增加:
        self.cartGoodsTotalCount += (quantity - model.p_quantity);
    }
    else{
        //减少:
        self.cartGoodsTotalCount -= (model.p_quantity - quantity);
    }
   
    
    [self.cartTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    
    /*重新计算价格*/
    self.allPrices = [self getAllPrices];
}

//左滑删除商品
- (void)deleteGoodsBySingleSlide:(NSIndexPath *)path {
    
    NSInteger section = path.section;
    NSInteger row     = path.row;
    
    NSMutableArray *shopArray = self.cartData[section];
    /* 注意此处一定是在删除之前拿到该model的数据，否则会造成数组越界 */
    HYCartModel *model = shopArray[row];
    NSInteger goodscount = model.p_quantity;
    
    [shopArray removeObjectAtIndex:row];
    if (shopArray.count == 0) {
        /*1 删除数据*/
        [self.cartData removeObjectAtIndex:section];
        /*2 删除 shopSelectArray*/
        [self.shopSelectArray removeObjectAtIndex:section];
        [self.cartTableView reloadData];
    } else {
        [self.cartTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    }
    //在cell被选中的情况下才进行计算,否则重复删减数据
    if (model.isSelect) {
        self.cartGoodsKindsCount-=1;//商品种类数量
        self.cartGoodsTotalCount -= goodscount;//商品总数量
    }
    
    self.cartGoodsCount = self.cartData.count;//商铺数量
    /*重新计算价格*/
    self.allPrices = [self getAllPrices];
}


//选中删除
- (void)deleteGoodsBySelect {
    
#if DEBUG
    NSLog(@"商铺数量:%ld,商品种类:%ld,商品总数量为:%ld",(long)self.cartGoodsCount,(long)self.cartGoodsKindsCount,(long)self.cartGoodsTotalCount);
#endif
    /*1 删除数据*/
    NSInteger index1 = -1;
    NSMutableIndexSet *shopSelectIndex = [NSMutableIndexSet indexSet];
    for (NSMutableArray *shopArray in self.cartData) {
        index1++;
        
        NSInteger index2 = -1;
        NSMutableIndexSet *selectIndexSet = [NSMutableIndexSet indexSet];
        for (HYCartModel *model in shopArray) {
            index2++;
            if (model.isSelect) {
                //如果删除时被选中,则意味着要被删除
                [selectIndexSet addIndex:index2];
                //拿到当前商品的数量，在商品总数中减掉该数量
                NSInteger deletegoodscounts = model.p_quantity;
                self.cartGoodsTotalCount -= deletegoodscounts;//商品总数量
            }
        }
        NSInteger shopCount = shopArray.count;
        NSInteger selectCount = selectIndexSet.count;
        if (selectCount == shopCount) {
    /* 当选中商品的种类数量和店铺中所有商品的种类数量都相等时,即删除总店铺的数量,即商铺数量-1,商品种类数量减去选中的数量 */
            [shopSelectIndex addIndex:index1];
//            self.cartGoodsCount --;//商铺数量  //因为在选中某个商品的时候不区分tableview的editing编辑模式，所以此时的商铺数量已经减过了，即，在此处不减去商铺的数量
        }
        self.cartGoodsKindsCount -= selectCount;//商品种类数量
        [shopArray removeObjectsAtIndexes:selectIndexSet];
    }
    [self.cartData removeObjectsAtIndexes:shopSelectIndex];
    /*2 删除 shopSelectArray*/
    [self.shopSelectArray removeObjectsAtIndexes:shopSelectIndex];
    [self.cartTableView reloadData];
    /*3 carbar 恢复默认*/
    self.allPrices = 0;
    /*重新计算价格*/
    self.allPrices = [self getAllPrices];
#if DEBUG
    NSLog(@"商铺数量:%ld,商品种类:%ld,商品总数量为:%ld",(long)self.cartGoodsCount,(long)self.cartGoodsKindsCount,(long)self.cartGoodsTotalCount);
#endif
}



@end
