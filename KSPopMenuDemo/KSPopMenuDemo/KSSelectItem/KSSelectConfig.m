//
//  KSSelectConfig.m
//  anfou
//
//  Created by Mr.kong on 2017/1/6.
//  Copyright © 2017年 李永. All rights reserved.
//

#import "KSSelectConfig.h"

@implementation KSSelectConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.width = 100;
        self.scriptPosi = 0.85;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    return self;
}

@end
