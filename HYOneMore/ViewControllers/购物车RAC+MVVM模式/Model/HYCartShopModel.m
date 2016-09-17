//
//  HYCartShopModel.m
//  SuperUserClientApp
//
//  Created by 海洋 on 16/9/10.
//  Copyright © 2016年 LC-World. All rights reserved.
//

#import "HYCartShopModel.h"

@implementation HYCartShopModel
- (id)initWithDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        self = [RMMapper populateObject:self fromDictionary:dic];
    }
    return self;
}

@end
