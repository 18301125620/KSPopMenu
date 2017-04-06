//
//  KSPopMenu.m
//  test
//
//  Created by kong on 16/4/8.
//  Copyright © 2016年 孔. All rights reserved.
//

#import "KSPopMenu.h"
#import <objc/runtime.h>

#define KSDefaultContentTransform (CGAffineTransformMakeScale(1, 0.01))
#define KSDefaultAnchorPoint (CGPointMake(0.5, 0.5))
#define KSDefaultAnimateDuration (0.2)
#define KSDefaultContentOrigin (self.contentView.frame.origin)
#define KSDefaultMaskViewColor ([[UIColor blackColor] colorWithAlphaComponent:0.5])

@interface KSPopMenu ()

/**  展示内容*/
@property (nonatomic, strong) UIView* contentView;
/**  阴影背景*/
@property (nonatomic, strong) UIView* maskView;
/** */
@property (nonatomic, assign) KSPopMenuStyle style;
/** 标记是否需要立即销毁视图*/
@property (nonatomic, assign) BOOL shouldHiddenIfNeeded;

@end

@implementation KSPopMenu
{
    CGPoint                 _anchorPoint;
    CGPoint                 _contentOrigin;
    KSPopAnimationValue     _animationValue;
    CGAffineTransform       _contentTransform;
    BOOL                    _shouldHiddenTapMaskView;
}

- (instancetype)initWithStyle:(KSPopMenuStyle)style{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

        self.style = style;
        
        self.maskView = [[UIView alloc] init];
        self.maskView.backgroundColor = KSDefaultMaskViewColor;
        [self addSubview:self.maskView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat selfX = 0;
    CGFloat selfY = 0;
    CGFloat selfW = CGRectGetWidth([UIScreen mainScreen].bounds);
    CGFloat selfH = CGRectGetHeight([UIScreen mainScreen].bounds);
    self.frame = CGRectMake(selfX, selfY, selfW, selfH);
    
    self.maskView.frame = self.bounds;
}

- (void)show{
    
    [[KSPopMenu globleArray] addObject:self];
    
    //添加到屏幕最上方
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    self.alpha = 0;
    self.contentView.transform = _contentTransform;
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:_animationValue.duration
                          delay:_animationValue.delay
         usingSpringWithDamping:_animationValue.damping
          initialSpringVelocity:_animationValue.velocity
                        options:_animationValue.options
                     animations:^{
                         weakSelf.alpha = 1;
                         weakSelf.contentView.transform = CGAffineTransformIdentity;
                     } completion:^(BOOL finished) {
                     }];
}

- (void)hidden{
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:_animationValue.duration
                          delay:0.
                        options:_animationValue.options
                     animations:^{
                         weakSelf.alpha = 0;
                         weakSelf.contentView.transform = _contentTransform;
                     } completion:^(BOOL finished) {
                         [weakSelf removeFromSuperview];
                     }];

}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    
    if (_shouldHiddenTapMaskView) {
        [KSPopMenu hiddenIfNeeded];
    }
}

+ (void)showContentView:(UIView *)contentView style:(KSPopMenuStyle)style{
    KSPopMenu* popMenu = [[KSPopMenu alloc] initWithStyle:style];
    popMenu.contentView = contentView;
    [popMenu prepareShow];
}

