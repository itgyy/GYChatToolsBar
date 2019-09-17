//
//  GYChatInputView.h
//  GYChat
//
//  Created by gyy on 2019/9/12.
//  Copyright © 2019 古耀耀. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GYChatInputViewDelegate  <NSObject>

@optional

///开始编辑
-(void)GYChatInputViewShouldBegin;

///高度变化
-(void)GYChatInputViewHeightChange:(CGFloat)height;

///改变
-(void)GYChatInputViewDidChange;

///结束编辑
-(void)GYChatInputViewDidEnd;

@end


@interface GYChatInputView : UITextView<UITextViewDelegate>

@property (assign, nonatomic) id<GYChatInputViewDelegate>gy_delegate;

@end

NS_ASSUME_NONNULL_END
