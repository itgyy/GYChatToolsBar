//
//  GYChatInputView.m
//  GYChat
//
//  Created by gyy on 2019/9/12.
//  Copyright © 2019 古耀耀. All rights reserved.
//

#import "GYChatInputView.h"
#import "UIView+GY.h"
#import "GYChatMacro.h"


@interface GYChatInputView()<UITextViewDelegate>
@property (assign, nonatomic) CGFloat minH;
@end

@implementation GYChatInputView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.delegate = self;
    }
    return self;
}



- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [self updateView];
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if (_gy_delegate && [_gy_delegate respondsToSelector:@selector(GYChatInputViewShouldBegin)]) {
        [_gy_delegate GYChatInputViewShouldBegin];
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    [self updateView];
    if (_gy_delegate && [_gy_delegate respondsToSelector:@selector(GYChatInputViewHeightChange:)]) {
        [_gy_delegate GYChatInputViewHeightChange:self.height];
    }
    if (_gy_delegate && [_gy_delegate respondsToSelector:@selector(GYChatInputViewDidChange)]) {
        [_gy_delegate GYChatInputViewDidChange];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if (_gy_delegate && [_gy_delegate respondsToSelector:@selector(GYChatInputViewDidEnd)]) {
        [_gy_delegate GYChatInputViewDidEnd];
    }
}

- (void)textViewDidChange:(UITextView *)textView{
    
}



-(void)updateView{
    CGSize strSize = [self sizeThatFits:CGSizeMake(self.width, MAXFLOAT)];
    if (strSize.height <= K_INPUT_MIN_H) {
        self.contentInset = UIEdgeInsetsMake((K_INPUT_MIN_H - strSize.height)/2, 0, 0, 0);
        self.height = K_INPUT_MIN_H;
    }else{
        self.contentInset = UIEdgeInsetsZero;
        if (strSize.height >= K_INPUT_MAX_H) {
            self.height = K_INPUT_MAX_H;
        }else{
            self.height = strSize.height;
        }
    }
}


@end
