//
//  KSDatePicker.m
//  KSPopMenuDemo
//
//  Created by Mr.kong on 2017/4/6.
//  Copyright © 2017年 Mr.kong. All rights reserved.
//

#import "KSDatePicker.h"
#import "KSPopMenu.h"

@interface KSDatePicker ()
@property (nonatomic, strong) UIDatePicker      * datePicker;
@property (nonatomic, strong) UIButton          * doneButton;
@property (nonatomic, copy) KSDatePickerResult  result;
@end

@implementation KSDatePicker

+ (void)pickerResult:(KSDatePickerResult)result{
    [self pickerConfig:nil result:result];
}

+ (void)pickerConfig:(KSDatePickerConfig)config
              result:(KSDatePickerResult)result{
    
    KSDatePicker* datePicker = [[KSDatePicker alloc] init];
    datePicker.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 200);
    if (config) {
        config(datePicker.datePicker);
    }
    
    datePicker.result = result;
    
    [KSPopMenu showContentView:datePicker style:KSPopMenuStylePresent];
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:242./255 green:242./255 blue:242./255 alpha:1];
        
        self.datePicker = [[UIDatePicker alloc] init];
        self.datePicker.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.datePicker];
        
        self.doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.doneButton setTitle:@"完成" forState:UIControlStateNormal];
        self.doneButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.doneButton setTitleColor:[UIColor colorWithRed:0 green:0.48 blue:1 alpha:1]
                              forState:UIControlStateNormal];
        
        [self.doneButton addTarget:self
                            action:@selector(doneAction)
                  forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.doneButton];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat buttonW = 60;
    CGFloat buttonH = 44;
    CGFloat buttonX = CGRectGetWidth(self.frame) - buttonW - 15;
    CGFloat buttonY = 0;
    self.doneButton.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
    
    CGFloat pickerX = 0;
    CGFloat pickerY = CGRectGetMaxY(self.doneButton.frame);
    CGFloat pickerW = CGRectGetWidth(self.frame);
    CGFloat pickerH = CGRectGetHeight(self.frame) - buttonH;
    self.datePicker.frame = CGRectMake(pickerX, pickerY, pickerW, pickerH);
}


- (void)doneAction{
    if (self.result) {
        self.result(self.datePicker.date,self.datePicker);
    }
    [KSPopMenu hiddenIfNeeded];
}


- (void)dealloc{
    NSLog(@"销毁KSPickerView");
}
@end
