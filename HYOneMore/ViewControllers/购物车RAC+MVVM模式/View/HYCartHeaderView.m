//
//  HYCartHeaderView.m
//  HYOneMore
//
//  Created by 海洋 on 16/9/6.
//  Copyright © 2016年 海洋. All rights reserved.
//


#import "HYCartHeaderView.h"

@interface HYCartHeaderView()

@property (nonatomic, strong) UIButton *storeNameButton;

@end

@implementation HYCartHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        [self setHeaderUI];
    }
    return self;
}

- (void)setHeaderUI{
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.selectStoreGoodsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectStoreGoodsButton.frame = CGRectZero;
    [self.selectStoreGoodsButton setImage:[UIImage imageNamed:@"radio_normal"]
                                 forState:UIControlStateNormal];
    [self.selectStoreGoodsButton setImage:[UIImage imageNamed:@"radio_selected"]
                                 forState:UIControlStateSelected];
    self.selectStoreGoodsButton.backgroundColor=[UIColor clearColor];
    //    [self.selectStoreGoodsButton addTarget:self action:@selector(selectShopGoods:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.selectStoreGoodsButton];
    
    self.storeNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.storeNameButton.frame = CGRectZero;
    [self.storeNameButton setTitle:@"货源方名称"
                          forState:UIControlStateNormal];
    [self.storeNameButton setTitleColor:[UIColor blackColor]
                               forState:UIControlStateNormal];
    //此处隐藏跳转至指定货源方的方法，拓展时可增加
    self.storeNameButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.storeNameButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.storeNameButton.titleLabel.font = HYFont(13);
    [self addSubview:self.storeNameButton];
    
}
- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.selectStoreGoodsButton.frame = CGRectMake(0, 0, 36, 30);
    
    self.storeNameButton.frame = CGRectMake(40, 0, WIDTH - 40, 30);
    
}

+ (CGFloat)getCartHeaderHeight{
    
    return 30;
}

@end
