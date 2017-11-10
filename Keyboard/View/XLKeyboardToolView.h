//
//  XLKeyboardToolView.h
//  iRead
//
//  Created by lixinglu on 2017/11/8.
//

#import <UIKit/UIKit.h>

#define k_Screen_W   [UIScreen mainScreen].bounds.size.width
#define k_Screen_H   [UIScreen mainScreen].bounds.size.height

#define k_tool_height  44

#pragma mark -
@interface XLTextView : UITextView

@property(nonatomic, copy) NSString *placeString;

@property(nonatomic, strong) UIColor *placeColor;

@property(nonatomic, assign) BOOL hiddenPlace;

@property(nonatomic, strong) NSArray *dataArray;

- (void)insertFaceName:(NSString *)faceName;

@end

#pragma mark -

@protocol XLKeyboardToolViewDelegate <NSObject>

@required

- (void)sendText:(NSString *)text;

- (void)faceSwitch;

@end

@interface XLKeyboardToolView : UIView


@property (nonatomic, weak) id <XLKeyboardToolViewDelegate> xlDelegate;

@property(nonatomic, copy) NSString *placeString;

@property(nonatomic, strong) XLTextView *textView;


/**
 清除当前数据
 */
- (void)clearCurrenText;

/**
 允许的最大行数 超过这个行数  textView  就会滚动  默认显示4行
 */
@property(nonatomic, assign) NSUInteger maxLine;


/**
 textView 将要出现
 */
- (void)willShow;


/**
 textView 将要消失
 */
- (void)willDown;

@end
