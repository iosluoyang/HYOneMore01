//
//  HYGoodsDetailVC.m
//  HYOneMore
//
//  Created by superman_in_supercommunity on 16/9/7.
//  Copyright © 2016年 海洋. All rights reserved.
//

#import "HYGoodsDetailVC.h"

@interface HYGoodsDetailVC ()

@end

@implementation HYGoodsDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品详情";
    UILabel*pricelabel = [[UILabel alloc]initWithFrame:self.view.frame];
    pricelabel.backgroundColor = self.view.backgroundColor;
    pricelabel.textColor = [UIColor blackColor];
    pricelabel.font = [UIFont systemFontOfSize:18];
    pricelabel.textAlignment = NSTextAlignmentCenter;
    pricelabel.numberOfLines = 0;
    pricelabel.text = [NSString stringWithFormat:@"该商品的价格为:%@",_price];
    [self.view addSubview:pricelabel];
    
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
