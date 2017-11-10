//
//  XLFaceLayout.h
//  test
//
//  Created by lixinglu on 2017/11/9.
//  Copyright © 2017年 lixinglu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLFaceLayout : UICollectionViewFlowLayout


/**
 每页显示的行数
 */
@property(nonatomic, assign) NSUInteger item_H;

/**
 每行显示的个数
 */
@property(nonatomic, assign) NSUInteger item_Row;

@property (strong, nonatomic) NSMutableArray *allAttributes;


@end
