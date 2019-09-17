//
//  GYChatToolsView.m
//  GYChat
//
//  Created by gyy on 2019/9/12.
//  Copyright © 2019 古耀耀. All rights reserved.
//

#import "GYChatToolsView.h"
#import "GYChatVoiceButton.h"
#import "GYChatInputView.h"
#import "GYChatToolsEmojiView.h"
#import "GYChatToolsMoreView.h"
#import "GYChatEmojiModel.h"
#import "GYChatEmojiHelper.h"
#import "GYChatMacro.h"
#import "UIView+GY.h"


typedef enum : NSUInteger {
    GYChateToolsKeyboardTypeNone,
    GYChateToolsKeyboardTypeSys,
    GYChateToolsKeyboardTypeEmoji,
    GYChateToolsKeyboardTypeMore,
    GYChateToolsKeyboardTypeVoice,
} GYChateToolsKeyboardType;


@interface GYChatToolsView()<GYChatInputViewDelegate,GYChatToolsEmojiViewDelegate,GYChatVoiceButtonDelegate,GYChatToolsMoreViewDelegate>

@property (strong, nonatomic) UIButton *voiceBtn; //语音
@property (strong, nonatomic) GYChatInputView *inputTx; //输入框
@property (strong, nonatomic) GYChatVoiceButton *voiceCenterBtn; //中间语音按钮
@property (strong, nonatomic) UIButton *emojiBtn; //表情
@property (strong, nonatomic) UIButton *moreBtn; //更多
@property (strong, nonatomic) UIButton *sendBtn; //发送


@property (strong, nonatomic) UIView *bottomView; //底部视图
@property (strong, nonatomic) GYChatToolsEmojiView *emojiView; //表情视图
@property (strong, nonatomic) GYChatToolsMoreView *moreView; //更多视图

@property (assign, nonatomic) GYChateToolsKeyboardType keyboardType;
@property (assign, nonatomic) CGFloat inputH; //记录文字框高度

@property (strong, nonatomic) UITapGestureRecognizer *inputTapGes;
@property (nonatomic, strong) NSDictionary *attributes;

@end



@implementation GYChatToolsView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUI];
    }
    return self;
}

-(void)setUI{
    self.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
    self.inputH = K_INPUT_MIN_H;
    self.attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13.0]};
    
    __weak typeof(self) weakSelf = self;
    
    ///底部功能视图
    [self addSubview:self.bottomView];
    
    ///表情视图
    [self.bottomView addSubview:self.emojiView];
    
    ///更多
    [self.bottomView addSubview:self.moreView];
    
    
    ///文字、音频转换按钮
    [self addSubview:self.voiceBtn];
    
    ///录音按钮
    [self addSubview:self.voiceCenterBtn];
    
    ///输入框
    [self addSubview:self.inputTx];
    
    ///表情按钮
    [self addSubview:self.emojiBtn];
    
    ///更多按钮
    [self addSubview:self.moreBtn];
    
    ///发送按钮
    [self addSubview:self.sendBtn];
    

    
    [self.voiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.bottomView.mas_top).offset(-10);
        make.left.equalTo(weakSelf.mas_left).offset(10);
        make.size.mas_offset(CGSizeMake(30, 30));
    }];
    
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mas_right).offset(-10);
        make.bottom.equalTo(weakSelf.voiceBtn);
        make.size.mas_offset(CGSizeMake(30, 30));
    }];
    
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mas_right).offset(-10);
        make.bottom.equalTo(weakSelf.voiceBtn);
        make.size.mas_offset(CGSizeMake(50, 30));
    }];
    
    [self.emojiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mas_right).offset(-50);
        make.bottom.equalTo(weakSelf.voiceBtn);
        make.size.mas_offset(CGSizeMake(30, 30));
    }];
    
    [self.inputTx mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.voiceBtn);
        make.left.equalTo(weakSelf.voiceBtn.mas_right).offset(10);
        make.right.equalTo(weakSelf.emojiBtn.mas_left).offset(-10);
        make.height.mas_offset(K_INPUT_MIN_H);
        make.top.equalTo(weakSelf.mas_top).offset(10);
    }];
    
    [self.voiceCenterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.voiceBtn.mas_right).offset(10);
        make.right.equalTo(weakSelf.emojiBtn.mas_left).offset(-10);
        make.bottom.equalTo(weakSelf.voiceBtn);
        make.height.mas_offset(K_INPUT_MIN_H);
    }];
    
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf);
        make.height.mas_offset(0);
    }];
    
    [self.emojiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
    }];
    
    [self.moreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
    }];
    
}


