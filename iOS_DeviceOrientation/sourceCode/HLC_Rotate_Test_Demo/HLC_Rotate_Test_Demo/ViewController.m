//
//  ViewController.m
//  HLC_Rotate_Test_Demo
//
//  Created by Rocky on 2018/3/21.
//  Copyright © 2018年 Rocky. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加方向监听
    [self addApplicationOrientationObserver];
}


- (void)addApplicationOrientationObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDeviceOrientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWillRotate:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDidRotate:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)handleDeviceOrientationChanged:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    UIInterfaceOrientation appOrientation = [UIApplication sharedApplication].statusBarOrientation;
    
    
    NSLog(@"\nOrientation:%@\n User Info :%@", @(appOrientation), userInfo);
}

- (void)handleWillRotate:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSLog(@"\nWill Rotate %@", userInfo);
}

- (void)handleDidRotate:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSLog(@"\nDid Rotate %@", userInfo);
}

@end
