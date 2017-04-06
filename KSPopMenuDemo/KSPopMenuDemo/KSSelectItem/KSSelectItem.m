//
//  KSCreateUserSelectItem.m
//  TalkOrder
//
//  Created by kong on 16/8/19.
//  Copyright © 2016年 孔. All rights reserved.
//

#import "KSSelectItem.h"


@implementation KSSelectItem

- (instancetype)initWithHandle:(dispatch_block_t)handel{
    if (self = [super init]) {
        _height = 50;
        _handle = handel;
    }
    return self;
}

@end