///底部功能菜单
- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.hidden = YES;
    }
    return _bottomView;
}
///表情视图
- (GYChatToolsEmojiView *)emojiView{
    if (!_emojiView) {
        _emojiView = [[GYChatToolsEmojiView alloc] init];
        _emojiView.delegate = self;
    }
    return _emojiView;
}
///更多视图
- (GYChatToolsMoreView *)moreView{
    if (!_moreView) {
        _moreView = [[GYChatToolsMoreView alloc] init];
        _moreView.delegate = self;
    }
    return _moreView;
}


///左边录音按钮
- (UIButton *)voiceBtn{
    if (!_voiceBtn) {
        _voiceBtn = [[UIButton alloc] init];
        [_voiceBtn setImage:[UIImage imageNamed:@"chatBar_record"] forState:UIControlStateNormal];
        [_voiceBtn addTarget:self action:@selector(voiceBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voiceBtn;
}

///中间录音按钮
- (GYChatVoiceButton *)voiceCenterBtn{
    if (!_voiceCenterBtn) {
        _voiceCenterBtn = [[GYChatVoiceButton alloc] init];
        _voiceCenterBtn.layer.cornerRadius = 4.0f;
        _voiceCenterBtn.layer.borderWidth = 1.0f;
        _voiceCenterBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _voiceCenterBtn.clipsToBounds = YES;
        _voiceCenterBtn.hidden = YES;
        _voiceCenterBtn.delegate = self;
    }
    return _voiceCenterBtn;
}

///输入框
- (GYChatInputView *)inputTx{
    if (!_inputTx) {
        _inputTx = [[GYChatInputView alloc] init];
        _inputTx.layer.cornerRadius = 4.0f;
        _inputTx.layer.borderWidth = 1.0f;
        _inputTx.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _inputTx.clipsToBounds = YES;
        _inputTx.font = [UIFont systemFontOfSize:13.0f];
        _inputTx.contentInset = UIEdgeInsetsMake(5, 0, 0, 5);
        _inputTx.gy_delegate = self;
    }
    return _inputTx;
}

- (UITapGestureRecognizer *)inputTapGes{
    if (!_inputTapGes) {
        _inputTapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(inputTapGesAction:)];
    }
    return _inputTapGes;
}

- (UIButton *)emojiBtn{
    if (!_emojiBtn) {
        _emojiBtn = [[UIButton alloc] init];
        //默认是语音按钮
        [_emojiBtn setImage:[UIImage imageNamed:@"chatBar_face"] forState:UIControlStateNormal];
        [_emojiBtn addTarget:self action:@selector(emojiBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _emojiBtn;
}



- (UIButton *)moreBtn{
    if (!_moreBtn) {
        _moreBtn = [[UIButton alloc] init];
        [_moreBtn setImage:[UIImage imageNamed:@"chatBar_more"] forState:UIControlStateNormal];
        [_moreBtn addTarget:self action:@selector(moreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}

- (UIButton *)sendBtn{
    if (!_sendBtn) {
        _sendBtn = [[UIButton alloc] init];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sendBtn.layer.cornerRadius = 4.0f;
        _sendBtn.layer.borderWidth = 1.0f;
        _sendBtn.layer.borderColor = [UIColor blueColor].CGColor;
        _sendBtn.clipsToBounds = YES;
        _sendBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        _sendBtn.backgroundColor = [UIColor blueColor];
        _sendBtn.hidden = YES;
        [_sendBtn addTarget:self action:@selector(sendBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}










- (void)setIsFirstResponse:(BOOL)isFirstResponse{
    if (isFirstResponse != _isFirstResponse) {
        _isFirstResponse = isFirstResponse;
    }
    if (isFirstResponse) {
        //显示键盘
        
    }else{
        //结束编辑,底部消失
        [_inputTx resignFirstResponder];
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(0);
        }];
        self.bottomView.hidden = YES;
        if (_keyboardType != GYChateToolsKeyboardTypeVoice) {
            self.keyboardType = GYChateToolsKeyboardTypeNone;
        }
    }
}

- (void)setKeyboardType:(GYChateToolsKeyboardType)keyboardType{
    _keyboardType = keyboardType;
    __weak typeof(self) weakSelf = self;
    switch (keyboardType) {
        case GYChateToolsKeyboardTypeNone:
        {
            [self.emojiBtn setImage:[UIImage imageNamed:@"chatBar_face"] forState:UIControlStateNormal];
        }
            break;
        case GYChateToolsKeyboardTypeVoice:
        {
            //结束编辑,隐藏输入框,显示录音,隐藏底部
            [self.inputTx resignFirstResponder];
            self.inputTx.hidden = YES;
            self.voiceCenterBtn.hidden = NO;
            [self.inputTx mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_offset(K_INPUT_MIN_H);
            }];
            
            [self.emojiBtn setImage:[UIImage imageNamed:@"chatBar_face"] forState:UIControlStateNormal];
            [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_offset(0);
            }];
        }
            break;
        case GYChateToolsKeyboardTypeSys:
        {
            //隐藏录音,隐藏底部视图,隐藏更多,显示原来的高度,默认图标
            [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_offset(0);
            }];
            self.bottomView.hidden = YES;
            
            self.inputTx.hidden = NO;
            [self.inputTx becomeFirstResponder];
            self.voiceCenterBtn.hidden = YES;
            [self.inputTx mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_offset(weakSelf.inputH);
            }];
            
            [self.emojiBtn setImage:[UIImage imageNamed:@"chatBar_face"] forState:UIControlStateNormal];
            [self.voiceBtn setImage:[UIImage imageNamed:@"chatBar_record"] forState:UIControlStateNormal];
            //更改为系统键盘
            self.inputTx.inputView = nil;
            [self.inputTx reloadInputViews];
            
        }
            break;
        case GYChateToolsKeyboardTypeEmoji:
        {
            //更改为输入框
            self.inputTx.hidden = NO;
            self.voiceCenterBtn.hidden = YES;
            [self.inputTx mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_offset(weakSelf.inputH);
            }];
            //更改为系统键盘
            self.inputTx.inputView = [[UIView alloc] initWithFrame:CGRectZero];
            [self.inputTx reloadInputViews];
        }
            break;
        case GYChateToolsKeyboardTypeMore:
        {
            //隐藏录音,隐藏底部视图,隐藏更多,显示原来的高度,默认图标
            self.inputTx.hidden = NO;
            [self.inputTx resignFirstResponder];
            self.voiceCenterBtn.hidden = YES;
            [self.inputTx mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_offset(weakSelf.inputH);
            }];
            
            [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_offset(K_CHAT_BAR_BOTTOM_HEIGHT);
            }];
            self.bottomView.hidden = NO;
            
            [self.emojiBtn setImage:[UIImage imageNamed:@"chatBar_face"] forState:UIControlStateNormal];
            [self.voiceBtn setImage:[UIImage imageNamed:@"chatBar_record"] forState:UIControlStateNormal];

        }
            break;
            
        default:
            break;
    }
}



#pragma mark
#pragma mark --- GYChatInputViewDelegate ---
- (void)GYChatInputViewHeightChange:(CGFloat)height{
    [self.inputTx mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(height);
    }];
    self.inputH = height;
}

- (void)GYChatInputViewShouldBegin{
    //隐藏所有
//    self.keyboardType = GYChateToolsKeyboardTypeSys;
    self.inputTx.inputView = nil;
    [self.inputTx reloadInputViews];
}

- (void)GYChatInputViewDidChange{
    __weak typeof(self) weakSelf = self;
    if ([self.inputTx.text stringByReplacingOccurrencesOfString:@" " withString:@""].length != 0) {
        //显示发送，隐藏更多
        self.moreBtn.hidden = YES;
        self.sendBtn.hidden = NO;
        [self.emojiBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.mas_right).offset(-70);
        }];
    }else{
        //显示更多，隐藏发送
        self.moreBtn.hidden = NO;
        self.sendBtn.hidden = YES;
        [self.emojiBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.mas_right).offset(-50);
        }];
    }
}

