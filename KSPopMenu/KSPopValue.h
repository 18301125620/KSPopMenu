//
//  KSPopValue.h
//  TalkOrder
//
//  Created by kong on 16/8/24.
//  Copyright © 2016年 孔. All rights reserved.
//

#ifndef KSPopValue_h
#define KSPopValue_h

struct KSPopAnimationValue {
    NSTimeInterval duration;
    NSTimeInterval delay;
    CGFloat damping;
    CGFloat velocity;
    UIViewAnimationOptions options;
};
typedef struct KSPopAnimationValue KSPopAnimationValue;

CG_INLINE KSPopAnimationValue
KSPopAnimationValueMake(NSTimeInterval duration,
                        NSTimeInterval delay,
                        CGFloat damping,
                        CGFloat velocity,
                        UIViewAnimationOptions options)
{
    KSPopAnimationValue value;
    value.duration = duration;
    value.delay = delay;
    value.damping = damping;
    value.velocity = velocity;
    value.options = options;
    return value;
}

/** KSPopAnimationDefalult 无阻尼动画*/
CG_INLINE KSPopAnimationValue
KSPopAnimationDefalult()
{
    KSPopAnimationValue value;
    value.duration = 0.25;
    value.delay = 0;
    value.damping = 1;
    value.velocity = 0;
    value.options = UIViewAnimationOptionCurveEaseInOut;
    return value;
}


#endif /* KSPopValue_h */