/** 准备展示，初始化一些变量,初始化完成后立即展示*/
- (void)prepareShow{
    
    _contentTransform   = KSDefaultContentTransform;
    _contentOrigin      = KSDefaultContentOrigin;
    _anchorPoint        = KSDefaultAnchorPoint;
    _animationValue     = KSPopAnimationDefalult();
    _shouldHiddenTapMaskView = YES;
    
    switch (self.style) {
        case KSPopMenuStylePresent:
        {
            _contentTransform   = CGAffineTransformMakeScale(1, 0.01);
            _contentOrigin      = CGPointMake(0, CGRectGetHeight([UIScreen mainScreen].bounds) - CGRectGetHeight(_contentView.frame));
            _anchorPoint        = CGPointMake(0, 1);
            _animationValue     = KSPopAnimationDefalult();
            _shouldHiddenTapMaskView = YES;
        }
            break;
        case KSPopMenuStyleCustom:
        {
            
            if ([_contentView conformsToProtocol:@protocol(KSPopMenuDataSource)]) {
                id<KSPopMenuDataSource> delegate = (id<KSPopMenuDataSource>)_contentView;
                
                if ([delegate respondsToSelector:@selector(popContentView:valueForDefaultContentTransform:)]) {
                    _contentTransform = [delegate popContentView:_contentView valueForDefaultContentTransform:KSDefaultContentTransform];
                }
                
                if ([delegate respondsToSelector:@selector(popContentView:valueForDefaultContentOrigin:)]) {
                    _contentOrigin = [delegate popContentView:_contentView valueForDefaultContentOrigin:KSDefaultContentOrigin];
                }
                
                if ([delegate respondsToSelector:@selector(popContentView:valueForDefaultContentAnchorPoint:)]) {
                    _anchorPoint = [delegate popContentView:_contentView valueForDefaultContentAnchorPoint:KSDefaultAnchorPoint];
                }
                
                if ([delegate respondsToSelector:@selector(popContentView:valueForDefaultAnimationValue:)]) {
                    _animationValue = [delegate popContentView:_contentView valueForDefaultAnimationValue:KSPopAnimationDefalult()];
                }
                
                if ([delegate respondsToSelector:@selector(popMenuShouldDismissWhenSelectMaskView)]) {
                    _shouldHiddenTapMaskView = [delegate popMenuShouldDismissWhenSelectMaskView];
                }
            }
        }
    }
    
//    [self setNeedsLayout];
//    [self layoutIfNeeded];
    
    //设置contentView锚点   为了动画的起点和终点
    [self setAnchorPoint:_anchorPoint forView:_contentView];
    
    _contentView.frame = (CGRect){_contentOrigin,_contentView.bounds.size};

    [self show];
}

/** 如果标记销毁视图，则立即销毁视图，否则先移除视图在销毁视图*/
+ (void)hiddenIfNeeded{
    if (![[[KSPopMenu globleArray] lastObject] shouldHiddenIfNeeded]) {
        [KSPopMenu setNeedsHidden];
    }
    
    [[KSPopMenu globleArray] removeLastObject];
}

/** 移除视图并且标记需要销毁。调用次方法后，一定要调用hiddenIfNeeded*/
+ (void)setNeedsHidden{
    
    [[[KSPopMenu globleArray] lastObject] setShouldHiddenIfNeeded:YES];
    
    [[[KSPopMenu globleArray] lastObject] hidden];
}

/**  记录当前显示的view,*/
+ (NSMutableArray *)globleArray{
    NSMutableArray* array = objc_getAssociatedObject(self, "globleArray");
    if (!array) {
        array = [NSMutableArray array];
        objc_setAssociatedObject(self, "globleArray", array, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return array;
}

#pragma mark- setting

- (void)setContentView:(UIView *)contentView
{
    _contentView = contentView;
    [self addSubview:contentView];
}


#pragma mark- setDefaultAnchor
/**  设置锚点的封装，并且恢复他的bounds*/
- (void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view
{
    CGPoint oldOrigin = view.frame.origin;
    view.layer.anchorPoint = anchorPoint;
    CGPoint newOrigin = view.frame.origin;
    
    CGPoint transition;
    transition.x = newOrigin.x - oldOrigin.x;
    transition.y = newOrigin.y - oldOrigin.y;
    
    view.center = CGPointMake (view.center.x - transition.x, view.center.y - transition.y);
}

- (void)dealloc{
    NSLog(@"销毁KSPopMenu");
}
@end
