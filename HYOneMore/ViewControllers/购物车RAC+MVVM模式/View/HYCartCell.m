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
@property (weak, nonatomic) IBOutlet UILabel *timeoutstrlabel;//失效提示文字
@property (weak, nonatomic) IBOutlet UILabel *timeoutcountlabel;//失效数量
@property (weak, nonatomic) IBOutlet UIButton *timeoutbtn;//失效按钮
@property (weak, nonatomic) IBOutlet UILabel *timeoutimglabel;//失效的图片蒙版



@end


@implementation HYCartCell

- (void)awakeFromNib {
    [super awakeFromNib];
     self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.goodsImageView.clipsToBounds = YES;
    //给selectnumberview增加手势交互，以确保当数量为1的时候不会进入详情页
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectnumberviewtapaction:)];
    [self.nummberCount addGestureRecognizer:tap];
    self.nummberCount.userInteractionEnabled = YES;
    
    //设置UI效果:
    self.GoodsPricesLabel.textColor = [UIColor colorWithHexString:@"#f7453c"];
    // Initialization code
}
//赋值
-(void)setModel:(HYCartModel *)model
{
    
    self.goodsNameLabel.text             = model.title;
    self.goodsKindLabel.text             = [NSString stringWithFormat:@"规格:%@",model.color];
    self.GoodsPricesLabel.text           = [NSString stringWithFormat:@"￥%.2f", [model.price floatValue]];
    self.nummberCount.totalNum           = [model.p_stock integerValue];
    self.nummberCount.currentCountNumber = [model.count integerValue];
    self.selectShopGoodsButton.selected  = [model.isSelect integerValue];
    self.goodsImageView.image = [UIImage imageNamed:@"smile"];
    self.timeoutcountlabel.text = [NSString stringWithFormat:@"×%@",model.count];
    //判断如果商品失效,则显示失效按钮、灰色蒙版、失效提示文字、失效数量 隐藏有效按钮、种类，尺寸、价格、数量选择器
    
    if ([model.issx integerValue ] == 1) {
        self.timeoutbtn.hidden = NO;
        self.timeoutimglabel.hidden = NO;
        self.timeoutstrlabel.hidden = NO;
        self.timeoutcountlabel.hidden = NO;
        
        self.selectShopGoodsButton.hidden = YES;
        self.goodsKindLabel.hidden = YES;
        self.GoodsPricesLabel.hidden = YES;
        self.nummberCount.hidden = YES;
        
    }
    else{
    //未失效,相反
        self.timeoutbtn.hidden = YES;
        self.timeoutimglabel.hidden = YES;
        self.timeoutstrlabel.hidden = YES;
        self.timeoutcountlabel.hidden = YES;
        
        self.selectShopGoodsButton.hidden = NO;
        self.goodsKindLabel.hidden = NO;
        self.GoodsPricesLabel.hidden = NO;
        self.nummberCount.hidden = NO;
  
    }
    
    //如果是编辑状态下，则失效商品的失效按钮隐藏，有效按钮显示
    if ([model.isEditing integerValue] == 1) {
        //处于编辑状态下的展示样式
        self.selectShopGoodsButton.hidden = NO;
        self.timeoutbtn.hidden = YES;
    }
    
}

+ (CGFloat)getCartCellHeight{
    
    return 100;
}
-(void)selectnumberviewtapaction:(UITapGestureRecognizer *)tap
{
#ifdef DEBUG
    NSLog(@"无意义的点击");
#endif
 
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
