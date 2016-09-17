//
//  HYCartBar.m
//  HYOneMore
//
//  Created by 海洋 on 16/9/5.
//  Copyright © 2016年 海洋. All rights reserved.
//
static NSInteger const PayButtonTag = 120;

static NSInteger const DeleteButtonTag = 121;

static NSInteger const SelectButtonTag = 122;
#define AllSelectBtnWidth 78 //全选按钮的宽度
#import "HYCartBar.h"

@interface UIImage (HY)

+ (UIImage *)imageWithColor:(UIColor *)color ;

@end

@implementation UIImage (HY)

+ (UIImage *)imageWithColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


@end

@implementation HYCartBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBarUI];
    }
    return self;
}

-(void)setBarUI{

    self.backgroundColor = [UIColor clearColor];
    /* 背景 */
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    effectView.userInteractionEnabled = NO;
    effectView.frame = self.bounds;
    [self addSubview:effectView];
    
    CGFloat wd = WIDTH * 3/7;//结算按钮宽度占比
    
    UIView*lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 0.5)];
    lineView.backgroundColor = LCRGBACOLOR(220, 220, 223, 1.0);
    [self addSubview:lineView];
    
    /* 结算 */
    UIButton *paybutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [paybutton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#ff3b30"]] forState:UIControlStateNormal];
    [paybutton setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
    [paybutton setTitle:@"去支付" forState:UIControlStateNormal];
    [paybutton setFrame:CGRectMake(WIDTH - wd, 0, wd, self.frame.size.height)];
    [paybutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [paybutton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    paybutton.enabled = NO;
    paybutton.tag = PayButtonTag;
    [self addSubview:paybutton];
    _payButton  =paybutton;
    
    /* 删除 */
    UIButton *deletebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deletebtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [deletebtn setBackgroundImage: [UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
    [deletebtn setTitle:@"删除" forState:UIControlStateNormal];
    [deletebtn setTitleColor:[UIColor colorWithHexString:@"#ff3b30"] forState:UIControlStateNormal];
    [deletebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [deletebtn setFrame:CGRectMake(WIDTH - wd, 0, wd, self.frame.size.height)];
    deletebtn.enabled = NO;
    deletebtn.hidden = YES;
    deletebtn.tag = DeleteButtonTag;
    [self addSubview:deletebtn];
    _deleteButton = deletebtn;
    
    /* 全选 */
    UIButton *allselectbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [allselectbtn setTitle:@"全选" forState:UIControlStateNormal];
    [allselectbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [allselectbtn setImage:[UIImage imageNamed:@"radio_normal"] forState:UIControlStateNormal];
    [allselectbtn setImage:[UIImage imageNamed:@"radio_selected"] forState:UIControlStateSelected];
    [allselectbtn setFrame:CGRectMake(0, 0, AllSelectBtnWidth, self.frame.size.height)];
    [allselectbtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    allselectbtn.tag = SelectButtonTag;
    [self addSubview:allselectbtn];
    _selectAllButton  =allselectbtn;
    
    /* 价格 */
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(allselectbtn.frame), 0, WIDTH - allselectbtn.frame.size.width - paybutton.frame.size.width - 5, self.frame.size.height)];
    label.text = [NSString stringWithFormat:@"去结算:¥%@",@(00.00)];
    label.textColor = [UIColor blackColor];
    label.font = HYFont(15);
    label.textAlignment = NSTextAlignmentRight;
    [self addSubview:label];
    _allMoneyLabel = label;
    
    /* assign value */
    RACWEAK
    //对合计金额进行响应式监控
    [RACObserve(self, money) subscribeNext:^(NSNumber *x) {
        RACSTRONG
        self.allMoneyLabel.text  = [NSString stringWithFormat:@"合计:¥%.2f",x.floatValue];
    }];
    
    /* RAC BLIND */
    RACSignal *comBineSign = [RACSignal combineLatest:@[RACObserve(self, money)] reduce:^id(NSNumber *money){
        if (money.floatValue == 0) {
            //当总额数量变为0的时候，全选按钮变为非点击状态
            self.selectAllButton.selected = NO;
        }
        return @(money.floatValue > 0);
    }];
    
    RAC(self.payButton,enabled) = comBineSign;
    
    //对各控件的显示隐藏方式进行响应式监控
    [RACObserve(self, isNormalState) subscribeNext:^(NSNumber *x) {
        BOOL isNormal = x.boolValue;
        self.payButton.hidden = !isNormal;
        self.allMoneyLabel.hidden = !isNormal;
        self.deleteButton.hidden = isNormal;
    }];
    
    
    
    
    
    
    
}

@end
