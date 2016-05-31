//
//  RotateBtnView.m
//  jspatch
//
//  Created by tom on 16/4/5.
//  Copyright © 2016年 donler. All rights reserved.
//

#import "RXRotateButtonOverlayView.h"
#import "ImageAndTitleVerticalButton.h"

static CGFloat btnWidth = 60.0f;
static CGFloat btnOffsetY = 75.0;
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#define  ScreenWidth [UIScreen mainScreen].bounds.size.width
#define  ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface RXRotateButtonOverlayView ()
@property (nonatomic, strong) UIDynamicAnimator* animator;
@property (nonatomic, strong) UIButton* mainBtn;
@property (nonatomic, strong) NSMutableArray* btns;
@property (nonatomic, strong) UITapGestureRecognizer* tap;

@property(strong,nonatomic)UIVisualEffectView *myblurEffect;
@property(strong,nonatomic) UILabel * titlelable;

@end

@implementation RXRotateButtonOverlayView

- (instancetype)init
{
    if (self=[super init]) {
        
        self.myblurEffect = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        self.myblurEffect.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        self.myblurEffect.alpha = 0.9f;
        [self addSubview:self.myblurEffect];

        
    }
    return self;
}
- (void)blur
{
//    self.visualView.effect = nil;
    
//    [UIView animateWithDuration:1.0 delay:0.f usingSpringWithDamping:1.0 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
    
//        UIBlurEffect *effectView = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//        
//        UIVisualEffectView *visualView = [[UIVisualEffectView alloc]initWithEffect:effectView];
//        visualView.alpha = 1;
//        self.visualView = visualView;
//        visualView.frame = self.bounds;
//        
//        [self addSubview:visualView];

        
//    } completion:^(BOOL finished) {
//        
//    }];
    
//       [self insertSubview:visualView atIndex:0];
}

- (void)builtInterface
{
    [self removeGestureRecognizer:self.tap];
    [self addGestureRecognizer:self.tap];
    
    //setColor
    UILabel *titlelable = [[UILabel alloc]initWithFrame:CGRectMake(0, self.height - 280, self.width, 30)];
    [self addSubview:titlelable];
    titlelable.text = @"你想发布什么内容";
    titlelable.textAlignment = NSTextAlignmentCenter;
    titlelable.textColor = [UIColor whiteColor];
    self.titlelable = titlelable;
//    [self blur];
    
    
    //clear dynamic behaviours
    [self.animator removeAllBehaviors];
    //clear btns
    [self.btns enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self.btns removeAllObjects];
    
    //add new Btns
    if (self.titles.count > 0) {
        for (NSString* title in self.titles) {
            UIView* v = nil;
            if (self.titleImages.count == self.titles.count) {
                NSUInteger index = [self.titles indexOfObject:title];
                v = [self addBtnWithTitle:title andTitleImage:[self.titleImages objectAtIndex:index]];
            }else{
                v = [self addBtnWithTitle:title];
            }
            
            [self.btns addObject:v];
        }
        [self addSubview:self.mainBtn];
    }
}


