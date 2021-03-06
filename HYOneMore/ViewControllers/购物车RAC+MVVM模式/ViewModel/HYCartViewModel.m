//
//  HYCartViewModel.m
//  HYOneMore
//
//  Created by 海洋 on 16/9/6.
//  Copyright © 2016年 海洋. All rights reserved.
//
#import "HYCartViewModel.h"
#import "HYCartShopModel.h"
#import "HYCartCell.h"



@implementation HYCartViewModel


#pragma mark - make data

- (void)getData{

    NSDictionary *resultDic = @{
                                @"shops" : @[
                                             @{
                                                 @"goods" :           @[
                                                                      @{
                                                                          @"color" : @"小周周",
                                                                          @"count" : @"10",
                                                                          @"id" : @"6948",
                                                                          @"img" : @"e471f1293a484e62ab69de265dcb9974.jpg",
                                                                          @"isSelect" : @"1",
                                                                          @"issx" : @"0",
                                                                          @"price" : @"180.00",
                                                                          @"sGoodId" : @"66",
                                                                          @"title" : @"牛逼哄哄的东西",
                                                                          @"vid" : @"2119"
                                                                      },
                                                                      @{
                                                                          @"color" : @"周杰伦",
                                                                          @"count" : @"2",
                                                                          @"id" : @"6949",
                                                                          @"img" : @"e471f1293a484e62ab69de265dcb9974.jpg",
                                                                          @"isSelect" : @"0",
                                                                          @"issx" : @"0",
                                                                          @"price" : @"120.00",
                                                                          @"sGoodId" : @"89",
                                                                          @"title" : @"哎呦不错呦",
                                                                          @"vid" : @"2119"
                                                                          }
                                                                      
                                                                      ],
                                                 @"id" : @"34",
                                                 @"type" : @"1"
                                             },
                          
                                            
                                             ],
                                @"sid" : @"6"
                                };
            self.sid = resultDic[@"sid"];//购物车sid
            //手动将viewmodel的编辑状态设置为NO
            self.isIdit = NO;
            //手动将viewmodel的记录编辑状态下的(不重复)数组清空
            self.editcartData = [NSMutableSet set];
            NSArray *shoparr = resultDic[@"shops"];
            NSInteger allGoodsCount = 0;//所有商品种类的数量
            NSInteger allGoodsTotalCount = 0;//所有商品总数的数量
            NSInteger allshopsCount = 0;//所有商铺的数量
            
            NSMutableArray *storeArray = [NSMutableArray arrayWithCapacity:shoparr.count];//店铺数组
            
            for (int i = 0; i<shoparr.count; i++) {
                NSDictionary *shopdata = shoparr[i];//每一个店铺的数据
                NSString *shopid = shopdata[@"id"];//商铺id
                NSString *shoptype = shopdata[@"type"];//商铺类型type
                NSArray *shopdataarr  = shopdata[@"goods"];//商铺中包含商品的数组
                //遍历商品数组:
                NSMutableArray *goodsArray = [NSMutableArray arrayWithCapacity:shopdataarr.count];
                for (int x = 0; x<shopdataarr.count; x++) {
                    NSDictionary *gooddata = shopdataarr[x];//商品数据
                    HYCartModel *cartModel = [[HYCartModel alloc] initWithDic:gooddata];
                    cartModel.p_stock      = @"0";//手动增加商品数据的库存数据,无库存
                    cartModel.isEditing    = @"0";//手动增加商品数据的是否处于编辑状态字段，默认否
                    cartModel.isfixed      = @"0"; //手动将model的修改状态置为NO，即0
                    [goodsArray addObject:cartModel];//将商品模型加入到商品数组中
                    
                    //计算总量:
                    //仅仅增加有效的且为选中的商品数量和商品种类:
                    if ([cartModel.issx integerValue] == 0 && [cartModel.isSelect integerValue] == 1) {
                        //有效且为选中的
                        allGoodsCount++;//商品种类+1
                        allGoodsTotalCount += [cartModel.count integerValue];//商品总数增加相应的值
                    }
                }
                //给每一个商铺数据进行赋值:
                HYCartShopModel *shopModel = [[HYCartShopModel alloc]init];
                shopModel.id = shopid;
                shopModel.type = shoptype;
                shopModel.goods = goodsArray;
                shopModel.isSelect = @"1";//手动增加店铺数据的选中状态，默认为选中
                //判断是否店铺被选中，条件是店铺中所有有效商品被选中，一旦有有效且未被选中的商品，则说明该店铺未被选中
                BOOL isalltimeout = YES;//默认全部为无效
                for (HYCartModel *cartmodel in shopModel.goods) {
                    if ([cartmodel.issx integerValue] == 0 && [cartmodel.isSelect integerValue] == 0) {
                        shopModel.isSelect = @"0";//未选中店铺
                    }
                    if ([cartmodel.issx integerValue] == 0) {
                        //有效
                        isalltimeout = NO;
                    }
                }
                //注意此处若全为无效商品，则该商铺也是未选中状态
                if (isalltimeout) {
                    shopModel.isSelect = @"0";
                }
                
                
                [storeArray addObject:shopModel];
                
            }
            //计算选中的商铺的数量:
            for (HYCartShopModel *shopModel in storeArray) {
                
                allshopsCount = [shopModel.isSelect integerValue] == 1 ?allshopsCount + 1 :allshopsCount + 0;
            }
            self.cartData = storeArray;//商铺数组
            self.cartGoodsCount = allshopsCount;//选中的商铺数量
            self.cartGoodsKindsCount = allGoodsCount;//选中的商品种类数量
            self.cartGoodsTotalCount = allGoodsTotalCount;//选中的商品总数量
            [self.cartTableView reloadData];
            self.allPrices = [self getAllPrices];
        
   
  
}

