//
//  UIView+GY.h
//  GYChat
//
//  Created by gyy on 2019/9/12.
//  Copyright © 2019 古耀耀. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (GY)

@property (nonatomic, assign) CGSize size;

@property (nonatomic,assign)  CGFloat x;

@property  (nonatomic,assign) CGFloat y;

@property (nonatomic, assign) CGFloat top;

@property (nonatomic, assign) CGFloat bottom;

@property (nonatomic, assign) CGFloat left;

@property (nonatomic, assign) CGFloat right;

@property (nonatomic, assign) CGFloat centerX;

@property (nonatomic, assign) CGFloat centerY;

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGFloat height;

@end

NS_ASSUME_NONNULL_END
