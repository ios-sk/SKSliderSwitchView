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

@property (nonatomic, retain) SKSliderSwitchView *slideSwitchView;

@end

@implementation SKViewController

- (void)viewDidLoad
{
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
    VC1.title = @"测试1";    ;
    VC1.viewColor = [UIColor whiteColor];
    [self addChildViewController:VC1];
    
    ChildViewController *VC2 = [[ChildViewController alloc] init];
    VC2.title = @"测试2";
    VC2.viewColor = [UIColor redColor];
    [self addChildViewController:VC2];
    
    ChildViewController *VC3 = [[ChildViewController alloc] init];
    VC3.title = @"测试3";
    VC3.viewColor = [UIColor cyanColor];
    [self addChildViewController:VC3];
    
    ChildViewController *VC4 = [[ChildViewController alloc] init];
    VC4.title = @"测试测试测试测试测试测试测试测试测试";
    VC4.viewColor = [UIColor brownColor];
    [self addChildViewController:VC4];
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
