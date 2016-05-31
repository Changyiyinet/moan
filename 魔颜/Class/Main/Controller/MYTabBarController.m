//
//  WQTabBarController.m
//  魔颜
//
//  Created by abc on 15/9/23.
//  Copyright (c) 2015年 abc. All rights reserved.
//

#import "MYTabBarController.h"
#import "MYHomeViewController.h"
#import "MYMeTableViewController.h"
//#import "MYTranformationTableViewController.h"
#import "MYNavigateViewController.h"


//#import "MYDiscountStoreViewController.h"
#import "MYTiyanFirstViewController.h"
#import "MYDiscoverMianController.h"
#import "MYTabBar.h"

#import "MYAskQuestionViewController.h"
#import "MYRandomChatPublicViewController.h"
#import "MYHeader.h"

// iOS7
#define iOS7 ([UIDevice currentDevice].systemVersion.doubleValue >= 7.0)

@interface MYTabBarController ()<UITabBarControllerDelegate>

@end

@implementation MYTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MYHomeViewController *home = [[MYHomeViewController alloc]init];
    [self addChildVC:home title:@"首页" imageName:@"tabbar_icon_home_Normal" selIamgeName:@"tabbar_icon_home_Highlight"];
    
    MYDiscoverMianController *traformation = [[MYDiscoverMianController alloc]init];
    [self addChildVC:traformation title:@"发现" imageName:@"tabbar_icon_mojing_Normal" selIamgeName:@"tabbar_icon_mojing_Highlight"];
    
    MYTiyanFirstViewController *discount = [[MYTiyanFirstViewController alloc]init];
//    discount.scrollPoint = MYScreenW;
    [self addChildVC:discount title:@"体验" imageName:@"tabbar_icon_Sale_Normal" selIamgeName:@"tabbar_icon_Sale_Highlight"];
    
    MYMeTableViewController *profile = [[MYMeTableViewController alloc]init];
    [self addChildVC:profile title:@"我的" imageName:@"tabbar_icon_me_Normal" selIamgeName:@"tabbar_icon_me_Highlight"];
    

    //处理tabBar
    [self setupTabBar];
    
//    //设置item属性
    [self setItems];
}

/**
*  设置item文字属性
*/
- (void)setItems
{
    //设置文字属性
    NSMutableDictionary *attrsNomal = [NSMutableDictionary dictionary];
    //文字颜色
    attrsNomal[NSForegroundColorAttributeName] = UIColorFromRGB(0x4c4c4c);
    //文字大小
    attrsNomal[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    
    NSMutableDictionary *attrsSelected = [NSMutableDictionary dictionary];
    //文字颜色
    attrsSelected[NSForegroundColorAttributeName] = MYRedColor;
    
    //统一整体设置
    UITabBarItem *item = [UITabBarItem appearance]; //拿到底部的tabBarItem
    [item setTitleTextAttributes:attrsNomal forState:UIControlStateNormal];
    [item setTitleTextAttributes:attrsSelected forState:UIControlStateSelected];
}


/**
 *  处理tabBar
 */
- (void)setupTabBar
{
    //用kvc的方式将系统的tabbar换成我们自定义的
    MYTabBar *tabBar = [[MYTabBar alloc] init];
    [self setValue:tabBar forKeyPath:@"tabBar"];
    
    [tabBar setBackgroundImage:[UIImage imageNamed:@"juxing@2x(1)"]];
        
     
    
}
-(void)addChildVC:(UIViewController *)VC title:(NSString *)title imageName:(NSString *)imageName selIamgeName:(NSString *)selImageName
{
//    VC.view.backgroundColor = [UIColor whiteColor];
    VC.title = title;
    [VC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:MYRedColor,NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    
    // ios7之后系统会自动渲染图片，对tabBarItem的selected图片进行处理
    UIImage *selImage = [UIImage imageNamed:selImageName];
    
    // 不让系统处理图片变蓝
    
    if (iOS7) {
        
        selImage = [selImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    
    [VC.tabBarItem setImage:[UIImage imageWithName:imageName]];
    [VC.tabBarItem setSelectedImage:selImage];
    
    MYNavigateViewController *nav = [[MYNavigateViewController alloc]initWithRootViewController:VC];
    
    // 添加到tabBarController
    [self addChildViewController:nav];
}

@end
