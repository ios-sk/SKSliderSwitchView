//
//  SKTopSwithView.m
//  OutsideThings
//
//  Created by lilekai on 2018/4/25.
//  Copyright © 2018年 lilekai. All rights reserved.
//

#import "SKTopSwithView.h"

@interface SKTopSwithView ()

// 当TabBar支持滚动时，使用此scrollView
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) SKSwithItem *otherItem;

@property (nonatomic, strong) UIView *otherLien;

@property (nonatomic, copy) void (^otherItemHandler)(SKSwithItem *item);

// 选中背景
@property (nonatomic, strong) UIImageView *itemSelectedBgImageView;

// 选中背景相对于YPTabItem的insets
@property (nonatomic, assign) UIEdgeInsets itemSelectedBgInsets;

// Item选中切换时，是否显示动画
@property (nonatomic, assign) BOOL itemSelectedBgSwitchAnimated;

// Item是否匹配title的文字宽度
@property (nonatomic, assign) BOOL itemFitTextWidth;

// item是否平分宽度 默认为NO
@property (nonatomic, assign) BOOL itemFullWidth;

// 当Item匹配title的文字宽度时，左右留出的空隙，item的宽度 = 文字宽度 + spacing
@property (nonatomic, assign) CGFloat itemFitTextWidthSpacing;

// item的宽度
@property (nonatomic, assign) CGFloat itemWidth;

// item的内容水平居中时，image与顶部的距离
@property (nonatomic, assign) CGFloat itemContentHorizontalCenterVerticalOffset;

// item的内容水平居中时，title与image的距离
@property (nonatomic, assign) CGFloat itemContentHorizontalCenterSpacing;


@end


@implementation SKTopSwithView

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
    
    _selectedItemIndex = -1;
    _itemSelectedBgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _itemContentHorizontalCenter = YES;
    _itemFontChangeFollowContentScroll = NO;
    _itemColorChangeFollowContentScroll = YES;
    _itemSelectedBgScrollFollowContent = YES;
    
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    // 更新选中背景的frame
    [self updateSelectedBgFrameWithIndex:self.selectedItemIndex];
}

- (void)setItems:(NSArray *)items {
    // 将老的item从superview上删除
    [_items makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _items = [items copy];
    
    // 初始化每一个item
    for (SKSwithItem *item in self.items) {
        item.titleColor = self.itemTitleColor;
        item.titleSelectedColor = self.itemTitleSelectedColor;
        item.titleFont = self.itemTitleFont;
        
        [item setContentHorizontalCenterWithVerticalOffset:5 spacing:5];
        
        [item addTarget:self action:@selector(tabItemClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        __weak typeof(self) weakSelf = self;
        [item setDoubleTapHandler:^(NSInteger index) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(topSwithView:didSelectedItemDoubleTapAtIndex:)]) {
                [weakSelf.delegate topSwithView:weakSelf didSelectedItemDoubleTapAtIndex:index];
            }
        }];
        
    }
    // 更新每个item的位置
    [self updateItemsFrame];
    
    // 更新item的大小缩放
    [self updateItemsScaleIfNeeded];
}

- (void)setTitles:(NSArray *)titles {
    NSMutableArray *items = [NSMutableArray array];
    for (NSString *title in titles) {
        SKSwithItem *item = [[SKSwithItem alloc] init];
        item.title = title;
        [items addObject:item];
    }
    self.items = items;
}

- (void)setleftAndRightSpacing:(CGFloat)leftAndRightSpacing {
    _leftAndRightSpacing = leftAndRightSpacing;
    [self updateItemsFrame];
}

