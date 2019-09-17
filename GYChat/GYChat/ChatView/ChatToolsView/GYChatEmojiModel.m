//
//  GYChatEmojiModel.m
//  GYChat
//
//  Created by gyy on 2019/9/16.
//  Copyright © 2019 古耀耀. All rights reserved.
//

#import "GYChatEmojiModel.h"

@implementation GYChatEmojiModel

@end







@implementation GYChatEmojiGroupModel
-(instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        self.cover_pic = dic[@"cover_pic"];
        self.title = dic[@"title"];
        self.folderName = dic[@"folderName"];
        self.isLargeEmoji = [dic[@"isLargeEmoji"] boolValue];

        NSString *emojiBundlePath = [[NSBundle mainBundle] pathForResource:@"EmojiPackage" ofType:@"bundle"];
        NSString *sourcePath = [[NSBundle bundleWithPath:emojiBundlePath] pathForResource:self.folderName ofType:nil];
        self.image = [UIImage imageWithContentsOfFile:[sourcePath stringByAppendingPathComponent:self.cover_pic]];
        if (self.isLargeEmoji) {
            //gif
            NSMutableArray *ary = [[NSMutableArray alloc] initWithCapacity:0];
            NSArray *emojisAry = dic[@"emojis"];
            for (int i = 0; i < emojisAry.count; i ++) {
                NSDictionary *item = dic[@"emojis"][i];
                GYChatEmojiModel *model = [[GYChatEmojiModel alloc] init];
                NSString *imagePath = [sourcePath stringByAppendingPathComponent:item[@"image"]];
                model.isLargeEmoji = YES;
                model.desc = item[@"desc"];
                model.imageName = imagePath;
                model.image = [UIImage imageWithContentsOfFile:imagePath];
                [ary addObject:model];
            }
            self.emojis = ary;
        }else{
            NSMutableArray *ary = [[NSMutableArray alloc] initWithCapacity:0];
            NSArray *emojisAry = dic[@"emojis"];
            for (int i = 0; i < emojisAry.count; i ++) {
                NSDictionary *item = dic[@"emojis"][i];
                GYChatEmojiModel *model = [[GYChatEmojiModel alloc] init];
                NSString *imagePath = [sourcePath stringByAppendingPathComponent:item[@"image"]];
                model.isDel = NO;
                model.desc = item[@"desc"];
                model.imageName = imagePath;
                model.image = [UIImage imageWithContentsOfFile:imagePath];
                model.isLargeEmoji = NO;
                [ary addObject:model];
                if (i == (i/21)*21 + 20) {
                    GYChatEmojiModel *model = [[GYChatEmojiModel alloc] init];
                    model.isDel = YES;
                    model.desc = @"[/del]";
                    model.imageName = @"delete-emoji";
                    model.image = [UIImage imageNamed:@"delete-emoji"];
                    model.isLargeEmoji = NO;
                    [ary insertObject:model atIndex:i];
                }
            }
            //在最后加上一个
            GYChatEmojiModel *model = [[GYChatEmojiModel alloc] init];
            model.isDel = YES;
            model.desc = @"[/del]";
            model.imageName = @"delete-emoji";
            model.image = [UIImage imageNamed:@"delete-emoji"];
            model.isLargeEmoji = NO;
            [ary addObject:model];
            self.emojis = ary;
        }
    }
    return self;
}

@end
