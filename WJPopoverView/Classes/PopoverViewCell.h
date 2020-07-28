//
//  PopoverViewCell.h
//  PopoverView
//
//  Created by WangJie on 2020/7/28.
//  Copyright © 2020 WangJie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopoverAction.h"
NS_ASSUME_NONNULL_BEGIN

@interface PopoverViewCell : UITableViewCell

@property (nonatomic, assign) PopoverViewStyle style;

+ (UIFont *)titleFont;

+ (UIColor *)bottomLineColorForStyle:(PopoverViewStyle)style;
- (void)setAction:(PopoverAction *)action;
- (void)showBottomLine:(BOOL)show;
@end

NS_ASSUME_NONNULL_END
