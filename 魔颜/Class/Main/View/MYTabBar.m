//
//  MYTabBar.m
//  魔颜
//
//  Created by Meiyue on 16/4/9.
//  Copyright © 2016年 Meiyue. All rights reserved.
//

#import "MYTabBar.h"
#import "RXRotateButtonOverlayView.h"
#import "MYPublicBtn.h"
#import "MYNavigateViewController.h"
#import "MYFinishViewController.h"
#import "MYAskQuestionViewController.h"
#import "MYRandomChatPublicViewController.h"
#import "MYTabBarController.h"
#import "MYLoginViewController.h"
#import "MYHeader.h"
#import "pushView.h"


@interface MYTabBar ()<RXRotateButtonOverlayViewDelegate>

/**<发布按钮*/
@property (nonatomic,weak) UIButton *publishButton;
@property(strong,nonatomic)pushView *myPushView;
@property (nonatomic, strong) RXRotateButtonOverlayView* overlayView;

@end

@implementation MYTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        //设置背景图片
        self.backgroundImage = [UIImage imageNamed:@"tabbar-light"];
        
        //添加+号按钮
         MYPublicBtn *publishButton = [MYPublicBtn buttonWithType:UIButtonTypeCustom];
        [publishButton setTitle:@"发布" forState:UIControlStateNormal];
        [publishButton setTitleColor:UIColorFromRGB(0x4c4c4c) forState:UIControlStateNormal];
        [publishButton setBackgroundImage:[UIImage imageNamed:@"post_animate_add"] forState:UIControlStateNormal];
//        [publishButton setBackgroundImage:[UIImage imageNamed:@"fabu"] forState:UIControlStateHighlighted];
        [publishButton sizeToFit];
        [publishButton addTarget:self action:@selector(publishClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.publishButton = publishButton;
        
        [self addSubview:self.publishButton];
        
    }
    return self;
}

- (void)publishClick
{
//    pushView *myview=[[pushView  alloc] init];
//    
//    self.myPushView=myview;

    
    MYTabBarController *tabVC = (MYTabBarController *)self.window.rootViewController;

    MYNavigateViewController *pushClassStance = (MYNavigateViewController *)tabVC.viewControllers[tabVC.selectedIndex];
    if (pushClassStance.viewControllers.count > 1) {
        return;
    }
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:self.overlayView];
    [self.overlayView show];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //设置发布按钮位置
    self.publishButton.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.1);
//    self.publishButton.width = 60;
//    self.publishButton.height = 60;

    //设置索引
    int index = 0;
    
    CGFloat tabBarButtonW = self.frame.size.width / 5;
    CGFloat tabBarButtonH = self.frame.size.height;
    CGFloat tabBarButtonY = 0;
    
    //设置UITabBarButton的位置
    for (UIView *tabBarButton in self.subviews) {
        if([NSStringFromClass([tabBarButton class]) isEqualToString:@"UITabBarButton"])
        {
            //计算x的位置
            CGFloat tabBarButtonX = index * tabBarButtonW;
            
            if(index >=2)
            {
                tabBarButtonX += tabBarButtonW;
            }
            
            //设置系统自带的UITabBarButton的frame
            tabBarButton.frame = CGRectMake(tabBarButtonX, tabBarButtonY, tabBarButtonW, tabBarButtonH);
            
            index++;
        }
        if ([tabBarButton isKindOfClass:[UIImageView class]] && tabBarButton.bounds.size.height <= 1) {
            UIImageView *ima = (UIImageView *)tabBarButton;
            ima.hidden = YES;
        }
    }
    
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *result = [super hitTest:point withEvent:event];
    CGPoint buttonPoint = [self.publishButton convertPoint:point fromView:self];
    if ([self.publishButton pointInside:buttonPoint withEvent:event]) {
        return _publishButton;
    }
    return result;
}

- (RXRotateButtonOverlayView *)overlayView
{
    if (_overlayView == nil) {
        _overlayView = [[RXRotateButtonOverlayView alloc] init];
        [_overlayView setTitles:@[@"随便聊聊",@"我要问"]];
        [_overlayView setTitleImages:@[@"post_animate_album",@"post_animate_camera"]];
        [_overlayView setDelegate:self];
        [_overlayView setFrame:[UIScreen mainScreen].bounds];
    }
    return _overlayView;
}
#pragma mark - RXRotateButtonOverlayViewDelegate
- (void)didSelected:(NSUInteger)index
{
    
    [_overlayView removeFromSuperview];
    
    if (!MYAppDelegate.isLogin) {
        
        [self push:@"MYLoginViewController" type:2];
        
    }else{

    
    if (index == 0){
        [self push:@"MYRandomChatPublicViewController" type:0];
    }else{
        [self push:@"MYAskQuestionViewController" type:1];
    }
    }
}
/**
 *  在此 万分感谢 技术交流群@小浣熊丢了干脆面的技术支持
 *
 *  @param params runtime好强大
 */
- (void)push:(NSString *)params type:(NSInteger )type
{
    NSString *class =params;
    const char *className = [class cStringUsingEncoding:NSASCIIStringEncoding];
    
    Class newClass = objc_getClass(className);
    if (!newClass){
        Class superClass = [NSObject class];
        newClass = objc_allocateClassPair(superClass, className, 0);
        objc_registerClassPair(newClass);
    }
    
    

    if (type == 0) {
        
        MYRandomChatPublicViewController *instance = [[newClass alloc] init];
        MYTabBarController *tabVC = (MYTabBarController *)self.window.rootViewController;
        MYNavigateViewController *pushClassStance = (MYNavigateViewController *)tabVC.viewControllers[tabVC.selectedIndex];
        instance.hidesBottomBarWhenPushed = YES;
        [pushClassStance pushViewController:instance animated:YES];

    }else{

        MYAskQuestionViewController *instance = [[newClass alloc] init];
        MYTabBarController *tabVC = (MYTabBarController *)self.window.rootViewController;
        MYNavigateViewController *pushClassStance = (MYNavigateViewController *)tabVC.viewControllers[tabVC.selectedIndex];
        instance.hidesBottomBarWhenPushed = YES;
        [pushClassStance pushViewController:instance animated:YES];
    }
    
}





@end
