//
//  PopoverView.m
//  PopoverView
//
//  Created by WangJie on 2020/7/28.
//  Copyright © 2020 WangJie. All rights reserved.
//

#import "PopoverView.h"

static NSString *kPopoverCellReuseId = @"kPopoverCellReuseId";

float PopoverViewDegressToRadians(float angle) {
    return angle *M_PI/180;
}

@interface PopoverView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UIWindow *keyWindow;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *shadeView;
@property (nonatomic, strong) NSArray *actions;
@property (nonatomic, assign) CGFloat windowWidth;
@property (nonatomic, assign) CGFloat windowHeight;
@property (nonatomic, assign) BOOL isUpward;

@end

@implementation PopoverView

+ (instancetype)shareInstance {
     return [[PopoverView alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    _actions = [NSArray array];
    _isUpward = YES;
    _style = PopoverViewStyleDefault;
    _arrowStyle = PopoverViewArrowStyleRound;
    self.backgroundColor = [UIColor whiteColor];
    _keyWindow = [UIApplication sharedApplication].keyWindow;
    _windowWidth = CGRectGetWidth(_keyWindow.frame);
    _windowHeight = CGRectGetHeight(_keyWindow.frame);
    _shadeView = [[UIView alloc] initWithFrame:_keyWindow.bounds];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHide)];
    [_shadeView addGestureRecognizer:tap];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.estimatedRowHeight = 0.f;
    _tableView.showsVerticalScrollIndicator = NO;
    [self addSubview:_tableView];
    
}

- (void)layoutSubviews {
    self.tableView.frame = CGRectMake(0, self.isUpward ? kPopoverViewArrowHeight : 0,
                                  CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - kPopoverViewArrowHeight);
}

