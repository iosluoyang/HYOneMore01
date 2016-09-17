//
//  HYCartVC.m
//  HYOneMore
//
//  Created by 海洋 on 16/9/6.
//  Copyright © 2016年 海洋. All rights reserved.
#define CartBarHeight 50//底部的高度

#import "HYCartVC.h"
#import "HYCartUIService.h"
#import "HYCartViewModel.h"
#import "HYCartShopModel.h"
#import "HYGoodsDetailVC.h"
@interface HYCartVC ()
{
    BOOL _isIdit;
    UIBarButtonItem *_editItem;
    UIBarButtonItem *_makeDataItem;
}
@property (nonatomic, strong) HYCartUIService *service;

@property (nonatomic, strong) HYCartViewModel *viewModel;

@property (nonatomic, strong) UITableView     *cartTableView;


@end

@implementation HYCartVC
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getNewData];
    /*setting up*/
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.title = @"购物车";
    /*eidit button*/
    _isIdit = NO;//默认状态为非编辑状态

    _editItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑"
                                                 style:UIBarButtonItemStyleDone
                                                target:self
                                                action:@selector(editClick:)];
    _editItem.tintColor = [UIColor colorWithHexString:@"#e0433a"];
    self.navigationItem.rightBarButtonItem = _editItem;
    /*add view*/
    [self.view addSubview:self.cartTableView];
    [self.view addSubview:self.cartBar];
    
    
    
    /* RAC  */
    //全选
    [[self.cartBar.selectAllButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
        x.selected = !x.selected;
        
        [self.viewModel selectAll:x.selected ifconnect:!_isIdit];
    }];
    //删除
    [[self.cartBar.deleteButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
        [self.viewModel deleteGoodsBySelect];
    }];
    //结算
    [[self.cartBar.payButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
        NSLog(@"%@",self.viewModel);
        NSLog(@"点击了支付按钮");
        //构建结算数据结构：
        NSString *sumprice = [NSString stringWithFormat:@"%.2f",self.cartBar.money];
        NSMutableArray *shoparray = [NSMutableArray array];
        
        for (HYCartShopModel *shopmodel in self.viewModel.cartData) {
            CGFloat totalprice = 0;
            NSMutableArray *goodsarray = [NSMutableArray array];
            for (HYCartModel *model in shopmodel.goods) {
                //只增加选中的有效的商品
                if ([model.issx integerValue] == 0 && [model.isSelect integerValue] ==1) {
                    [goodsarray addObject:model];
                    totalprice += [model.count integerValue] * [model.price floatValue];
                }
                
            }
            
            if (goodsarray.count != 0) {
                NSDictionary *tempdic = @{@"totalPrice":[NSString stringWithFormat:@"%.2f",totalprice],@"goods":goodsarray};
                [shoparray addObject:tempdic];
            }
           
        }
        
        HYGoodsDetailVC *goodsdetailvc = [[HYGoodsDetailVC alloc]initWithOnlyDetail:NO sumPrice:sumprice DataArr:shoparray];
        [self.navigationController pushViewController:goodsdetailvc animated:YES];
  
    }];
   
    /* 观察价格属性 */
    
    [RACObserve(self.viewModel, allPrices) subscribeNext:^(NSNumber *x) {
        self.cartBar.money = x.floatValue;
    }];
   

    /* 全选 状态 */
    RAC(self.cartBar.selectAllButton, selected) = RACObserve(self.viewModel, isSelectAll);
 
    
    /* 监控删除按钮的可点击性 */
    RACWEAK;
    [RACObserve(self.viewModel, deleteenabel) subscribeNext:^(NSString *candelete) {
        RACSTRONG;
        self.cartBar.deleteButton.enabled = candelete && [candelete integerValue] == 1 ? YES :NO;
    }];

    
    
    /* 购物车商品种类数量 */
    [RACObserve(self.viewModel, cartGoodsKindsCount) subscribeNext:^(NSNumber *x) {
        if(x.integerValue == 0){
            [self.cartBar.payButton setTitle:@"去结算" forState:UIControlStateNormal];
        } else {
            [self.cartBar.payButton setTitle:[NSString stringWithFormat:@"去结算(%@类)",x] forState:UIControlStateNormal];
        }
    }];


    
    
   
}
#pragma mark - 懒加载

- (HYCartViewModel *)viewModel {
    
    if (!_viewModel) {
        _viewModel = [[HYCartViewModel alloc] init];
        _viewModel.cartVC = self;
        _viewModel.cartTableView  = self.cartTableView;
    }
    return _viewModel;
}