- (void)updateItemsFrame {
    if (self.items.count == 0) {
        return;
    }
    
    // 将item从superview上删除
    [self.items makeObjectsPerformSelector:@selector(removeFromSuperview)];
    // 将item的选中背景从superview上删除
    [self.itemSelectedBgImageView removeFromSuperview];
    
    [self.scrollView addSubview:self.itemSelectedBgImageView];
    CGFloat x = self.leftAndRightSpacing;
    
    if (_itemFullWidth) {
        // 平分宽度
        CGFloat allItemsWidth = self.frame.size.width - self.leftAndRightSpacing * 2;
        
        if (self.otherItem && self.otherItem.frame.size.width != 0) {
            self.itemWidth = (allItemsWidth - self.otherItem.frame.size.width) / self.items.count;
        } else {
            self.itemWidth = allItemsWidth / self.items.count;
        }
        
        // 四舍五入，取整，防止字体模糊
        self.itemWidth = floorf(self.itemWidth + 0.5f);
        
        for (NSInteger index = 0; index < self.items.count; index++) {
            SKSwithItem *item = self.items[index];
            item.frame = CGRectMake(x, 0, self.itemWidth, self.frame.size.height);
            item.index = index;
            x += self.itemWidth;
            [self.scrollView addSubview:item];
        }
        
    }else{
        
        if (self.otherItem && self.otherItem.frame.size.width != 0) {
            self.scrollView.frame = CGRectMake(0, 0, self.frame.size.width - self.otherItem.frame.size.width, self.frame.size.height);
        }
        
        for (NSInteger index = 0; index < self.items.count; index++) {
            SKSwithItem *item = self.items[index];
            CGFloat width = 0;
            // item的宽度为一个固定值
            if (self.itemWidth > 0) {
                width = self.itemWidth;
            }
            // item的宽度为根据字体大小和spacing进行适配
            if (self.itemFitTextWidth) {
                CGSize size = [item.title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                                       options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                    attributes:@{NSFontAttributeName : self.itemTitleFont}
                                                       context:nil].size;
                width = ceilf(size.width) + self.itemFitTextWidthSpacing;
            }
            
            item.frame = CGRectMake(x, 0, width, self.frame.size.height);
            item.index = index;
            x += width;
            [self.scrollView addSubview:item];
        }
        
    }
    
    // 如果有特殊的单独item，设置其位置 在最右侧
    if (self.otherItem && self.otherItem.frame.size.width != 0) {
        CGFloat width = self.otherItem.frame.size.width;
        CGFloat height = self.frame.size.height;
        self.otherItem.frame = CGRectMake(self.frame.size.width - width, 0, width, height);
        _otherLien.frame = CGRectMake(self.frame.size.width - width , 10, 1, height-20);
    }
    
    self.scrollView.contentSize = CGSizeMake(MAX(x + self.leftAndRightSpacing, self.scrollView.frame.size.width),
                                             self.scrollView.frame.size.height);
    
}

- (void)setSelectedItemIndex:(NSInteger)selectedItemIndex {
    
    if (selectedItemIndex == _selectedItemIndex ||
        selectedItemIndex < 0 ||
        selectedItemIndex >= self.items.count ||
        self.items.count == 0) {
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(topSwithView:shouldSelectItemAtIndex:)]) {
        BOOL should = [self.delegate topSwithView:self shouldSelectItemAtIndex:selectedItemIndex];
        if (!should) {
            return;
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(topSwithView:willSelectItemAtIndex:)]) {
        [self.delegate topSwithView:self willSelectItemAtIndex:selectedItemIndex];
    }
    
    if (_selectedItemIndex >= 0) {
        SKSwithItem *oldSelectedItem = self.items[_selectedItemIndex];
        oldSelectedItem.selected = NO;
        if (self.itemFontChangeFollowContentScroll) {
            // 如果支持字体平滑渐变切换，则设置item的scale
            oldSelectedItem.transform = CGAffineTransformMakeScale(self.itemTitleUnselectedFontScale,
                                                                   self.itemTitleUnselectedFontScale);
        } else {
            // 如果不支持字体平滑渐变切换，则直接设置字体
            oldSelectedItem.titleFont = self.itemTitleFont;
        }
    }
    
    SKSwithItem *newSelectedItem = self.items[selectedItemIndex];
    newSelectedItem.selected = YES;
    if (self.itemFontChangeFollowContentScroll) {
        // 如果支持字体平滑渐变切换，则设置item的scale
        newSelectedItem.transform = CGAffineTransformMakeScale(1, 1);
    } else {
        // 如果支持字体平滑渐变切换，则直接设置字体
        if (self.itemTitleSelectedFont) {
            newSelectedItem.titleFont = self.itemTitleSelectedFont;
        }
    }
    
    if (self.itemSelectedBgSwitchAnimated && _selectedItemIndex >= 0) {
        [UIView animateWithDuration:0.25f animations:^{
            [self updateSelectedBgFrameWithIndex:selectedItemIndex];
        }];
    } else {
        [self updateSelectedBgFrameWithIndex:selectedItemIndex];
    }
    
    _selectedItemIndex = selectedItemIndex;
    
    // 如果tabbar支持滚动，将选中的item放到tabbar的中央
    [self setSelectedItemCenter];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(topSwithView:didSelectedItemAtIndex:)]) {
        
        [self.delegate topSwithView:self didSelectedItemAtIndex:selectedItemIndex];
    }
}