//获取总价
- (float)getAllPrices {
    
    __block float allPrices   = 0;
    //遍历所有有效商品,如果全部都选中的话就说明是全选了
    NSMutableArray *tempselectarr = [NSMutableArray array];
    for (HYCartShopModel *shopModel in self.cartData) {
        for (HYCartModel *cartModel in shopModel.goods) {
            if ([cartModel.issx integerValue] == 0) {
                //有效
                [tempselectarr addObject:[NSString stringWithFormat:@"%@",cartModel.isSelect]];
                //判断是否选中，如果选中，则计入总价
                if ([cartModel.isSelect integerValue] == 1) {
                    allPrices += [cartModel.count integerValue]*[cartModel.price floatValue];
                }
            }
           
        }
    }
    //如果数组中有一个是@“0”,未选中，则说明没有全选
    self.isSelectAll = ![tempselectarr containsObject:@"0"];
    
    
    
    
//    //映射
//    NSArray *pricesArray = [[[self.cartData rac_sequence] map:^id(HYCartShopModel *value) {
//        
//        
//        
//        //过滤器
//        
//        return
//        
//        [[[value.goods rac_sequence] filter:^BOOL(HYCartModel *model) {
//            //过滤商品信号,只让商品状态为有效且被选中时才使用该信号
//            if ([model.issx integerValue] == 0) {
//                //有效
//                if ([model.isSelect integerValue] == 1) {
//                    //选中
//                    return  YES;
//                }
//                //未选中
//                self.isSelectAll = NO;
//                return NO;
//                
//            }
//            return NO;
//
//        }] map:^id(HYCartModel *model) {
//            //判断商品是否失效，如果是失效状态则不计入总价
//            return ([model.issx integerValue] == 0 && [model.isSelect integerValue] == 1) ? @([model.count integerValue]*[model.price floatValue]):@(0);
//        }];
//        
//        
//        
//        
//        
//        
//        
//        
//    }] array];
    
    
//    for (NSArray *priceA in pricesArray) {
//        for (NSNumber *price in priceA) {
//            allPrices += price.floatValue;
//        }
//    }
    NSLog(@"%@",tempselectarr);
    return allPrices;
}

