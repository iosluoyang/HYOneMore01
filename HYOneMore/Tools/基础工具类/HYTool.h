//
//  HYTool.h
//  HYOneMore
//
//  Created by 海洋 on 16/9/9.
//  Copyright © 2016年 海洋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CALayer+HYTool.h"//图层拓展
#import "UIColor+Hex.h"//颜色拓展
@interface HYTool : NSObject
/**
 *  执行启动页动画
 *
 *  @param window        主程序窗口
 *  @param image         显示的图片
 *  @param AnimationTime 广告的时间
 */
+(void)animWithWindow:(UIWindow *)window image:(UIImage *)image withAnimationTime:(CGFloat)AnimationTime;


/**
 *  添加到购物车动画
 *
 *  @param startview               开始动画的view
 *  @param startviewifoncurrenview 开始动画的view是否在当前的view上
 *  @param isfromstartviewcenter   是否从开始动画的view的中心点开始
 *  @param endview                 结束动画的view
 *  @param endviewifoncurrenview   结束动画的view是否在当前的view上
 *  @param contentImg              弹出物
 *  @param isopacity               是否渐变效果
 *  @param istransform             是否缩小
 *  @param AnimationTime           动画执行时间
 *  @param target                  当前控制器
 */
/**
 target 需要实现两个代理方法
 动画结束之后的方法:
 - (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag;
 
 移除弹出物
 - (void)removeFromLayer:(CALayer *)layerAnimation；
 */
+(void)startAnimationWithstartView:(UIView *)startview startviewifoncurrenview:(BOOL)startviewifoncurrenview isfromstartviewcenter:(BOOL)isfromstartviewcenter endView:(UIView *)endview endviewifoncurrenview:(BOOL)endviewifoncurrenview contentImg:(UIImage *)contentImg isopacity:(BOOL)isopacity  istransform:(BOOL)istransform AnimationTime:(NSTimeInterval)AnimationTime target:(UIViewController *)target;
@end