#pragma mark
#pragma mark ------ GYChatToolsEmojiViewDelegate ------
- (void)GYChatToolsEmojiViewDidSelected:(id)obj{
    //获取当前光标位置
    NSRange selectedRange = _inputTx.selectedRange;
    NSAttributedString *emojiAttributedString = [[NSAttributedString alloc] initWithString:obj];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:_inputTx.attributedText];
    [attributedText replaceCharactersInRange:selectedRange withAttributedString:emojiAttributedString];
    self.inputTx.attributedText = attributedText;
    self.inputTx.selectedRange = NSMakeRange(selectedRange.location + emojiAttributedString.length, 0);
}

- (void)GYChatToolsEmojiViewCustomDidSelected:(GYChatEmojiModel *)obj{
    if (!obj.isLargeEmoji) {
        NSRange selectedRange = _inputTx.selectedRange;
        NSAttributedString *emojiAttributedString = [[NSAttributedString alloc] initWithString:obj.desc];
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:_inputTx.attributedText];
        [attributedText replaceCharactersInRange:selectedRange withAttributedString:emojiAttributedString];
        self.inputTx.attributedText = attributedText;
        self.inputTx.selectedRange = NSMakeRange(selectedRange.location + emojiAttributedString.length, 0);
        [self textViewDidChange:self.inputTx];
    }else{
        //gif图片
    }
}

