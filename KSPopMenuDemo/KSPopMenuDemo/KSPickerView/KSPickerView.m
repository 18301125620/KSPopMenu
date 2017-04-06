//
//  KSPickerView.m
//  anfou
//
//  Created by Mr.kong on 2017/3/23.
//  Copyright © 2017年 李永. All rights reserved.
//

#import "KSPickerView.h"
#import "KSPopMenu.h"

@interface KSPickerView ()
<
UIPickerViewDelegate,
UIPickerViewDataSource
>

@property (nonatomic, strong) UIPickerView                      * pickerView;
@property (nonatomic, strong) NSArray<id<KSPickerViewDelegate>> * dataSource;
@property (nonatomic, strong) UIButton                          * doneButton;
@property (nonatomic, copy) KSPickerViewResult                  result;

@property (nonatomic, assign) NSUInteger                        selectedIndex;
@end

@implementation KSPickerView

+ (void)selectItems:(NSArray<id<KSPickerViewDelegate>> *)items
        selectIndex:(NSUInteger)index
             result:(KSPickerViewResult)result{
    KSPickerView* view = [[KSPickerView alloc] init];
    view.dataSource = items;
    view.result = result;
    view.selectedIndex = index;
    
    view.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 200);
    
    [KSPopMenu showContentView:view style:KSPopMenuStylePresent];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:242./255 green:242./255 blue:242./255 alpha:1];
        
        self.pickerView = [[UIPickerView alloc] init];
        self.pickerView.backgroundColor = [UIColor whiteColor];
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        self.pickerView.showsSelectionIndicator = YES;
        [self addSubview:self.pickerView];
        
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
    self.pickerView.frame = CGRectMake(pickerX, pickerY, pickerW, pickerH);
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex{
    _selectedIndex = selectedIndex;
    if ([self.pickerView numberOfRowsInComponent:0] > selectedIndex) {
        [self.pickerView selectRow:selectedIndex inComponent:0 animated:NO];
    }
}

- (void)doneAction{
    if (self.result) {
        NSUInteger index = [self.pickerView selectedRowInComponent:0];
        if (self.dataSource.count > index) {
            self.result(self.dataSource[index],index);
        }else{
            self.result(nil,NSNotFound);
        }
    }
    
    [KSPopMenu hiddenIfNeeded];
}

#pragma mark- UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.dataSource.count;
}

- (UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    NSString* string = [self.dataSource[row] titleForPicker];
    UILabel* label = (UILabel*)view;
    
    if (!view) {
        //设置文字的属性
        label = [UILabel new];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = string;
    }

    return label;
}

- (void)dealloc{
    NSLog(@"销毁KSPickerView");
}
@end



//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////

@implementation KSPickerObj

- (NSString *)titleForPicker{
    return self.title;
}


@end

