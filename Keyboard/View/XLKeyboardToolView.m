//
//  XLKeyboardToolView.m
//  iRead
//
//  Created by lixinglu on 2017/11/8.
//

#import "XLKeyboardToolView.h"

#import "XLFaceBottomView.h"

#import "XLFaceModel.h"

#define k_one_heigth         34-18// 单行的高度
#define k_face_btn_width     40//按钮的宽度
#define k_toolView_bg_Color           [UIColor colorWithRed:240/255. green:240/255. blue:240/255. alpha:1]//toolViewBgColor

#pragma mark - 自定义 textView  实现placeholder
@interface XLTextView ()

@property(nonatomic, weak) UILabel *placheholderLabel;


@end

@implementation XLTextView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        UILabel *placheholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 8, frame.size.width-10, frame.size.height - 16)];
        placheholderLabel.numberOfLines = 0;
        placheholderLabel.font = [UIFont systemFontOfSize:15];
        placheholderLabel.textColor = [UIColor colorWithRed:153/255. green:153/255. blue:153/255. alpha:1];
        
        [self addSubview:placheholderLabel];
        
        self.placheholderLabel = placheholderLabel;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

- (void)deleteBackward{
    NSString *string = self.text;
    
    NSRange range = self.selectedRange;
    if (range.location == NSNotFound) {
        range.location = self.text.length;
    }
    
    string = [string substringToIndex:range.location];
    
    if ([self isFaceWithText:string]) {//最后是表情
        NSLog(@"删除了一个表情符号!!！");
        [self.delegate textViewDidChange:self];

    }else{
        [super deleteBackward];
    }
}


- (void)insertFaceName:(NSString *)faceName{
    NSString *string = self.text;

    NSRange range = self.selectedRange;
    if (range.location == NSNotFound) {
        range.location = self.text.length;
    }
    
    NSString *str2 = [string substringToIndex:range.location];

    if ([string isEqualToString:str2]) {
        string = [string stringByAppendingString:faceName];
        self.text = string;
    }else{
        NSString *str3 = [string substringFromIndex:range.location];
        str2 = [str2 stringByAppendingString:faceName];
        string = [str2 stringByAppendingString:str3];
        self.text = string;
        self.selectedRange = NSMakeRange(str2.length, 0);
    }
    
    [self.delegate textViewDidChange:self];
}
- (void)textDidChange{
    self.placheholderLabel.hidden = self.hasText;
}

- (void)setPlaceString:(NSString *)placeString{
    _placeString = placeString;
    
    self.placheholderLabel.text = placeString;
}

- (void)setHiddenPlace:(BOOL)hiddenPlace{
    _hiddenPlace = hiddenPlace;
    
    self.placheholderLabel.hidden = hiddenPlace;
}

#pragma mark - 判断删除的最后一个是否是自定义的表情 是的话直接删除
- (BOOL)isFaceWithText:(NSString *)text{
    if (!text) {
        return NO;
    }
    BOOL hasFace = NO;
    if (text.length > 2) {
        if ([text containsString:@"["] && [text containsString:@"]"]) {
            NSString *lastStr = [text substringFromIndex:text.length-1];
            if ([lastStr isEqualToString:@"]"]) {
                
                NSRange range = [text rangeOfString:@"[" options:NSBackwardsSearch];
                
                range = NSMakeRange(range.location+1, self.selectedRange.location-range.location-2);
                
                NSString *string = [text substringWithRange:range];
                
                if ([self.dataArray containsObject:string]) {
                    NSString *totalString = self.text;
                    
                    text = [text substringToIndex:self.selectedRange.location];
                    
                    string = [NSString stringWithFormat:@"[%@]",string];
                    
                    range = [totalString rangeOfString:string options:NSBackwardsSearch range:NSMakeRange(0, self.selectedRange.location)];
                    
                    totalString = [totalString stringByReplacingCharactersInRange:range withString:@""];
                    
                    self.text = totalString;

                    self.selectedRange = NSMakeRange(range.location, 0);
                    
                    
                    hasFace = YES;
                }
            }
        }
    }
    
    return hasFace;
}

@end

#pragma mark - toolView
@interface XLKeyboardToolView ()<UITextViewDelegate,XLFaceBottomViewDelegate>

@property(nonatomic, strong) XLFaceBottomView *faceBottomView;

/**
 默认显示1行
 */
@property(nonatomic, assign) CGFloat maxHeight;

@property(nonatomic, assign) BOOL showFace;

@end

static CGFloat minHeight = k_tool_height - 10;

