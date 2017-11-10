//
//  XLFaceModel.m
//  test
//
//  Created by lixinglu on 2017/11/9.
//  Copyright © 2017年 lixinglu. All rights reserved.
//

#import "XLFaceModel.h"

@implementation XLFaceModel

+ (instancetype)modelWithDic:(NSDictionary *)dic{
    XLFaceModel *model = [[self alloc] initWithDic:dic];
    
    return model;
}

- (instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

@end
