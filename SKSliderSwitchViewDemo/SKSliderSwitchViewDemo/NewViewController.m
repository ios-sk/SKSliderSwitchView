//
//  NewViewController.m
//  SKSliderSwitchViewDemo
//
//  Created by 李烁凯 on 2020/11/2.
//  Copyright © 2020 llk. All rights reserved.
//

#import "NewViewController.h"
#import "ViewController.h"
@interface NewViewController ()

@end

@implementation NewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [button setTitle:@"点击" forState:(UIControlStateNormal)];
    button.backgroundColor = [UIColor redColor];
    button.frame = CGRectMake(10, 100, 50, 50);
    [button addTarget:self action:@selector(pushVC) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:button];
    
}

- (void)pushVC{
    [self.navigationController pushViewController:[ViewController new] animated:YES];
}


@end
