//
//  HYCartFooterView.m
//  HYOneMore
//
//  Created by 海洋 on 16/9/6.
//  Copyright © 2016年 海洋. All rights reserved.
//

#import "HYCartFooterView.h"
#import "HYCartModel.h"

@interface HYCartFooterView ()

@property (nonatomic, retain) UILabel *priceLabel;

@end

@implementation HYCartFooterView


- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        [self initCartFooterView];
    }
    return self;
}

- (void)initCartFooterView {
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.textAlignment = NSTextAlignmentRight;
    _priceLabel.text = @"该货源方的总价,例如: NBA官方旗舰店:小计 ¥888888";
    _priceLabel.font = HYFont(13);
    _priceLabel.textColor = [UIColor orangeColor];
    
    [self addSubview:_priceLabel];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    _priceLabel.frame = CGRectMake(10, 0.5, WIDTH - 20, 30);
}
//赋值
-(void)setShopModel:(HYCartShopModel *)shopModel
{
    _shopModel = shopModel;
    
    //增加响应信号
    NSArray *pricesArray = [[[_shopModel.goods rac_sequence] map:^id(HYCartModel *model) {
        //返回有效且选中的商品的数额
        
        return [model.isSelect integerValue] == 1 && [model .issx integerValue] == 0 ?  @([model.count integerValue] * [model.price floatValue]) : @(0);
        
    }] array];
    
    float shopPrice = 0;
    for (NSNumber *prices in pricesArray) {
        shopPrice += prices.floatValue;
    }
    //给每个店铺的总金额赋值:
    _shopModel.totalPrice = [NSString stringWithFormat:@"%.2f",shopPrice];
    
    _priceLabel.text = [NSString stringWithFormat:@"该货源方的总价,例如: NBA官方旗舰店:小计 ￥%.2f",shopPrice];
    
}

+ (CGFloat)getCartFooterHeight {
    return 30;
}

@end
