//
//  HYCartNumberCount.h
//  HYOneMore
//
//  Created by 海洋 on 16/9/6.
//  Copyright © 2016年 海洋. All rights reserved.
//
/**
 *  @brief  CartCell上面的@“+”， @“-”
 *  @author HY
 *  @date   2016.09.06
 */

#import <UIKit/UIKit.h>
typedef void(^HYNumberChangeBlock)(NSInteger count);
@interface HYCartNumberCount : UIView

/**
 *  总数
 */
@property (nonatomic, assign) NSInteger           totalNum;
/**
 *  当前显示数量
 */
@property (nonatomic, assign) NSInteger           currentCountNumber;
/**
 *  数量改变回调
 */
@property (nonatomic, copy  ) HYNumberChangeBlock NumberChangeBlock;
@end
