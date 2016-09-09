//
//  HYCartVC.m
//  HYOneMore
//
//  Created by 海洋 on 16/9/6.
//  Copyright © 2016年 海洋. All rights reserved.


#import "HYCartVC.h"
#import "HYCartUIService.h"
#import "HYCartViewModel.h"

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
    _isIdit = NO;
    /*   _makeDataItem = [[UIBarButtonItem alloc] initWithTitle:@"新数据"
     style:UIBarButtonItemStyleDone
     target:self
     action:@selector(makeNewData:)];
     
     _makeDataItem.tintColor = [UIColor redColor];
     self.navigationItem.leftBarButtonItem = _makeDataItem;
     */
    
    _editItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑"
                                                 style:UIBarButtonItemStyleDone
                                                target:self
                                                action:@selector(editClick:)];
    _editItem.tintColor =  RGBA_COLOR(170, 170, 170, 1);
    self.navigationItem.rightBarButtonItem = _editItem;
    /*add view*/
    [self.view addSubview:self.cartTableView];
    [self.view addSubview:self.cartBar];
    
    /* 默认选择全部商品 */
    [self.viewModel selectAll:YES];
    
    /* RAC  */
    //全选
    [[self.cartBar.selectAllButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
        x.selected = !x.selected;
        [self.viewModel selectAll:x.selected];
    }];
    //删除
    [[self.cartBar.deleteButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
        [self.viewModel deleteGoodsBySelect];
    }];
    //结算
    [[self.cartBar.payButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
        NSLog(@"点击了支付按钮");
        
    }];
   
    /* 观察价格属性 */
    
    [RACObserve(self.viewModel, allPrices) subscribeNext:^(NSNumber *x) {
        self.cartBar.money = x.floatValue;
    }];
   

    /* 全选 状态 */
    RAC(self.cartBar.selectAllButton, selected) = RACObserve(self.viewModel, isSelectAll);
    
    
    UIAlertController *alertviewcontroller = [UIAlertController alertControllerWithTitle:@"小海哥温馨提示,请您选择模式哦~~" message:@"请选择合适的展示方式" preferredStyle:UIAlertControllerStyleAlert];
   
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"展示简洁的商铺数量" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //展示商铺数量:
        /* 购物车商铺数量 */
        [RACObserve(self.viewModel, cartGoodsCount) subscribeNext:^(NSNumber *x) {
            if(x.integerValue == 0){
                [self.cartBar.payButton setTitle:@"去结算" forState:UIControlStateNormal];
            } else {
                [self.cartBar.payButton setTitle:[NSString stringWithFormat:@"去结算(%@家)",x] forState:UIControlStateNormal];
            }
        }];
        
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"展示恰当的商品种类" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //展示商品种类:
        /* 购物车商品种类数量 */
        [RACObserve(self.viewModel, cartGoodsKindsCount) subscribeNext:^(NSNumber *x) {
            if(x.integerValue == 0){
                [self.cartBar.payButton setTitle:@"去结算" forState:UIControlStateNormal];
            } else {
                [self.cartBar.payButton setTitle:[NSString stringWithFormat:@"去结算(%@类)",x] forState:UIControlStateNormal];
            }
        }];
        
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"展示多多的商品数量" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //展示商品总数量:
        /* 观察购物车商品总数数量 */
        [RACObserve(self.viewModel, cartGoodsTotalCount) subscribeNext:^(NSNumber *x) {
            if(x.integerValue == 0){
                [self.cartBar.payButton setTitle:@"去结算" forState:UIControlStateNormal];
            } else {
                [self.cartBar.payButton setTitle:[NSString stringWithFormat:@"去结算(%@个)",x] forState:UIControlStateNormal];
            }
        }];
        
    }];

    [alertviewcontroller addAction:action1];
    [alertviewcontroller addAction:action2];
    [alertviewcontroller addAction:action3];
    [self presentViewController:alertviewcontroller animated:YES completion:nil];

    
    //设置一些初始值,默认全部选中:
    [self.viewModel selectAll:YES];
   
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
        
        _cartTableView = [[UITableView alloc] initWithFrame:self.view.frame
                                                      style:UITableViewStyleGrouped];
        [_cartTableView registerNib:[UINib nibWithNibName:@"HYCartCell" bundle:nil]
             forCellReuseIdentifier:@"HYCartCell"];
        [_cartTableView registerClass:NSClassFromString(@"HYCartFooterView") forHeaderFooterViewReuseIdentifier:@"HYCartFooterView"];
        [_cartTableView registerClass:NSClassFromString(@"HYCartHeaderView") forHeaderFooterViewReuseIdentifier:@"HYCartHeaderView"];
        _cartTableView.dataSource = self.service;
        _cartTableView.delegate   = self.service;
        _cartTableView.backgroundColor = RGBA_COLOR(240, 240, 240, 1);
        _cartTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 50)];
        //设置点击回调事件:
        DidSelectCellBlock selectedBlock = ^(NSIndexPath *indexPath, id item) {
            NSLog(@"点击了第%@行,点击的商品价格为:%@",@(indexPath.row),item) ;
            HYGoodsDetailVC *vc = [[HYGoodsDetailVC alloc]init];
            vc.price = item;
            [self.navigationController pushViewController:vc animated:YES];
            
        } ;
        self.service.didSelectCellBlock = selectedBlock;
    }
    return _cartTableView;
}

- (HYCartBar *)cartBar {
    
    if (!_cartBar) {
        _cartBar = [[HYCartBar alloc] initWithFrame:CGRectMake(0, HEIGHT-50, WIDTH, 50)];
        _cartBar.isNormalState = YES;
    }
    return _cartBar;
}
#pragma mark - 操作方法

- (void)getNewData {
    /**
     *  获取数据
     */
    [self.viewModel getData];
    [self.cartTableView reloadData];
}

- (void)editClick:(UIBarButtonItem *)item {
    _isIdit = !_isIdit;
    NSString *itemTitle = _isIdit == YES ? @"完成" : @"编辑";
    _editItem.title = itemTitle;
    self.cartBar.isNormalState = !_isIdit;
//    self.cartTableView.editing = _isIdit;
    
    
    [self.viewModel selectAll:!_isIdit];
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
