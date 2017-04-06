//
//  KSActionSheet.m
//  KSPopMenuDemo
//
//  Created by Mr.kong on 2017/4/6.
//  Copyright © 2017年 Mr.kong. All rights reserved.
//

#import "KSActionSheet.h"
#import "KSPopMenu.h"




////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface KSAction ()
@property (nonatomic, copy) NSAttributedString* title;
@property (nonatomic, copy) void(^action)();
@end

@implementation KSAction
- (instancetype)init{
    return [self initWithTitle:@"取消" attribute:@{NSForegroundColorAttributeName:[[UIColor redColor] colorWithAlphaComponent:0.7]} action:NULL];
}

- (instancetype)initWithTitle:(NSString *)title
                    attribute:(NSDictionary *)attribute
                       action:(void (^)())action{
    
    self = [super init];
    if (self) {
        self.title = [[NSAttributedString alloc] initWithString:title
                                                     attributes:attribute];
        self.action = action;
    }
    
    return self;
}
@end
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define kItemHeight (50.)

@interface KSActionSheet ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView       * tableView;
@property (nonatomic, strong) NSArray<KSAction*>* dataSource;
@end

@implementation KSActionSheet

+ (void)actions:(NSArray<KSAction *> *)actions{
    KSActionSheet* sheet = [[KSActionSheet alloc] init];
    sheet.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), actions.count * kItemHeight);

    sheet.dataSource = actions;
    
    [KSPopMenu showContentView:sheet style:KSPopMenuStylePresent];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                      style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.scrollEnabled = NO;
        self.tableView.separatorInset = UIEdgeInsetsZero;
        self.tableView.layoutMargins = UIEdgeInsetsZero;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.showsHorizontalScrollIndicator = NO;
        
        [self addSubview:self.tableView];
        
    }
    return self;
}

- (void)layoutSubviews{
    self.tableView.frame = self.bounds;
}

#pragma mark- UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kItemHeight;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.separatorInset = UIEdgeInsetsZero;
    UILabel* label = [cell.contentView viewWithTag:999];
    label.frame = cell.contentView.bounds;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"item"];
    UILabel* label = [cell.contentView viewWithTag:999];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"item"];
        label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:label];
        label.tag = 999;
    }
    label.attributedText = self.dataSource[indexPath.row].title;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    KSAction* action = self.dataSource[indexPath.row];
    if (action.action) {
        action.action();
    }
    
    [KSPopMenu setNeedsHidden];
    [KSPopMenu hiddenIfNeeded];
}
@end


