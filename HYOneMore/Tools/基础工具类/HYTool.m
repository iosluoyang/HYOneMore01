//
//  HYTool.m
//  HYOneMore
//
//  Created by 海洋 on 16/9/9.
//  Copyright © 2016年 海洋. All rights reserved.
//

#import "HYTool.h"


@implementation HYTool
/**
 *  执行启动页动画
 *
 *  @param window        主程序窗口
 *  @param image         显示的图片
 *  @param AnimationTime 广告的时间
 */
+(void)animWithWindow:(UIWindow *)window image:(UIImage *)image withAnimationTime:(CGFloat)AnimationTime{
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //注意，此处设置为适应图片会有一个问题，就是在图片偏小的时候顶部的导航栏会显示出来，调整图片或者图片的展现方式即可
    imageV.contentMode = UIViewContentModeScaleAspectFit;
    imageV.clipsToBounds = YES;
    imageV.backgroundColor = [UIColor whiteColor];
    //给imageV增加一个无谓的手势,以跳过点击事件:
    UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImg)];
    imageV.userInteractionEnabled = YES;
    [imageV addGestureRecognizer:tap];
    
    imageV.image = image==nil?[self launchImage]:image;
    
    [window.rootViewController.view addSubview:imageV];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [imageV removeFromSuperview];
        //在此设置类似于网易云音乐的启动页转换动画
        [window.layer transitionWithAnimType:TransitionAnimTypeOglFlip subType:TransitionSubtypesFromRight curve:TransitionCurveLinear duration:AnimationTime];
    });
}




/**
 *  获取启动图片
 */
+(UIImage *)launchImage{
    
    NSString *imageName=@"HYOneMore";
    
    if(iphone5x_4_0) imageName=@"HYOneMore";
    
    if(iphone6_4_7) imageName = @"HYOneMore";
    
    if(iphone6Plus_5_5) imageName = @"HYOneMore";
    
    UIImage *image = [UIImage imageNamed:imageName];
    
    NSAssert(image != nil, @"Charlin Feng提示您：请添加启动图片！");
    
    return image;
}
+(void)tapImg
{
    NSLog(@"点击了启动图片");
}


#pragma mark - 加入购物车动画效果
+(void)startAnimationWithstartView:(UIView *)startview startviewifoncurrenview:(BOOL)startviewifoncurrenview isfromstartviewcenter:(BOOL)isfromstartviewcenter endView:(UIView *)endview endviewifoncurrenview:(BOOL)endviewifoncurrenview contentImg:(UIImage *)contentImg isopacity:(BOOL)isopacity  istransform:(BOOL)istransform AnimationTime:(NSTimeInterval)AnimationTime target:(UIViewController *)target;
{
    //获取起点(根据参数BOOL值来判断是否从中心点开始)
    UIView *startviewsuperview = startviewifoncurrenview ? [UIApplication sharedApplication].keyWindow :startview.superview;
    CGFloat startX = isfromstartviewcenter? [startviewsuperview convertRect:startview.frame toView:[UIApplication sharedApplication].keyWindow].origin.x +[startviewsuperview convertRect:startview.frame toView:[UIApplication sharedApplication].keyWindow].size.width/2 :  [startviewsuperview convertRect:startview.frame toView:[UIApplication sharedApplication].keyWindow].origin.x;
    CGFloat startY = isfromstartviewcenter ? [startviewsuperview convertRect:startview.frame toView:[UIApplication sharedApplication].keyWindow].origin.y + [startviewsuperview convertRect:startview.frame toView:[UIApplication sharedApplication].keyWindow].size.height/2 : [startviewsuperview convertRect:startview.frame toView:[UIApplication sharedApplication].keyWindow].origin.y;
    
    //获取终点(默认终点为终点view的中心点)
    UIView *endviewsuperview = endviewifoncurrenview ? [UIApplication sharedApplication].keyWindow :endview.superview;
    CGFloat endX = [endviewsuperview convertRect:endview.frame toView:[UIApplication sharedApplication].keyWindow].origin.x + [endviewsuperview convertRect:endview.frame toView:[UIApplication sharedApplication].keyWindow].size.width/2 ;
    CGFloat endY = [endviewsuperview convertRect:endview.frame toView:[UIApplication sharedApplication].keyWindow].origin.y + [endviewsuperview convertRect:endview.frame toView:[UIApplication sharedApplication].keyWindow].size.height/2;
    
    //获取转折点(根据BOOL值判断是左弧度还是右弧度)
    CGFloat middleX = fabs(endX - startX) /4;//取绝对值
    CGFloat middleY = fabs(endY - startY)/2;
    
    
    
    UIBezierPath *_path = [UIBezierPath bezierPath];
    [_path moveToPoint:CGPointMake(startX, startY)];
    
    //三点曲线
    [_path addCurveToPoint:CGPointMake(endX, endY)//终点
             controlPoint1:CGPointMake(startX, startY)//起点
             controlPoint2:CGPointMake(middleX, middleY)];//转折点
    
    //弹出物件的layer绘制
    UIImageView *contentimgview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    contentimgview.contentMode = UIViewContentModeScaleAspectFill;
    contentimgview.clipsToBounds = YES;
    contentimgview.image = contentImg;
    [[UIApplication sharedApplication].keyWindow.layer addSublayer:contentimgview.layer];
    
    //路径动画
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.duration = AnimationTime;
    animation.path = _path.CGPath;
    animation.rotationMode = kCAAnimationCubic;//在此处更改弹出物件的旋转状态，此时为不旋转
    
    //渐变动画
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.duration = AnimationTime;
    alphaAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    alphaAnimation.toValue = [NSNumber numberWithFloat:0.2];
    alphaAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    //放大缩小动画
    CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    transformAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    transformAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 0.5, 0.5, 1)];
    
    
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    NSMutableArray *animationarr = [NSMutableArray arrayWithObject:animation];
    //根据参数选择加入的动画:
    if (isopacity) {
        //是否显示渐变
        [animationarr addObject:alphaAnimation];
    }
    if (istransform) {
        //是否显示缩小
        [animationarr addObject:transformAnimation];
    }
    groups.animations = [NSArray arrayWithArray:animationarr];
    
    groups.duration = AnimationTime;
    groups.removedOnCompletion = NO;
    groups.fillMode = kCAFillModeForwards;
    groups.delegate = target;
    [groups setValue:@"groupsAnimation" forKey:@"animationName"];
    [contentimgview.layer addAnimation:groups forKey:nil];
    [target performSelector:@selector(removeFromLayer:) withObject:contentimgview.layer afterDelay:AnimationTime];
    
}
@end
