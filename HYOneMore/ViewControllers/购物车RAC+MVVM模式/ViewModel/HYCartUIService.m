//
//  HYCartUIService.m
//  HYOneMore
//
//  Created by 海洋 on 16/9/6.
//  Copyright © 2016年 海洋. All rights reserved.
//

#import "HYCartUIService.h"
#import "HYCartViewModel.h"
#import "HYCartCell.h"
#import "HYCartHeaderView.h"
#import "HYCartFooterView.h"
#import "HYCartShopModel.h"
#import "HYCartNumberCount.h"

@implementation HYCartUIService
#pragma mark - UITableView Delegate/DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.cartData.count;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    HYCartShopModel *shopmodel = self.viewModel.cartData[section];
    return shopmodel.goods.count;
}

#pragma mark - header view

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return [HYCartHeaderView getCartHeaderHeight];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    HYCartShopModel *shopmodel =  self.viewModel.cartData[section];
    NSMutableArray *shopArray = shopmodel.goods;
    
    HYCartHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HYCartHeaderView"];
    //店铺全选
    [[[headerView.selectStoreGoodsButton rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:headerView.rac_prepareForReuseSignal] subscribeNext:^(UIButton *xx) {
        //非编辑状态下的操作
        if (!self.viewModel.isIdit) {
            //判断如果数组中全为无效商品，则不进行任何操作:
            NSInteger timeoutcount = 0;
            for (HYCartModel *cartmodel in shopmodel.goods) {
                timeoutcount += [cartmodel.issx integerValue] == 1 ? 1:0;
            }
            if (timeoutcount == shopmodel.goods.count) {
                //全为无效商品,不能进行点击
                return ;
            }
            xx.selected = !xx.selected;
            BOOL isSelect = xx.selected;//已经取反过的值，表示即将变的值
            NSString *isselectstr = isSelect ? @"1" : @"0";
            [shopmodel setValue:isselectstr forKey:@"isSelect"];
            
            //        [self.viewModel.shopSelectArray replaceObjectAtIndex:section withObject:@(isSelect)];
            //重新计算商铺数量，商品总数，商品种类
            if (isSelect) {
                //选中
                
                //商品种类是增加该商铺之前未选中的有效的商品种类 商品总数量是增加该商铺之前未选中的有效的商品总数量 店铺数量是增加该商铺之前未选中的有效店铺数量
                NSInteger tempkindsnum = self.viewModel.cartGoodsKindsCount;
                NSInteger temptotalnum = self.viewModel.cartGoodsTotalCount;
                NSInteger tempshopnum  = 0;
                
                for (HYCartModel *model in shopArray) {
                    //增加的是之前未选中且为有效
                    tempkindsnum +=  [model.isSelect integerValue] == 0 && [model.issx integerValue] == 0 ? 1:0;
                    temptotalnum += [model.isSelect integerValue] == 0 && [model.issx integerValue] == 0 ?  [model.count integerValue] : 0;
                    //只要商品数组中存在一个未选中且为有效的商品，则商铺数量+1
                    if ([model.isSelect integerValue] == 0 && [model.issx integerValue] == 0) {
                        tempshopnum = 1;
                    }
                }
                self.viewModel.cartGoodsKindsCount = tempkindsnum;//商品种类数量
                self.viewModel.cartGoodsTotalCount = temptotalnum;//商品总数量
                self.viewModel.cartGoodsCount += tempshopnum;//商铺数量
                
            }
            else
            {
                //取消选中，减少
                //商品种类是减去该商铺之前未选中的有效的商品种类 商品总数量是减去该商铺之前未选中的有效的商品总数量 店铺数量是减去该商铺之前未选中的有效店铺数量
                NSInteger tempkindsnum = self.viewModel.cartGoodsKindsCount;
                NSInteger temptotalnum = self.viewModel.cartGoodsTotalCount;
                NSInteger tempshopnum  = 1;
                
                for (HYCartModel *model in shopArray) {
                    //减少的是选中的且为有效的商品
                    tempkindsnum -=  [model.isSelect integerValue] == 1 && [model.issx integerValue] == 0 ? 1:0;
                    temptotalnum -= [model.isSelect integerValue] == 1 && [model.issx integerValue] == 0 ? [model.count integerValue]:0;
                }
                self.viewModel.cartGoodsKindsCount = tempkindsnum;//商品种类数量
                self.viewModel.cartGoodsTotalCount = temptotalnum;//商品总数量
                self.viewModel.cartGoodsCount -= tempshopnum;//商铺数量
                
                
            }
            
            
            for (HYCartModel *model in shopArray) {
                NSString *isselectstr = isSelect ? @"1" : @"0";
                //如果是选中的话，也仅仅是针对有效商品进行选中操作:
                if ([model.issx integerValue] == 0) {
                    //无效的商品不能被选中也不能被取消选中
                    [model setValue:isselectstr forKey:@"isSelect"];
                }
                
            }
            [self.viewModel.cartTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
            
            self.viewModel.allPrices = [self.viewModel getAllPrices];
        }
        else {
        //编辑状态下:
            
            xx.selected = !xx.selected;
            BOOL isSelect = xx.selected;//已经取反过的值，表示即将变的值
            NSString *isselectstr = isSelect ? @"1" : @"0";
            [shopmodel setValue:isselectstr forKey:@"isSelect"];
            //将该店铺下的所有商品的Id加入或者移除不重复数组中，此时不用考虑重复加入的情况

            for (HYCartModel *model in shopArray) {
                NSString *isselectstr = isSelect ? @"1" : @"0";
                //对所有商品进行选中操作:
                    [model setValue:isselectstr forKey:@"isSelect"];
                isSelect ? [self.viewModel.editcartData addObject:model.sGoodId] :[self.viewModel.editcartData removeObject:model.sGoodId];
            }
            self.viewModel.deleteenabel = self.viewModel.editcartData.count == 0 ? @"0" :@"1";

            [self.viewModel.cartTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
            //判断是否是全选状态:
            NSMutableArray *tempselectarr = [NSMutableArray array];
            for (HYCartShopModel *shopModel in self.viewModel.cartData) {
                for (HYCartModel *cartModel in shopModel.goods) {
                    [tempselectarr addObject:[NSString stringWithFormat:@"%@",cartModel.isSelect]];
                }
            }
            //如果数组中有一个是@“0”,未选中，则说明没有全选
            self.viewModel.isSelectAll = ![tempselectarr containsObject:@"0"];
            }
   
    }];
 
headerView.selectStoreGoodsButton.selected = [shopmodel.isSelect integerValue];//isSelect 0未选中 1选中

    
    return headerView;
}
#pragma mark - footer view

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    //是否编辑状态:
    return  self.viewModel.isIdit ? CGFLOAT_MIN : [HYCartFooterView getCartFooterHeight];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
     HYCartShopModel *shopmodel =  self.viewModel.cartData[section];
    HYCartFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HYCartFooterView"];
    
    footerView.shopModel = shopmodel;
    
    //是否编辑状态:
    return  self.viewModel.isIdit ? nil :footerView;
    
}
#pragma mark - row
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [HYCartCell getCartCellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HYCartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HYCartCell"
                                                       forIndexPath:indexPath];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HYCartShopModel *shopmodel = self.viewModel.cartData[indexPath.section];
    
    HYCartModel *model = shopmodel.goods[indexPath.row];
    self.didSelectCellBlock(indexPath,model) ;
}

