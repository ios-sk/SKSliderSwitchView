//
//  SKSliderSwitchView.m
//  OutsideThings
//
//  Created by lilekai on 2018/4/25.
//  Copyright © 2018年 lilekai. All rights reserved.
//

#import "SKSliderSwitchView.h"

#define kTabBarHeight   44
#define kNomColor   [UIColor blackColor]
#define kSelColor   [UIColor redColor]
#define kBGColor    [UIColor redColor]
#define kNomFont    [UIFont systemFontOfSize:14]
#define kSelFont    [UIFont systemFontOfSize:16]

@interface SKSliderSwitchView ()

@property (nonatomic, strong, readonly) SKTopSwithView *tabBar;
@property (nonatomic, strong) UIScrollView *rootScrollView;

@end

@implementation SKSliderSwitchView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initValues];
    }
    return self;
}

#pragma mark - 初始化参数
- (void)initValues{
    
    //创建主滚动视图
    _rootScrollView = [[UIScrollView alloc] init];
    _rootScrollView.delegate = self;
    _rootScrollView.pagingEnabled = YES;
    _rootScrollView.userInteractionEnabled = YES;
    _rootScrollView.bounces = NO;
    _rootScrollView.showsHorizontalScrollIndicator = NO;
    _rootScrollView.showsVerticalScrollIndicator = NO;
    _rootScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    if (@available(iOS 11.0, *)) {
        _rootScrollView.contentInsetAdjustmentBehavior  =  UIScrollViewContentInsetAdjustmentNever;
    }
    
    
    [self addSubview:_rootScrollView];
    
    // tab
    _tabBar = [[SKTopSwithView alloc] init];
    _tabBar.delegate = self;
    _loadViewOfChildContollerWhileAppear = NO;
    _tabBar.itemFontChangeFollowContentScroll = YES;
    _tabBar.itemColorChangeFollowContentScroll = YES;
    
    _tabItemTitleColor = kNomColor;
    _tabItemTitleSelectedColor = kSelColor;
    _tabItemSelectedBgColor = kSelColor;
    _tabItemTitleFont = kNomFont;
    _tabItemTitleSelectedFont = kSelFont;
    _leftAndRightSpacing = 10;
    
    [self addSubview:_tabBar];
    [self setupFrameOfTabBarAndContentView];
}

// 设置默认的tabBar的frame和contentViewFrame
- (void)setupFrameOfTabBarAndContentView {
    CGSize screenSize = self.bounds.size;
    CGFloat contentViewHeight = screenSize.height - kTabBarHeight;
    [self setTabBarFrame:CGRectMake(0, 0, screenSize.width, kTabBarHeight)
        contentViewFrame:CGRectMake(0, kTabBarHeight, screenSize.width, contentViewHeight)];
}

// 设置tabBar的frame和contentViewFrame
- (void)setTabBarFrame:(CGRect)tabBarFrame contentViewFrame:(CGRect)contentViewFrame {
    self.tabBar.frame = tabBarFrame;
    self.contentViewFrame = contentViewFrame;
}

- (void)setContentViewHeight:(CGFloat)H{
    self.contentViewFrame = CGRectMake(self.contentViewFrame.origin.x, self.contentViewFrame.origin.y, self.contentViewFrame.size.width, H);
    [self updateContentViewsFrame];
}

