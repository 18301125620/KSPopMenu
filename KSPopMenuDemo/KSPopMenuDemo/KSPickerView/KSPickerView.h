//
//  KSPickerView.h
//  anfou
//
//  Created by Mr.kong on 2017/3/23.
//  Copyright © 2017年 李永. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KSPickerViewDelegate <NSObject>
- (NSString*)titleForPicker;
@end

typedef void(^KSPickerViewResult)(id<KSPickerViewDelegate> obj,NSUInteger index);
typedef void(^KSPickerViewCancelResult)(NSUInteger type);

@interface KSPickerView : UIView


+ (void)selectItems:(NSArray<id<KSPickerViewDelegate>> *)items
        selectIndex:(NSUInteger)index
             result:(KSPickerViewResult)result;

@end


//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////

@interface KSPickerObj : NSObject<KSPickerViewDelegate>
/**
 展示的标题
 */
@property (nonatomic, copy) NSString*  title;


/**
 自定义参数
 */
@property (nonatomic, strong) NSDictionary* userInfo;

@end
