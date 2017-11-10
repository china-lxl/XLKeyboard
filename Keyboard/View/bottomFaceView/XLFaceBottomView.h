//
//  XLFaceBottomView.h
//  test
//
//  Created by lixinglu on 2017/11/8.
//  Copyright © 2017年 lixinglu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define k_bottom_height  200

@class XLFaceModel;

@protocol XLFaceBottomViewDelegate <NSObject>


/**
 选择了一个表情符号
 */
- (void)addFaceModel:(XLFaceModel *)faceModel;


/**
 点击了一次删除操作
 */
- (void)deleFaceModel;

@end

@interface XLFaceBottomView : UIView


/**
 静态的数据模型 face name
 */
@property(nonatomic, strong) NSArray *dataArray;


@property (nonatomic, weak) id <XLFaceBottomViewDelegate> delegate;


@end