- (void)setViewControllers:(NSArray *)viewControllers {
    
    for (UIViewController *controller in _viewControllers) {
        [controller removeFromParentViewController];
        [controller.view removeFromSuperview];
    }
    
    _viewControllers = [viewControllers copy];
    
    NSMutableArray *items = [NSMutableArray array];
    if (_itemAttrTitles.count) {
        if (_itemAttrTitles.count != _viewControllers.count) {
            NSLog(@"attrTitles数量不对");
            return;
        }
        
        for (NSAttributedString *attrStr in _itemAttrTitles) {
            SKSwithItem *item = [SKSwithItem buttonWithType:UIButtonTypeCustom];
            item.attrTitle = attrStr;
            [items addObject:item];
        }
    }else{
        for (UIViewController *controller in _viewControllers) {
            SKSwithItem *item = [SKSwithItem buttonWithType:UIButtonTypeCustom];
            item.title = controller.title;
            [items addObject:item];
        }
    }
    
    self.tabBar.items = items;
    
    _tabBar.itemTitleColor = self.tabItemTitleColor;
    _tabBar.itemTitleSelectedColor = self.tabItemTitleSelectedColor;
    _tabBar.itemSelectedBgColor = self.tabItemSelectedBgColor;
    _tabBar.itemTitleFont = self.tabItemTitleFont;
    _tabBar.itemTitleSelectedFont = self.tabItemTitleSelectedFont;
    _tabBar.leftAndRightSpacing = self.leftAndRightSpacing;
    
    [_tabBar setScrollEnabledAndItemFitTextWidthWithSpacing:20 andIsFullWidth:_isFullWidth];
    [_tabBar setItemSelectedBgInsets:UIEdgeInsetsMake(kTabBarHeight - 2, 10, 0, 10) tapSwitchAnimated:NO];
    
    self.rootScrollView.contentSize = CGSizeMake(self.contentViewFrame.size.width * _viewControllers.count, self.contentViewFrame.size.height);
    
    [_tabBar setSelectedItemIndex:0];
    
    [self updateContentViewsFrame];
}

- (void)updateContentViewsFrame {
    self.rootScrollView.frame = self.contentViewFrame;
    self.rootScrollView.contentSize = CGSizeMake(self.contentViewFrame.size.width * self.viewControllers.count,
                                                 self.contentViewFrame.size.height);
    [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull controller,
                                                       NSUInteger idx, BOOL * _Nonnull stop) {
        if (controller.isViewLoaded) {
            controller.view.frame = [self frameForControllerAtIndex:idx];
        }
    }];
    [self.rootScrollView scrollRectToVisible:self.selectedController.view.frame animated:NO];
    
}

- (CGRect)frameForControllerAtIndex:(NSInteger)index {
    return CGRectMake(index * self.contentViewFrame.size.width, 0, self.contentViewFrame.size.width, self.contentViewFrame.size.height);
}

- (void)setSelectedControllerIndex:(NSInteger)selectedControllerIndex {
    _tabBar.selectedItemIndex = selectedControllerIndex;
}

- (void)setLoadViewOfChildContollerWhileAppear:(BOOL)loadViewOfChildContollerWhileAppear{
    _loadViewOfChildContollerWhileAppear = loadViewOfChildContollerWhileAppear;
}

- (void)setTabItemTitleColor:(UIColor *)tabItemTitleColor{
    _tabItemTitleColor = tabItemTitleColor;
}

- (void)setTabItemTitleSelectedColor:(UIColor *)tabItemTitleSelectedColor{
    _tabItemTitleSelectedColor = tabItemTitleSelectedColor;
}

- (void)setTabItemSelectedBgColor:(UIColor *)tabItemSelectedBgColor{
    _tabItemSelectedBgColor = tabItemSelectedBgColor;
}

- (void)setTabItemSelectedBgImage:(UIImage *)tabItemSelectedBgImage{
    _tabItemSelectedBgImage = tabItemSelectedBgImage;
}

- (void)setTabItemSelectedBgCornerRadius:(CGFloat)tabItemSelectedBgCornerRadius{
    _tabItemSelectedBgCornerRadius = tabItemSelectedBgCornerRadius;
}

- (void)setLeftAndRightSpacing:(CGFloat)leftAndRightSpacing{
    _leftAndRightSpacing = leftAndRightSpacing;
}

- (void)setTabItemTitleFont:(UIFont *)tabItemTitleFont{
    _tabItemTitleFont = tabItemTitleFont;
}

- (void)setTabItemTitleSelectedFont:(UIFont *)tabItemTitleSelectedFont{
    _tabItemTitleSelectedFont = tabItemTitleSelectedFont;
}

