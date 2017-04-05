//
//  KSPopMenu.h
//  test
//
//  Created by kong on 16/4/8.
//  Copyright © 2016年 孔. All rights reserved.
//  自定义的一中弹框

#import <UIKit/UIKit.h>
#import "KSPopValue.h"

@class KSPopMenu;

@protocol KSPopMenuDelegate <NSObject>
@optional
- (void)popMenu:(KSPopMenu*)menu willShowContentView:(UIView*)contentView;
- (void)popMenu:(KSPopMenu*)menu didShowContentView:(UIView*)contentView;

- (void)popMenu:(KSPopMenu*)menu willHiddenContentView:(UIView*)contentView;
- (void)popMenu:(KSPopMenu*)menu didHiddenContentView:(UIView*)contentView;

@end

@protocol KSPopMenuDataSource <NSObject>
@required
/**  指定动画类型，比如缩放，下拉, 旋转等,默认下拉（比较难看）*/
- (CGAffineTransform)popContentView:(UIView *)contentView valueForContentTransformWithDefault:(CGAffineTransform)value;

/**  指定锚点，如果要做比较好看的动画，需要指定此点,默认为(0.5,0.5)*/
- (CGPoint)popContentView:(UIView *)contentView valueForContentAnchorPointWithDefault:(CGPoint)value;

/**  指定contentView显示的位置 默认为初始化的位置*/
- (CGPoint)popContentView:(UIView *)contentView valueForContentOriginDefault:(CGPoint)value;

@optional
/**  指定动画一些属性 默认KSPopAnimationDefalult()无阻尼动画*/
- (KSPopAnimationValue)popContentView:(UIView *)contentView valueForDefaultValue:(KSPopAnimationValue)value;

/**  指定maskView的颜色*/
- (UIColor*)popMaskView:(UIView *)contentView valueForColorDefault:(UIColor*)color;

/**  点击背景是否消失 默认yes*/
- (BOOL)popMenuShouldDismissWhenSelectMaskView;

@end
@interface KSPopMenu : UIView
/**
 *  显示弹出的view 需要指定size origin可以在代理中指定
 *
 *  @param contentView 要弹出的view
 *  @param delegate    代理
 */
+ (void)showContentView:(UIView*)contentView delegate:(id<KSPopMenuDelegate,KSPopMenuDataSource>)delegate;

/** 在必要的时候调用这个方法移除弹出的view */
+ (void)hiddenFromSubview;

@end
