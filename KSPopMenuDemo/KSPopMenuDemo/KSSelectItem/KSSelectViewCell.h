//
//  KSSelectViewCell.h
//  anfou
//
//  Created by Mr.kong on 2017/1/6.
//  Copyright © 2017年 李永. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KSSelectItem;
@interface KSSelectViewCell : UITableViewCell

@property (nonatomic, strong) KSSelectItem* item;

@end


UIKIT_EXTERN NSString * const KSSelectViewCellID;
