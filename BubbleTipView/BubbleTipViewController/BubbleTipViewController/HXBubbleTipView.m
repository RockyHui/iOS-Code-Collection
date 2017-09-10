//
//  HXBubbleTipView.m
//  BubbleTipViewController
//
//  Created by LinchaoHui on 16/9/27.
//  Copyright © 2016年 LinchaoHui. All rights reserved.
//

#import "HXBubbleTipView.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
//常量根号3
#define MATH_GEN_3 1.1547
//阴影的宽度
#define SHADOW_PADDING 25.0
//标签视图距左右边框的最小距离
#define TIP_PADDING 10.0
//文本距标签的边距
#define LABEL_PADDING 12.0
//箭头的高度
#define ARROW_HEIGHT 22.0
//tipview的圆角
#define TIP_CORDIOUS 6.0
//标签视图的箭头距离屏幕左右的最小距离
#define ARROW_MIN_PADDING 40.0
//标签视图的最小宽度
//#define TIP_MIN_WIDTH 35.0

@interface HXBubbleTipView ()
//添加提示视图的frame
@property (nonatomic, assign) CGRect superviewFrame;
//提示的文本内容
@property (nonatomic, strong) NSString *tipText;
//tip视图
@property (nonatomic, strong) UIView *tipView;
//阴影视图
@property (nonatomic, strong) UIView *ghostView;
//字体大小
@property (nonatomic, assign) CGFloat textFont;
//蒙版视图
@property (nonatomic, strong) UIView *maskView;
//箭头的位置
@property (nonatomic, assign) CGPoint arrowLocation;
//箭头的方向
@property (nonatomic, assign) Arrow_Orientation orientation;

@property (nonatomic, assign) BOOL isAppearWithAnimation;

@property (nonatomic, assign) BOOL isDisAppearWithAnimation;

@end

@implementation HXBubbleTipView
//初始化方法
- (instancetype)initBubbleTipViewWithSuperFrame:(CGRect)superviewFrame ArrowLocation:(CGPoint)arrowlocation Title:(NSString *)title Orientation:(Arrow_Orientation)orientation
{
    self = [super init];
    if(self)
    {
        _superviewFrame = superviewFrame;
        if(arrowlocation.x < ARROW_MIN_PADDING)
        {
            arrowlocation.x = ARROW_MIN_PADDING;
        }
        else if(arrowlocation.x > SCREEN_WIDTH - ARROW_MIN_PADDING)
        {
            arrowlocation.x = SCREEN_WIDTH-ARROW_MIN_PADDING;
        }
        _arrowLocation = arrowlocation;
        _tipText       = title;
        _textFont      = 15.0;
        _orientation   = orientation;
        [self drawView];
    }
    return self;
}

