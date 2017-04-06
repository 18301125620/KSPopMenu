//
//  KSSelectConfig.h
//  anfou
//
//  Created by Mr.kong on 2017/1/6.
//  Copyright © 2017年 李永. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSSelectConfig : NSObject

/**
 View的高宽,高度用KSSelectItem去设置 默认100
 */
@property (nonatomic, assign) float width;

/**
 View的空白区域的背景色 默认 #000000  50%
 */
@property (nonatomic, strong) UIColor* backgroundColor;


/**
 View的三角箭头的底部中心点，相对于View的位置比例 [0,1] 默认0.85
 */
@property(nonatomic, assign) float scriptPosi;

/**
 View的位置偏移量微调 x横向  y纵向
 */
@property(nonatomic, assign) CGPoint edgeInsets;


//以下暂不支持
/**
 View的圆角
 */
@property(nonatomic, assign) float cornerRadius NS_UNAVAILABLE;

/**
 View的三角箭头的高度
 */
@property(nonatomic, assign) float scriptHeight NS_UNAVAILABLE;

/**
 View的三角箭头的底边宽度
 */
@property(nonatomic, assign) float scriptWidth NS_UNAVAILABLE;

@end
