//
//  KSCreateUserSelectItem.h
//  TalkOrder
//
//  Created by kong on 16/8/19.
//  Copyright © 2016年 孔. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KSSelectItem : NSObject

- (instancetype)initWithHandle:(dispatch_block_t)handel NS_UNAVAILABLE;

/**
 handle
 */
@property(nonatomic, copy, readonly) dispatch_block_t handle NS_UNAVAILABLE;

/**
 标题
 */
@property (nonatomic, copy) NSAttributedString* title;

/**
 图片标题，只支持本地图片
 */
@property (nonatomic, copy) NSString* imageName;

/**
 Item内容偏移量 默认 UIEdgeInsetsZero
 */
@property(nonatomic, assign)          UIEdgeInsets contentEdgeInsets;

/**
 Item标题偏移量 默认 UIEdgeInsetsZero
 */
@property(nonatomic, assign)          UIEdgeInsets titleEdgeInsets;

/**
 Item图片偏移量 默认 UIEdgeInsetsZero
 */
@property(nonatomic, assign)          UIEdgeInsets imageEdgeInsets;

/**
 Item内部对其方式 默认center
 */
@property(nonatomic,assign) UIControlContentHorizontalAlignment contentHorizontalAlignment;

/**
 Item的高度,默认50
 */
@property (nonatomic, assign) float height;

/**
 自定义参数
 */
@property (nonatomic, strong) NSDictionary* userInfo;

@end