- (void)drawView
{
    //容器视图（self）
    self.backgroundColor = [UIColor blueColor];
    [self setFrame:_superviewFrame];
    CGFloat self_x = self.frame.origin.x;
    CGFloat self_y = self.frame.origin.y;
    //蒙版视图
    self.maskView = [[UIView alloc]initWithFrame:self.bounds];
    self.maskView.backgroundColor = [UIColor redColor];
    UITapGestureRecognizer *tapGestureForMask = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TipViewDisAppear)];
    [self.maskView addGestureRecognizer:tapGestureForMask];
    [self addSubview:self.maskView];
    //计算文本所占的大小
    UILabel *tempLabel = [UILabel new];
    tempLabel.font = [UIFont systemFontOfSize:_textFont];
    tempLabel.text = _tipText;
    tempLabel.numberOfLines = 0;
    CGSize textSize = [tempLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH-2*(TIP_PADDING+LABEL_PADDING), CGFLOAT_MAX)];
    CGFloat tip_min_width = TIP_CORDIOUS*2 + ARROW_HEIGHT*MATH_GEN_3;
    if(textSize.width<tip_min_width)
    {
        textSize.width = tip_min_width;
    }
    
    self.tipView = [UIView new];
    self.tipView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tapGestureForTip = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TipViewDisAppear)];
    [self.tipView addGestureRecognizer:tapGestureForTip];
    CGFloat tipView_x,tipView_y,tipView_w,tipView_h;
    tipView_w = textSize.width + 2*LABEL_PADDING;
    tipView_h = textSize.height + 2*LABEL_PADDING;
    tipView_y = _orientation==Arrow_Down ? (_arrowLocation.y - tipView_h - ARROW_HEIGHT) : (_arrowLocation.y + ARROW_HEIGHT);
    CGFloat arrow_left_width   = _arrowLocation.x;
    CGFloat arrow_right_width  = SCREEN_WIDTH - _arrowLocation.x;
    if(arrow_left_width <= arrow_right_width)
    {
        if((textSize.width/2+TIP_PADDING+LABEL_PADDING) <= arrow_left_width)
        {
            tipView_x = arrow_left_width - (textSize.width/2+LABEL_PADDING);
        }
        else
        {
            tipView_x = TIP_PADDING;
        }
    }
    else
    {
        if((textSize.width/2+TIP_PADDING+LABEL_PADDING) <=arrow_right_width)
        {
            tipView_x = arrow_left_width - (textSize.width/2+LABEL_PADDING);
        }
        else
        {
            tipView_x = SCREEN_WIDTH - (textSize.width+2*LABEL_PADDING+TIP_PADDING);
        }
    }
    tipView_x -= self_x;
    tipView_y -= self_y;
    [self.tipView setFrame:CGRectMake(tipView_x, tipView_y, tipView_w, tipView_h)];
    [self addSubview:self.tipView];
    
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(LABEL_PADDING, LABEL_PADDING, textSize.width, textSize.height)];
    textLabel.font           = [UIFont systemFontOfSize:_textFont];
    textLabel.textAlignment  = NSTextAlignmentLeft;
    textLabel.text           = _tipText;
    textLabel.numberOfLines  = 0;
    [self.tipView addSubview:textLabel];

    //重新计算箭头所指的坐标在父视图中的位置
    _arrowLocation.x = _arrowLocation.x - self_x;
    _arrowLocation.y = _arrowLocation.y - self_y;
    
    //阴影视图
    self.ghostView = [[UIView alloc]initWithFrame:self.tipView.frame];
    [self.ghostView setBackgroundColor:[UIColor whiteColor]];
    self.ghostView.layer.shadowOpacity  = 0.3;
    self.ghostView.layer.shadowColor    = [UIColor grayColor].CGColor;
    self.ghostView.layer.shadowRadius   = 15;
    self.ghostView.layer.shadowOffset   = CGSizeMake(0, 0);
    self.ghostView.layer.cornerRadius   = TIP_CORDIOUS;
    self.ghostView.layer.masksToBounds  = NO;
    [self addSubview:self.ghostView];
    [self sendSubviewToBack:self.ghostView];
    
    float width  = self.tipView.bounds.size.width;
    float height = self.tipView.bounds.size.height;
    float x      = self.tipView.bounds.origin.x;
    float y      = self.tipView.bounds.origin.y;
    //路径阴影
    UIBezierPath *shaowpath = [UIBezierPath bezierPath];
    
    CGPoint shaow_topLeft      = CGPointMake(x, y-SHADOW_PADDING/2);
    CGPoint shaow_topRight     = CGPointMake(x+width,y-SHADOW_PADDING/2);
    CGPoint shaow_left_top     = CGPointMake(x, y);
    
    CGPoint shaow_leftTop      = CGPointMake(x-SHADOW_PADDING/2, y);
    CGPoint shaow_leftBottom   = CGPointMake(x-SHADOW_PADDING/2, y+height);
    CGPoint shaow_left_bottom  = CGPointMake(x, y+height);
    
    CGPoint shaow_bottomLeft   = CGPointMake(x,y+height+SHADOW_PADDING/2);
    CGPoint shaow_bottomRight  = CGPointMake(x+width+SHADOW_PADDING/2,y+height+SHADOW_PADDING/2);
    CGPoint shaow_right_bottom =CGPointMake(x+width, y+height);
    
    CGPoint shaow_rightTop     = CGPointMake(x+width+SHADOW_PADDING/2, y);
    CGPoint shaow_rightBottom  = CGPointMake(x+width+SHADOW_PADDING/2, y+height);
    CGPoint shaow_right_top    =CGPointMake(x+width, y);
    
    [shaowpath moveToPoint:shaow_topLeft];
    //添加路径
    [shaowpath addArcWithCenter:shaow_left_top radius:SHADOW_PADDING/2 startAngle:M_PI+M_PI_2 endAngle:M_PI clockwise:NO ];
     
    [shaowpath addLineToPoint:shaow_leftBottom];
    [shaowpath addArcWithCenter:shaow_left_bottom radius:SHADOW_PADDING/2 startAngle:M_PI endAngle:M_PI_2 clockwise:NO];
    [shaowpath addLineToPoint:shaow_bottomRight];
    [shaowpath addArcWithCenter:shaow_right_bottom radius:SHADOW_PADDING/2 startAngle:M_PI_2 endAngle:0 clockwise:NO];
    [shaowpath addLineToPoint:shaow_rightTop];
    [shaowpath addArcWithCenter:shaow_right_top radius:SHADOW_PADDING/2 startAngle:0 endAngle:M_PI_2+M_PI clockwise:NO];
    [shaowpath addLineToPoint:shaow_topLeft];
    [shaowpath closePath];
    //设置阴影路径
    self.ghostView.layer.shadowPath = shaowpath.CGPath;
    
    CGFloat offset = _orientation == Arrow_Up ? ARROW_HEIGHT : 0;
    //绘制形状
    CGPoint border_top_left    = CGPointMake(x-TIP_CORDIOUS, y+offset);
    CGPoint border_top_right   = CGPointMake(x+width-TIP_CORDIOUS, y+offset);
    CGPoint border_left_top_center = CGPointMake(x+TIP_CORDIOUS, y+TIP_CORDIOUS+offset);
    
    CGPoint border_left_top    = CGPointMake(x, y+TIP_CORDIOUS+offset);
    CGPoint border_left_bottom = CGPointMake(x, y+height-TIP_CORDIOUS+offset);
    CGPoint border_left_bottom_center = CGPointMake(x+TIP_CORDIOUS, y+height-TIP_CORDIOUS+offset);
    
    CGPoint border_bottom_left = CGPointMake(x+TIP_CORDIOUS, y+height+offset);
    CGPoint border_bottom_right= CGPointMake(x+width-TIP_CORDIOUS, y+height+offset);
    CGPoint border_right_bottom_center = CGPointMake(x+width-TIP_CORDIOUS, y+height-TIP_CORDIOUS+offset);
    
    CGPoint border_right_top   = CGPointMake(x+width, y+TIP_CORDIOUS+offset);
    CGPoint border_right_bottom=  CGPointMake(x+width, y+height-TIP_CORDIOUS+offset);
    CGPoint border_right_top_center = CGPointMake(x+width-TIP_CORDIOUS, y+TIP_CORDIOUS+offset);
    
    _arrowLocation.x = _arrowLocation.x- self.tipView.frame.origin.x;
    _arrowLocation.y = _arrowLocation.y- self.tipView.frame.origin.y;
    
    CGFloat arrow_border_width_2 = ARROW_HEIGHT*MATH_GEN_3/2;

    UIBezierPath *borderpath = [UIBezierPath bezierPath];
    [borderpath moveToPoint:border_top_left];
    [borderpath addArcWithCenter:border_left_top_center radius:TIP_CORDIOUS startAngle:M_PI+M_PI_2 endAngle:M_PI clockwise:NO];
    [borderpath addLineToPoint:border_left_bottom];
    [borderpath addArcWithCenter:border_left_bottom_center radius:TIP_CORDIOUS startAngle:M_PI endAngle:M_PI_2 clockwise:NO];
    //如果箭头朝下
    if(_orientation==Arrow_Down)
    {
        CGPoint arrow_point_1      = CGPointMake(_arrowLocation.x-arrow_border_width_2/2*3, y+height);
        CGPoint arrow_point_2      = CGPointMake(_arrowLocation.x-arrow_border_width_2, y+height);
        CGPoint arrow_point_3      = CGPointMake(_arrowLocation.x-arrow_border_width_2/2, y+height+ARROW_HEIGHT/2);
        CGPoint arrow_point_4      = CGPointMake(_arrowLocation.x, _arrowLocation.y);
        CGPoint arrow_point_5      = CGPointMake(_arrowLocation.x+arrow_border_width_2/2, y+height+ARROW_HEIGHT/2);
        CGPoint arrow_point_6      = CGPointMake(_arrowLocation.x+arrow_border_width_2, y+height);
        CGPoint arrow_point_7      = CGPointMake(_arrowLocation.x+arrow_border_width_2/2*3, y+height);
        [borderpath addLineToPoint:arrow_point_1];
        [borderpath addQuadCurveToPoint:arrow_point_3 controlPoint:arrow_point_2];
        [borderpath addQuadCurveToPoint:arrow_point_5 controlPoint:arrow_point_4];
        [borderpath addQuadCurveToPoint:arrow_point_7 controlPoint:arrow_point_6];
    }
    [borderpath addLineToPoint:border_bottom_right];
    [borderpath addArcWithCenter:border_right_bottom_center radius:TIP_CORDIOUS startAngle:M_PI_2 endAngle:0 clockwise:NO];
    [borderpath addLineToPoint:border_right_top];
    [borderpath addArcWithCenter:border_right_top_center radius:TIP_CORDIOUS startAngle:0 endAngle:M_PI_2+M_PI clockwise:NO];
    if(_orientation==Arrow_Up)
    {
        CGPoint arrow_point_7      = CGPointMake(_arrowLocation.x-arrow_border_width_2/2*3, y+offset);
        CGPoint arrow_point_6      = CGPointMake(_arrowLocation.x-arrow_border_width_2, y+offset);
        CGPoint arrow_point_5      = CGPointMake(_arrowLocation.x-arrow_border_width_2/2, y-ARROW_HEIGHT/2+offset);
        CGPoint arrow_point_4      = CGPointMake(_arrowLocation.x, 0);
        CGPoint arrow_point_3      = CGPointMake(_arrowLocation.x+arrow_border_width_2/2, y-ARROW_HEIGHT/2+offset);
        CGPoint arrow_point_2      = CGPointMake(_arrowLocation.x+arrow_border_width_2, y+offset);
        CGPoint arrow_point_1      = CGPointMake(_arrowLocation.x+arrow_border_width_2/2*3, y+offset);
        [borderpath addLineToPoint:arrow_point_1];
        [borderpath addQuadCurveToPoint:arrow_point_3 controlPoint:arrow_point_2];
        [borderpath addQuadCurveToPoint:arrow_point_5 controlPoint:arrow_point_4];
        [borderpath addQuadCurveToPoint:arrow_point_7 controlPoint:arrow_point_6];
    }
    [borderpath addLineToPoint:border_top_left];
    [borderpath closePath];
    
    CAShapeLayer *masklayer = [CAShapeLayer layer];
    masklayer.path = borderpath.CGPath;
    masklayer.fillColor = [UIColor whiteColor].CGColor;

    self.tipView.layer.mask = masklayer;
    CGRect frame = self.tipView.frame;
    frame.size.height += ARROW_HEIGHT;
    if(_orientation == Arrow_Up)
    {
        frame.origin.y -= ARROW_HEIGHT;
        CGRect labelFrame = textLabel.frame;
        labelFrame.origin.y += ARROW_HEIGHT;
        [textLabel setFrame:labelFrame];
    }
    [self.tipView setFrame:frame];
    
    [self setHidden:YES];
    self.alpha = 0.0f;
}

