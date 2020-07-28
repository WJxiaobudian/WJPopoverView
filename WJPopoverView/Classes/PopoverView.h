//
//  PopoverView.h
//  PopoverView
//
//  Created by WangJie on 2020/7/28.
//  Copyright © 2020 WangJie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopoverViewCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface PopoverView : UIView

/// 弹窗风格 默认 PopoverViewStyleDefault（白色）
@property (nonatomic, assign) PopoverViewStyle style;
/// 箭头样式 默认 PopoverViewArrowStyleRound
@property (nonatomic, assign) PopoverViewArrowStyle arrowStyle;

+ (instancetype)shareInstance;

/// 指定的view显示弹窗
- (void)showToView:(UIView *)pointView withActions:(NSArray *)actions;
/// 指定的point显示弹窗
- (void)showToPoint:(CGPoint)point withActions:(NSArray *)actions;
@end

NS_ASSUME_NONNULL_END
