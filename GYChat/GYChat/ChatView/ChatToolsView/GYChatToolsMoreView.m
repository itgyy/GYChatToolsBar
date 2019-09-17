//
//  GYChatToolsMoreView.m
//  GYChat
//
//  Created by gyy on 2019/9/16.
//  Copyright © 2019 古耀耀. All rights reserved.
//

#import "GYChatToolsMoreView.h"
#import "UIView+GY.h"
#import "GYChatMacro.h"


@interface GYChatToolsMoreViewItemView : UIButton
@property (strong, nonatomic) UIImageView *iconView;
@property (strong, nonatomic) UILabel *titleLab;
@end
@implementation GYChatToolsMoreViewItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, frame.size.width - 20, frame.size.height - 50)];
        _iconView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_iconView];
        
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_iconView.frame) + 10, frame.size.width - 20, 20)];
        _titleLab.textColor = [UIColor blackColor];
        _titleLab.font = [UIFont systemFontOfSize:11.0f];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLab];
    }
    return self;
}
@end










@interface GYChatToolsMoreView()
@property (strong, nonatomic) NSArray *titleArys;
@property (strong, nonatomic) NSArray *iconArys;
@end
@implementation GYChatToolsMoreView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initUI];
    }
    return self;
}

-(void)initUI{
    _titleArys = [[NSArray alloc] initWithObjects:@"相册",@"视频",@"位置", nil];
    _iconArys = [[NSArray alloc] initWithObjects:@"icon_msg_photos",@"icon_msg_video",@"icon_msg_location", nil];
    
    for (int i = 0; i < _titleArys.count; i ++) {
        GYChatToolsMoreViewItemView *item = [[GYChatToolsMoreViewItemView alloc] initWithFrame:CGRectMake(K_SCREEN_WIDTH/4 *i, 0, K_SCREEN_WIDTH/4, K_CHAT_BAR_BOTTOM_HEIGHT/2)];
        item.titleLab.text = _titleArys[i];
        item.iconView.image = [UIImage imageNamed:_iconArys[i]];
        item.tag = i;
        [item addTarget:self action:@selector(itemAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:item];
    }
}


-(void)itemAction:(GYChatToolsMoreViewItemView *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(GYChatToolsMoreViewDidSelected:)]) {
        [_delegate GYChatToolsMoreViewDidSelected:sender.tag];
    }
}


@end