@implementation XLKeyboardToolView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setSubViews];
    }
    return self;
}

- (void)setSubViews{
    self.backgroundColor = k_toolView_bg_Color;
    self.backgroundColor = [UIColor orangeColor];
    
    [self addSubview:self.textView];
    
    self.maxLine = 4;
    
    self.maxHeight = k_one_heigth + 0.5 + 18 * self.maxLine;
    
    UIButton *faceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [faceBtn setImage:[UIImage imageNamed:@"input_icon_face"] forState:UIControlStateNormal];
    [faceBtn addTarget:self action:@selector(faceBtnCliecked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:faceBtn];
    
    faceBtn.frame = CGRectMake(CGRectGetMaxX(self.textView.frame), (self.frame.size.height - k_face_btn_width)/2., k_face_btn_width, k_face_btn_width);
}

- (void)faceBtnCliecked:(UIButton *)faceBtn{
    UIImage *image = [UIImage imageNamed:_showFace ? @"input_icon_face" : @"input_icon_keyboard"];

    _showFace = !_showFace;
    
    if (_showFace) {
        self.textView.inputView = self.faceBottomView;
    }else{
        self.textView.inputView = nil;
    }
    
    [faceBtn setImage:image forState:UIControlStateNormal];
    
    if ([self.xlDelegate respondsToSelector:@selector(faceSwitch)]) {
        [self.xlDelegate faceSwitch];
    }
}


#pragma mark - action
- (void)willShow{
    CGRect frame = self.frame;
    frame.origin.y = k_Screen_H;
    self.frame = frame;
    [self.textView becomeFirstResponder];
}

- (void)willDown{
    [self.textView endEditing:YES];
}

- (void)clearCurrenText{
    self.textView.text = @"";
    
    [self textViewDidChange:self.textView];
}

#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];

    float tempY = 0;
    
    if (size.height < minHeight) {
        size.height = minHeight;
    }else if (size.height <= frame.size.height) {
        tempY = size.height - frame.size.height ;
    }else{
        if (size.height >= self.maxHeight)
        {
            size.height = self.maxHeight;
            textView.scrollEnabled = YES;   // 允许滚动
        }
        else
        {
            tempY = size.height - frame.size.height;
            textView.scrollEnabled = NO;    // 不允许滚动
        }
    }
    textView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height);
    
    frame = self.frame;
    
    frame.origin.y = frame.origin.y - tempY;
    frame.size.height = size.height + 10;
    
    self.frame = frame;
    
    if (!textView.scrollEnabled) {//防止ContentOffset 发生改变
        [textView setContentOffset:CGPointZero animated:YES];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        [self.textView resignFirstResponder];
        if ([self.xlDelegate respondsToSelector:@selector(sendText:)]) {
            [self.xlDelegate sendText:textView.text];
        }
        return NO;
    }
    return YES;
}

#pragma mark - 表情 按钮操作
- (void)addFaceModel:(XLFaceModel *)faceModel{
    if (!self.textView.dataArray) {
        self.textView.dataArray = self.faceBottomView.dataArray;
    }
    
    [self.textView insertFaceName:[NSString stringWithFormat:@"[%@]",faceModel.name]];
    self.textView.hiddenPlace = YES;
}

- (void)deleFaceModel{
    [self.textView deleteBackward];
}
#pragma mark 最大行数
- (void)setMaxLine:(NSUInteger)maxLine{
    _maxLine = maxLine;
    
    self.maxHeight = k_one_heigth + 0.5 + 18 * maxLine;
}
#pragma mark 默认文字
- (void)setPlaceString:(NSString *)placeString{
    _placeString = placeString;
    
    self.textView.placeString = placeString;
}

#pragma mark set/get
- (XLFaceBottomView *)faceBottomView{
    if (!_faceBottomView) {
        _faceBottomView = [[XLFaceBottomView alloc] initWithFrame:CGRectMake(0, 0, k_Screen_W, k_bottom_height)];
        _faceBottomView.delegate = self;
    }
    return _faceBottomView;
}
- (XLTextView *)textView{
    if (!_textView) {
        _textView = [[XLTextView alloc] initWithFrame:CGRectMake(10, 5, self.frame.size.width - 10 - k_face_btn_width, self.frame.size.height - 10)];
        _textView.layer.masksToBounds = YES;
        _textView.layer.cornerRadius = 2;
        _textView.backgroundColor = [UIColor whiteColor];
        
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.layoutManager.allowsNonContiguousLayout = NO;
        
        _textView.returnKeyType = UIReturnKeySend;

        _textView.delegate = self;
    }
    return _textView;
}
@end
