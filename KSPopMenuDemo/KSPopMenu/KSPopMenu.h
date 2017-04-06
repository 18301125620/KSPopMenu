//
//  KSPopMenu.h
//  test
//
//  Created by kong on 16/4/8.
//  Copyright © 2016年 孔. All rights reserved.
//  自定义的一种弹框

#import <UIKit/UIKit.h>
#import "KSPopValue.h"

@class KSPopMenu;

@protocol KSPopMenuDelegate <NSObject>
//@optional
//- (void)popMenu:(KSPopMenu*)menu willShowContentView:(UIView*)contentView;
//- (void)popMenu:(KSPopMenu*)menu didShowContentView:(UIView*)contentView;
//
//- (void)popMenu:(KSPopMenu*)menu willHiddenContentView:(UIView*)contentView;
//- (void)popMenu:(KSPopMenu*)menu didHiddenContentView:(UIView*)contentView;

@end

@protocol KSPopMenuDataSource <NSObject>
@optional
/**  指定动画类型，比如缩放，下拉, 旋转等*/
- (CGAffineTransform)popContentView:(UIView *)contentView valueForDefaultContentTransform:(CGAffineTransform)value;

/**  指定锚点，需要指定此点,默认为(0.5,0.5)*/
- (CGPoint)popContentView:(UIView *)contentView valueForDefaultContentAnchorPoint:(CGPoint)value;

/**  指定contentView显示的位置 默认为初始化的位置*/
- (CGPoint)popContentView:(UIView *)contentView valueForDefaultContentOrigin:(CGPoint)value;

/**  指定动画一些属性 默认KSPopAnimationDefalult()*/
- (KSPopAnimationValue)popContentView:(UIView *)contentView valueForDefaultAnimationValue:(KSPopAnimationValue)value;

/**  指定maskView的颜色*/
- (UIColor*)popMaskView:(UIView *)contentView valueForDefaultColor:(UIColor*)color;

/**  点击背景是否消失 默认yes*/
- (BOOL)popMenuShouldDismissWhenSelectMaskView;

@end

@interface KSPopMenu : UIView

+ (void)showContentView:(UIView*)contentView
                  style:(KSPopMenuStyle)style;


/** 移除视图并且标记需要销毁。调用次方法后，一定要调用hiddenIfNeeded*/
+ (void)setNeedsHidden;

/** 如果标记销毁视图，则立即销毁视图，否则先移除视图在销毁视图*/
+ (void)hiddenIfNeeded;

@end
