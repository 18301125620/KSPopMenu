//
//  KSPopMenu.m
//  test
//
//  Created by kong on 16/4/8.
//  Copyright © 2016年 孔. All rights reserved.
//

#import "KSPopMenu.h"

#define KSDefaultContentTransform (CGAffineTransformMakeScale(1, 0.01))
#define KSDefaultAnchorPoint (CGPointMake(0.5, 0.5))
#define KSDefaultAnimateDuration (0.2)
#define KSDefaultContentOrigin (contentView.frame.origin)
#define KSDefaultMaskViewColor ([[UIColor lightGrayColor] colorWithAlphaComponent:0.3])

@interface KSPopMenu ()

/**  展示内容*/
@property (nonatomic, strong) UIView* contentView;
/**  阴影背景*/
@property (nonatomic, strong) UIView* maskView;
/**  设置代理*/
@property (nonatomic, weak) id<KSPopMenuDelegate,KSPopMenuDataSource>delegate;

@end

@implementation KSPopMenu

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectOffset([UIScreen mainScreen].bounds, 0, 0) ;
        self.backgroundColor = [UIColor clearColor];
        
        self.maskView = [[UIView alloc] initWithFrame:self.bounds];
        self.maskView.backgroundColor = KSDefaultMaskViewColor;
        [self addSubview:self.maskView];
    }
    return self;
}

- (void)show{
    
    //回调代理
    if (_delegate && [_delegate respondsToSelector:@selector(popMenu:willShowContentView:)]) {
        [_delegate popMenu:self willShowContentView:self.contentView];
    }
    
    //添加到屏幕最上方
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    //做动画  (背景透明度渐变  contentView做动画)
    self.alpha = 0;
    self.contentView.transform = self.contentTransform;

    [UIView animateWithDuration:self.animationValue.duration
                          delay:self.animationValue.delay
         usingSpringWithDamping:self.animationValue.damping
          initialSpringVelocity:self.animationValue.velocity
                        options:self.animationValue.options
                     animations:^{
                         self.alpha = 1;
                         self.contentView.transform = CGAffineTransformIdentity;
                     } completion:^(BOOL finished) {
                         //回调代理
                         if (_delegate && [_delegate respondsToSelector:@selector(popMenu:didShowContentView:)]) {
                             [_delegate popMenu:self didShowContentView:self.contentView];
                         }
                     }];
}
- (void)hidden{
    
    //回调代理
    if (_delegate && [_delegate respondsToSelector:@selector(popMenu:willHiddenContentView:)]) {
        [_delegate popMenu:self willHiddenContentView:self.contentView];
    }
    
    //点击屏幕其他区域，移除view 并且做动画
    [UIView animateWithDuration:KSDefaultAnimateDuration
                          delay:0.
                        options:self.animationValue.options
                     animations:^{
                         self.alpha = 0;
                         self.contentView.transform = self.contentTransform;
                     } completion:^(BOOL finished) {
                         //回调代理
                         if (_delegate && [_delegate respondsToSelector:@selector(popMenu:didHiddenContentView:)]) {
                             [_delegate popMenu:self didHiddenContentView:self.contentView];
                         }
                         
                         [self removeFromSuperview];
                     }];
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    BOOL shouldHidden = YES;
    
    if (_delegate && [_delegate respondsToSelector:@selector(popMenuShouldDismissWhenSelectMaskView)]) {
        shouldHidden = [_delegate popMenuShouldDismissWhenSelectMaskView];
    }
    
    if (shouldHidden) {
        [KSPopMenu hiddenFromSubview];
    }
}

/**  向外界提供这个方法，展示获取contentView*/
+ (void)showContentView:(UIView *)contentView delegate:(id<KSPopMenuDelegate,KSPopMenuDataSource>)delegate
{
    KSPopMenu* popview = [[KSPopMenu alloc] init];
    popview.delegate = delegate;
    popview.contentView = contentView;
    [popview show];
    [[KSPopMenu globleArray] addObject:popview];
}
/**  向外界提供这个方法，隐藏*/
+ (void)hiddenFromSubview
{
    [[[KSPopMenu globleArray] lastObject] hidden];
    [[KSPopMenu globleArray] removeLastObject];
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

- (void)setDelegate:(id<KSPopMenuDelegate,KSPopMenuDataSource>)delegate{
    _delegate = delegate;
    
    if (_delegate && [_delegate respondsToSelector:@selector(popMaskView:valueForColorDefault:)]) {
        self.maskView.backgroundColor = [_delegate popMaskView:self valueForColorDefault:KSDefaultMaskViewColor];
    }
}
- (void)setContentView:(UIView *)contentView
{
    _contentView = contentView;
    
    //设置contentView的位置
    _contentView.frame = (CGRect){self.contentOrigin,contentView.bounds.size};
    
    //设置contentView锚点   为了动画的起点和终点
    [self setAnchorPoint:self.anchorPoint forView:_contentView];
    
    [self addSubview:contentView];
}

#pragma mark- getting
/**  返回动画类型*/
- (CGAffineTransform)contentTransform
{
    if (_delegate && [_delegate respondsToSelector:@selector(popContentView:valueForContentTransformWithDefault:)]) {
        return [_delegate popContentView:self.contentView valueForContentTransformWithDefault:KSDefaultContentTransform];
    }
    return KSDefaultContentTransform;
}

/**  返回一个锚点*/
- (CGPoint)anchorPoint
{
    if (_delegate && [_delegate respondsToSelector:@selector(popContentView:valueForContentAnchorPointWithDefault:)]) {
        return [_delegate popContentView:self.contentView valueForContentAnchorPointWithDefault:KSDefaultAnchorPoint];
    }
    return KSDefaultAnchorPoint;
}
/**  返回一个contentView位置*/
- (CGPoint)contentOrigin
{
    if (_delegate && [_delegate respondsToSelector:@selector(popContentView:valueForContentOriginDefault:)]) {
        return [_delegate popContentView:self.contentView valueForContentOriginDefault:KSDefaultAnchorPoint];
    }
    return KSDefaultAnchorPoint;
}

/**  返回一个动画属性*/
- (KSPopAnimationValue)animationValue
{
    if (_delegate && [_delegate respondsToSelector:@selector(popContentView:valueForDefaultValue:)]) {
        return [_delegate popContentView:self.contentView valueForDefaultValue:KSPopAnimationDefalult()];
    }
    return KSPopAnimationDefalult();
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

@end
