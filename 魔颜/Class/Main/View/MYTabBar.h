//
//  MYTabBar.h
//  魔颜
//
//  Created by Meiyue on 16/4/9.
//  Copyright © 2016年 Meiyue. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MYPublicBlock)(NSUInteger index);

@interface MYTabBar : UITabBar

@property (copy, nonatomic) MYPublicBlock publicBlock;

@end
