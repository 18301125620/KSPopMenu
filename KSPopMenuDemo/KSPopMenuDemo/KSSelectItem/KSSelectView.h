//
//  KSSelectView.h
//  anfou
//
//  Created by Mr.kong on 2017/1/6.
//  Copyright © 2017年 李永. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSSelectItem.h"
#import "KSSelectConfig.h"

typedef void(^KSSelectViewResult)(KSSelectItem* obj,NSUInteger index);
typedef void(^KSSelectViewCancelResult)(NSUInteger type);
typedef KSSelectConfig*(^KSSelectViewConfig)();

@interface KSSelectView : UIView

+ (void)selectItems:(NSArray<KSSelectItem*>*)items
             result:(KSSelectViewResult)result;

/*
+ (void)selectItems:(NSArray<KSSelectItem*> *)items
             result:(KSSelectViewResult)result
             cancel:(KSSelectViewCancelResult)cancel;
*/

+ (void)selectItems:(NSArray<KSSelectItem *> *)items
             config:(KSSelectViewConfig)config
             result:(KSSelectViewResult)result;

/*
+ (void)selectItems:(NSArray<KSSelectItem *> *)items
             config:(KSSelectViewConfig)config
             result:(KSSelectViewResult)result
             cancel:(KSSelectViewCancelResult)cancel;
*/
@end
