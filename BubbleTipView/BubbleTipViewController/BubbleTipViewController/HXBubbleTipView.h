//
//  HXBubbleTipView.h
//  BubbleTipViewController
//
//  Created by LinchaoHui on 16/9/27.
//  Copyright © 2016年 LinchaoHui. All rights reserved.
//
// #*  气泡引导标签视图  *#
//
//       ---------------------                   /\
//      |  This is a tipview  |        ----------  ---------
//       ----------  ---------        |  This is a tipview  |
//                 \/                  ---------------------
//

#import <UIKit/UIKit.h>

//箭头的方向
typedef NS_ENUM(NSInteger,Arrow_Orientation)
{
    Arrow_Up=0,
    Arrow_Down
};

@interface HXBubbleTipView : UIView
//初始化函数
- (instancetype)initBubbleTipViewWithSuperFrame:(CGRect)superviewFrame ArrowLocation:(CGPoint)arrowlocation Title:(NSString *)title Orientation:(Arrow_Orientation)orientation;
//设置是否开启出现个消失的动画
- (void)setAppearWithAnimation:(BOOL)isAni_A andDisAppearWithAnimation:(BOOL)isAni_D;
//视图显示操作
- (void)TipViewAppear;
@end
