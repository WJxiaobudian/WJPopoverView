//
//  PopoverAction.m
//  PopoverView
//
//  Created by WangJie on 2020/7/28.
//  Copyright © 2020 WangJie. All rights reserved.
//

#import "PopoverAction.h"

@implementation PopoverAction

+ (instancetype)actionWithTitle:(NSString *)title handler:(void (^)(PopoverAction * _Nonnull))handler {
    return [self actionWithImage:nil title:title handler:handler];
}

+ (instancetype)actionWithImage:(UIImage *__nullable)image title:(NSString *)title handler:(void (^)(PopoverAction * _Nonnull))handler {
    PopoverAction *action = [[PopoverAction alloc] init];
    action.image = image;
    action.title = title ?: @"";
    action.handler = handler ?: NULL;
    return action;
}

@end
