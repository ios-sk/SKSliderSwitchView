//
//  ChildViewController.m
//  SKSliderSwitchView_Example
//
//  Created by 李烁凯 on 2019/4/16.
//  Copyright © 2019 luckyLSK. All rights reserved.
//

#import "ChildViewController.h"

@interface ChildViewController ()

@end

@implementation ChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 50)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = self.title;
    lable.textColor = [UIColor blackColor];
    [self.view addSubview:lable];
}


- (void)setViewColor:(UIColor *)viewColor{
    self.view.backgroundColor = viewColor;
}

@end