//全选
- (void)selectAll:(BOOL)isSelect ifconnect:(BOOL)ifconnect {
    if (ifconnect) {
       
       

        //重置各种数量为0
        __block float allPrices = 0;
        __block float allgoodskind = 0;
        __block float allgooscount = 0;
        __block float allshopcount = 0;
        
        
        
        
        self.cartData = [[[[self.cartData rac_sequence] map:^id(HYCartShopModel *value) {
            
            //注意,因为此处不再是直接数组化，而是返回店铺对象，所以由于Block嵌套的不及时性，此处改为for循环将model的isSelect属性赋值
            for (HYCartModel *model in value.goods) {
                //只有有效商品才能被手动全选中或者取消选中:
                if ([model.issx integerValue] == 0) {
                    [model setValue:isSelect ? @"1" : @"0" forKey:@"isSelect"];
                    //只有被点选的才计入总价
                    if ([model.isSelect integerValue] == 1) {
                        allPrices += [model.count integerValue]*[model.price floatValue];
                        //合计总共商品数量的数据:
                        allgooscount += [model.count integerValue];
                        //合计总共商品种类的数据:
                        allgoodskind ++;
                    }
                }
            }
            
            //计算店铺数量的方法较复杂，有三种状态：全为失效商品 有失效有有效商品  全为有效商品
            NSMutableArray *tempstatearray = [NSMutableArray array];
            //将每个店铺的商品状态放置到数组中:
            for (HYCartModel *model in value.goods) {
                [tempstatearray addObject:model.issx];
            }
            NSInteger arrcount = tempstatearray.count;
            
            //进行判断哪种状态:
            [tempstatearray removeObject:@"0"];//移除掉所有的有效商品
            if (tempstatearray.count == 0) {
                //说明全部是有效商品
                allshopcount ++;
                [value setValue:isSelect ? @"1" : @"0" forKey:@"isSelect"];
            }
            else if (tempstatearray.count != 0 && tempstatearray.count < arrcount){
                //如果数量变少且不为0，则说明无效商品有效商品都有
                allshopcount ++;
                [value setValue:isSelect ? @"1" : @"0" forKey:@"isSelect"];
                
            }
            else
            {
                //全部为无效商品,不进行加减操作,为非选中状态
                [value setValue:@"0" forKey:@"isSelect"];
            }
            
            
            return value;
        }] array] mutableCopy];
        
        self.isSelectAll = isSelect;
        self.allPrices = allPrices;//总价
        self.cartGoodsTotalCount = allgooscount;//商品总数量
        self.cartGoodsCount = allshopcount;//商铺数量
        self.cartGoodsKindsCount = allgoodskind;//商品种类数量
        [self.cartTableView reloadData];
        
        
            
        
    }
    else
    {
    //不需要进行后台交互，直接更改数据模型中的isselect属性值就行
        
        //将编辑状态下的商品id全部清除:
        self.editcartData = [NSMutableSet set];
        self.deleteenabel = @"0";
        
        self.cartData = [[[[self.cartData rac_sequence] map:^id(HYCartShopModel *value) {
            
            //注意,因为此处不再是直接数组化，而是返回店铺对象，所以由于Block嵌套的不及时性，此处改为for循环将model的isSelect属性赋值
            for (HYCartModel *model in value.goods) {
                //有效商品和无效商品都能被手动全选中或者取消选中:
                    [model setValue:isSelect ? @"1" : @"0" forKey:@"isSelect"];
                //将商品数据的是否处于编辑状态手动设置为是
                [model setValue:@"1" forKey:@"isEditing"];
                //根据isselect字段选择是增加还是移除
                isSelect ? [self.editcartData addObject:model.sGoodId] : [self.editcartData removeObject:model.sGoodId];
            }
            
             [value setValue:isSelect ? @"1" : @"0" forKey:@"isSelect"];

            return value;
        }] array] mutableCopy];
        
        self.deleteenabel = _editcartData.count == 0 ? @"0" :@"1";
        self.isSelectAll = isSelect;
        [self.cartTableView reloadData];
    }
}

