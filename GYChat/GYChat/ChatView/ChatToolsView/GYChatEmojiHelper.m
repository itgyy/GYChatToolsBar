//
//  GYChatEmojiHelper.m
//  GYChat
//
//  Created by gyy on 2019/9/16.
//  Copyright © 2019 古耀耀. All rights reserved.
//

#import "GYChatEmojiHelper.h"
#import "GYChatEmojiModel.h"

#define EMOJI_CODE_TO_SYMBOL(x) ((((0x808080F0 | (x & 0x3F000) >> 4) | (x & 0xFC0) << 10) | (x & 0x1C0000) << 18) | (x & 0x3F) << 24);
static GYChatEmojiHelper *helper = nil;
@implementation GYChatEmojiHelper

+(instancetype)share{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[GYChatEmojiHelper alloc] init];
    });
    return helper;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _convertEmojiDic = @{@"[):]":@"😊", @"[:D]":@"😃", @"[;)]":@"😉", @"[:-o]":@"😮", @"[:p]":@"😋", @"[(H)]":@"😎", @"[:@]":@"😡", @"[:s]":@"😖", @"[:$]":@"😳", @"[:(]":@"😞", @"[:'(]":@"😭", @"[:|]":@"😐", @"[(a)]":@"😇", @"[8o|]":@"😬", @"[8-|]":@"😆", @"[+o(]":@"😱", @"[<o)]":@"🎅", @"[|-)]":@"😴", @"[*-)]":@"😕", @"[:-#]":@"😷", @"[:-*]":@"😯", @"[^o)]":@"😏", @"[8-)]":@"😑", @"[(|)]":@"💖", @"[(u)]":@"💔", @"[(S)]":@"🌙", @"[(*)]":@"🌟", @"[(#)]":@"🌞", @"[(R)]":@"🌈", @"[(})]":@"😚", @"[({)]":@"😍", @"[(k)]":@"💋", @"[(F)]":@"🌹", @"[(W)]":@"🍂", @"[(D)]":@"👍"};
    }
    return self;
}

+ (NSArray<NSString *> *)getAllEmojis
{
    NSArray *emojis = @[[GYChatEmojiHelper emojiWithCode:0x1F60a],
                        [GYChatEmojiHelper emojiWithCode:0x1F603],
                        [GYChatEmojiHelper emojiWithCode:0x1F609],
                        [GYChatEmojiHelper emojiWithCode:0x1F62e],
                        [GYChatEmojiHelper emojiWithCode:0x1F60b],
                        [GYChatEmojiHelper emojiWithCode:0x1F60e],
                        [GYChatEmojiHelper emojiWithCode:0x1F621],
                        [GYChatEmojiHelper emojiWithCode:0x1F616],
                        [GYChatEmojiHelper emojiWithCode:0x1F633],
                        [GYChatEmojiHelper emojiWithCode:0x1F61e],
                        [GYChatEmojiHelper emojiWithCode:0x1F62d],
                        [GYChatEmojiHelper emojiWithCode:0x1F610],
                        [GYChatEmojiHelper emojiWithCode:0x1F607],
                        [GYChatEmojiHelper emojiWithCode:0x1F62c],
                        [GYChatEmojiHelper emojiWithCode:0x1F606],
                        [GYChatEmojiHelper emojiWithCode:0x1F631],
                        [GYChatEmojiHelper emojiWithCode:0x1F385],
                        [GYChatEmojiHelper emojiWithCode:0x1F634],
                        [GYChatEmojiHelper emojiWithCode:0x1F615],
                        [GYChatEmojiHelper emojiWithCode:0x1F637],
                        [GYChatEmojiHelper emojiWithCode:0x1F62f],
                        [GYChatEmojiHelper emojiWithCode:0x1F60f],
                        [GYChatEmojiHelper emojiWithCode:0x1F611],
                        [GYChatEmojiHelper emojiWithCode:0x1F496],
                        [GYChatEmojiHelper emojiWithCode:0x1F494],
                        [GYChatEmojiHelper emojiWithCode:0x1F319],
                        [GYChatEmojiHelper emojiWithCode:0x1f31f],
                        [GYChatEmojiHelper emojiWithCode:0x1f31e],
                        [GYChatEmojiHelper emojiWithCode:0x1F308],
                        [GYChatEmojiHelper emojiWithCode:0x1F60d],
                        [GYChatEmojiHelper emojiWithCode:0x1F61a],
                        [GYChatEmojiHelper emojiWithCode:0x1F48b],
                        [GYChatEmojiHelper emojiWithCode:0x1F339],
                        [GYChatEmojiHelper emojiWithCode:0x1F342],
                        [GYChatEmojiHelper emojiWithCode:0x1F44d]];
    
    return emojis;
}

+ (BOOL)isStringContainsEmoji:(NSString *)aString
{
    __block BOOL ret = NO;
    [aString enumerateSubstringsInRange:NSMakeRange(0, [aString length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        const unichar hs = [substring characterAtIndex:0];
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    ret = YES;
                }
            }
        } else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3) {
                ret = YES;
            }
        } else {
            if (0x2100 <= hs && hs <= 0x27ff) {
                ret = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                ret = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                ret = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                ret = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                ret = YES;
            }
        }
    }];
    
    return ret;
}