- (void)setAppearWithAnimation:(BOOL)isAni_A andDisAppearWithAnimation:(BOOL)isAni_D
{
    _isAppearWithAnimation    = isAni_A;
    _isDisAppearWithAnimation = isAni_D;
}

- (void)TipViewAppear
{
    [self setHidden:NO];
    if(_isAppearWithAnimation)
    {
        [UIView animateWithDuration:0.5f animations:^{
            self.alpha = 1.0f;
        }];
    }
    else
    {
        self.alpha = 1.0f;
    }
}

- (void)TipViewDisAppear
{
    
    if(_isDisAppearWithAnimation)
    {
        [UIView animateWithDuration:0.5f animations:^{
            self.alpha = 0.0f;
        } completion:^(BOOL finished) {;
            [self setHidden:YES];
            [self removeFromSuperview];
        }];
    }
    else
    {
        self.alpha = 0.0f;
        [self setHidden:YES];
        [self removeFromSuperview];
    }
}

#pragma mark - pointInside 

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    //tipView 视图的范围
    CGFloat tip_min_x  = CGRectGetMinX(self.ghostView.frame);
    CGFloat tip_max_x  = CGRectGetMaxX(self.ghostView.frame);
    CGFloat tip_min_y  = CGRectGetMinY(self.ghostView.frame);
    CGFloat tip_max_y  = CGRectGetMaxY(self.ghostView.frame);
    //maskView 视图的范围
    CGFloat mask_min_x = CGRectGetMinX(self.maskView.frame);
    CGFloat mask_max_x = CGRectGetMaxX(self.maskView.frame);
    CGFloat mask_min_y = CGRectGetMinY(self.maskView.frame);
    CGFloat mask_max_y = CGRectGetMaxY(self.maskView.frame);
    
    if((point.x < tip_max_x && point.x > tip_min_x) && (point.y < tip_max_y && point.y > tip_min_y))
    {
        return YES;
    }
    else if((point.x < mask_max_x && point.x > mask_min_x) && (point.y < mask_max_y && point.y > mask_min_y))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
@end
