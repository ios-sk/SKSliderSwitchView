//
//  SKSliderSwitchView.h
//  OutsideThings
//
//  Created by lilekai on 2018/4/25.
//  Copyright © 2018年 lilekai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSwithItem.h"
#import "SKTopSwithView.h"

@class SKSliderSwitchView;

@protocol SKSliderSwitchViewDeleagte <NSObject>

@optional
/**
 *  切换到指定index
 */
- (void)sliderSwitchView:(SKSliderSwitchView *)view didSelectItemAtIndex:(NSUInteger)index;

/**
 *  是否能切换到指定index
 */
- (BOOL)sliderSwitchView:(SKSliderSwitchView *)view shouldSelectItemAtIndex:(NSInteger)index;

/**
 *  将要切换到指定index
 */
- (void)sliderSwitchView:(SKSliderSwitchView *)view willSelectItemAtIndex:(NSInteger)index;

/**
 *  已经选中的index双击
 */
- (void)sliderSwitchView:(SKSliderSwitchView *)view didSelectedItemDoubleTapAtIndex:(NSInteger)index;

/**
 *  最右边按钮点击事件
 */
- (void)sliderSwitchView:(SKSliderSwitchView *)view OtherItemHandler:(SKSwithItem *)item;

@end

@interface SKSliderSwitchView : UIView

/**
 * item选中背景图像
 */
@property (nonatomic, strong) UIImage *tabItemSelectedBgImage;

/**
 * item选中背景圆角
 */
@property (nonatomic, assign) CGFloat tabItemSelectedBgCornerRadius;

/**
 * TabBar边缘与第一个和最后一个item的距离
 */
@property (nonatomic, assign) CGFloat leftAndRightSpacing;

/**
 * item选中背景固定宽度
 */
@property (nonatomic, assign) CGFloat tabItemSelectedBgFixedWidth;

/**
 * item选中背景颜色
 */
@property (nonatomic, strong) UIColor *tabItemSelectedBgColor;

/**
 * 标题颜色
 */
@property (nonatomic, strong) UIColor *tabItemTitleColor;

/**
 * 选中时标题的颜色
 */
@property (nonatomic, strong) UIColor *tabItemTitleSelectedColor;

/**
 * 标题字体
 */
@property (nonatomic, strong) UIFont  *tabItemTitleFont;

/**
 * 选中时标题的字体
 */
@property (nonatomic, strong) UIFont  *tabItemTitleSelectedFont;

// 选中背景相对于TabItem的insets
@property (nonatomic, assign) UIEdgeInsets tabItemSelectedBgInsets;

/**
 * 是否平分宽度
 */
@property (nonatomic, assign) BOOL isFullWidth;

/**
 * item的attr标题  必须和vc的数量一样
 */
@property (nonatomic, strong) NSArray *itemAttrTitles;

/**
 所有的视图
 */
@property (nonatomic, copy) NSArray <UIViewController *> *viewControllers;

/**
 *  内容视图的Frame
 */
@property (nonatomic, assign) CGRect contentViewFrame;

/**
 *  被选中的ViewController的Index
 */
@property (nonatomic, assign) NSInteger selectedControllerIndex;

/**
 *  控制child view controller调用viewDidLoad方法的时机
 *  1. 值为YES时，拖动内容视图，一旦拖动到该child view controller所在的位置，立即加载其view
 *  2. 值为NO时，拖动内容视图，拖动到该child view controller所在的位置，不会立即其view，而是要等到手势结束，scrollView停止滚动后，再加载其view
 *  3. 默认值为NO
 */
@property (nonatomic, assign) BOOL loadViewOfChildContollerWhileAppear;


@property (nonatomic, assign)  id<SKSliderSwitchViewDeleagte> delegate;

/**
 手动设置tab位置 和content的位置
 
 @param tabBarFrame tab位置
 @param contentViewFrame content位置
 */
- (void)setTabBarFrame:(CGRect)tabBarFrame contentViewFrame:(CGRect)contentViewFrame;

/**
 *  添加一个特殊的Item到tabBar最后面，此Item不包含在tabBar的items数组里
 *
 *  @param item    Item对象
 */
- (void)addOtherItem:(SKSwithItem *)item;

/**
 *  获取被选中的ViewController
 */
- (UIViewController *)selectedController;

/**
 * tabBar高度
 */
+ (CGFloat)tabBarHeight;

@end
