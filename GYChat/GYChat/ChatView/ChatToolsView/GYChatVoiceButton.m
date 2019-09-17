//
//  GYChatVoiceButton.m
//  GYChat
//
//  Created by gyy on 2019/9/12.
//  Copyright © 2019 古耀耀. All rights reserved.
//

#import "GYChatVoiceButton.h"
#import <Masonry/Masonry.h>
#import "GYChatVoiceHudView.h"

@interface GYChatVoiceButton()
@property (strong, nonatomic) UIImageView *iconView;
@property (strong, nonatomic) UILabel *desLab;

@property (strong, nonatomic) UILongPressGestureRecognizer *longTap;
@property (strong, nonatomic) GYChatVoiceHudView *hudView;

@end

@implementation GYChatVoiceButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUI];
        self.longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTapAction:)];
        self.longTap.minimumPressDuration = 0.5;
        [self addGestureRecognizer:self.longTap];
    }
    return self;
}

-(void)setUI{
    self.hudView = [[GYChatVoiceHudView alloc] init];
    
    _iconView = [UIImageView new];
    _iconView.image = [UIImage imageNamed:@"录音"];
    [self addSubview:_iconView];
    
    _desLab = [UILabel new];
    _desLab.text = @"长按录音";
    _desLab.font = [UIFont systemFontOfSize:13.0f];
    _desLab.textColor = [UIColor blackColor];
    [self addSubview:_desLab];
    
    __weak typeof(self) weakSelf = self;
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.size.mas_offset(CGSizeMake(15, 15));
        make.left.equalTo(weakSelf.desLab.mas_right).offset(10);
    }];
    
    [_desLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.centerX.equalTo(weakSelf.mas_centerX).offset(-12);
    }];
}


-(void)longTapAction:(UIGestureRecognizer *)sender{
    CGPoint startPoint;
    CGPoint endPoint;
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
        {
            NSLog(@"长按开始");
            //开始动画
            [self.hudView show];
            _desLab.text = @"上滑取消";
            if (_delegate && [_delegate respondsToSelector:@selector(GYChatVoiceButtonStartRecord)]) {
                [_delegate GYChatVoiceButtonStartRecord];
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            [self.hudView dismiss];
            CGPoint point =  [sender locationInView:self.superview];
            if (fabsf(point.y) >= 150.0) {
                if (_delegate && [_delegate respondsToSelector:@selector(GYChatVoiceButtonCancleRecord)]) {
                    [_delegate GYChatVoiceButtonCancleRecord];
                }
            }else{
                if (_delegate && [_delegate respondsToSelector:@selector(GYChatVoiceButtonSendRecord)]) {
                    [_delegate GYChatVoiceButtonSendRecord];
                }
            }
            _desLab.text = @"长按录音";
        }
            break;
            
        default:
            break;
    }
}



@end