- (void)GYChatToolsEmojiViewCustomDidDel:(GYChatEmojiModel *)obj{
    NSRange selectedRange = self.inputTx.selectedRange;
    if (selectedRange.location == 0 && selectedRange.length == 0) {
        return;
    }
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.inputTx.attributedText];
    if (selectedRange.length > 0) {
        [attributedText deleteCharactersInRange:selectedRange];
        self.inputTx.attributedText = attributedText;
        self.inputTx.selectedRange = NSMakeRange(selectedRange.location, 0);
    } else {
        NSUInteger deleteCharactersCount = 1;
        // 下面这段正则匹配是用来匹配文本中的所有系统自带的 emoji 表情，以确认删除按钮将要删除的是否是 emoji。这个正则匹配可以匹配绝大部分的 emoji，得到该 emoji 的正确的 length 值；不过会将某些 combined emoji（如 👨‍👩‍👧‍👦 👨‍👩‍👧‍👦 👨‍👨‍👧‍👧），这种几个 emoji 拼在一起的 combined emoji 则会被匹配成几个个体，删除时会把 combine emoji 拆成个体。瑕不掩瑜，大部分情况下表现正确，至少也不会出现删除 emoji 时崩溃的问题了。
        NSString *emojiPattern1 = @"[\\u2600-\\u27BF\\U0001F300-\\U0001F77F\\U0001F900-\\U0001F9FF]";
        NSString *emojiPattern2 = @"[\\u2600-\\u27BF\\U0001F300-\\U0001F77F\\U0001F900–\\U0001F9FF]\\uFE0F";
        NSString *emojiPattern3 = @"[\\u2600-\\u27BF\\U0001F300-\\U0001F77F\\U0001F900–\\U0001F9FF][\\U0001F3FB-\\U0001F3FF]";
        NSString *emojiPattern4 = @"[\\rU0001F1E6-\\U0001F1FF][\\U0001F1E6-\\U0001F1FF]";
        NSString *pattern = [[NSString alloc] initWithFormat:@"%@|%@|%@|%@", emojiPattern4, emojiPattern3, emojiPattern2, emojiPattern1];
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:kNilOptions error:NULL];
        NSArray<NSTextCheckingResult *> *matches = [regex matchesInString:attributedText.string options:kNilOptions range:NSMakeRange(0, attributedText.string.length)];
        for (NSTextCheckingResult *match in matches) {
            if (match.range.location + match.range.length == selectedRange.location) {
                deleteCharactersCount = match.range.length;
                break;
            }
        }
        [attributedText deleteCharactersInRange:NSMakeRange(selectedRange.location - deleteCharactersCount, deleteCharactersCount)];
        self.inputTx.attributedText = attributedText;
        self.inputTx.selectedRange = NSMakeRange(selectedRange.location - deleteCharactersCount, 0);
    }
    [self textViewDidChange:self.inputTx];
}

