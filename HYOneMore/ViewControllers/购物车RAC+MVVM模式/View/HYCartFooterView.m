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
-(void)setShopGoodsArray:(NSMutableArray *)shopGoodsArray
{
    _shopGoodsArray = shopGoodsArray;
    
    //增加响应信号
    NSArray *pricesArray = [[[_shopGoodsArray rac_sequence] map:^id(HYCartModel *model) {
        
        return @(model.p_quantity * [model.p_price floatValue]);
        
    }] array];
    
    float shopPrice = 0;
    for (NSNumber *prices in pricesArray) {
        shopPrice += prices.floatValue;
    }
    _priceLabel.text = [NSString stringWithFormat:@"该货源方的总价,例如: NBA官方旗舰店:小计 ￥%.2f",shopPrice];
    
}

+ (CGFloat)getCartFooterHeight {
    return 30;
}

@end
