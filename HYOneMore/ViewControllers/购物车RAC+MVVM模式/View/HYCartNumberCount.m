//
//  HYCartNumberCount.m
//  HYOneMore
//
//  Created by 海洋 on 16/9/6.
//  Copyright © 2016年 海洋. All rights reserved.
//

#import "HYCartNumberCount.h"

static CGFloat const Wd = 20;

@interface HYCartNumberCount()
//加
@property (nonatomic, strong) UIButton    *addButton;
//减
@property (nonatomic, strong) UIButton    *subButton;
//数字按钮
@property (nonatomic, strong) UITextField *numberTT;

@end

@implementation HYCartNumberCount

//初始化方法:
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)awakeFromNib {
    
    [self setUI];
}

#pragma mark - setUI
-(void)setUI
{
    self.backgroundColor = [UIColor clearColor];
    self.currentCountNumber = 0;
    self.totalNum = 0;
    /************************** 加 ****************************/
    _subButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _subButton.frame = CGRectMake(0, 0, Wd, Wd);
    [_subButton setBackgroundImage:[UIImage imageNamed:@"减（可操作）60"] forState:UIControlStateNormal];
    [_subButton setBackgroundImage:[UIImage imageNamed:@"减（不可操作）60"] forState:UIControlStateDisabled];
    _subButton.tag = 0;
    //给-按钮增加响应式信号,传递当前数量
    [[self.subButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self.currentCountNumber --;
        if (self.NumberChangeBlock) {
            self.NumberChangeBlock(self.currentCountNumber , 0 ,1);//currentcount 当前数量  type 0减 1增 changeNum 变化的数量(点击加减固定为1,输入文本有差值)
        }
    }];
    [self addSubview:_subButton];
    
    /************************** 内容 ****************************/
    self.numberTT = [[UITextField alloc]init];
    self.numberTT.frame = CGRectMake(CGRectGetMaxX(_subButton.frame), 0, Wd*1.5, _subButton.frame.size.height);
    self.numberTT.keyboardType=UIKeyboardTypeNumberPad;
    self.numberTT.text = [NSString stringWithFormat:@"%@",@(0)];
    self.numberTT.backgroundColor = [UIColor whiteColor];
    self.numberTT.textColor = [UIColor blackColor];
    self.numberTT.adjustsFontSizeToFitWidth = YES;
    self.numberTT.textAlignment = NSTextAlignmentCenter;
    self.numberTT.layer.borderColor = RGBA_COLOR(201, 201, 201, 1).CGColor;
    self.numberTT.layer.borderWidth = 1.3;
    self.numberTT.font = HYFont(12);
    //暂时关闭输入TF的可输入性
//    self.numberTT.enabled = NO;
    [self addSubview:self.numberTT];
    
    /************************** 加 ****************************/
    _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _addButton.frame = CGRectMake(CGRectGetMaxX(_numberTT.frame), 0, Wd,Wd);
    [_addButton setBackgroundImage:[UIImage imageNamed:@"加60"]
                          forState:UIControlStateNormal];
    [_addButton setBackgroundImage:[UIImage imageNamed:@"加（不可操作）60"]
                          forState:UIControlStateDisabled];
    _addButton.tag = 1;
    //给+按钮增加响应式信号,传递当前数量
    [[self.addButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self.currentCountNumber++;
        if (self.NumberChangeBlock) {
            self.NumberChangeBlock(self.currentCountNumber , 1, 1);//currentcount 当前数量  type 0减 1增 changeNum 变化的数量(点击加减固定为1,输入文本有差值)
        }
    }];
    
    [self addSubview:_addButton];
    
    /************************** 内容改变 ****************************/

    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:@"UITextFieldTextDidEndEditingNotification" object:self.numberTT] subscribeNext:^(id x) {
        UITextField *t1 = [x object];
        NSString *text = t1.text;
        NSInteger changedNum = 0;//更改之后的数量
        NSInteger changeType  = 0;//更改的类型, 0减  1增
        NSInteger changeNum = 0;//更改的数量
        //当有最高数量的限制并且输入数量大于最高数量
        if (text.integerValue > _totalNum && _totalNum != 0) {
            //记录差值:
            changeType = 1;//一定为增
            changeNum = _totalNum - self.currentCountNumber;
            self.currentCountNumber = self.totalNum;
            self.numberTT.text = [NSString stringWithFormat:@"%@", @(self.totalNum)];
            changedNum = self.totalNum;
        }
        //输入数量少于1的时候
        else if (text.integerValue < 1){
              //记录差值:
            changeType = 0;//一定为减
            changeNum = self.currentCountNumber - 1;
            
            self.numberTT.text = @"1";
            changedNum = 1;
        }
        //正常输入情况下
        else{
            //记录差值:
            changeType = self.currentCountNumber > text.integerValue ? 0:1;
            changeNum = labs(self.currentCountNumber - text.integerValue);//取绝对值
            self.currentCountNumber = text.integerValue;
            changedNum = self.currentCountNumber;
        }
        if (self.NumberChangeBlock) {
            self.NumberChangeBlock(changedNum,changeType,changeNum);
        }
    }];
    
    /* 捆绑加减的enable */
    RACSignal *subSignal = [RACObserve(self, currentCountNumber) map:^id(NSNumber *subValue) {
        return @(subValue.integerValue > 1);
    }];
    
    RACSignal *addSignal = [RACObserve(self, currentCountNumber) map:^id(NSNumber *addValue) {
        return @(1);
    }];
    RAC(self.subButton, enabled)  = subSignal;
    RAC(self.addButton, enabled)  = addSignal;
    /* 内容颜色显示 */
    RACSignal *numColorSignal = [RACObserve(self, totalNum) map:^id(NSNumber *totalValue) {
        return totalValue.integerValue ==0 ? [UIColor redColor] : [UIColor blackColor];
    }];
    RAC(self.numberTT, textColor) = numColorSignal;
    /*  */
    RACSignal *textSigal = [RACObserve(self, currentCountNumber) map:^id(NSNumber *Value) {
        return [NSString stringWithFormat:@"%@", Value];
    }];
    RAC(self.numberTT, text) = textSigal;

    

    
}
@end
