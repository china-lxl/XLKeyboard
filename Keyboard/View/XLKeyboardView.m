//
//  XLKeyboardView.m
//  iRead
//
//  Created by lixinglu on 2017/11/8.
//

#import "XLKeyboardView.h"

#import "XLKeyboardToolView.h"


@interface XLKeyboardView ()<XLKeyboardToolViewDelegate>

@property(nonatomic, strong) XLKeyboardToolView *toolView;

@property(nonatomic,strong) UIButton *backgroudBtn;

@property(nonatomic, assign) BOOL switchingKeybaord;


@end

static XLKeyboardView *keyboardView;

@implementation XLKeyboardView

+ (instancetype)shareKeyBoard{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        keyboardView = [[self alloc] init];
    });
    return keyboardView;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setSubViews];
    }
    return self;
}

- (void)setSubViews{
    [self addSubview:self.backgroudBtn];
    
    [self.backgroudBtn addSubview:self.toolView];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewWillDown:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark -

- (void)textViewWillShow:(NSNotification *)noti{
    if (self.switchingKeybaord) {
        return;
    }
    NSDictionary *userInfo = noti.userInfo;
    
    CGRect keyBoardBounds = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    float height = keyBoardBounds.size.height;
    
    
    float animationTime = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    void (^animation)(void) = ^void(void){
        CGRect frame = self.toolView.frame;
        frame.origin.y = k_Screen_H - height - frame.size.height;
        self.toolView.frame = frame;
    };
    
    if (animationTime > 0) {
        [UIView animateWithDuration:animationTime animations:animation];
    }else{
        animation();
    }
}

- (void)textViewWillDown:(NSNotification *)noti{
    if (self.switchingKeybaord) {
        return;
    }
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:noti.userInfo];
    CGFloat animationTime  = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    // 定义好动作
    void (^animation)(void) = ^void(void) {
        CGRect frame = self.toolView.frame;
        frame.origin.y = k_Screen_H;
        self.toolView.frame = frame;
        [self removeFromSuperview];
    };
    
    if (animationTime > 0) {
        [UIView animateWithDuration:animationTime animations:animation];
    } else {
        animation();
    }
}

#pragma mark -
- (void)showView{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = window.bounds;
    [window addSubview:self];
    
    
    [self.toolView willShow];
}

- (void)dissmissView{
    [self.toolView willDown];
}

#pragma mark - toolViewDelegate
- (void)sendText:(NSString *)text{
    NSLog(@"%@",text);
    [self.toolView clearCurrenText];
}

- (void)faceSwitch{
    self.switchingKeybaord = YES;
    
    [self.toolView willDown];
    
    self.switchingKeybaord = NO;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 弹出键盘

        [self.toolView.textView becomeFirstResponder];
    });
}

#pragma mark - set
- (void)setPlaceString:(NSString *)placeString{
    _placeString = placeString;
    
    self.toolView.placeString = placeString;
}
#pragma mark -
- (UIButton *)backgroudBtn{
    if (!_backgroudBtn) {
        _backgroudBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;

        _backgroudBtn.frame = window.bounds;
        
        _backgroudBtn.backgroundColor = [UIColor clearColor];
        //[UIColor colorWithRed:0 green:0 blue:0 alpha:0.35];
        
        [_backgroudBtn addTarget:self action:@selector(dissmissView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backgroudBtn;
}
- (XLKeyboardToolView *)toolView{
    if (!_toolView) {
        _toolView = [[XLKeyboardToolView alloc] initWithFrame:CGRectMake(0, k_Screen_H, k_Screen_W, k_tool_height)];
        
        _toolView.xlDelegate = self;
        
    }
    return _toolView;
}



@end
