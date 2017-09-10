//
//  ViewController.m
//  BubbleTipViewController
//
//  Created by LinchaoHui on 16/9/27.
//  Copyright © 2016年 LinchaoHui. All rights reserved.
//

#import "ViewController.h"
#import "HXBubbleTipView.h"

@interface ViewController ()

@property (nonatomic, strong) HXBubbleTipView *upTipView;

@property (nonatomic, strong) HXBubbleTipView *downTipView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 向上箭头提示
    _upTipView = [[HXBubbleTipView alloc] initBubbleTipViewWithSuperFrame:CGRectMake(100, 100, 50, 30) ArrowLocation:CGPointMake(125, 130) Title:@"这是一个新功能1" Orientation:Arrow_Up];
    [_upTipView setAppearWithAnimation:YES andDisAppearWithAnimation:YES];
    [self.view addSubview:_upTipView];
    
    // 向下箭头提示
    _downTipView = [[HXBubbleTipView alloc] initBubbleTipViewWithSuperFrame:CGRectMake(200, 300, 40, 40) ArrowLocation:CGPointMake(220, 300) Title:@"这是一个新功能2" Orientation:Arrow_Down];
    [_downTipView setAppearWithAnimation:YES andDisAppearWithAnimation:YES];
    [self.view addSubview:_downTipView];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [_upTipView TipViewAppear];
    
    [_downTipView TipViewAppear];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
