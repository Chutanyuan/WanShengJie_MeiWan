//
//  StateAllController.m
//  MeiWan
//
//  Created by user_kevin on 16/11/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "StateAllController.h"
#import "stateTitleView.h"

@interface StateAllController ()

@end

@implementation StateAllController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarTintColor:[CorlorTransform colorWithHexString:@"78cdf8"]];
    self.navigationController.title = @"最新动态";
    stateTitleView * view = [[stateTitleView alloc]initWithFrame:CGRectMake(0, 0, dtScreenWidth, 44)];
    [self.navigationController.navigationItem setTitleView:view];

}


@end
