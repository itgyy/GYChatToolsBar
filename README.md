# GYChatToolsBar
iOS聊天输入框

GYChatMacro.h 
  宏定义（详细可见：https://github.com/itgyy/GYMacro）

1、下载-> 进入工程目录-> pod install
2、引入
    __weak typeof(self) weakSelf = self;
    _toolsView = [[GYChatToolsView alloc] init];
    [self.view addSubview:_toolsView];
    [_toolsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.view);
    }];
 3、键盘事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];

- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat transformY = keyboardFrame.origin.y - self.view.frame.size.height;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:duration animations:^{
        [_toolsView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).offset(-keyboardFrame.size.height);
        }];
    }];
}

- (void)keyboardDidHide:(NSNotification *)notification{
    __weak typeof(self) weakSelf = self;
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        [_toolsView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).offset(0);
        }];
    }];
}

4、输入框取消第一响应
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.toolsView.isFirstResponse = NO;
}



