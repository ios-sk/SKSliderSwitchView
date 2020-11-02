//
//  SKViewController.m
//  SKSliderSwitchView
//
//  Created by luckyLSK on 04/16/2019.
//  Copyright (c) 2019 luckyLSK. All rights reserved.
//

#import "SKViewController.h"
#import "SKSliderSwitchView.h"
#import "ChildViewController.h"

@interface SKViewController ()<SKSliderSwitchViewDeleagte>

@property (nonatomic, retain) SKSliderSwitchView *sliderSwitchView;

@end

@implementation SKViewController

- (void)dealloc{
    NSLog(@"释放");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"SliderSwitchView";
    [self initSlideSwitchView];
}


// 滑动选择视图
- (void)initSlideSwitchView{
    _sliderSwitchView = [[SKSliderSwitchView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    _sliderSwitchView.delegate = self;
    _sliderSwitchView.isFullWidth = NO;
    _sliderSwitchView.tabItemSelectedBgImage = [UIImage imageNamed:@"icon_line"];
    _sliderSwitchView.tabItemSelectedBgFixedWidth = 20;
    _sliderSwitchView.tabItemSelectedBgColor = [UIColor whiteColor];
//    _sliderSwitchView.tabItemSelectedBgCornerRadius = 10;
    _sliderSwitchView.tabItemSelectedBgInsets = UIEdgeInsetsMake([SKSliderSwitchView tabBarHeight] - 6, 0, 2, 0);
    [self.view addSubview:_sliderSwitchView];
    
//    self.slideSwitchView.tabItemTitleColor
//    self.slideSwitchView.tabItemTitleSelectedColor
//    self.slideSwitchView.tabItemSelectedBgColor
    
    ChildViewController *VC1 = [[ChildViewController alloc] init];
    VC1.title = @"全部";    ;
    VC1.viewColor = [UIColor whiteColor];
    [self addChildViewController:VC1];
    
    ChildViewController *VC2 = [[ChildViewController alloc] init];
    VC2.title = @"进行中";
    VC2.viewColor = [UIColor redColor];
    [self addChildViewController:VC2];
    
    ChildViewController *VC3 = [[ChildViewController alloc] init];
    VC3.title = @"已完成";
    VC3.viewColor = [UIColor cyanColor];
    [self addChildViewController:VC3];
    
    ChildViewController *VC4 = [[ChildViewController alloc] init];
    VC4.title = @"待评价";
    VC4.viewColor = [UIColor brownColor];
    [self addChildViewController:VC4];
    
    ChildViewController *VC5 = [[ChildViewController alloc] init];
    VC5.title = @"待电话沟通";
    VC5.viewColor = [UIColor blueColor];
    [self addChildViewController:VC5];
    
    _sliderSwitchView.viewControllers = [NSMutableArray arrayWithObjects:VC1, VC2, VC3, VC4, VC5, nil];
    
    
    SKSwithItem *item = [[SKSwithItem alloc] init];
    item.title = @"筛选";
    item.titleColor = [UIColor blueColor];
    item.titleFont = [UIFont systemFontOfSize:12];
    item.size = CGSizeMake(40, 40);
    [_sliderSwitchView addOtherItem:item];
    
}

/**
 切换到指定index
 */
- (void)sliderSwitchView:(SKSliderSwitchView *)view didSelectItemAtIndex:(NSUInteger)index{
    NSLog(@"切换到了%ld", index);
}

- (void)sliderSwitchView:(SKSliderSwitchView *)view didSelectedItemDoubleTapAtIndex:(NSInteger)index{
    NSLog(@"选中的%ld双击", index);
}

/**
 *  最右边按钮点击事件
 */
- (void)slideSwitchView:(SKSliderSwitchView *)view OtherItemHandler:(SKSwithItem *)item{
    NSLog(@"右边按钮点击");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
