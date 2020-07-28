//
//  PopoverAction.h
//  PopoverView
//
//  Created by WangJie on 2020/7/28.
//  Copyright © 2020 WangJie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PopoverMisc.h"

NS_ASSUME_NONNULL_BEGIN

@interface PopoverAction : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) void (^handler)(PopoverAction *action);

+ (instancetype)actionWithTitle:(NSString *)title handler:(void(^)(PopoverAction *action))handler;
/// 对声明参数添加属性（__nullable）时参数可传nil，传（__nonnull）时参数不能为空
+ (instancetype)actionWithImage:(UIImage * __nullable)image title:(NSString *)title handler:(void(^)(PopoverAction *action))handler;

@end

NS_ASSUME_NONNULL_END