#pragma mark - public
//show the overlay
- (void)show
{
    [self builtInterface];
    
    CGFloat margin = 40;
    CGFloat width=(ScreenWidth-margin*4)/2.0;
    
    
    [UIView animateWithDuration:.5 animations:^{
        self.mainBtn.transform = CGAffineTransformMakeRotation(M_PI_4);
    }];
    //
    for (int i = 0; i < 2; i ++) {
        
        //按钮要到的位置的frame
//        CGRect toValue = CGRectZero;
//        if (i == 0) {
//            toValue = CGRectMake(self.mainBtn.frame.origin.x - 80, self.mainBtn.frame.origin.y - 120, btnWidth, btnWidth);
//        }else{
//            toValue = CGRectMake(CGRectGetMaxX(self.mainBtn.frame) + 20, self.mainBtn.frame.origin.y - 120, btnWidth, btnWidth);
//        }
        CGRect toValue =CGRectMake(margin*(i+1)+(0.68+i)*width, ScreenHeight*0.67+width/2, btnWidth, btnWidth);
        
        UIButton *menuButton = [self.btns objectAtIndex:i];
        
        //pushButton *menuButton = self.btnArray[i];
        
        //从小到大
        CABasicAnimation *animationScale=[CABasicAnimation animation];
        animationScale.keyPath=@"transform.scale";
        animationScale.toValue=@(1.3);
        //透明度不断增大
        CABasicAnimation *animationoPacity=[CABasicAnimation animation];
        animationoPacity.keyPath=@"opacity";
        animationoPacity.fromValue=@(0);
        animationoPacity.toValue=@(1);
        //按钮有旋转
        CABasicAnimation *animationRotation=[CABasicAnimation animation];
        animationRotation.keyPath=@"transform.rotation.z";
        
        //根据按钮的出现顺序旋转的角度也不同
        animationRotation.fromValue=@(DEGREES_TO_RADIANS(90/(self.btns.count-i)));
        animationRotation.toValue=@(0);
        //有弹性效果
        
        /*
         * mass:
         质量，影响图层运动时的弹簧惯性，质量越大，弹簧拉伸和压缩的幅度越大
         * stiffness:
         刚度系数(劲度系数/弹性系数)，刚度系数越大，形变产生的力就越大，运动越快
         
         * damping:
         阻尼系数，阻止弹簧伸缩的系数，阻尼系数越大，停止越快
         
         * initialVelocity:
         初始速率，动画视图的初始速度大小
         速率为正数时，速度方向与运动方向一致，速率为负数时，速度方向与运动方向相反
         */
        
        
        CASpringAnimation *animationSpring=[CASpringAnimation animationWithKeyPath:@"position"];
        animationSpring.damping =8;
        animationSpring.stiffness = 120;
        animationSpring.mass = 0.6;
        animationSpring.initialVelocity = 0;
        animationSpring.toValue =[NSValue valueWithCGPoint:toValue.origin];
        
        
        CAAnimationGroup *animationGroup=[CAAnimationGroup animation];
        
        animationGroup.animations=@[animationoPacity,animationScale,animationRotation,animationSpring];
        animationGroup.duration=0.5;
        //让动画延迟执行
        animationGroup.beginTime=CACurrentMediaTime()+i*(0.4/self.btns.count);
        
        animationGroup.removedOnCompletion=NO;
        
        animationGroup.fillMode=kCAFillModeForwards;
        
        [menuButton.layer addAnimation:animationGroup forKey:[NSString stringWithFormat:@"animation%ld",(long)i]];
        
    }
}

//dismiss the overlay
- (void)dismiss
{
    [UIView animateWithDuration:.5 animations:^{
        //        self.mainBtn.transform = CGAffineTransformMakeRotation(M_PI / 180.0);
        self.mainBtn.transform=CGAffineTransformIdentity;
    }];
    
    for (int i = 0; i < 2; i ++) {
        
        UIButton *menuButton = [self.btns objectAtIndex:i];
        
        CABasicAnimation *animationoPacity=[CABasicAnimation animation];
        animationoPacity.keyPath=@"opacity";
        animationoPacity.toValue=@(1);
        animationoPacity.toValue=@(0.5);
        
        CABasicAnimation *animationScale=[CABasicAnimation animation];
        
        animationScale.keyPath=@"transform.scale";
        animationScale.toValue=@(0.7);
        
        
        CABasicAnimation *animationRotation=[CABasicAnimation animation];
        
        animationRotation.keyPath=@"transform.rotation.z";
        
        //animationRotation.fromValue=@(0);
        animationRotation.toValue=@(DEGREES_TO_RADIANS(90/(self.btns.count-i)));
        
        CABasicAnimation *animationPosition=[CABasicAnimation animationWithKeyPath:@"position"];
        
        animationPosition.toValue =[NSValue valueWithCGPoint:self.mainBtn.center];
        CAAnimationGroup *animationGroup=[CAAnimationGroup animation];
        
        animationGroup.animations=@[animationPosition,animationScale,animationoPacity];
        
        animationGroup.duration=0.23;
        
        animationGroup.beginTime=CACurrentMediaTime()+(self.btns.count-1-i)*(0.4/self.btns.count);
        
        animationGroup.removedOnCompletion=NO;
        
        animationGroup.fillMode=kCAFillModeForwards;
        if(i==0)
        {
            animationGroup.delegate=self;
        }
        
        
        [menuButton.layer addAnimation:animationGroup forKey:[NSString stringWithFormat:@"animationa%ld",(long)i]];
        
        
        
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
//        self.visualView.hidden = YES;
    });
}

