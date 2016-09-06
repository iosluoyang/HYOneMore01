//
//  HYCartCell.m
//  HYOneMore
//
//  Created by 海洋 on 16/9/5.
//  Copyright © 2016年 海洋. All rights reserved.
//

#import "HYCartCell.h"
#import "HYCartNumberCount.h"
#import "HYCartModel.h"
@interface HYCartCell()
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *GoodsPricesLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsKindLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsSizeLabel;

@end


@implementation HYCartCell

- (void)awakeFromNib {
    [super awakeFromNib];
     self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.goodsImageView.clipsToBounds = YES;
    // Initialization code
}
//赋值
-(void)setModel:(HYCartModel *)model
{
    self.goodsNameLabel.text             = model.p_name;
    self.GoodsPricesLabel.text           = [NSString stringWithFormat:@"￥%.2f", [model.p_price floatValue]];
    self.nummberCount.totalNum           = model.p_stock;
    self.nummberCount.currentCountNumber = model.p_quantity;
    self.selectShopGoodsButton.selected  = model.isSelect;
    self.goodsImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", model.p_imageUrl]];
    
}

+ (CGFloat)getCartCellHeight{
    
    return 100;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
