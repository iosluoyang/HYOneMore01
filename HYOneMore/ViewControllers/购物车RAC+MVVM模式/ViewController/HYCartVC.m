//
//  HYCartVC.m
//  HYOneMore
//
//  Created by 海洋 on 16/9/6.
//  Copyright © 2016年 海洋. All rights reserved.


#import "HYCartVC.h"
#import "HYCartUIService.h"
#import "HYCartViewModel.h"
#import "HYCartBar.h"
@interface HYCartVC ()
{
    BOOL _isIdit;
    UIBarButtonItem *_editItem;
    UIBarButtonItem *_makeDataItem;
}
@property (nonatomic, strong) HYCartUIService *service;

@property (nonatomic, strong) HYCartViewModel *viewModel;

@property (nonatomic, strong) UITableView     *cartTableView;

@property (nonatomic, strong) HYCartBar       *cartBar;
@end

@implementation HYCartVC
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self getNewData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
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
        NSLog(@"点击了结算按钮");
    }];
    /* 观察价格属性 */
    
    [RACObserve(self.viewModel, allPrices) subscribeNext:^(NSNumber *x) {
        self.cartBar.money = x.floatValue;
    }];
    
    /* 全选 状态 */
    RAC(self.cartBar.selectAllButton, selected) = RACObserve(self.viewModel, isSelectAll);
    
    /* 购物车数量 */
    [RACObserve(self.viewModel, cartGoodsCount) subscribeNext:^(NSNumber *x) {
        if(x.integerValue == 0){
            self.title = [NSString stringWithFormat:@"购物车"];
        } else {
            self.title = [NSString stringWithFormat:@"购物车(已选%@件)",x];
        }
    }];
    // Do any additional setup after loading the view.
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
        _cartTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 30)];
    }
    return _cartTableView;
}

- (HYCartBar *)cartBar {
    
    if (!_cartBar) {
        _cartBar = [[HYCartBar alloc] initWithFrame:CGRectMake(0, HEIGHT-30, WIDTH, 30)];
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
//    self.cartTableView.editing = !_isIdit;
}

- (void)makeNewData:(UIBarButtonItem *)item{
    
    [self getNewData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
