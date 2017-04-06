//
//  KSSelectViewCell.m
//  anfou
//
//  Created by Mr.kong on 2017/1/6.
//  Copyright © 2017年 李永. All rights reserved.
//

#import "KSSelectViewCell.h"
#import "KSSelectItem.h"

@interface KSSelectViewCell ()
@property (nonatomic, strong) UIButton* button;
@end
@implementation KSSelectViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.button];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.button.frame = self.contentView.bounds;
}

#pragma mark-
#pragma mark- setter
- (void)setItem:(KSSelectItem *)item{
    _item = item;
    
    if (item.title) {
        [self.button setAttributedTitle:item.title forState:UIControlStateNormal];
    }
    
    if (item.imageName) {
        [self.button setImage:[UIImage imageNamed:item.imageName] forState:UIControlStateNormal];
    }
    
    self.button.imageEdgeInsets = item.imageEdgeInsets;
    self.button.titleEdgeInsets = item.titleEdgeInsets;
    self.button.contentEdgeInsets = item.contentEdgeInsets;
    self.button.contentHorizontalAlignment = item.contentHorizontalAlignment;

}

#pragma mark- 
#pragma mark- getter
- (UIButton* )button{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.userInteractionEnabled = NO;
    }
    return _button;
}
@end


NSString * const KSSelectViewCellID = @"KSSelectViewCellID";
