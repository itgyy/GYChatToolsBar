//
//  GYChatToolsMoreView.h
//  GYChat
//
//  Created by gyy on 2019/9/16.
//  Copyright © 2019 古耀耀. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GYChatToolsMoreViewDelegate <NSObject>

///选择的索引
-(void)GYChatToolsMoreViewDidSelected:(NSInteger)index;

@end
@interface GYChatToolsMoreView : UIView

@property (assign, nonatomic) id<GYChatToolsMoreViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
