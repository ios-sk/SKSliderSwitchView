//
//  ChildViewController.m
//  SKSliderSwitchViewDemo
//
//  Created by lilekai on 2018/5/28.
//  Copyright © 2018年 llk. All rights reserved.
//

#import "ChildViewController.h"

@interface ChildViewController ()

@end

@implementation ChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 50)];
    lable.text = self.title;
    lable.textColor = [UIColor blackColor];
    [self.view addSubview:lable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