/**
 *  更新选中背景的frame
 */
- (void)updateSelectedBgFrameWithIndex:(NSInteger)index {
    if (index < 0) {
        return;
    }
    
    
    SKSwithItem *item = self.items[index];
    
    CGFloat x = item.frameWithOutTransform.origin.x + self.itemSelectedBgInsets.left;
    CGFloat y = item.frameWithOutTransform.origin.y + self.itemSelectedBgInsets.top;
    CGFloat width = item.frameWithOutTransform.size.width - self.itemSelectedBgInsets.left - self.itemSelectedBgInsets.right;
    CGFloat height = item.frameWithOutTransform.size.height - self.itemSelectedBgInsets.top - self.itemSelectedBgInsets.bottom;
    
    if (self.selectedBgFixedWidth > 0) {
        x += (item.frameWithOutTransform.size.width - self.selectedBgFixedWidth)/2;
        width = self.selectedBgFixedWidth - self.itemSelectedBgInsets.left - self.itemSelectedBgInsets.right;
    }
    
    self.itemSelectedBgImageView.frame = CGRectMake(x, y, width, height);
}

- (void)setScrollEnabledAndItemFitTextWidthWithSpacing:(CGFloat)spacing andIsFullWidth:(BOOL)fullWidth{
    self.itemFitTextWidth = YES;
    self.itemFitTextWidthSpacing = spacing;
    self.itemWidth = 0;
    self.itemFullWidth = fullWidth;
    [self updateItemsFrame];
}