- (void)configureCell:(HYCartCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    HYCartShopModel *shopmodel =  self.viewModel.cartData[section];
    HYCartModel *model = shopmodel.goods[row];
    //cell 选中
    [[[cell.selectShopGoodsButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(UIButton *x) {
        x.selected = !x.selected;
        [self.viewModel rowSelect:x.selected IndexPath:indexPath];
    }];
    
    //数量改变
    cell.nummberCount.NumberChangeBlock = ^(NSInteger currentcount , NSInteger type , NSInteger changeNum){
        
        //currentcount 当前数量  type 0减 1增 changeNum 变化的数量(点击加减固定为1,输入文本有差值)
        //根据传来的值进行判断是增加还是减少
        //执行加入购物车或者减少购物车的动画,如果是增加,则起点为cell的加按钮,终点为结算按钮,否则则相反
#warning 注意此处为了拿到起点位置和终点位置，故循环引入了cartvc,暂时未出现问题，分析时会有问题，待解决
        if (type == 1) {
            //增加加入购物车轨迹
                            UIView *startview = cell.nummberCount.subButton;
                            UIView *endview = self.viewModel.cartVC.cartBar.payButton;
                            [HYTool startAnimationWithstartView:startview startviewifoncurrenview:NO isfromstartviewcenter:NO endView:endview endviewifoncurrenview:NO contentImg:[UIImage imageNamed:@"HYOneMore"] isopacity:NO istransform:YES AnimationTime:0.8 target:self.viewModel.cartVC];
            //增加相应数量
            self.viewModel.cartGoodsTotalCount =  self.viewModel.cartGoodsTotalCount + changeNum;
            
        }
        else
        {
            //增加加入购物车轨迹
                            UIView *startview = self.viewModel.cartVC.cartBar.payButton;
                            UIView *endview = cell.nummberCount.subButton;
                            [HYTool startAnimationWithstartView:startview startviewifoncurrenview:NO isfromstartviewcenter:YES endView:endview endviewifoncurrenview:NO contentImg:[UIImage imageNamed:@"HYOneMore"] isopacity:NO istransform:YES AnimationTime:0.8 target:self.viewModel.cartVC];
            //减少相应数量
            self.viewModel.cartGoodsTotalCount =  self.viewModel.cartGoodsTotalCount - changeNum;
        }
        
        [self.viewModel rowChangeQuantity:currentcount indexPath:indexPath];
        
        
        
        
    };
    cell.model = model;
}

#pragma mark - 删除事件
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.viewModel deleteGoodsBySingleSlide:indexPath];
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.viewModel.cartTableView endEditing:YES];
}
@end