+ (NSString *)convertEmoji:(NSString *)aString
{
    NSDictionary *emojisDic = [GYChatEmojiHelper share].convertEmojiDic;
    NSRange range;
    range.location = 0;
    
    NSMutableString *retStr = [NSMutableString stringWithString:aString];
    for (NSString *key in emojisDic) {
        range.length = retStr.length;
        NSString *value = emojisDic[key];
        [retStr replaceOccurrencesOfString:key withString:value options:NSLiteralSearch range:range];
    }
    
    return retStr;
}

+ (NSString *)emojiWithCode:(int)aCode
{
    int sym = EMOJI_CODE_TO_SYMBOL(aCode);
    return [[NSString alloc] initWithBytes:&sym length:sizeof(sym) encoding:NSUTF8StringEncoding];
}






+(NSArray *)getAllCustomEmojis{
    NSString *emojiBundlePath = [[NSBundle mainBundle] pathForResource:@"EmojiPackage" ofType:@"bundle"];
    NSBundle *emojiBundle = [NSBundle bundleWithPath:emojiBundlePath];
    NSString *emojiPath = [emojiBundle pathForResource:@"EmojiPackageList" ofType:@"plist"];
    NSMutableArray *emojiPackageList = [NSMutableArray array];
    NSArray<NSDictionary *> *emojiArray = [NSArray arrayWithContentsOfFile:emojiPath];
    for (int i = 0; i < emojiArray.count; i ++) {
        GYChatEmojiGroupModel *groupModel = [[GYChatEmojiGroupModel alloc] initWithDic:emojiArray[i]];
        [emojiPackageList addObject:groupModel];
    }
    [GYChatEmojiHelper share].emojiPackages = emojiPackageList;
    return emojiPackageList;
}

- (NSMutableAttributedString *)replaceEmojiWithAttributedString:(NSAttributedString *)attributedString attributes:(nullable NSDictionary<NSAttributedStringKey, id> *)attributes {
    if (attributedString.length == 0) {
        return nil;
    }
    NSMutableAttributedString *targetAttStr = [[NSMutableAttributedString alloc] initWithAttributedString:attributedString];
    if (attributes) {
        [targetAttStr addAttributes:attributes range:NSMakeRange(0, attributedString.length)];
    }
    NSError *error = nil;
    NSRegularExpression *regExp = [[NSRegularExpression alloc] initWithPattern:@"\\[/\\w+\\]" options:NSRegularExpressionCaseInsensitive error:&error];
    if (!error && attributedString != nil && attributedString.length != 0) {
        NSArray *resultArr = [regExp matchesInString:attributedString.string options:0 range:NSMakeRange(0, attributedString.length)];
        UIFont *font = attributes[NSFontAttributeName];
        NSUInteger base = 0;
        //> 遍历匹配结果进行替换
        for (NSTextCheckingResult *result in resultArr) {
            ///> 要替换的字符串
            NSAttributedString *emojStr = [attributedString attributedSubstringFromRange:result.range];
            ///> 判断表情包里边是否包含该表情
            GYChatEmojiModel *emoji = [self isContainObjectWith:emojStr.string];
            if (emoji) {    ///> 如果表情包里边有该表情, 则进行替换, 如果没有不进行操作
                YBTextAttachment *attachment = [YBTextAttachment attachmentWith:emoji font:font];
                ///> 创建包含表情图片的属性字符串
                NSAttributedString *tempAttributedStr = [NSAttributedString attributedStringWithAttachment:attachment];
                ///> 将包含表情图片的属性字符串将表情文字替换掉
                [targetAttStr replaceCharactersInRange:NSMakeRange(result.range.location - base, result.range.length) withAttributedString:tempAttributedStr];
                base = base + emojStr.length - tempAttributedStr.length;
            }
        }
    }
    return targetAttStr;
}

///> 判断表情包所有key中是否含有相同的字符串(表情)
- (GYChatEmojiModel *)isContainObjectWith:(NSString *)str {
    GYChatEmojiModel *emoji = nil;
    for (GYChatEmojiGroupModel *groupModel in self.emojiPackages) {
        if (!groupModel.isLargeEmoji) {
            for (GYChatEmojiModel *emojiModel in groupModel.emojis) {
                if ([str isEqualToString:emojiModel.desc]) {
                    emoji = emojiModel;
                    break;
                }
            }
        }
    }
    return emoji;
}

@end


@implementation YBTextAttachment
+ (YBTextAttachment *)attachmentWith:(GYChatEmojiModel *)emoji font:(UIFont *)font {
    YBTextAttachment *attachment = [[YBTextAttachment alloc] init];
    attachment.desc = emoji.desc;
    attachment.imageName = emoji.imageName;
    attachment.bounds = CGRectMake(0, font.descender, font.lineHeight, font.lineHeight);
    attachment.image = emoji.image;
    return attachment;
}


@end
