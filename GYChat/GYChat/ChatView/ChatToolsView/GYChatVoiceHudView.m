//
//  GYChatVoiceHudView.m
//  GYChat
//
//  Created by gyy on 2019/9/17.
//  Copyright © 2019 古耀耀. All rights reserved.
//

#import "GYChatVoiceHudView.h"
#import "UIView+GY.h"
#import "GYChatMacro.h"

@interface GYChatVoiceHudView()
@property (strong, nonatomic) NSMutableArray *imagesAry;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *hudLab;

@end


@implementation GYChatVoiceHudView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}

-(void)initUI{
    _imagesAry = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 25; i < 88; i ++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"animate_000%d",i]];
        [_imagesAry addObject:image];
    }
    self.width = K_SCREEN_WIDTH/3;
    self.height = self.width;
    self.center = CGPointMake(K_SCREEN_WIDTH/2, K_SCREEN_HEITHG/2);
    self.backgroundColor = [UIColor lightGrayColor];
    self.layer.cornerRadius = 4;
    self.clipsToBounds = YES;
    
    _imageView = [[UIImageView alloc] init];
    _imageView.frame = CGRectMake(0, 0, self.width, self.height);
    [self addSubview:_imageView];
    _imageView.animationImages = _imagesAry;
    
}



-(void)show{
    [[[UIApplication sharedApplication].delegate window] addSubview:self];
    [_imageView startAnimating];
}

-(void)dismiss{
    [_imageView stopAnimating];
    [self removeFromSuperview];
}

@end