- (void)addOtherItem:(SKSwithItem *)item{
    
    __weak typeof(self) weakSelf = self;
    [_tabBar setOtherItem:item tapHandler:^(SKSwithItem *item) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(slideSwitchView:OtherItemHandler:)]) {
            [weakSelf.delegate slideSwitchView:weakSelf OtherItemHandler:item];
        }
    }];
}

- (UIViewController *)selectedController {
    if (self.selectedControllerIndex >= 0) {
        return self.viewControllers[self.selectedControllerIndex];
    }
    return nil;
}

#pragma mark - YPTabBarDelegate
- (void)topSwithView:(SKTopSwithView *)topView didSelectedItemAtIndex:(NSInteger)index {
    
    UIViewController *oldController = nil;
    if (self.selectedControllerIndex >= 0) {
        oldController = self.viewControllers[self.selectedControllerIndex];
        [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull controller, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx != index && controller.isViewLoaded && controller.view.superview) {
                [controller.view removeFromSuperview];
            }
        }];
    }
    UIViewController *curController = self.viewControllers[index];
    
    if (!curController.isViewLoaded) {
        curController.view.frame = [self frameForControllerAtIndex:index];
    }
    
    [self.rootScrollView addSubview:curController.view];
    // 切换到curController
    [self.rootScrollView scrollRectToVisible:curController.view.frame animated:NO];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(slideSwitchView:didselectTab:)]) {
        [self.delegate slideSwitchView:self didselectTab:index];
    }
    
    // 当contentView为scrollView及其子类时，设置它支持点击状态栏回到顶部
    if (oldController && [oldController.view isKindOfClass:[UIScrollView class]]) {
        [(UIScrollView *)oldController.view setScrollsToTop:NO];
    }
    if ([curController.view isKindOfClass:[UIScrollView class]]) {
        [(UIScrollView *)curController.view setScrollsToTop:YES];
    }
    //    UIResponder
    _selectedControllerIndex = index;
}

/**
 *  是否能切换到指定index
 */
- (BOOL)topSwithView:(SKTopSwithView *)topView shouldSelectItemAtIndex:(NSInteger)index{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(slideSwitchView:shouldSelectItemAtIndex:)]) {
        return [self.delegate slideSwitchView:self shouldSelectItemAtIndex:index];
    }
    return YES;
}

/**
 *  将要切换到指定index
 */
- (void)topSwithView:(SKTopSwithView *)topView willSelectItemAtIndex:(NSInteger)index{
    // 可以写代理
    if (self.delegate && [self.delegate respondsToSelector:@selector(slideSwitchView:willSelectItemAtIndex:)]) {
        [self.delegate slideSwitchView:self willSelectItemAtIndex:index];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger page = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.tabBar.selectedItemIndex = page;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 如果不是手势拖动导致的此方法被调用，不处理
    if (!(scrollView.isDragging || scrollView.isDecelerating)) {
        return;
    }
    
    // 滑动越界不处理
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat scrollViewWidth = scrollView.frame.size.width;
    if (offsetX < 0) {
        return;
    }
    if (offsetX > scrollView.contentSize.width - scrollViewWidth) {
        return;
    }
    
    NSInteger leftIndex = offsetX / scrollViewWidth;
    NSInteger rightIndex = leftIndex + 1;
    if (leftIndex == offsetX / scrollViewWidth) {
        rightIndex = leftIndex;
    }
    // 将需要显示的child view放到scrollView上
    for (NSInteger index = leftIndex; index <= rightIndex; index++) {
        UIViewController *controller = self.viewControllers[index];
        
        if (!controller.isViewLoaded && self.loadViewOfChildContollerWhileAppear) {
            controller.view.frame = [self frameForControllerAtIndex:index];
        }
        if (controller.isViewLoaded && !controller.view.superview) {
            [self.rootScrollView addSubview:controller.view];
        }
    }
    
    // 同步修改tarBar的子视图状态
    [self.tabBar updateSubViewsWhenParentScrollViewScroll:self.rootScrollView];
}


@end
