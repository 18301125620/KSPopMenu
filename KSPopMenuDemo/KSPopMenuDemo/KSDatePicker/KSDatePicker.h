//
//  KSDatePicker.h
//  KSPopMenuDemo
//
//  Created by Mr.kong on 2017/4/6.
//  Copyright © 2017年 Mr.kong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^KSDatePickerResult)(NSDate* date, UIDatePicker* picker);
typedef void(^KSDatePickerConfig)(UIDatePicker* picker);

@interface KSDatePicker : UIView


/**
 选择日期，默认配置

 @param result <#result description#>
 */
+ (void)pickerResult:(KSDatePickerResult)result;


/**
 选择日期，可以自定义配置DatePicker

 @param config <#config description#>
 @param result <#result description#>
 */
+ (void)pickerConfig:(KSDatePickerConfig)config
              result:(KSDatePickerResult)result;

@end
