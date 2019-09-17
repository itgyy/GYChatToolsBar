//
//  GYChatEmojiHelper.h
//  GYChat
//
//  Created by gyy on 2019/9/16.
//  Copyright © 2019 古耀耀. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class GYChatEmojiModel;

@interface YBTextAttachment : NSTextAttachment
+ (YBTextAttachment *)attachmentWith:(GYChatEmojiModel *)emoji font:(UIFont *)font;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *imageName;
@end


@interface GYChatEmojiHelper : NSObject
@property (nonatomic, strong) NSDictionary *convertEmojiDic;
+(instancetype)share;
+ (NSString *)convertEmoji:(NSString *)aString;
+ (NSArray<NSString *> *)getAllEmojis;


@property (strong, nonatomic) NSArray *emojiPackages;
+(NSArray *)getAllCustomEmojis;
- (NSMutableAttributedString *)replaceEmojiWithAttributedString:(NSAttributedString *)attributedString attributes:(nullable NSDictionary<NSAttributedStringKey, id> *)attributes;

@end

