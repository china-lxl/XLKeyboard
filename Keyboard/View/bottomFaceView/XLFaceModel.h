//
//  XLFaceModel.h
//  test
//
//  Created by lixinglu on 2017/11/9.
//  Copyright © 2017年 lixinglu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLFaceModel : NSObject


/**
 文字
 */
@property(nonatomic, copy) NSString *name;


/**
 是否是删除键
 */
@property(nonatomic, assign) BOOL isDele;

/**
 图片表情
 */
@property(nonatomic, copy) NSString *picname;


+ (instancetype)modelWithDic:(NSDictionary *)dic;

@end



