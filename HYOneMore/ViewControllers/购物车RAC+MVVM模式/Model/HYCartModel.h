//
//  HYCartModel.h
//  HYOneMore
//
//  Created by 海洋 on 16/9/5.
//  Copyright © 2016年 海洋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYCartModel : NSObject

@property (nonatomic, strong) NSString  *p_id;

@property (nonatomic, strong) NSString * p_price;

@property (nonatomic, strong) NSString  *p_name;

@property (nonatomic, strong) NSString  *p_imageUrl;

@property (nonatomic, assign) NSInteger p_stock;

@property (nonatomic, assign) NSInteger p_quantity;

//商品是否被选中
@property (nonatomic, assign) BOOL      isSelect;

@end
