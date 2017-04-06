//
//  ViewController.m
//  KSPopMenuDemo
//
//  Created by Mr.kong on 2017/4/5.
//  Copyright © 2017年 Mr.kong. All rights reserved.
//

#import "ViewController.h"

#import "KSPickerView.h"
#import "KSDatePicker.h"
#import "KSActionSheet.h"
#import "KSSelectView.h"

@interface ViewController ()
@end

@implementation ViewController

//单项选择
- (IBAction)siglePicker:(id)sender{
    KSPickerObj* obj1 = [[KSPickerObj alloc] init];
    obj1.title = @"男";
    
    KSPickerObj* obj2 = [[KSPickerObj alloc] init];
    obj2.title = @"女";
    
    [KSPickerView selectItems:@[obj1,obj2]
                  selectIndex:0
                       result:^(KSPickerObj* obj, NSUInteger index) {
                           NSLog(@"选择完成%@",obj);
                       }];
}

//选择时间
- (IBAction)selectDatePicker:(id)sender {

    [KSDatePicker pickerConfig:^(UIDatePicker *picker) {
        
        picker.minimumDate = [NSDate date];
        picker.datePickerMode = UIDatePickerModeDate;

    } result:^(NSDate *date, UIDatePicker *picker) {
        NSLog(@"%@",date);
    }];
}

//选择照片
- (IBAction)selectPhoto:(id)sender {
    KSAction* action1 = [[KSAction alloc] initWithTitle:@"相机" attribute:@{} action:^{
        NSLog(@"选择了相机");
    }];
    
    KSAction* action2 = [[KSAction alloc] initWithTitle:@"相册" attribute:@{} action:^{
        NSLog(@"选择了相册");
    }];
    
    KSAction* cancel = [[KSAction alloc] init];
    
    [KSActionSheet actions:@[action1,action2,cancel]];
}
//添加
- (IBAction)add:(id)sender {

    KSSelectItem *item1 = [[KSSelectItem alloc] init];
    item1.height = 34;
    item1.title = [[NSAttributedString alloc] initWithString:@"添加好友"
                                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],
                                                               NSForegroundColorAttributeName:[UIColor blackColor]}];

    [KSSelectView selectItems:@[item1] result:^(KSSelectItem *obj, NSUInteger index) {
        NSLog(@"选择%@",obj);
    }];
}

@end