- (HYCartUIService *)service {
    
    if (!_service) {
        _service = [[HYCartUIService alloc] init];
        _service.viewModel = self.viewModel;
    }
    return _service;
}


- (UITableView *)cartTableView {
    
    if (!_cartTableView) {
        
        _cartTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, self.view.frame.size.height - CartBarHeight)
                                                      style:UITableViewStyleGrouped];
        [_cartTableView registerNib:[UINib nibWithNibName:@"HYCartCell" bundle:nil]
             forCellReuseIdentifier:@"HYCartCell"];
        [_cartTableView registerClass:NSClassFromString(@"HYCartFooterView") forHeaderFooterViewReuseIdentifier:@"HYCartFooterView"];
        [_cartTableView registerClass:NSClassFromString(@"HYCartHeaderView") forHeaderFooterViewReuseIdentifier:@"HYCartHeaderView"];
        _cartTableView.dataSource = self.service;
        _cartTableView.delegate   = self.service;
        _cartTableView.backgroundColor = RGBA_COLOR(240, 240, 240, 1);
        //设置点击回调事件:
        DidSelectCellBlock selectedBlock = ^(NSIndexPath *indexPath, HYCartModel *model) {
#ifdef  DEBUG
            NSLog(@"点击了第%@行,点击的商品价格为:%@",@(indexPath.row),model.price) ;
#endif
            //只有为完成界面下的有效商品才可以点击跳转,其余不需要跳转
            if (!self.viewModel.isIdit && [model.issx integerValue] == 0) {
                HYGoodsDetailVC *vc = [[HYGoodsDetailVC alloc]init];
                vc.price = model.price;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        } ;
        self.service.didSelectCellBlock = selectedBlock;
    }
    return _cartTableView;
}

- (HYCartBar *)cartBar {
    
    if (!_cartBar) {
        _cartBar = [[HYCartBar alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.cartTableView.frame), WIDTH, CartBarHeight)];
        _cartBar.isNormalState = YES;
    }
    return _cartBar;
}
#pragma mark - 操作方法

- (void)getNewData {
    /**
     *  获取数据,刷新tableview
     */
    [self.viewModel getData];
}

- (void)editClick:(UIBarButtonItem *)item {
    _isIdit = !_isIdit;
    if (_isIdit) {
        //编辑状态下全不选为不和后台接口有交互
        NSString *itemTitle = _isIdit == YES ? @"完成" : @"编辑";
        _editItem.title = itemTitle;
        self.cartBar.isNormalState = !_isIdit;
        self.viewModel.isIdit = _isIdit;

        [self.viewModel selectAll:NO ifconnect:NO];
    }
    else
    {
        //从编辑界面到完成界面，先看是否有修改的商品，如果有就进行更新数量的接口操作，然后获取新数据，没有则直接获取新数据
        NSMutableArray *fixarray = [NSMutableArray array];
        for (HYCartShopModel *shopmodel in self.viewModel.cartData ) {
            for (HYCartModel *model in shopmodel.goods) {
                //将修改过的数据加入到数组中
                if ([model.isfixed integerValue] == 1) {
                    NSDictionary *dic = @{@"id":model.sGoodId,@"count":model.count};
                    [fixarray addObject:dic];
                }
            }
        }
        if (fixarray.count == 0) {
            NSString *itemTitle = _isIdit == YES ? @"完成" : @"编辑";
            _editItem.title = itemTitle;
            self.cartBar.isNormalState = !_isIdit;
            self.viewModel.isIdit = _isIdit;
             [self.viewModel getData];
        }
        else{
        //有修改过的数据:
            
            NSString *itemTitle = _isIdit == YES ? @"完成" : @"编辑";
            _editItem.title = itemTitle;
            self.cartBar.isNormalState = !_isIdit;
            self.viewModel.isIdit = _isIdit;
            [self getNewData];
            
        }
       
    }
    
}

- (void)makeNewData:(UIBarButtonItem *)item{
    
    [self getNewData];
}
#pragma  mark - 加入购物车动画
#pragma  CAAnimationDelegate 动画结束之后的方法:
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ([[anim valueForKey:@"animationName"]isEqualToString:@"groupsAnimation"]) {
        
        CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        shakeAnimation.duration = 0.25f;
        shakeAnimation.fromValue = [NSNumber numberWithFloat:0.8];
        shakeAnimation.toValue = [NSNumber numberWithFloat:1.2];
        shakeAnimation.autoreverses = YES;
        
        [self.cartBar.payButton.layer addAnimation:shakeAnimation forKey:nil];
    }
}
// 移除弹出物
- (void)removeFromLayer:(CALayer *)layerAnimation{
    [layerAnimation removeFromSuperlayer];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