#pragma mark - action

- (void)selectBtnAction:(UITapGestureRecognizer*)gesture
{
    UIButton* btn = (UIButton*)gesture.view;
    if ([self.delegate respondsToSelector:@selector(didSelected:)]) {
        [self.delegate didSelected:[self.titles indexOfObject:btn.titleLabel.text]];
//        self.visualView.hidden = YES;
        self.titlelable.hidden = YES;
    }
}



- (void)clickedSelf:(id)sender
{
    [self dismiss];
}
- (void)btnClicked:(id)sender
{
    [self dismiss];
}

#pragma mark - private
- (UIView*)addBtnWithTitle:(NSString*)title andTitleImage:(NSString*)imageName
{
    ImageAndTitleVerticalButton *view = [[ImageAndTitleVerticalButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2.0 - btnWidth / 2.0, [UIScreen mainScreen].bounds.size.height - btnOffsetY, btnWidth, btnWidth)];
    view.titleLabel.textColor = [UIColor whiteColor];
    [view setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [view setTitle:title forState:UIControlStateNormal];
    [view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    view.titleLabel.textAlignment = NSTextAlignmentCenter;
    view.titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:view];
    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectBtnAction:)]];
    return view;
}

- (UIView*)addBtnWithTitle:(NSString*)title
{
    UIButton *view = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2.0 - btnWidth / 2.0, [UIScreen mainScreen].bounds.size.height - btnOffsetY, btnWidth, btnWidth)];
    view.titleLabel.textColor = [UIColor whiteColor];
    view.backgroundColor = [UIColor yellowColor];
    [view setTitle:title forState:UIControlStateNormal];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = btnWidth / 2.0;
    [view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    view.titleLabel.textAlignment = NSTextAlignmentCenter;
    view.titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:view];
    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectBtnAction:)]];
    return view;
}


#pragma mark - getter & setter
- (UITapGestureRecognizer *)tap
{
    if (_tap == nil) {
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedSelf:)];
    }
    return _tap;
}

- (UIDynamicAnimator *)animator
{
    if (_animator == nil) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    }
    return _animator;
}
- (UIButton *)mainBtn
{
    if (_mainBtn == nil) {
        _mainBtn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2.0 - btnWidth / 2.0, [UIScreen mainScreen].bounds.size.height - btnOffsetY, btnWidth, btnWidth)];
        [_mainBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_mainBtn.layer setCornerRadius:btnWidth / 2.0];
        UIImage* image = [UIImage imageNamed:@"post_animate_add"];
        [_mainBtn setImage:image forState:UIControlStateNormal];
    }
    return _mainBtn;
}

- (NSMutableArray *)btns
{
    if (_btns == nil) {
        _btns = [NSMutableArray array];
    }
    return _btns;
}

- (void)setTitles:(NSArray *)titles
{
    self.btns = [NSMutableArray array];
    _titles = [NSArray arrayWithArray:titles];
}

- (void)setTitleImages:(NSArray *)titleImages
{
    self.btns = [NSMutableArray array];
    _titleImages = [NSArray arrayWithArray:titleImages];
}
@end
