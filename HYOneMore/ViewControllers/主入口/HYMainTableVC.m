//
//  HYMainTableVC.m
//  HYOneMore
//
//  Created by 海洋 on 16/9/4.
//  Copyright © 2016年 海洋. All rights reserved.
//

#import "HYMainTableVC.h"
#import "HYCartVC.h"//购物车RAC+MVVM

@interface HYMainTableVC ()<RETableViewManagerDelegate>
@property (nonatomic,strong) UITableView* tableview;
@property (nonatomic,strong) RETableViewManager*tableviewmanager;
@end

@implementation HYMainTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"每天一点点";
    _tableview = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    [self.view addSubview:_tableview];
    self.tableviewmanager = [[RETableViewManager alloc]initWithTableView:self.tableview];
    self.tableviewmanager.delegate = self;
    RETableViewSection*section = [RETableViewSection sectionWithHeaderTitle:@"TableView相关练习"];
    [self.tableviewmanager addSection:section];
    
    RETableViewItem*item1 =  [RETableViewItem itemWithTitle:@"购物车RAC+MVVM相关(2016.09.04更)" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
        //点击cell方法:
        HYCartVC * vc = [[HYCartVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
   }];
    item1.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [section addItem:item1];
    
    
    
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
