//
//  HYGoodsDetailVC.h
//  HYOneMore
//
//  Created by superman_in_supercommunity on 16/9/7.
//  Copyright © 2016年 海洋. All rights reserved.
//


@interface HYGoodsDetailVC : HYBaseViewController
-(id)initWithOnlyDetail:(BOOL)OnlyDetail sumPrice:(NSString *)sumPrice DataArr:(NSMutableArray *)DataArr;
@property (nonatomic,copy) NSString *price;
@end
