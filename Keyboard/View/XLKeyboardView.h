//
//  XLKeyboardView.h
//  iRead
//
//  Created by lixinglu on 2017/11/8.
//

#import <UIKit/UIKit.h>

@interface XLKeyboardView : UIView

+ (instancetype)shareKeyBoard;


@property(nonatomic, copy) NSString *placeString;

/**
 弹出键盘
 */
- (void)showView;

@end
