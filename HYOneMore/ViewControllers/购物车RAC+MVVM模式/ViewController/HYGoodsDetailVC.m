//
//  HYGoodsDetailVC.m
//  HYOneMore
//
//  Created by superman_in_supercommunity on 16/9/7.
//  Copyright © 2016年 海洋. All rights reserved.
//

#import "HYGoodsDetailVC.h"

@interface HYGoodsDetailVC ()
/**
 *  是否只展示价格详情
 */
@property (nonatomic, assign) BOOL            OnlyDetail;
/**
 *  下单时候的合计价格
 */
@property (nonatomic, strong) NSString *      sumPrice;
/**
 *  下单时的商品数据 每一个字典中包含 totalPrice 总价 和 goods 商品清单数组（商品数据模型）
 */
@property (nonatomic, strong) NSMutableArray *DataArr;
@end

@implementation HYGoodsDetailVC

-(id)initWithOnlyDetail:(BOOL)OnlyDetail sumPrice:(NSString *)sumPrice DataArr:(NSMutableArray *)DataArr
{
    if (self = [super init]) {
        //赋值
        self.OnlyDetail = OnlyDetail;
        self.sumPrice = sumPrice;
        self.DataArr = DataArr;
    }
     return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"详情";
    UILabel*pricelabel = [[UILabel alloc]initWithFrame:self.view.frame];
    pricelabel.backgroundColor = self.view.backgroundColor;
    pricelabel.textColor = [UIColor blackColor];
    pricelabel.font = [UIFont systemFontOfSize:18];
    pricelabel.textAlignment = NSTextAlignmentCenter;
    pricelabel.numberOfLines = 0;
    
    if (self.OnlyDetail) {
        //仅展示商品详情
         pricelabel.text = [NSString stringWithFormat:@"该商品的价格为:%@",_price];
    }
   else
   {
   //展示下单页的商品清单详情:
       
   }
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
