//
//  KSSelectView.m
//  anfou
//
//  Created by Mr.kong on 2017/1/6.
//  Copyright © 2017年 Mr.kong. All rights reserved.
//

#import "KSSelectView.h"
#import "KSSelectViewCell.h"

#import "KSPopMenu.h"

@interface KSSelectView ()<
KSPopMenuDelegate,
KSPopMenuDataSource,
UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic, strong)   UITableView                 * tableView;
@property (nonatomic, strong)   KSSelectConfig              * config;

@property (nonatomic, strong)   NSArray<KSSelectItem*>      * items;
@property (nonatomic, copy)     KSSelectViewResult            result;
@property (nonatomic, copy)     KSSelectViewCancelResult      cancelResult;

@end

@implementation KSSelectView

+ (void)selectItems:(NSArray<KSSelectItem*> *)items result:(KSSelectViewResult)result{
    [self selectItems:items config:^(){return[KSSelectConfig new];} result:result cancel:NULL];
}

+ (void)selectItems:(NSArray<KSSelectItem *> *)items config:(KSSelectViewConfig)config result:(KSSelectViewResult)result{
    [self selectItems:items config:config result:result cancel:NULL];
}

+ (void)selectItems:(NSArray<KSSelectItem*> *)items result:(KSSelectViewResult)result cancel:(KSSelectViewCancelResult)cancel{
    [self selectItems:items config:^(){return[KSSelectConfig new];} result:result cancel:cancel];
}

+ (void)selectItems:(NSArray<KSSelectItem *> *)items config:(KSSelectViewConfig)config result:(KSSelectViewResult)result cancel:(KSSelectViewCancelResult)cancel{
    KSSelectView* item = [[KSSelectView alloc] init];
    
    item.config = config();
    item.items = items;
    item.result = result;
    item.cancelResult = cancel;
    
    NSNumber* height = [[items valueForKeyPath:@"@unionOfObjects.height"] valueForKeyPath:@"@sum.floatValue"];
    
    item.frame = CGRectMake(0, 0, item.config.width, height.floatValue + 6);
    
    [KSPopMenu showContentView:item style:KSPopMenuStyleCustom];
}



#pragma mark-
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.items.count;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self.items[indexPath.row] height];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KSSelectViewCell* cell = [tableView dequeueReusableCellWithIdentifier:KSSelectViewCellID forIndexPath:indexPath];
    cell.item = self.items[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    KSSelectItem* item = self.items[indexPath.row];
    
    if (self.result) {
        self.result(item,indexPath.row);
    }
    
    [KSPopMenu setNeedsHidden];
    [KSPopMenu hiddenIfNeeded];
}



#pragma mark-
#pragma mark init:
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.tableView];
    }
    return self;
}

#pragma mark-
#pragma mark layoutSubviews
- (void)layoutSubviews{
    [super layoutSubviews];
    self.tableView.frame = UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(6, 0, 0, 0));
}

#pragma mark-
#pragma mark drawRect:
- (void)drawRect:(CGRect)rect{
    
    CAShapeLayer* layer = [CAShapeLayer layer];
    
    CGFloat height = 6;
    CGFloat width = 12;
    CGFloat postion = CGRectGetWidth(rect) * self.config.scriptPosi;
    
    UIBezierPath* round = [UIBezierPath bezierPathWithRoundedRect:UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(height, 0, 0, 0))
                                                byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(4, 4)];
    
    UIBezierPath* path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(postion - width / 2, height)];
    [path addLineToPoint:CGPointMake(postion, 0)];
    [path addLineToPoint:CGPointMake(postion + width / 2, height)];
    [path closePath];

    [round appendPath:path];
    layer.path = round.CGPath;
    
    self.layer.mask = layer;
}



#pragma mark-
#pragma mark getter
- (UITableView* )tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.layoutMargins = UIEdgeInsetsZero;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        [_tableView registerClass:[KSSelectViewCell class] forCellReuseIdentifier:KSSelectViewCellID];
    }
    return _tableView;
}

#pragma mark-
#pragma mark KSPopMenuDataSource
//**  指定动画类型，比如缩放，下拉, 旋转等,默认下拉（比较难看）*/
- (CGAffineTransform)popContentView:(UIView *)contentView valueForDefaultContentTransform:(CGAffineTransform)value{
    return CGAffineTransformMakeScale(0.01, 0.01);
}
//**  指定锚点，如果要做比较好看的动画，需要指定此点,默认为(0.5,0.5)*/
- (CGPoint)popContentView:(UIView *)contentView valueForDefaultContentAnchorPoint:(CGPoint)value{
    return CGPointMake(0.87, 0);
}
//**  指定contentView显示的位置 默认为初始化的位置*/
- (CGPoint)popContentView:(UIView *)contentView valueForDefaultContentOrigin:(CGPoint)value{
    return CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds) -
                       CGRectGetWidth(contentView.frame) - 6 +
                       self.config.edgeInsets.x,
                       54 + self.config.edgeInsets.y);
}
//**  指定maskView的颜色*/
- (UIColor *)popMaskView:(UIView *)contentView valueForDefaultColor:(UIColor *)color{
    return self.config.backgroundColor;
}
@end
