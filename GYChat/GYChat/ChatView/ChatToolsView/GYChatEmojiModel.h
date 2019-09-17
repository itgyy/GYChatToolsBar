//
//  GYChatEmojiModel.h
//  GYChat
//
//  Created by gyy on 2019/9/16.
//  Copyright © 2019 古耀耀. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface GYChatEmojiModel : NSObject
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *imageName;
@property (assign, nonatomic) BOOL isDel;
@property (assign, nonatomic) BOOL isLargeEmoji;

@end




@interface GYChatEmojiGroupModel : NSObject
@property (strong, nonatomic) NSString *cover_pic;
@property (strong, nonatomic) NSArray *emojis;
@property (strong, nonatomic) NSString *folderName;
@property (assign, nonatomic) BOOL isLargeEmoji;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) UIImage *image;
-(instancetype)initWithDic:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
