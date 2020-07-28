//
//  PopoverViewCell.m
//  PopoverView
//
//  Created by WangJie on 2020/7/28.
//  Copyright © 2020 WangJie. All rights reserved.
//

#import "PopoverViewCell.h"

@interface PopoverViewCell ()
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation PopoverViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initialize];
    }
    return self;
}

- (void)setStyle:(PopoverViewStyle)style {
    _style = style;
    self.bottomLine.backgroundColor = [[self class] bottomLineColorForStyle:style];
    if (style == PopoverViewStyleDefault) {
        [self.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    } else {
        [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

- (void)initialize {
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.titleLabel.font = [[self class] titleFont];
    self.button.backgroundColor = self.backgroundColor;
    self.button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.contentView addSubview:self.button];
    self.button.userInteractionEnabled = NO;
    
    self.bottomLine = [[UIView alloc] init];
    self.bottomLine.backgroundColor = [UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1.00];
    [self.contentView addSubview:self.bottomLine];
}

- (void)layoutSubviews {
    self.button.frame = CGRectMake(PopoverViewCellHorizontalMargin, PopoverViewCellVerticalMargin, self.frame.size.width - PopoverViewCellHorizontalMargin * 2, self.frame.size.height - PopoverViewCellVerticalMargin * 2);
    self.bottomLine.frame = CGRectMake(0, self.frame.size.height - (1/[UIScreen mainScreen].scale), self.frame.size.width, 1 / [UIScreen mainScreen].scale);
}

+ (UIFont *)titleFont {
    return [UIFont systemFontOfSize:15.f];
}

+ (UIColor *)bottomLineColorForStyle:(PopoverViewStyle)style {
    return style == PopoverViewStyleDefault ? [UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1.0] : [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0];
}

- (void)setAction:(PopoverAction *)action {
    [self.button setImage:action.image forState:UIControlStateNormal];
    [self.button setTitle:action.title forState:UIControlStateNormal];
    self.button.titleEdgeInsets = action.image ? UIEdgeInsetsMake(0, PopoverViewCellTitleLeftEdge, 0, -PopoverViewCellTitleLeftEdge) : UIEdgeInsetsZero;
}

- (void)showBottomLine:(BOOL)show {
    _bottomLine.hidden = !show;
}

@end
