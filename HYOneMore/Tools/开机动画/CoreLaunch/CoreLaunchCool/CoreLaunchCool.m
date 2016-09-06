//
//  CoreLaunchLite.m
//  CoreLaunch
//
//  Created by 冯成林 on 15/10/16.
//  Copyright © 2015年 冯成林. All rights reserved.
//

#import "CoreLaunchCool.h"
#import "CALayer+Cool.h"

#define iphone4x_3_5 ([UIScreen mainScreen].bounds.size.height==480.0f)

#define iphone5x_4_0 ([UIScreen mainScreen].bounds.size.height==568.0f)

#define iphone6_4_7 ([UIScreen mainScreen].bounds.size.height==667.0f)

#define iphone6Plus_5_5 ([UIScreen mainScreen].bounds.size.height==736.0f || [UIScreen mainScreen].bounds.size.height==414.0f)

@implementation CoreLaunchCool


/** 执行动画 */
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

@end
