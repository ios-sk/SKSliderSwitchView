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
- (void)slideSwitchView:(SKSliderSwitchView *)view didselectTab:(NSUInteger)number;

/**
 *  是否能切换到指定index
 */
- (BOOL)slideSwitchView:(SKSliderSwitchView *)view shouldSelectItemAtIndex:(NSInteger)index;

/**
 *  将要切换到指定index
 */
- (void)slideSwitchView:(SKSliderSwitchView *)view willSelectItemAtIndex:(NSInteger)index;

/**
 *  最右边按钮点击事件
 */
- (void)slideSwitchView:(SKSliderSwitchView *)view OtherItemHandler:(SKSwithItem *)item;

@end

@interface SKSliderSwitchView : UIView<UIScrollViewDelegate, SKTopSwithViewDelegate>

@property (nonatomic, strong) UIImage *tabItemSelectedBgImage;         // item选中背景图像
@property (nonatomic, assign) CGFloat tabItemSelectedBgCornerRadius;   // item选中背景圆角
@property (nonatomic, assign) CGFloat leftAndRightSpacing;             // TabBar边缘与第一个和最后一个item的距离
@property (nonatomic, strong) UIColor *tabItemSelectedBgColor;         // item选中背景颜色
@property (nonatomic, strong) UIColor *tabItemTitleColor;              // 标题颜色
@property (nonatomic, strong) UIColor *tabItemTitleSelectedColor;      // 选中时标题的颜色
@property (nonatomic, strong) UIFont  *tabItemTitleFont;               // 标题字体
@property (nonatomic, strong) UIFont  *tabItemTitleSelectedFont;       // 选中时标题的字体
@property (nonatomic, assign) BOOL isFullWidth;                        // 是否平分宽度
@property (nonatomic, assign)  id<SKSliderSwitchViewDeleagte> delegate;

@property (nonatomic, strong) NSArray *itemAttrTitles; // item的attr标题  必须和vc的数量一样

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

- (void)setContentViewHeight:(CGFloat)H;


@end
