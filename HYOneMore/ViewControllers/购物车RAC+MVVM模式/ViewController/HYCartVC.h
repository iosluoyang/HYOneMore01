//
//  HYCartVC.h
//  HYOneMore
//
//  Created by 海洋 on 16/9/6.
//  Copyright © 2016年 海洋. All rights reserved.
//
//
/**
 *  @brief  CartVC
 *  @author HY
 *  @date   2016.09.06
 */

#import <UIKit/UIKit.h>
#import "HYCartBar.h"
@interface HYCartVC : HYBaseViewController
/**
 *  底部支付View
 */
@property (nonatomic, strong) HYCartBar       *cartBar;

@end
