//
//  GYChatVoiceButton.h
//  GYChat
//
//  Created by gyy on 2019/9/12.
//  Copyright © 2019 古耀耀. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GYChatVoiceButtonDelegate <NSObject>

@optional

/**
 开始录音
 */
-(void)GYChatVoiceButtonStartRecord;


/**
 发送录音
 */
-(void)GYChatVoiceButtonSendRecord;


/**
 取消录音
 */
-(void)GYChatVoiceButtonCancleRecord;


@end

@interface GYChatVoiceButton : UIButton

@property (assign, nonatomic) id<GYChatVoiceButtonDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
