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
#import "HYCartModel.h"
#import "HYCartNumberCount.h"

@implementation HYCartUIService
#pragma mark - UITableView Delegate/DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.cartData.count;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.viewModel.cartData[section] count];
}

#pragma mark - header view

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return [HYCartHeaderView getCartHeaderHeight];
//    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSMutableArray *shopArray = self.viewModel.cartData[section];
    
    HYCartHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HYCartHeaderView"];
    //店铺全选
    [[[headerView.selectStoreGoodsButton rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:headerView.rac_prepareForReuseSignal] subscribeNext:^(UIButton *xx) {
        xx.selected = !xx.selected;
        BOOL isSelect = xx.selected;//已经取反过的值，表示即将变的值
        [self.viewModel.shopSelectArray replaceObjectAtIndex:section withObject:@(isSelect)];
        //重新计算商铺数量，商品总数，商品种类
        if (isSelect) {
            //选中,增加
            self.viewModel.cartGoodsCount ++;//商铺数量
            //商品种类是增加该商铺之前未选中的商品种类 商品总数量是增加该商铺之前未选中的商品总数量
            NSInteger tempkindsnum = self.viewModel.cartGoodsKindsCount;
            NSInteger temptotalnum = self.viewModel.cartGoodsTotalCount;
            
            for (HYCartModel *model in shopArray) {
                tempkindsnum +=  model.isSelect ? 0:1;
                temptotalnum += model.isSelect ? 0:model.p_quantity;
            }
            self.viewModel.cartGoodsKindsCount = tempkindsnum;//商品种类数量
            self.viewModel.cartGoodsTotalCount = temptotalnum;//商品总数量
            
        }
        else
        {
        //取消选中，减少
            self.viewModel.cartGoodsCount --;//商铺数量
            //商品种类是减去该商铺之前选中的商品种类 商品总数量是减去该商铺之前选中的商品总数量
            NSInteger tempkindsnum = self.viewModel.cartGoodsKindsCount;
            NSInteger temptotalnum = self.viewModel.cartGoodsTotalCount;
            
            for (HYCartModel *model in shopArray) {
                tempkindsnum -=  model.isSelect ? 1:0;
                temptotalnum -= model.isSelect ? model.p_quantity:0;
            }
            self.viewModel.cartGoodsKindsCount = tempkindsnum;//商品种类数量
            self.viewModel.cartGoodsTotalCount = temptotalnum;//商品总数量
            
        }
        
        
        for (HYCartModel *model in shopArray) {
            [model setValue:@(isSelect) forKey:@"isSelect"];
        }
        [self.viewModel.cartTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
        
        self.viewModel.allPrices = [self.viewModel getAllPrices];
    }];
    //店铺选中状态
    headerView.selectStoreGoodsButton.selected = [self.viewModel.shopSelectArray[section] boolValue];
    
    //    [RACObserve(headerView.selectStoreGoodsButton, selected) subscribeNext:^(NSNumber *x) {
    //
    //        BOOL isSelect = x.boolValue;
    //
    //        [self.viewModel.shopSelectArray replaceObjectAtIndex:section withObject:@(isSelect)];
    //        for (JSCartModel *model in shopArray) {
    //            [model setValue:@(isSelect) forKey:@"isSelect"];
    //        }
    //        [self.viewModel.cartTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    //    }];
    
    return headerView;
//    return nil;
}
#pragma mark - footer view

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [HYCartFooterView getCartFooterHeight];
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    NSMutableArray *shopArray = self.viewModel.cartData[section];
    
    HYCartFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HYCartFooterView"];
    
    footerView.shopGoodsArray = shopArray;
    
    return footerView;
//    return nil;
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
    HYCartModel *model = self.viewModel.cartData[indexPath.section][indexPath.row];
    self.didSelectCellBlock(indexPath,model.p_price) ;
}

- (void)configureCell:(HYCartCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    HYCartModel *model = self.viewModel.cartData[section][row];
    //cell 选中
    [[[cell.selectShopGoodsButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(UIButton *x) {
        x.selected = !x.selected;
        [self.viewModel rowSelect:x.selected IndexPath:indexPath];
    }];
    //数量改变
    cell.nummberCount.NumberChangeBlock = ^(NSInteger currentcount , NSInteger type , NSInteger changeNum){
        //currentcount 当前数量  type 0减 1增 changeNum 变化的数量(点击加减固定为1,输入文本有差值)
        //根据传来的值进行判断是增加还是减少
       self.viewModel.cartGoodsTotalCount =  type == 0 ? (self.viewModel.cartGoodsTotalCount - changeNum) :(self.viewModel.cartGoodsTotalCount + changeNum);
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