//选择某个商品
- (void)rowSelect:(BOOL)isSelect IndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section          = indexPath.section;
    NSInteger row              = indexPath.row;
    
    HYCartShopModel *shopmodel = self.cartData[section];
    NSMutableArray *goodsArray = shopmodel.goods;
    NSInteger shopCount        = goodsArray.count;
    HYCartModel *model         = goodsArray[row];
    
    
    //非编辑状态下与后台进行交互，编辑状态下不需要与后台进行交互，但是需要记录联动效果
    if (!self.isIdit) {
       
        [model setValue:isSelect ? @"1" : @"0" forKey:@"isSelect"];
        if ([model.isSelect integerValue] == 1) {
            //选中，为增值
            self.cartGoodsTotalCount += [model.count integerValue];//商品总数量
            self.cartGoodsKindsCount ++;//商品总种类
        }
        else{
            //未选中，为减值
            self.cartGoodsTotalCount -= [model.count integerValue];
            self.cartGoodsKindsCount --;
        }
        
        
        //判断是否都到达足够数量,展示是否选中商铺
        NSInteger isSelectShopCount = 0;
        NSInteger timeoutcount = 0;//记录失效的商品的数量
        for (HYCartModel *model in goodsArray) {
            if ([model.isSelect integerValue] == 1) {
                isSelectShopCount++;
            }
            if ([model.issx integerValue] == 1) {
                //失效
                timeoutcount ++;
            }
            
        }
        //对isSelectShopCount是否和该商铺的商品数量 - 失效商品数量相等做对比，如果相同则表明选中店铺
        NSString *shopisselect = isSelectShopCount  == (shopCount - timeoutcount) ?@"1" : @"0";
        [shopmodel setValue:shopisselect forKey:@"isSelect"];
        
        
        //给商铺数量赋值,通过对self.shopselectarray中数值的监控拿到当前的商铺数量:
        NSInteger shopsnum = 0;
        
        for (HYCartShopModel *shopmodel  in self.cartData) {
            if ([shopmodel.isSelect integerValue] == 1) {
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
    else
    {
    //编辑状态下:
        
        [model setValue:isSelect ? @"1" : @"0" forKey:@"isSelect"];
        //将该商品的id加入或者移除从记录编辑状态的数组中
        isSelect ? [_editcartData addObject:model.sGoodId] : [_editcartData removeObject:model.sGoodId];
        self.deleteenabel = _editcartData.count == 0 ? @"0" :@"1";

        //判断是否都到达足够数量,展示是否选中商铺
        NSInteger isSelectShopCount = 0;
        for (HYCartModel *model in goodsArray) {
            if ([model.isSelect integerValue] == 1) {
                isSelectShopCount++;
            }
        }
        //对isSelectShopCount是否和该商铺的商品数量相等做对比，如果相同则表明选中店铺
        NSString *shopisselect = isSelectShopCount  == shopCount ?@"1" : @"0";
        [shopmodel setValue:shopisselect forKey:@"isSelect"];
        
        
        [self.cartTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
        //判断是否是全选状态:
        NSMutableArray *tempselectarr = [NSMutableArray array];
        for (HYCartShopModel *shopModel in self.cartData) {
            for (HYCartModel *cartModel in shopModel.goods) {
            [tempselectarr addObject:[NSString stringWithFormat:@"%@",cartModel.isSelect]];  
            }
        }
        //如果数组中有一个是@“0”,未选中，则说明没有全选
        self.isSelectAll = ![tempselectarr containsObject:@"0"];
        
    }
    
}

//某个商品的数量加减
- (void)rowChangeQuantity:(NSInteger)quantity indexPath:(NSIndexPath *)indexPath {
    
    NSInteger section  = indexPath.section;
    NSInteger row      = indexPath.row;
    
    HYCartShopModel *shopmodel = self.cartData[section];
    HYCartModel *model = shopmodel.goods[row];
    
    
    //非编辑状态下加减数量:
    if (!self.isIdit) {
                //非编辑状态
    [model setValue:[NSString stringWithFormat:@"%ld",(long)quantity] forKey:@"count"];
    if (quantity > [model.count integerValue]) {
        //增加:
        self.cartGoodsTotalCount += (quantity - [model.count integerValue]);
    }
    else{
        //减少:
        self.cartGoodsTotalCount -= ([model.count integerValue] - quantity);
    }
    
    [self.cartTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    
    /*重新计算价格*/
    self.allPrices = [self getAllPrices];
    }
    //编辑状态下仅仅改变model的属性
    else{
        
        [model setValue:[NSString stringWithFormat:@"%ld",(long)quantity] forKey:@"count"];
         model.isfixed = @"1";
         [self.cartTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    }

}

//左滑删除商品
- (void)deleteGoodsBySingleSlide:(NSIndexPath *)path {
    //二次确认按钮
    UIAlertController *alertvc = [UIAlertController alertControllerWithTitle:nil message:@"你确定将商品从购物车中删除吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSInteger section = path.section;
        NSInteger row     = path.row;
        HYCartShopModel *shopmodel = self.cartData[section];
        NSMutableArray *shopArray = shopmodel.goods;
        /* 注意此处一定是在删除之前拿到该model的数据，否则会造成数组越界 */
        HYCartModel *model = shopArray[row];
        {
            //删除成功之后根据不同场景选择不同操作，完成状态下更改数据，删除当前商品，刷新tableview或者该区数据
            //编辑状态下不需要更改数据，直接删除当前商品，刷新tableview或者该区数据
            if (!self.isIdit) {
                //完成状态下
                [shopArray removeObjectAtIndex:row];
                
                //判断是否都到达足够数量,展示是否选中商铺
                NSInteger isSelectShopCount = 0;
                NSInteger timeoutcount = 0;//记录失效的商品的数量
                for (HYCartModel *model in shopArray) {
                    if ([model.isSelect integerValue] == 1) {
                        isSelectShopCount++;
                    }
                    if ([model.issx integerValue] == 1) {
                        //失效
                        timeoutcount ++;
                    }
                    
                }
                //对isSelectShopCount是否和该商铺的商品数量 - 失效商品数量相等做对比，如果相同则表明选中店铺
                NSString *shopisselect = isSelectShopCount  == (shopArray.count - timeoutcount)  && isSelectShopCount!= 0 ?@"1" : @"0";
                [shopmodel setValue:shopisselect forKey:@"isSelect"];
                
                NSInteger selectshopcount = 0;
                for (HYCartShopModel *shopmodel in self.cartData) {
                    if ([shopmodel.isSelect integerValue] == 1) {
                        selectshopcount ++;
                    }
                }
                self.cartGoodsCount = selectshopcount;
                
                if (shopArray.count == 0) {
                    /* 删除店铺数据 */
                    [self.cartData removeObjectAtIndex:section];
                    [self.cartTableView reloadData];
                } else {
                    [self.cartTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
                }
                //在cell被选中且有效的情况下才进行计算,否则重复删减数据
                if ([model.isSelect integerValue] == 1 && [model.issx integerValue] == 0) {
                    self.cartGoodsKindsCount --;//选中的商品种类数量
                    self.cartGoodsTotalCount -= [model.count integerValue];//选中的商品总数量
                }
                
                /*重新计算价格*/
                self.allPrices = [self getAllPrices];
            }
            else
            {
                //编辑状态下
                [shopArray removeObjectAtIndex:row];
                
                //判断是否都到达足够数量,展示是否选中商铺
                NSInteger isSelectShopCount = 0;
                for (HYCartModel *model in shopArray) {
                    if ([model.isSelect integerValue] == 1) {
                        isSelectShopCount++;
                    }
                    
                }
                //对isSelectShopCount是否和该商铺的商品数量相等且不等于0做对比，如果相同则表明选中店铺
                NSString *shopisselect = isSelectShopCount  == shopArray.count  && isSelectShopCount!= 0 ?@"1" : @"0";
                [shopmodel setValue:shopisselect forKey:@"isSelect"];
                
                if (shopArray.count == 0) {
                    /* 删除店铺数据 */
                    [self.cartData removeObjectAtIndex:section];
                    [self.cartTableView reloadData];
                } else {
                    [self.cartTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
                }
                //根据当前商品情况进行全选按钮的点击或者被点击状态的区分
                //遍历当前所有商品,如果全部都选中的话就说明是全选了
                NSMutableArray *tempselectarr = [NSMutableArray array];
                for (HYCartShopModel *shopModel in self.cartData) {
                    for (HYCartModel *cartModel in shopModel.goods) {
                        [tempselectarr addObject:[NSString stringWithFormat:@"%@",cartModel.isSelect]];
                    }
                }
                //如果数组有元素且其中有一个是@“0”,未选中，则说明没有全选
                self.isSelectAll =  tempselectarr.count >0 && ![tempselectarr containsObject:@"0"];
                //判断删除记录数组中的数据变更
                if ([model.isSelect integerValue] == 1) {
                    [self.editcartData removeObject:model.sGoodId];
                }
                self.deleteenabel = _editcartData.count == 0 ? @"0" :@"1";
                
            }
            
            
        }
        
    }];
    [alertvc addAction:action1];
    [alertvc addAction:action2];
    [self.cartVC presentViewController:alertvc animated:YES completion:nil];

}


//选中删除
- (void)deleteGoodsBySelect {
    
    //二次确认按钮
    UIAlertController *alertvc = [UIAlertController alertControllerWithTitle:nil message:@"你确定将商品从购物车中删除吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSMutableArray *array = [NSMutableArray array];
        for (NSString *id in self.editcartData) {
            [array addObject:id];
        }
        NSString *ids = [array componentsJoinedByString:@","];
        NSDictionary *info = @{@"ids":ids};
        
            /*1 删除数据*/
            NSInteger index1 = -1;
            NSMutableIndexSet *shopSelectIndex = [NSMutableIndexSet indexSet];
            for (HYCartShopModel*shopmodel in self.cartData) {
                NSMutableArray *shopArray = shopmodel.goods;
                
                index1++;
                NSInteger index2 = -1;
                NSMutableIndexSet *selectIndexSet = [NSMutableIndexSet indexSet];
                for (HYCartModel *model in shopArray) {
                    index2++;
                    if ([model.isSelect integerValue] == 1) {
                        //如果删除时被选中,则意味着要被删除,也从记录状态的数组中删除
                        [selectIndexSet addIndex:index2];
                        [self.editcartData removeObject:model.sGoodId];
                    }
                }
                NSInteger shopCount = shopArray.count;
                NSInteger selectCount = selectIndexSet.count;
                if (selectCount == shopCount) {
                    /* 当选中商品的种类数量和店铺中所有商品的种类数量都相等时,即删除总店铺的数量 */
                    [shopSelectIndex addIndex:index1];
                }
                [shopArray removeObjectsAtIndexes:selectIndexSet];
            }
            [self.cartData removeObjectsAtIndexes:shopSelectIndex];
            [self.cartTableView reloadData];
            //根据当前商品情况进行全选按钮的点击或者被点击状态的区分
            //遍历当前所有商品,如果全部都选中的话就说明是全选了
            NSMutableArray *tempselectarr = [NSMutableArray array];
            for (HYCartShopModel *shopModel in self.cartData) {
                for (HYCartModel *cartModel in shopModel.goods) {
                    [tempselectarr addObject:[NSString stringWithFormat:@"%@",cartModel.isSelect]];
                }
            }
            //如果数组有元素且其中有一个是@“0”,未选中，则说明没有全选
            self.isSelectAll =  tempselectarr.count >0 && ![tempselectarr containsObject:@"0"];
            //判断删除记录数组中的数据变更
            self.deleteenabel = _editcartData.count == 0 ? @"0" :@"1";
            
        
        
    }];
    [alertvc addAction:action1];
    [alertvc addAction:action2];
    [self.cartVC presentViewController:alertvc animated:YES completion:nil];

}

@end
