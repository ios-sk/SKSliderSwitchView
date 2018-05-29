//
//  ViewController.m
//  SKSliderSwitchViewDemo
//
//  Created by lilekai on 2018/5/28.
//  Copyright © 2018年 llk. All rights reserved.
//

#import "ViewController.h"
#import "SKSliderSwitchView.h"
#import "ChildViewController.h"

@interface ViewController ()<SKSliderSwitchViewDeleagte>

@property (nonatomic, retain) SKSliderSwitchView *slideSwitchView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSlideSwitchView];
}


// 滑动选择视图
- (void)initSlideSwitchView{
    _slideSwitchView = [[SKSliderSwitchView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    _slideSwitchView.delegate = self;
    _slideSwitchView.isFullWidth = NO;
    _slideSwitchView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_slideSwitchView];
    
//    self.slideSwitchView.tabItemTitleColor
//    self.slideSwitchView.tabItemTitleSelectedColor
//    self.slideSwitchView.tabItemSelectedBgColor
    
    ChildViewController *VC1 = [[ChildViewController alloc] init];
    VC1.title = @"测试1";
    [self addChildViewController:VC1];
    
    ChildViewController *VC2 = [[ChildViewController alloc] init];
    VC2.title = @"测试2";
    [self addChildViewController:VC1];
    
    ChildViewController *VC3 = [[ChildViewController alloc] init];
    VC3.title = @"测试3";
    [self addChildViewController:VC1];
    
    ChildViewController *VC4 = [[ChildViewController alloc] init];
    VC4.title = @"测试测试测试测试测试测试测试测试测试";
    [self addChildViewController:VC1];
    
    _slideSwitchView.viewControllers = [NSMutableArray arrayWithObjects:VC1, VC2, VC3, VC4, nil];
    
    
    SKSwithItem *item = [[SKSwithItem alloc] init];
    item.title = @"按钮";
    item.titleColor = [UIColor blueColor];
    item.titleFont = [UIFont systemFontOfSize:12];
    item.size = CGSizeMake(40, 40);
    [_slideSwitchView addOtherItem:item];
    
}

/**
 切换到指定index
 */
- (void)slideSwitchView:(SKSliderSwitchView *)view didselectTab:(NSUInteger)number{
   

}

/**
 *  最右边按钮点击事件
 */
- (void)slideSwitchView:(SKSliderSwitchView *)view OtherItemHandler:(SKSwithItem *)item{
    NSLog(@"1");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