-(void)textViewDidChange:(UITextView *)textView{
    textView.typingAttributes = self.attributes;
    if (!textView.markedTextRange) {
        NSRange selectedRange = textView.selectedRange;
        NSAttributedString *attributedString = [[GYChatEmojiHelper share] replaceEmojiWithAttributedString:textView.attributedText attributes:self.attributes];
        NSUInteger offset = textView.attributedText.length - attributedString.length;
        textView.attributedText = attributedString;
        textView.selectedRange = NSMakeRange(selectedRange.location - offset, 0);
    }else {
        // 输入汉字拼音未确定状态, 不做处理
    }
}

#pragma mark
#pragma mark --- GYChatVoiceButtonDelegate ---
///开始录音
- (void)GYChatVoiceButtonStartRecord{
    
}

///结束发送录音
- (void)GYChatVoiceButtonSendRecord{
    
}
///结束取消录音
- (void)GYChatVoiceButtonCancleRecord{
    
}


#pragma mark
#pragma mark --- GYChatToolsMoreViewDelegate ---
///选择的索引
- (void)GYChatToolsMoreViewDidSelected:(NSInteger)index{
    
}

#pragma mark
#pragma mark ------ 事件 ------
///语音、文字切换
-(void)voiceBtnAction:(UIButton *)sender{
    if (_keyboardType != GYChateToolsKeyboardTypeVoice) {
        self.keyboardType = GYChateToolsKeyboardTypeVoice;
        [self.voiceBtn setImage:[UIImage imageNamed:@"chatBar_keyboard"] forState:UIControlStateNormal];
    }else{
        self.keyboardType = GYChateToolsKeyboardTypeSys;
        [self.voiceBtn setImage:[UIImage imageNamed:@"chatBar_record"] forState:UIControlStateNormal];
    }
}

///表情
-(void)emojiBtnAction:(UIButton *)sender{
    if (_keyboardType != GYChateToolsKeyboardTypeEmoji) {
        [self.voiceBtn setImage:[UIImage imageNamed:@"chatBar_record"] forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"chatBar_keyboard"] forState:UIControlStateNormal];
        [self.inputTx becomeFirstResponder];
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(K_CHAT_BAR_BOTTOM_HEIGHT);
        }];
        self.bottomView.hidden = NO;
//        [self.inputTx addGestureRecognizer:self.inputTapGes];
        self.keyboardType = GYChateToolsKeyboardTypeEmoji;
        [self.bottomView bringSubviewToFront:self.emojiView];
    }else{
        [self.voiceBtn setImage:[UIImage imageNamed:@"chatBar_record"] forState:UIControlStateNormal];
//        [self.inputTx removeGestureRecognizer:self.inputTapGes];
        self.keyboardType = GYChateToolsKeyboardTypeSys;
    }
    
}


///更多
-(void)moreBtnAction:(UIButton *)sender{
    self.keyboardType = GYChateToolsKeyboardTypeMore;
    [self.bottomView bringSubviewToFront:self.moreView];
}

///发送
-(void)sendBtnAction:(UIButton *)sender{
    
}



-(void)inputTapGesAction:(UITapGestureRecognizer *)sender{
//    self.keyboardType = GYChateToolsKeyboardTypeSys;
}



@end
