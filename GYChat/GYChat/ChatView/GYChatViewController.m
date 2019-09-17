//
//  GYChatViewController.m
//  GYChat
//
//  Created by gyy on 2019/9/12.
//  Copyright © 2019 古耀耀. All rights reserved.
//

#import "GYChatViewController.h"
#import "GYChatView.h"
#import "GYChatToolsView.h"
#import "GYChatMacro.h"
#import "UIView+GY.h"

@interface GYChatViewController ()

@property (strong, nonatomic) GYChatView *chatView;
@property (strong, nonatomic) GYChatToolsView *toolsView;
@end

@implementation GYChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    
    
    
    __weak typeof(self) weakSelf = self;
    
    _chatView = [[GYChatView alloc] init];
    [self.view addSubview:_chatView];
   
    
    _toolsView = [[GYChatToolsView alloc] init];
    [self.view addSubview:_toolsView];
    [_toolsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.view);
    }];
    
    [_chatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.toolsView.mas_top);
    }];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];

}


#pragma mark --键盘弹出
- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //计算控制器的view需要平移的距离
    CGFloat transformY = keyboardFrame.origin.y - self.view.frame.size.height;
    
    __weak typeof(self) weakSelf = self;
    //执行动画
    [UIView animateWithDuration:duration animations:^{
        [_toolsView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).offset(-keyboardFrame.size.height);
        }];
    }];
}
#pragma mark --键盘收回
- (void)keyboardDidHide:(NSNotification *)notification{
    __weak typeof(self) weakSelf = self;
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        [_toolsView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).offset(0);
        }];
    }];
}




- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.toolsView.isFirstResponse = NO;
}





@end