/// 可以使用图片替代
- (void)showToPoint:(CGPoint)point {
    CGFloat arrowWidth = 28.f;
    CGFloat cornerRadius = 6.f;
    CGFloat arrowCornerRadius = 2.5f;
    CGFloat arrowBottomCornerRadius = 4.f;
    
    if (_arrowStyle == PopoverViewArrowStyleTriangle) {
        arrowWidth = 22.f;
    }
    CGFloat minHorizontalEdge = kPopoverViewMargin + cornerRadius + arrowWidth / 2 + 2;
    if (point.x < minHorizontalEdge) {
        point.x = minHorizontalEdge;
    }
    if (_windowWidth - point.x < minHorizontalEdge) {
        point.x = _windowWidth - minHorizontalEdge;
    }
    
    _shadeView.alpha = 0.f;
    [_keyWindow addSubview:_shadeView];
    
    [_tableView reloadData];
    CGFloat currentW = [self calculateMaxWidth];
    CGFloat currentH = _tableView.contentSize.height;
    if (self.actions.count == 0) {
        currentW = 150.f;
        currentH = 20.f;
    }
    currentH += kPopoverViewArrowHeight;
    CGFloat maxHeight = _isUpward ? (_windowHeight - point.y - kPopoverViewMargin) : (point.y - CGRectGetHeight([UIApplication sharedApplication].statusBarFrame));
    if (currentH > maxHeight) {
        currentH = maxHeight;
        _tableView.scrollEnabled = YES;
        if (!_isUpward) {
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_actions.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }
    
    CGFloat currentX = point.x - currentW / 2;
    CGFloat currentY = point.y;
    /// 窗口靠左
    if (point.x <= currentW / 2 + kPopoverViewMargin) {
        currentX = kPopoverViewMargin;
    }
    /// 窗口靠右
    if (_windowWidth - point.x <= currentW / 2 + kPopoverViewMargin) {
        currentX = _windowWidth - kPopoverViewMargin - currentW;
    }
    /// 箭头向下
    if (!_isUpward) {
        currentY = point.y - currentH;
    }
    self.frame = CGRectMake(currentX, currentY, currentW, currentH);
    /// 截取箭头
    CGPoint arrowPoint = CGPointMake(point.x - CGRectGetMinX(self.frame), _isUpward ? 0 : currentH);
    CGFloat maskTop = _isUpward ? kPopoverViewArrowHeight : 0;
    CGFloat maskBottom = _isUpward ? currentH : currentH - kPopoverViewArrowHeight;
    UIBezierPath *maskPath = [UIBezierPath bezierPath];
    /// 左上圆角
    [maskPath moveToPoint:CGPointMake(0, cornerRadius + maskTop)];
    [maskPath addArcWithCenter:CGPointMake(cornerRadius, cornerRadius + maskTop) radius:cornerRadius startAngle:PopoverViewDegressToRadians(180) endAngle:PopoverViewDegressToRadians(270) clockwise:YES];
    /// 箭头向上时箭头的位置
    if (_isUpward) {
        [maskPath addLineToPoint:CGPointMake(arrowPoint.x - arrowWidth / 2, kPopoverViewArrowHeight)];
        if (_arrowStyle == PopoverViewArrowStyleTriangle) {
            [maskPath addLineToPoint:arrowPoint];
            [maskPath addLineToPoint:CGPointMake(arrowPoint.x + arrowWidth / 2 , kPopoverViewArrowHeight)];
        } else {
            [maskPath addQuadCurveToPoint:CGPointMake(arrowPoint.x - arrowCornerRadius, arrowCornerRadius) controlPoint:CGPointMake(arrowPoint.x - arrowWidth / 2 + arrowBottomCornerRadius, kPopoverViewArrowHeight)];
            [maskPath addQuadCurveToPoint:CGPointMake(arrowPoint.x + arrowCornerRadius, arrowCornerRadius) controlPoint:arrowPoint];
            [maskPath addQuadCurveToPoint:CGPointMake(arrowPoint.x + arrowWidth / 2, kPopoverViewArrowHeight) controlPoint:CGPointMake(arrowPoint.x + arrowWidth / 2 - arrowBottomCornerRadius, kPopoverViewArrowHeight)];
        }
    }
    /// 右上圆角
    [maskPath addLineToPoint:CGPointMake(currentW - cornerRadius, maskTop)];
    [maskPath addArcWithCenter:CGPointMake(currentW - cornerRadius, maskTop + cornerRadius) radius:cornerRadius startAngle:PopoverViewDegressToRadians(270) endAngle:PopoverViewDegressToRadians(0) clockwise:YES];
    /// 右下圆角
    [maskPath addLineToPoint:CGPointMake(currentW, maskBottom - cornerRadius)];
    [maskPath addArcWithCenter:CGPointMake(currentW - cornerRadius, maskBottom - cornerRadius) radius:cornerRadius startAngle:PopoverViewDegressToRadians(0) endAngle:PopoverViewDegressToRadians(90) clockwise:YES];
    /// 箭头向下时箭头的位置
    if (!_isUpward) {
        [maskPath addLineToPoint:CGPointMake(arrowPoint.x + arrowWidth / 2, currentH - kPopoverViewArrowHeight)];
        if (_arrowStyle == PopoverViewArrowStyleTriangle) {
            [maskPath addLineToPoint:arrowPoint];
            [maskPath addLineToPoint:CGPointMake(arrowPoint.x - arrowWidth / 2 , currentH - kPopoverViewArrowHeight)];
        } else {
            [maskPath addQuadCurveToPoint:CGPointMake(arrowPoint.x + arrowCornerRadius, currentH - arrowCornerRadius) controlPoint:CGPointMake(arrowPoint.x + arrowWidth / 2 - arrowBottomCornerRadius, currentH - kPopoverViewArrowHeight)];
            [maskPath addQuadCurveToPoint:CGPointMake(arrowPoint.x - arrowCornerRadius, currentH - arrowCornerRadius) controlPoint:arrowPoint];
            [maskPath addQuadCurveToPoint:CGPointMake(arrowPoint.x - arrowWidth / 2, currentH - kPopoverViewArrowHeight) controlPoint:CGPointMake(arrowPoint.x - arrowWidth / 2 + arrowBottomCornerRadius, currentH - kPopoverViewArrowHeight)];
        }
    }
    /// 左下圆角
    [maskPath addLineToPoint:CGPointMake(cornerRadius, maskBottom)];
    [maskPath addArcWithCenter:CGPointMake(cornerRadius, maskBottom - cornerRadius) radius:cornerRadius startAngle:PopoverViewDegressToRadians(90) endAngle:PopoverViewDegressToRadians(180) clockwise:YES];
    [maskPath closePath];
    /// 截取圆角和箭头
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    /// 边框
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.frame = self.bounds;
    borderLayer.path = maskPath.CGPath;
    borderLayer.lineWidth = 1;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = _tableView.separatorColor.CGColor;
    [self.layer addSublayer:borderLayer];
    
    [_keyWindow addSubview:self];
    
    /// 弹出动画
    CGRect oldFrame = self.frame;
    self.layer.anchorPoint = CGPointMake(arrowPoint.x / currentW, _isUpward ? 0.f : 1.f);
    self.frame = oldFrame;
    self.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
    [UIView animateWithDuration:0.25f animations:^{
        self.transform = CGAffineTransformIdentity;
        self->_shadeView.alpha = 1.f;
    }];
}

/// 计算最大宽度
- (CGFloat)calculateMaxWidth {
    CGFloat maxWidth = 0.f;
    CGFloat titleLeftEdge = 0.f;
    CGFloat imageWidth = 0.f;
    CGFloat imageMaxHeight = kPopoverViewCellHeight - PopoverViewCellVerticalMargin*2;
    CGSize imageSize = CGSizeZero;
    UIFont *titleFont = [PopoverViewCell titleFont];
    for (PopoverAction *action in self.actions) {
        imageWidth = 0.f;
        titleLeftEdge = 0.f;
        if (action.image) {
            titleLeftEdge = PopoverViewCellTitleLeftEdge;
            imageSize = action.image.size;
            if (imageSize.height > imageMaxHeight) {
                imageWidth = imageMaxHeight * imageSize.width / imageSize.height;
            } else {
                imageWidth = imageSize.width;
            }
        }
        CGFloat titleWidth = [action.title sizeWithAttributes:@{NSFontAttributeName:titleFont}].width;
        CGFloat contentWidth = PopoverViewCellHorizontalMargin * 2 + imageWidth + titleWidth + titleLeftEdge;
        if (contentWidth > maxWidth) {
            maxWidth = ceil(contentWidth);
        }
    }
    if (maxWidth > CGRectGetWidth(_keyWindow.bounds) - kPopoverViewMargin * 2) {
        maxWidth = CGRectGetWidth(_keyWindow.bounds) - kPopoverViewMargin * 2;
    }
    
    return maxWidth;
}
/// 隐藏
- (void)tapHide {
    [UIView animateWithDuration:0.25f animations:^{
        self.alpha = 0.f;
        self.shadeView.alpha = 0.f;
        self.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
    } completion:^(BOOL finished) {
        [self.shadeView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

/// 指定的view显示弹窗
- (void)showToView:(UIView *)pointView withActions:(NSArray *)actions {
    CGRect pointViewRect = [pointView.superview convertRect:pointView.frame toView:self.keyWindow];
    CGFloat pointViewUpLength = CGRectGetMinY(pointViewRect);
    CGFloat pointViewDownLength = self.windowHeight - CGRectGetMaxY(pointViewRect);
    CGPoint toPoint = CGPointMake(CGRectGetMidX(pointViewRect), 0);
    if (pointViewUpLength > pointViewDownLength) {
        toPoint.y = pointViewUpLength - 5;
    } else {
        toPoint.y = CGRectGetMaxY(pointViewRect) + 5;
    }
    self.isUpward = pointViewUpLength <= pointViewDownLength;
    if (!actions) {
        self.actions = @[];
    } else {
        self.actions = [actions copy];
    }
    [self showToPoint:toPoint];
}
/// 指定的point显示弹窗
- (void)showToPoint:(CGPoint)point withActions:(NSArray *)actions {
    _actions = actions;
    self.isUpward = point.y <= self.windowHeight - point.y;
    [self showToPoint:point];
}
/// 更改style 修改颜色
- (void)setStyle:(PopoverViewStyle)style {
    _style = style;
    self.tableView.separatorColor = [PopoverViewCell bottomLineColorForStyle:style];
    if (style == PopoverViewStyleDefault) {
        self.backgroundColor = [UIColor whiteColor];
    } else {
        self.backgroundColor = [UIColor colorWithRed:0.29 green:0.29 blue:0.29 alpha:1.00];
    }
}

#pragma mark ---- UITableViewDataSouce  UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.actions.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kPopoverViewCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PopoverViewCell *cell = [[PopoverViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kPopoverCellReuseId];
    cell.style = self.style;
    [cell setAction:self.actions[indexPath.row]];
    [cell showBottomLine:indexPath.row < self.actions.count - 1];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [UIView animateWithDuration:0.25f animations:^{
        self.alpha = 0.f;
        self.shadeView.alpha = 0.f;
    } completion:^(BOOL finished) {
        PopoverAction *action = self.actions[indexPath.row];
        action.handler ? action.handler(action) : NULL;
        self->_actions = nil;
        [self.shadeView removeFromSuperview];
        [self removeFromSuperview];
    }];
}
@end
