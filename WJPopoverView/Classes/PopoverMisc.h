//
//  PopoverMisc.h
//  PopoverView
//
//  Created by WangJie on 2020/7/28.
//  Copyright © 2020 WangJie. All rights reserved.
//

#ifndef PopoverMisc_h
#define PopoverMisc_h

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PopoverViewArrowStyle) {
    PopoverViewArrowStyleRound,
    PopoverViewArrowStyleTriangle
};

typedef NS_ENUM(NSUInteger, PopoverViewStyle) {
    PopoverViewStyleDefault, // 默认风格, 白色
    PopoverViewStyleDark, // 黑色风格
};


static CGFloat const kPopoverViewMargin = 8.f;          /// 边距
static CGFloat const kPopoverViewCellHeight = 40.f;     /// cell高度
static CGFloat const kPopoverViewArrowHeight = 13.f;    /// 箭头高度

static CGFloat const PopoverViewCellHorizontalMargin = 15.f; ///< 水平边距
static CGFloat const PopoverViewCellVerticalMargin = 3.f; ///< 垂直边距
static CGFloat const PopoverViewCellTitleLeftEdge = 8.f; ///< 标题左边边距

#endif /* PopoverMisc_h */