- (void)setSelectedItemCenter {
    
    // 修改偏移量
    CGFloat offsetX = self.selectedItem.center.x - self.scrollView.frame.size.width * 0.5f;
    
    // 处理最小滚动偏移量
    if (offsetX < 0) {
        offsetX = 0;
    }
    
    // 处理最大滚动偏移量
    CGFloat maxOffsetX = self.scrollView.contentSize.width - self.scrollView.frame.size.width;
    if (offsetX > maxOffsetX) {
        offsetX = maxOffsetX;
    }
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

/**
 *  获取未选中字体与选中字体大小的比例
 */
- (CGFloat)itemTitleUnselectedFontScale {
    if (_itemTitleSelectedFont) {
        return self.itemTitleFont.pointSize / _itemTitleSelectedFont.pointSize;
    }
    return 1.0f;
}

- (void)tabItemClicked:(SKSwithItem *)item {
    self.selectedItemIndex = item.index;
}

- (void)otherItemClicked:(SKSwithItem *)item {
    if (self.otherItemHandler) {
        self.otherItemHandler(item);
    }
}

- (SKSwithItem *)selectedItem {
    if (self.selectedItemIndex < 0) {
        return nil;
    }
    return self.items[self.selectedItemIndex];
}

// 设置一个单独的item
- (void)setOtherItem:(SKSwithItem *)item tapHandler:(void (^)(SKSwithItem *item))handler {
    self.otherItem = item;
    [self.otherItem addTarget:self action:@selector(otherItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:item];
    
    _otherLien = [[UIView alloc] init];
    _otherLien.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.8];
    [self addSubview:_otherLien];
    
    [self updateItemsFrame];
    
    self.otherItemHandler = handler;
}

#pragma mark - ItemSelectedBg
- (void)setItemSelectedBgColor:(UIColor *)itemSelectedBgColor {
    _itemSelectedBgColor = itemSelectedBgColor;
    self.itemSelectedBgImageView.backgroundColor = itemSelectedBgColor;
}

- (void)setItemSelectedBgImage:(UIImage *)itemSelectedBgImage {
    _itemSelectedBgImage = itemSelectedBgImage;
    self.itemSelectedBgImageView.image = itemSelectedBgImage;
}

- (void)setItemSelectedBgCornerRadius:(CGFloat)itemSelectedBgCornerRadius {
    _itemSelectedBgCornerRadius = itemSelectedBgCornerRadius;
    self.itemSelectedBgImageView.clipsToBounds = YES;
    self.itemSelectedBgImageView.layer.cornerRadius = itemSelectedBgCornerRadius;
}

- (void)setItemSelectedBgInsets:(UIEdgeInsets)insets
              tapSwitchAnimated:(BOOL)animated{
    self.itemSelectedBgInsets = insets;
    self.itemSelectedBgSwitchAnimated = animated;
}

- (void)setItemSelectedBgInsets:(UIEdgeInsets)itemSelectedBgInsets {
    _itemSelectedBgInsets = itemSelectedBgInsets;
    if (self.items.count > 0 && self.selectedItemIndex >= 0) {
        [self updateSelectedBgFrameWithIndex:self.selectedItemIndex];
    }
}


#pragma mark - ItemTitle
- (void)setItemTitleColor:(UIColor *)itemTitleColor {
    _itemTitleColor = itemTitleColor;
    [self.items makeObjectsPerformSelector:@selector(setTitleColor:) withObject:itemTitleColor];
}

- (void)setItemTitleSelectedColor:(UIColor *)itemTitleSelectedColor {
    _itemTitleSelectedColor = itemTitleSelectedColor;
    [self.items makeObjectsPerformSelector:@selector(setTitleSelectedColor:) withObject:itemTitleSelectedColor];
}

- (void)setItemTitleFont:(UIFont *)itemTitleFont {
    _itemTitleFont = itemTitleFont;
    if (self.itemFontChangeFollowContentScroll) {
        // item字体支持平滑切换，更新每个item的scale
        [self updateItemsScaleIfNeeded];
    } else {
        // item字体不支持平滑切换，更新item的字体
        if (self.itemTitleSelectedFont) {
            // 设置了选中字体，则只更新未选中的item
            for (SKSwithItem *item in self.items) {
                if (!item.selected) {
                    [item setTitleFont:itemTitleFont];
                }
            }
        } else {
            // 未设置选中字体，更新所有item
            [self.items makeObjectsPerformSelector:@selector(setTitleFont:) withObject:itemTitleFont];
        }
    }
    if (self.itemFitTextWidth) {
        // 如果item的宽度是匹配文字的，更新item的位置
        [self updateItemsFrame];
    }
}

- (void)setItemTitleSelectedFont:(UIFont *)itemTitleSelectedFont {
    _itemTitleSelectedFont = itemTitleSelectedFont;
    self.selectedItem.titleFont = itemTitleSelectedFont;
    [self updateItemsScaleIfNeeded];
}

- (void)setItemFontChangeFollowContentScroll:(BOOL)itemFontChangeFollowContentScroll {
    _itemFontChangeFollowContentScroll = itemFontChangeFollowContentScroll;
    [self updateItemsScaleIfNeeded];
}

- (void)updateItemsScaleIfNeeded {
    if (self.itemTitleSelectedFont &&
        self.itemFontChangeFollowContentScroll &&
        self.itemTitleSelectedFont.pointSize != self.itemTitleFont.pointSize) {
        [self.items makeObjectsPerformSelector:@selector(setTitleFont:) withObject:self.itemTitleSelectedFont];
        for (SKSwithItem *item in self.items) {
            if (!item.selected) {
                item.transform = CGAffineTransformMakeScale(self.itemTitleUnselectedFontScale,
                                                            self.itemTitleUnselectedFontScale);
            }
        }
    }
}

#pragma mark - Item Content
- (void)setItemContentHorizontalCenter:(BOOL)itemContentHorizontalCenter {
    _itemContentHorizontalCenter = itemContentHorizontalCenter;
    if (itemContentHorizontalCenter) {
        [self setItemContentHorizontalCenterWithVerticalOffset:5 spacing:5];
    } else {
        self.itemContentHorizontalCenterVerticalOffset = 0;
        self.itemContentHorizontalCenterSpacing = 0;
        [self.items makeObjectsPerformSelector:@selector(setContentHorizontalCenter:) withObject:@(NO)];
    }
}

- (void)setItemContentHorizontalCenterWithVerticalOffset:(CGFloat)verticalOffset
                                                 spacing:(CGFloat)spacing {
    _itemContentHorizontalCenter = YES;
    self.itemContentHorizontalCenterVerticalOffset = verticalOffset;
    self.itemContentHorizontalCenterSpacing = spacing;
    for (SKSwithItem *item in self.items) {
        [item setContentHorizontalCenterWithVerticalOffset:verticalOffset spacing:spacing];
    }
}

#pragma mark - Others
- (void)updateSubViewsWhenParentScrollViewScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat scrollViewWidth = scrollView.frame.size.width;
    
    NSInteger leftIndex = offsetX / scrollViewWidth;
    NSInteger rightIndex = leftIndex + 1;
    
    SKSwithItem *leftItem = self.items[leftIndex];
    SKSwithItem *rightItem = nil;
    if (rightIndex < self.items.count) {
        rightItem = self.items[rightIndex];
    }
    
    // 计算右边按钮偏移量
    CGFloat rightScale = offsetX / scrollViewWidth;
    // 只想要 0~1
    rightScale = rightScale - leftIndex;
    CGFloat leftScale = 1 - rightScale;
    
    if (self.itemFontChangeFollowContentScroll && self.itemTitleUnselectedFontScale != 1.0f) {
        // 如果支持title大小跟随content的拖动进行变化，并且未选中字体和已选中字体的大小不一致
        
        // 计算字体大小的差值
        CGFloat diff = self.itemTitleUnselectedFontScale - 1;
        // 根据偏移量和差值，计算缩放值
        leftItem.transform = CGAffineTransformMakeScale(rightScale * diff + 1, rightScale * diff + 1);
        rightItem.transform = CGAffineTransformMakeScale(leftScale * diff + 1, leftScale * diff + 1);
    }
    
    if (self.itemColorChangeFollowContentScroll) {
        CGFloat normalRed, normalGreen, normalBlue, normalAlpha;
        CGFloat selectedRed, selectedGreen, selectedBlue, selectedAlpha;
        
        [self.itemTitleColor getRed:&normalRed green:&normalGreen blue:&normalBlue alpha:&normalAlpha];
        [self.itemTitleSelectedColor getRed:&selectedRed green:&selectedGreen blue:&selectedBlue alpha:&selectedAlpha];
        // 获取选中和未选中状态的颜色差值
        CGFloat redDiff = selectedRed - normalRed;
        CGFloat greenDiff = selectedGreen - normalGreen;
        CGFloat blueDiff = selectedBlue - normalBlue;
        CGFloat alphaDiff = selectedAlpha - normalAlpha;
        // 根据颜色值的差值和偏移量，设置tabItem的标题颜色
        leftItem.titleLabel.textColor = [UIColor colorWithRed:leftScale * redDiff + normalRed
                                                        green:leftScale * greenDiff + normalGreen
                                                         blue:leftScale * blueDiff + normalBlue
                                                        alpha:leftScale * alphaDiff + normalAlpha];
        rightItem.titleLabel.textColor = [UIColor colorWithRed:rightScale * redDiff + normalRed
                                                         green:rightScale * greenDiff + normalGreen
                                                          blue:rightScale * blueDiff + normalBlue
                                                         alpha:rightScale * alphaDiff + normalAlpha];
    }
    
    // 计算背景的frame
    if (self.itemSelectedBgScrollFollowContent) {
        CGRect frame = self.itemSelectedBgImageView.frame;
        
        CGFloat rightItemX = rightItem.frameWithOutTransform.origin.x;
        CGFloat leftItemX = leftItem.frameWithOutTransform.origin.x;
        
        if (self.selectedBgFixedWidth > 0) {
            rightItemX += (rightItem.frameWithOutTransform.size.width - self.selectedBgFixedWidth) / 2;
            leftItemX += (leftItem.frameWithOutTransform.size.width - self.selectedBgFixedWidth) / 2;
        }
        
        CGFloat xDiff = rightItemX - leftItemX;
        
        if (self.selectedBgFixedWidth > 0) {
            frame.origin.x = rightScale * xDiff + leftItem.frameWithOutTransform.origin.x + self.itemSelectedBgInsets.left + (leftItem.frameWithOutTransform.size.width - self.selectedBgFixedWidth) / 2;
            frame.size.width = self.selectedBgFixedWidth - self.itemSelectedBgInsets.left - self.itemSelectedBgInsets.right;
            
        }else{
            frame.origin.x = rightScale * xDiff + leftItem.frameWithOutTransform.origin.x + self.itemSelectedBgInsets.left;
            
            CGFloat widthDiff = rightItem.frameWithOutTransform.size.width - leftItem.frameWithOutTransform.size.width;
            if (widthDiff != 0) {
                CGFloat leftSelectedBgWidth = leftItem.frameWithOutTransform.size.width - self.itemSelectedBgInsets.left - self.itemSelectedBgInsets.right;
                frame.size.width = rightScale * widthDiff + leftSelectedBgWidth;
            }
        }
        
        self.itemSelectedBgImageView.frame = frame;
    }
}


@end
