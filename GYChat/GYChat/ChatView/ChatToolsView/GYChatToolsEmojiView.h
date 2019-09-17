//
//  GYChatToolsEmojiView.h
//  GYChat
//
//  Created by gyy on 2019/9/16.
//  Copyright © 2019 古耀耀. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GYChatEmojiModel;

@protocol GYChatToolsEmojiViewDelegate <NSObject>

@optional

/// 点击了表情
-(void)GYChatToolsEmojiViewDidSelected:(id)obj;


///点击自定义的表情
-(void)GYChatToolsEmojiViewCustomDidSelected:(GYChatEmojiModel *)obj;

///删除自定义的表情
-(void)GYChatToolsEmojiViewCustomDidDel:(GYChatEmojiModel *)obj;

@end

@interface GYChatToolsEmojiView : UIView


@property (assign, nonatomic) id<GYChatToolsEmojiViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
